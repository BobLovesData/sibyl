-- =====================================
-- Author: Deborah Wangerin
-- Create Date: 15January2017
-- Description: Process Fact Asset Prices
-- 2017.01.15 - Original Proc
-- =====================================

USE [ODS]
GO

CREATE PROCEDURE [dbo].[sp_ProcessFactAssetPrices] AS
BEGIN

IF OBJECT_ID('tempdb..#DimAssets') IS NOT NULL DROP TABLE #DimAssets
CREATE TABLE #DimAssets(DimCK BIGINT, SourceSystemKey NVARCHAR(50), etl_key UNIQUEIDENTIFIER)
CREATE CLUSTERED INDEX CIDX_1_ETLKey ON #DimAssets(etl_key)
CREATE NONCLUSTERED INDEX NCIDX_DIM1_ETLKey ON #DimAssets(SourceSystemKey)


BEGIN TRANSACTION
-------------------
INSERT INTO #DimAssets(SourceSystemKey, etl_key)  
SELECT Symbol, ETLKey  
FROM eod.EODPrices   
WHERE Processed = 0 
AND ErrorRecord =  0

UPDATE tt   
SET tt.DimCK = cmt.AssetsCK   
FROM #DimAssets tt   
JOIN cm.DimAssets cmt   
ON tt.SourceSystemKey COLLATE DATABASE_DEFAULT = cmt.SourceSystemKey COLLATE DATABASE_DEFAULT

---------------------------------------------------------------------------------------------

TRUNCATE TABLE cm.FactAssetPrices


INSERT INTO cm.FactAssetPrices
(
[ETLKey],
[AssetsCK],
[AsOfDateCK],
[PriceOpen],
[PriceHigh],
[PriceLow],
[PriceClose],
[Volume],
[CreatedOn],
[CreatedBy], 
[UpdatedOn], 
[UpdatedBy], 
[SourceSystem] 
)

SELECT
p.ETLKey,
a.DimCK,
p.AsOfDate,
p.OpenPrice,
p.HighPrice,
p.LowPrice,
p.ClosingPrice,
p.Volume,
CURRENT_TIMESTAMP,
SYSTEM_USER,
CURRENT_TIMESTAMP,
SYSTEM_USER ,
'EODData'
FROM [eod].[EODPrices] p
JOIN #DimAssets  a   
ON  a.etl_key  =  p.ETLKey
WHERE Processed = 0 
AND ErrorRecord =  0


MERGE FSA..[FactAssetPrices] AS target
USING(
SELECT
[AssetsCK],
[AsOfDateCK],
[PriceOpen],
[PriceHigh],
[PriceLow],
[PriceClose],
[Volume],
[CreatedOn],
[CreatedBy], 
[UpdatedOn], 
[UpdatedBy], 
[SourceSystem], 
[UniqueDims]  
FROM [cm].[FactAssetPrices]
) AS source
ON target.[UniqueDims] = source.[UniqueDims]

WHEN NOT MATCHED THEN

INSERT(
[AssetsCK],
[AsOfDateCK],
[PriceOpen],
[PriceHigh],
[PriceLow],
[PriceClose],
[Volume],
[CreatedOn],
[CreatedBy], 
[UpdatedOn], 
[UpdatedBy], 
[SourceSystem]
)
VALUES(
source.[AssetsCK],
source.[AsOfDateCK],
source.[PriceOpen],
source.[PriceHigh],
source.[PriceLow],
source.[PriceClose],
source.[Volume],
source.[CreatedOn],
source.[CreatedBy], 
source.[UpdatedOn], 
source.[UpdatedBy], 
source.[SourceSystem]
);


UPDATE p
SET p.[UniqueDims] = cmt.[UniqueDims]
FROM [eod].[EODPrices] p
JOIN [cm].[FactAssetPrices] cmt
ON p.ETLKey = cmt.ETLKey


COMMIT TRANSACTION


DROP TABLE dbo.#DimAssets


END

GO