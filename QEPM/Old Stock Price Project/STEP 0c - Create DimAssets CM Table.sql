USE [ODS]
GO

/****** Object:  Table [cm].[DimAssets]    Script Date: 1/16/2017 9:52:31 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [cm].[DimAssets](
	[AssetsCK] [bigint] NULL,
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
	[RowHash] [binary](16) NULL
) ON [PRIMARY]

GO


