USE [Reporting]
GO

/****** Object:  View [dbo].[vw_NumberOfYearsListed]    Script Date: 10/29/2017 6:21:58 AM ******/
DROP VIEW IF EXISTS [dbo].[vw_NumberOfYearsListed]
GO

/****** Object:  View [dbo].[vw_NumberOfYearsListed]    Script Date: 10/29/2017 6:21:58 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[vw_NumberOfYearsListed]'))
EXEC dbo.sp_executesql @statement = N'
CREATE VIEW [dbo].[vw_NumberOfYearsListed] AS(
SELECT a.Symbol, a.AssetName, a.AssetExchange, MIN(d.[Date]) AS DateOfFirstRecord, MAX(d.[Date]) AS DateOfLastRecord, DATEDIFF(YY,MIN(d.[Date]),MAX(d.[Date])) AS NumberOfYearsListed
FROM FSA..DimAssets a
JOIN FSA..FactAssetPrices p
ON a.AssetsCK = p.AssetsCK
JOIN FSA..DimDate d
ON d.DateCK = p.AsOfDate
WHERE a.AssetExchange <> ''INDEX''
GROUP BY a.Symbol, a.AssetName, a.AssetExchange
)' 
GO


