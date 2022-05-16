USE [ODS]
GO

/****** Object:  Table [eod].[Asset]    Script Date: 1/16/2017 9:25:32 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [eod].[Asset](
	[ETLKey] [uniqueidentifier] NOT NULL,
	[Symbol] [nvarchar](255) NULL,
	[AssetName] [nvarchar](255) NULL,
	[UniqueDims] [varbinary](35) NULL,
	[UniqueRows] [nvarchar](255) NULL,
	[SourceSystem] [nvarchar](255) NULL,
	[ErrorRecord] [bit] NULL,
	[Processed] [bit] NULL,
	[RunDate] [date] NULL,
 CONSTRAINT [PK_Asset] PRIMARY KEY CLUSTERED 
(
	[ETLKey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

ALTER TABLE [eod].[Asset] ADD  CONSTRAINT [DF_Asset_ETLKey]  DEFAULT (newid()) FOR [ETLKey]
GO


