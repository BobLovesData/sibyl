USE [ODS]
GO

/****** Object:  StoredProcedure [dbo].[sp_LoadReportingTablesVIXValues]    Script Date: 10/31/2017 5:53:25 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[sp_LoadReportingTablesVIXValues]
GO

/****** Object:  StoredProcedure [dbo].[sp_LoadReportingTablesVIXValues]    Script Date: 10/31/2017 5:53:25 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[sp_LoadReportingTablesVIXValues]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[sp_LoadReportingTablesVIXValues] AS' 
END
GO


ALTER PROCEDURE [dbo].[sp_LoadReportingTablesVIXValues]
AS

TRUNCATE TABLE Reporting..VIXValues

INSERT INTO Reporting..VIXValues(
[Symbol],
[Date],
[VIXValue],
[AsOfDate]
)
SELECT 
a.Symbol, 
d.[Date],
p.PriceClose,
CURRENT_TIMESTAMP
FROM FSA..DimAssets a
JOIN FSA..FactAssetPrices p
ON a.AssetsCK = p.AssetsCK
JOIN FSA..DimDate d
ON d.DateCK = p.AsOfDate
WHERE a.Symbol = 'VIX'
GO


