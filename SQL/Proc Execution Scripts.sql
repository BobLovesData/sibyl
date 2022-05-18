USE ODS
--Clean Data
EXEC usp_CleanTreasuryYieldCurveData

--Process Facts
EXEC usp_ProcessFactTreasuryYieldCurve

TRUNCATE TABLE Sibyl.[dw].[FactTreasuryYieldCurve]

SELECT CAST(BC_6MONTH AS NUMERIC(30,25))
FROM [ODS].[fred].[TreasuryYieldCurveData]
WHERE IsNumeric(BC_6MONTH) = 0

UPDATE [ODS].[fred].[TreasuryYieldCurveData]
SET BC_6MONTH = '0'
WHERE IsNumeric(BC_6MONTH) = 0


UPDATE [ODS].[fred].[TreasuryYieldCurveData]
SET CLEANSED = 0

---Jobs
EXEC sp_CleanEODPricesData
GO
EXEC sp_CleanEODAssetData
GO
EXEC sp_ProcessDimAssets
GO
EXEC sp_ProcessFactAssetPrices
GO
EXEC sp_MarkRecordsAsProcessed
GO