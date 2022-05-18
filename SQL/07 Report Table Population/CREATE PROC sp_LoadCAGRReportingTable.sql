USE [ODS]
GO

/****** Object:  StoredProcedure [dbo].[sp_LoadCAGRReportingTable]    Script Date: 3/25/2018 12:41:35 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[sp_LoadCAGRReportingTable]
GO

/****** Object:  StoredProcedure [dbo].[sp_LoadCAGRReportingTable]    Script Date: 3/25/2018 12:41:35 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[sp_LoadCAGRReportingTable]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[sp_LoadCAGRReportingTable] AS' 
END
GO

ALTER PROCEDURE [dbo].[sp_LoadCAGRReportingTable] AS

BEGIN

DECLARE @Today BIGINT
DECLARE @FiveYearsAgo BIGINT
DECLARE @Periods TINYINT = 5

SELECT 
@Today = CAST(MAX(AsOfDate) AS NCHAR(8)), 
@FiveYearsAgo = REPLACE(DATEADD(YY,-5, CAST(CAST(MAX(AsOfDate) AS NCHAR(8)) AS DATE)),'-','')
FROM [FSA].[dbo].[FactAssetPrices]

TRUNCATE TABLE Reporting..CAGRReport

BEGIN TRANSACTION

;
WITH PricesToday(Symbol, AssetName, AssetType, PriceClose)
AS(
SELECT 
a.Symbol,
a.AssetName,
a.AssetType, 
fap.PriceClose
FROM FSA..DimAssets a
JOIN FSA..FactAssetPrices fap
ON a.AssetsCK = fap.AssetsCK
WHERE fap.AsOfDate = @Today
AND fap.PriceClose > 0
),
PricesFiveYearsAgo(Symbol, PriceClose)
AS(
SELECT a.Symbol, fap.PriceClose
FROM FSA..DimAssets a
JOIN FSA..FactAssetPrices fap
ON a.AssetsCK = fap.AssetsCK
WHERE fap.AsOfDate = @FiveYearsAgo
AND fap.PriceClose > 0
)
INSERT INTO Reporting..CAGRReport(
Symbol,
AssetName,
AssetType,
BeginningPrice,
EndingPrice,
AsOfDate
)
SELECT 
pt.Symbol,
pt.AssetName,
pt.AssetType, 
pfya.PriceClose, 
pt.PriceClose,
CURRENT_TIMESTAMP
FROM PricesToday pt
JOIN PricesFiveYearsAgo pfya
ON pt.Symbol = pfya.Symbol


UPDATE Reporting..CAGRReport
SET CAGR = (POWER(EndingPrice/BeginningPrice, 1.0/@Periods)-1)

COMMIT TRANSACTION

END

GO


