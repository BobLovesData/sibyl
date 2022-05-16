USE [FSA]
GO

/****** Object:  Table [dbo].[FactAssetPrices]    Script Date: 1/16/2017 9:42:59 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ARITHABORT ON
GO

CREATE TABLE [dbo].[FactAssetPrices](
	[RowID] [bigint] IDENTITY(1,1) NOT NULL,
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
	CONVERT([nvarchar](35),[AsOfDateCK],(0)))),(0))) PERSISTED,
CONSTRAINT [PK_prices] PRIMARY KEY CLUSTERED 
(
	[RowID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY],
 CONSTRAINT [IX_FactAssetPrices] UNIQUE NONCLUSTERED 
(
	[UniqueDims] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

ALTER TABLE [dbo].[FactAssetPrices]  WITH CHECK ADD CONSTRAINT [FK_FactAssetPrices_DimAsOfDate] FOREIGN KEY([AsOfDateCK]) 
REFERENCES [dbo].[DimDate] ([DateCK])
GO

ALTER TABLE [dbo].[FactAssetPrices] CHECK CONSTRAINT [FK_FactAssetPrices_DimAsOfDate]
GO

ALTER TABLE [dbo].[FactAssetPrices]  WITH CHECK ADD CONSTRAINT [FK_FactAssetPrices_DimAssets] FOREIGN KEY([AssetsCK]) 
REFERENCES [dbo].[DimAssets] ([AssetsCK])
GO

ALTER TABLE [dbo].[FactAssetPrices] CHECK CONSTRAINT [FK_FactAssetPrices_DimAssets]
GO


