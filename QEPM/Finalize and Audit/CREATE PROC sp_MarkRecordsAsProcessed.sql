-- =============================================
-- Author: Bob Wakefield
-- Create date: 15Oct17
-- Description: Mark records in stage tables as having been processsed.
-- Change log
-- 17Oct17 Added way to mark EODPrices error records as processed.
-- =============================================


USE ODS
GO

/****** Object:  StoredProcedure dbo.sp_MarkRecordsAsProcessed    Script Date: 2/5/2016 4:00:34 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'dbo.sp_MarkRecordsAsProcessed') AND type in (N'P', N'PC'))
DROP PROCEDURE dbo.sp_MarkRecordsAsProcessed
GO

/****** Object:  StoredProcedure dbo.sp_MarkRecordsAsProcessed    Script Date: 2/5/2016 4:00:34 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'dbo.sp_MarkRecordsAsProcessed') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE dbo.sp_MarkRecordsAsProcessed AS' 
END
GO


ALTER PROCEDURE dbo.sp_MarkRecordsAsProcessed
AS
BEGIN


UPDATE st
SET Processed = 1
FROM [eod].[Assets] st
JOIN FSA..DimAssets pt
ON pt.RowHash = st.UniqueRows 
WHERE st.ErrorRecord = 0

UPDATE st
SET Processed = 1
FROM eod.Exchanges st
JOIN FSA..FactExchangeCloseData pt
ON pt.UniqueDims = st.UniqueDims
WHERE st.ErrorRecord = 0


--Marking price data is a mulit step process.
BEGIN TRANSACTION ProcessedPrices
UPDATE st
SET Processed = 1
FROM eod.EODPrices st
JOIN FSA..FactAssetPrices pt
ON pt.UniqueDims = st.UniqueDims
WHERE st.ErrorRecord = 0

--Mark records that are listed in 
--more than one exchange.
UPDATE st
SET st.Processed = 1
FROM eod.EODPrices st
JOIN FSA..DimAssets pt
ON st.Symbol = pt.Symbol
WHERE st.ErrorRecord = 1
AND st.Processed = 0

--Save records that have no record in DimAsset
INSERT INTO err.EODPrices(
[ETLKey],
[Symbol],
[Exchange],
[Date],
[Open],
[High],
[Low],
[Close],
[Volume],
[UniqueDims],
[UniqueRows],
[SourceSystem],
[ErrorRecord],
[Processed],
[RunDate]
)
SELECT
[ETLKey],
[Symbol],
[Exchange],
[Date],
[Open],
[High],
[Low],
[Close],
[Volume],
[UniqueDims],
[UniqueRows],
[SourceSystem],
[ErrorRecord],
[Processed],
[RunDate]
FROM eod.EODPrices p
WHERE p.ErrorRecord = 1
AND p.Processed = 0

--Mark saved error records as processed
UPDATE p
SET p.Processed = 1
FROM eod.EODPrices p
JOIN err.EODPrices ep
ON p.ETLKey = ep.ETLKey
WHERE p.ErrorRecord = 1
AND p.Processed = 0

COMMIT TRANSACTION ProcessedPrices



END
GO


