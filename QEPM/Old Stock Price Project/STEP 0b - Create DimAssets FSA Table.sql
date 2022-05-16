USE [FSA]
GO

/****** Object:  Table [dbo].[DimAssets]    Script Date: 1/16/2017 9:42:22 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[DimAssets](
	[AssetsCK] [bigint] IDENTITY(1,1) NOT NULL,
	[Symbol] [nvarchar](50) NULL,
	[AssetName] [nvarchar](100) NULL,
	[CreatedBy] [nvarchar](50) NULL,
	[CreatedOn] [datetime] NULL,
	[UpdatedBy] [nvarchar](50) NULL,
	[UpdatedOn] [datetime] NULL,
	[SourceSystem] [nvarchar](100) NULL,
	[SourceSystemKey] [nvarchar](100) NULL,
	[EffectiveFrom] [datetime] NULL,
	[EffectiveTo] [datetime] NULL,
	[IsMostRecentRecord] [bit] NULL,
	[RowHash] [binary](16) NULL,
 CONSTRAINT [PK_tickers] PRIMARY KEY CLUSTERED 
(
	[AssetsCK] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

ALTER TABLE [dbo].[DimAssets]  WITH CHECK ADD  CONSTRAINT [FK_tickers_tickers] FOREIGN KEY([AssetsCK])
REFERENCES [dbo].[DimAssets] ([AssetsCK])
GO

ALTER TABLE [dbo].[DimAssets] CHECK CONSTRAINT [FK_tickers_tickers]
GO


