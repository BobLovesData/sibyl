USE [ODS]
GO

/****** Object:  Table [cm].[FactAssetPrices]    Script Date: 1/16/2017 9:54:08 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [cm].[FactAssetPrices](
	[ETLKey] [uniqueidentifier] NULL,
	[AssetsCK] [bigint] NOT NULL,
	[AsOfDateCK] [bigint] NOT NULL,
	[PriceOpen] [money] NULL,
	[PriceHigh] [money] NULL,
	[PriceLow] [money] NULL,
	[PriceClose] [money] NULL,
	[Volume] [int] NULL,
	[CreatedOn] [datetime] NULL,
	[CreatedBy] [nvarchar](50) NULL,
	[UpdatedOn] [datetime] NULL,
	[UpdatedBy] [nvarchar](50) NULL,
	[SourceSystem] [nvarchar](50) NULL,
	[UniqueDims]  AS (CONVERT([varbinary](35),hashbytes('SHA1',concat(
	CONVERT([nvarchar](35),[AssetsCK],(0)),
	CONVERT([nvarchar](35),[AsOfDateCK],(0)))),(0))) PERSISTED
) ON [PRIMARY]

GO


