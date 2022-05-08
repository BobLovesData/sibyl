-- =============================================
-- Author: Bob Wakefield
-- Create date: 11Jul20
-- Description: Process treasury yield curve data
-- =============================================

USE ODS

GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_ProcessFactTreasuryYieldCurve]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[usp_ProcessFactTreasuryYieldCurve]
GO


SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE usp_ProcessFactTreasuryYieldCurve
AS
BEGIN


TRUNCATE TABLE [cm].[FactTreasuryYieldCurve]

BEGIN TRANSACTION


INSERT INTO [cm].[FactTreasuryYieldCurve](
[ETLKey],
[AsOfDateCK],
[1Month],
[3Month],
[6Month],
[1Year],
[2Year],
[3Year],
[5Year],
[7Year],
[10Year],
[20Year],
[30Year],
[SourceSystem]
)
SELECT
tycd.[ETL_Key],
tycd.[NEW_DATE],
tycd.[BC_1MONTH],
tycd.[BC_3MONTH],
tycd.[BC_6MONTH],
tycd.[BC_1YEAR],
tycd.[BC_2YEAR],
tycd.[BC_3YEAR],
tycd.[BC_5YEAR],
tycd.[BC_7YEAR],
tycd.[BC_10YEAR],
tycd.[BC_20YEAR],
tycd.[BC_30YEAR],
tycd.SOURCE_SYSTEM
FROM [fred].[TreasuryYieldCurveData] tycd
WHERE tycd.PROCESSED = 0
AND tycd.ERROR_RECORD = 0
AND tycd.CLEANSED = 1

--Update staging so you can match to production later.
UPDATE st
SET st.UNIQUE_DIMS = cmt.[UniqueDims]
FROM [fred].[TreasuryYieldCurveData] st
JOIN [cm].[FactTreasuryYieldCurve] cmt
ON st.ETL_Key = cmt.ETLKey


MERGE Sibyl.dw.[FactTreasuryYieldCurve] AS target
USING(
SELECT
[AsOfDateCK],
[1Month],
[3Month],
[6Month],
[1Year],
[2Year],
[3Year],
[5Year],
[7Year],
[10Year],
[20Year],
[30Year],
[SourceSystem],
[UniqueDims]
FROM [cm].[FactTreasuryYieldCurve]
) AS source
ON target.[UniqueDims] = source.[UniqueDims]

WHEN NOT MATCHED THEN

INSERT(
[AsOfDateCK],
[1Month],
[3Month],
[6Month],
[1Year],
[2Year],
[3Year],
[5Year],
[7Year],
[10Year],
[20Year],
[30Year],
[SourceSystem],
[CreatedOn],
[CreatedBy]
)
VALUES(
source.[AsOfDateCK],
source.[1Month],
source.[3Month],
source.[6Month],
source.[1Year],
source.[2Year],
source.[3Year],
source.[5Year],
source.[7Year],
source.[10Year],
source.[20Year],
source.[30Year],
source.[SourceSystem],
CURRENT_TIMESTAMP,
SYSTEM_USER
)

WHEN MATCHED
THEN
UPDATE
SET
[1Month] = source.[1Month],
[3Month] = source.[3Month],
[6Month] = source.[6Month],
[1Year] = source.[1Year],
[2Year] = source.[2Year],
[3Year] = source.[3Year],
[5Year] = source.[5Year],
[7Year] = source.[7Year],
[10Year] = source.[10Year],
[20Year] = source.[20Year],
[30Year] = source.[30Year],
[UpdatedBy] = SYSTEM_USER,
[UpdatedOn] = CURRENT_TIMESTAMP
;






COMMIT TRANSACTION


END