-- =============================================
-- Author: Deborah Wangerin
-- Create date: January 2017
-- Description: Clean EOD Price Stage Data
-- 20170115 Original Proc
-- =============================================

USE [ODS]
GO

/****** Object:  StoredProcedure [dbo].[sp_CleanEODPricesData]    Script Date: 1/6/2017 11:54:01 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[sp_CleanEODPricesData] AS BEGIN

----Set empty dates to the empty field code
----This HAS to be done before you check for bad dates.
UPDATE [eod].[EODPrices]  
SET [AsOfDate] = 20120602  
WHERE [AsOfDate] IS NULL	

----Set error dates to the error field code
UPDATE [eod].[EODPrices]  
SET [AsOfDate] = 20120601  
WHERE ISDATE([AsOfDate]) = 0	

----Convert the rest of the dates into YYYYMMDD format
UPDATE [eod].[EODPrices]  
SET [AsOfDate] = CONVERT(VARCHAR(10),CAST([AsOfDate] AS DATE),112)	

----Error out records where the date is prior to 20120601
UPDATE [eod].[EODPrices]  
SET [AsOfDate] = 20120601 
WHERE [AsOfDate] < 20120601

--Remove junk on [OpenPrice]. Necessary for casting
UPDATE [eod].[EODPrices]  
SET [OpenPrice] = REPLACE([OpenPrice],',','')

UPDATE [eod].[EODPrices]  
SET [OpenPrice] = REPLACE([OpenPrice],'(','-')

UPDATE [eod].[EODPrices]  
SET [OpenPrice] = REPLACE([OpenPrice],')','')


--Remove junk on [HighPrice]. Necessary for casting
UPDATE [eod].[EODPrices]  
SET [HighPrice] = REPLACE([HighPrice],',','')

UPDATE [eod].[EODPrices]  
SET [HighPrice] = REPLACE([HighPrice],'(','-')

UPDATE [eod].[EODPrices]  
SET [HighPrice] = REPLACE([HighPrice],')','')

--Remove junk on [LowPrice]. Necessary for casting
UPDATE [eod].[EODPrices]  
SET [LowPrice] = REPLACE([LowPrice],',','')

UPDATE [eod].[EODPrices]  
SET [LowPrice] = REPLACE([LowPrice],'(','-')

UPDATE [eod].[EODPrices]  
SET [LowPrice] = REPLACE([LowPrice],')','')

--Remove junk on [ClosingPrice]. Necessary for casting
UPDATE [eod].[EODPrices]  
SET [ClosingPrice] = REPLACE([ClosingPrice],',','')

UPDATE [eod].[EODPrices]  
SET [ClosingPrice] = REPLACE([ClosingPrice],'(','-')

UPDATE [eod].[EODPrices]  
SET [ClosingPrice] = REPLACE([ClosingPrice],')','')

--Remove junk on [Volume]. Necessary for casting
UPDATE [eod].[EODPrices]  
SET [Volume] = REPLACE([Volume],',','')

UPDATE [eod].[EODPrices]  
SET [Volume] = REPLACE([Volume],'(','-')

UPDATE [eod].[EODPrices]  
SET [Volume] = REPLACE([Volume],')','')

----Remove odd negative signs

UPDATE [eod].[EODPrices]   
SET [OpenPrice] = REPLACE([OpenPrice],'-','')   
WHERE LEN([OpenPrice]) = 1  
AND [OpenPrice] = '-'

UPDATE [eod].[EODPrices]   
SET [HighPrice] = REPLACE([HighPrice],'-','')   
WHERE LEN([HighPrice]) = 1  
AND [HighPrice] = '-'

UPDATE [eod].[EODPrices]   
SET [LowPrice] = REPLACE([LowPrice],'-','')   
WHERE LEN([LowPrice]) = 1  
AND [LowPrice] = '-'

UPDATE [eod].[EODPrices]   
SET [ClosingPrice] = REPLACE([ClosingPrice],'-','')   
WHERE LEN([ClosingPrice]) = 1  
AND [ClosingPrice] = '-'

UPDATE [eod].[EODPrices]   
SET [Volume] = REPLACE([Volume],'-','')   
WHERE LEN([Volume]) = 1  
AND [Volume] = '-'

----Convert NULLS to empty strings
UPDATE [eod].[EODPrices]  
SET [Symbol] = ''  
WHERE [Symbol] IS NULL

END

GO
