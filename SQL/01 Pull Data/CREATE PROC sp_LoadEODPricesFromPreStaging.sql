USE [ODS]
GO

/****** Object:  StoredProcedure [dbo].[sp_LoadEODPricesFromPreStaging]    Script Date: 10/20/2017 2:54:53 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[sp_LoadEODPricesFromPreStaging]
GO

/****** Object:  StoredProcedure [dbo].[sp_LoadEODPricesFromPreStaging]    Script Date: 10/20/2017 2:54:53 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[sp_LoadEODPricesFromPreStaging]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[sp_LoadEODPricesFromPreStaging] AS' 
END
GO

ALTER PROCEDURE [dbo].[sp_LoadEODPricesFromPreStaging] @exchange NVARCHAR(50)
AS
BEGIN

BEGIN TRANSACTION

DELETE FROM eod.EODPricesPreStaging WHERE Symbol = 'Symbol'



--Handle New Records
MERGE [eod].[EODPrices] AS target
USING (
SELECT
[Symbol],
@exchange AS [Exchange],
[Date],
[Open],
[High],
[Low],
[Close],
[Volume],
'EODData' AS [SourceSystem],
'0' AS [ErrorRecord],
'0' AS [Processed],
CURRENT_TIMESTAMP AS [RunDate]
FROM [eod].[EODPricesPreStaging]
) AS source
ON source.[Symbol] COLLATE DATABASE_DEFAULT = target.[Symbol] COLLATE DATABASE_DEFAULT
AND source.[Exchange] COLLATE DATABASE_DEFAULT = target.[Exchange] COLLATE DATABASE_DEFAULT
AND source.[Date] COLLATE DATABASE_DEFAULT = target.[Date] COLLATE DATABASE_DEFAULT

WHEN NOT MATCHED THEN
INSERT (
[Symbol],
[Exchange],
[Date],
[Open],
[High],
[Low],
[Close],
[Volume],
[SourceSystem],
[ErrorRecord],
[Processed],
[RunDate]
)
VALUES (
[Symbol],
[Exchange],
[Date],
[Open],
[High],
[Low],
[Close],
[Volume],
[SourceSystem],
[ErrorRecord],
[Processed],
[RunDate]
);



TRUNCATE TABLE eod.EODPricesPreStaging

COMMIT TRANSACTION

END
GO


