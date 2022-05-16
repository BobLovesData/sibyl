USE [FSA]
GO

/****** Object:  Table [dbo].[Asset Prices]    Script Date: 1/16/2017 11:31:27 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ARITHABORT ON
GO

CREATE VIEW [dbo].[Asset Prices] AS
SELECT
	a.SourceSystemKey AS [Symbol],
	dt.Date AS [As of Date],
	PriceOpen AS [Price Open],
	PriceHigh AS [Price High],
	PriceLow AS [Price Low],
	PriceClose AS [Price Close],
	Volume AS [Volume]
	FROM FSA..FactAssetPrices p
	JOIN FSA..DimAssets a
	ON a.AssetsCK = p.AssetsCK
	JOIN FSA..DimDate dt
	ON dt.DateCK = p.AsOfDateCK

