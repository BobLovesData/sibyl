-- =============================================
-- Author: Deborah Wangerin
-- Create date: January 2017
-- Description: Process Dimension Assets
-- 20170115 Original Proc
-- =============================================

USE [ODS]
GO

/****** Object:  StoredProcedure [dbo].[sp_ProcessDimAssets]    Script Date: 1/16/2017 7:14:23 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[sp_ProcessDimAssets] AS
BEGIN

DECLARE @LowDate AS DATETIME
DECLARE @HighDate AS DATETIME

SELECT @HighDate = CAST(CAST(MAX(DateCK) AS NVARCHAR) AS DATETIME)
FROM FSA.dbo.DimDate 

SELECT @LowDate =  CAST(CAST(MIN(DateCK) AS NVARCHAR) AS DATETIME)
FROM FSA.dbo.DimDate 

TRUNCATE TABLE cm.DimAssets

BEGIN TRANSACTION

INSERT INTO cm.DimAssets(
[Symbol],
[AssetName],
[SourceSystem],
[SourceSystemKey]
)
SELECT
Symbol,
AssetName,
SourceSystem,
Symbol
FROM eod.Asset
UNION
SELECT '','','',''


MERGE FSA..DimAssets AS target
USING (
SELECT
[Symbol],
[AssetName],
[SourceSystem],
[SourceSystemKey]
FROM cm.DimAssets
) AS source
ON (target.SourceSystemKey COLLATE DATABASE_DEFAULT  = source.SourceSystemKey COLLATE DATABASE_DEFAULT)

WHEN NOT MATCHED THEN
INSERT (
[Symbol],
[AssetName],
[SourceSystem],
[SourceSystemKey],
EffectiveFrom,
EffectiveTo,
IsMostRecentRecord,
CreatedBy,
CreatedOn
)
VALUES (
[Symbol],
[AssetName],
[SourceSystem],
[SourceSystemKey],
@LowDate,
@HighDate,
1,
SYSTEM_USER,
CURRENT_TIMESTAMP
);


TRUNCATE TABLE cm.DimAssets

INSERT INTO cm.DimAssets(
AssetsCK,
SourceSystemKey
)
SELECT
AssetsCK,
SourceSystemKey
FROM FSA..DimAssets




COMMIT TRANSACTION

--Debug output
--SELECT COUNT(*) AS COUNTFROMBI360 FROM FSA..DimAssets
--SELECT COUNT(*) AS CONNTFROMODS FROM cm.DimAssets

END


GO


