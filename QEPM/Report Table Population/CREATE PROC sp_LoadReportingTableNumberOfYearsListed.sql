USE [ODS]
GO

/****** Object:  StoredProcedure [dbo].[sp_LoadReportingTableNumberOfYearsListed]    Script Date: 10/31/2017 5:41:12 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[sp_LoadReportingTableNumberOfYearsListed]
GO

/****** Object:  StoredProcedure [dbo].[sp_LoadReportingTableNumberOfYearsListed]    Script Date: 10/31/2017 5:41:12 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[sp_LoadReportingTableNumberOfYearsListed]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[sp_LoadReportingTableNumberOfYearsListed] AS' 
END
GO


ALTER PROCEDURE [dbo].[sp_LoadReportingTableNumberOfYearsListed]
AS

TRUNCATE TABLE Reporting..NumberOfYearsListed

INSERT INTO Reporting..NumberOfYearsListed(
[Symbol],
[AssetName],
[AssetExchange],
[DateOfFirstRecord],
[DateOfLastRecord],
[NumberOfYearsListed],
[AsOfDate]
)
SELECT 
a.Symbol, 
a.AssetName, 
a.AssetExchange, 
MIN(d.[Date]) AS DateOfFirstRecord, 
MAX(d.[Date]) AS DateOfLastRecord, 
DATEDIFF(YY,MIN(d.[Date]),MAX(d.[Date])) AS NumberOfYearsListed,
CURRENT_TIMESTAMP
FROM FSA..DimAssets a
JOIN FSA..FactAssetPrices p
ON a.AssetsCK = p.AssetsCK
JOIN FSA..DimDate d
ON d.DateCK = p.AsOfDate
WHERE a.AssetExchange <> 'INDEX'
GROUP BY a.Symbol, a.AssetName, a.AssetExchange




GO


