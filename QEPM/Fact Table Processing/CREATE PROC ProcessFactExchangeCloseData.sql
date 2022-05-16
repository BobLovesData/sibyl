-- =============================================
-- Author: Bob Wakefield
-- Create date: 6Oct16
-- Description: ProcessFactExchangeCloseData
-- =============================================

USE ODS

GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'dbo.sp_ProcessFactExchangeCloseData') AND type in (N'P', N'PC'))
DROP PROCEDURE dbo.sp_ProcessFactExchangeCloseData
GO


SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE sp_ProcessFactExchangeCloseData
AS
BEGIN

IF OBJECT_ID('tempdb..#DimExchanges') IS NOT NULL DROP TABLE #DimExchanges


CREATE TABLE #DimExchanges(DimCK BIGINT, SourceSystemKey NVARCHAR(50), ETLKey UNIQUEIDENTIFIER)
CREATE CLUSTERED INDEX CIDX_1_ETLKey ON #DimExchanges(ETLKey)
CREATE NONCLUSTERED INDEX NCIDX_DIM1_ETLKey ON #DimExchanges(SourceSystemKey)


BEGIN TRANSACTION
----


INSERT INTO #DimExchanges(SourceSystemKey, ETLKey)
SELECT Code, ETLKey
FROM eod.Exchanges
WHERE Processed = 0
AND ErrorRecord = 0

UPDATE tt
SET tt.DimCK = cmt.ExchangesCK
FROM #DimExchanges tt
JOIN cm.DimExchanges cmt
ON tt.SourceSystemKey COLLATE DATABASE_DEFAULT = cmt.SourceSystemKey COLLATE DATABASE_DEFAULT


----

TRUNCATE TABLE cm.FactExchangeCloseData

INSERT INTO cm.FactExchangeCloseData(
[ETLKey],
[ExchangesCK],
[AsOfDate],
[Declines],
[Advances],
[LastTradeDateTime],
[CreatedOn],
[CreatedBy],
[SourceSystem]
)
SELECT
e.ETLKey,
de.DimCK,
CAST(REPLACE(CAST(CAST(e.LastTradeDateTime AS DATE) AS NVARCHAR),'-','') AS INT),
e.Advances,
e.Declines,
e.LastTradeDateTime,
CURRENT_TIMESTAMP,
SYSTEM_USER,
e.SourceSystem
FROM eod.Exchanges e
JOIN #DimExchanges de
ON de.ETLKey = e.ETLKey
WHERE e.Processed = 0
AND e.ErrorRecord = 0

----Update staging so you can determine what has been processed.
UPDATE e
SET e.UniqueDims = cmt.UniqueDims
FROM eod.Exchanges e
JOIN cm.FactExchangeCloseData cmt
ON e.ETLKey = cmt.ETLKey

MERGE FSA..FactExchangeCloseData AS target
USING(
SELECT
[ETLKey],
[ExchangesCK],
[AsOfDate],
[Declines],
[Advances],
[LastTradeDateTime],
[CreatedOn],
[CreatedBy],
[SourceSystem],
UniqueDims
FROM cm.FactExchangeCloseData
) AS source
ON target.UniqueDims = source.UniqueDims

WHEN NOT MATCHED THEN

INSERT(
[ExchangesCK],
[AsOfDate],
[Declines],
[Advances],
[LastTradeDateTime],
[CreatedOn],
[CreatedBy],
[SourceSystem]
)
VALUES(
[ExchangesCK],
[AsOfDate],
[Declines],
[Advances],
[LastTradeDateTime],
[CreatedOn],
[CreatedBy],
[SourceSystem]
);

COMMIT TRANSACTION

DROP TABLE #DimExchanges



END