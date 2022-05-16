USE [ODS]
GO

/****** Object:  Table [eod].[EODPrices]    Script Date: 1/10/2017 5:43:47 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [eod].[EODPrices](
	[ETLKey] [uniqueidentifier] NOT NULL,
	[Symbol] [varchar](255) NULL,
	[AsOfDate] [varchar](255) NULL,
	[OpenPrice] [money] NULL,
	[HighPrice] [money] NULL,
	[LowPrice] [money] NULL,
	[ClosingPrice] [money] NULL,
	[Volume] [int] NULL,
	[UniqueDims] [varbinary](35) NULL,
	[UniqueRows] [nvarchar](255) NULL,
	[SourceSystem] [nvarchar](255) NULL,
	[ErrorRecord] [bit] NULL,
	[Processed] [bit] NULL,
	[RunDate] [date] NULL,
 CONSTRAINT [PK_EODPrices] PRIMARY KEY CLUSTERED 
(
	[ETLKey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

ALTER TABLE [eod].[EODPrices] ADD  CONSTRAINT [DF_EODPrices_ETLKey]  DEFAULT (newid()) FOR [ETLKey]
GO


