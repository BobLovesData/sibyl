-- =============================================
-- Author: Bob Wakefield
-- Create date: 10Jul20
-- Description: clean yield curve data
-- =============================================

USE [ODS]
GO

/****** Object:  StoredProcedure [dbo].[usp_CleanTreasuryYieldCurveData]    Script Date: 9/15/2016 12:05:55 AM ******/
DROP PROCEDURE IF EXISTS [dbo].[usp_CleanTreasuryYieldCurveData]
GO

/****** Object:  StoredProcedure [dbo].[usp_CleanTreasuryYieldCurveData]    Script Date: 9/15/2016 12:05:55 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[usp_CleanTreasuryYieldCurveData] 
AS
BEGIN

BEGIN TRANSACTION

--Set empty dates to the empty field code
--This HAS to be done before you check for
--bad dates.

UPDATE fred.TreasuryYieldCurveData
SET NEW_DATE = REPLACE(NEW_DATE,'-', '')
WHERE CLEANSED  = 0

UPDATE fred.TreasuryYieldCurveData
SET [NEW_DATE] = '00000000'
WHERE [NEW_DATE] IS NULL
AND CLEANSED  = 0

--Set error dates to the error field code
UPDATE fred.TreasuryYieldCurveData
SET [NEW_DATE] = '11111111'
WHERE ISDATE([NEW_DATE]) = 0
AND CLEANSED  = 0


--Convert the rest of the dates into YYYYMMDD format
UPDATE fred.TreasuryYieldCurveData
SET NEW_DATE = dbo.udf_CleanDate([NEW_DATE])
WHERE 1 = 1
AND (NEW_DATE <> '00000000' OR [NEW_DATE] <> '11111111')
AND CLEANSED  = 0

UPDATE fred.TreasuryYieldCurveData
SET [BC_1MONTH] = 0
WHERE [BC_1MONTH] = ''
AND CLEANSED  = 0

UPDATE fred.TreasuryYieldCurveData
SET [BC_3MONTH] = 0
WHERE [BC_3MONTH] = ''
AND CLEANSED  = 0

UPDATE fred.TreasuryYieldCurveData
SET [BC_6MONTH] = 0
WHERE [BC_6MONTH] = ''
AND CLEANSED  = 0

UPDATE fred.TreasuryYieldCurveData
SET [BC_1YEAR] = 0
WHERE [BC_1YEAR] = ''
AND CLEANSED  = 0

UPDATE fred.TreasuryYieldCurveData
SET [BC_2YEAR] = 0
WHERE [BC_2YEAR] = ''
AND CLEANSED  = 0

UPDATE fred.TreasuryYieldCurveData
SET [BC_3YEAR] = 0
WHERE [BC_3YEAR] = ''
AND CLEANSED  = 0

UPDATE fred.TreasuryYieldCurveData
SET [BC_5YEAR] = 0
WHERE [BC_5YEAR] = ''
AND CLEANSED  = 0

UPDATE fred.TreasuryYieldCurveData
SET [BC_7YEAR] = 0
WHERE [BC_7YEAR] = ''
AND CLEANSED  = 0

UPDATE fred.TreasuryYieldCurveData
SET [BC_10YEAR] = 0
WHERE [BC_10YEAR] = ''
AND CLEANSED  = 0

UPDATE fred.TreasuryYieldCurveData
SET [BC_20YEAR] = 0
WHERE [BC_20YEAR] = ''
AND CLEANSED  = 0

UPDATE fred.TreasuryYieldCurveData
SET [BC_30YEAR] = 0
WHERE [BC_30YEAR] = ''
AND CLEANSED  = 0

UPDATE fred.TreasuryYieldCurveData
SET CLEANSED = 1


COMMIT TRANSACTION

END



GO


