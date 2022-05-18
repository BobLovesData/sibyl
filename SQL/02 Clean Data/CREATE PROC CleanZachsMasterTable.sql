USE ODS

DROP TABLE IF EXISTS #AssetTypeDescriptions

CREATE TABLE #AssetTypeDescriptions(
AssetType NVARCHAR(3) NOT NULL,
AssetTypeDescription NVARCHAR(MAX) NOT NULL
)

INSERT INTO #AssetTypeDescriptions(
AssetType,
AssetTypeDescription
)
SELECT 'ADR','American Depository Receipts. Used for foreign companies trading on US exchanges instead of stock certificates. Companies traded as ADR are based outside the US. This category does not include Canadian companies, as they are tracked separately under asset type CDN.'
UNION ALL
SELECT 'CDN','Canadian firms traded in the US as ADRs but tracked separately.'
UNION ALL
SELECT 'CEF','Closed-End Funds. Similar to mutual funds but they have a limit on the number of shares issued and trade continuously like ETFs.'
UNION ALL
SELECT 'COM','Common Stock Equities'
UNION ALL
SELECT 'ETF','Exchange Traded Funds. Similar to mutual funds, except they trade continuously like common equities.'
UNION ALL
SELECT 'MLP','Master Limited Partnerships. Traded like common equities. Companies traded as "MLP"s are usually in oil & gas drilling, mining, or other natural resource extraction industries.'

BEGIN TRANSACTION

UPDATE zmt
SET zmt.asset_type_description = atd.AssetTypeDescription
FROM qdl.ZachsMasterTable zmt
JOIN #AssetTypeDescriptions atd
ON zmt.asset_type = atd.AssetType

UPDATE qdl.ZachsMasterTable
SET active_ticker_flag = 
CASE
WHEN active_ticker_flag = 'Y' THEN 'Yes'
WHEN active_ticker_flag = 'N' THEN 'No'
ELSE 'Unknown'
END
WHERE Cleansed = 0

UPDATE qdl.ZachsMasterTable
SET optionable_flag = 
CASE
WHEN optionable_flag = 'Y' THEN 'Yes'
WHEN optionable_flag = 'N' THEN 'No'
ELSE 'Unknown'
END
WHERE Cleansed = 0

UPDATE qdl.ZachsMasterTable
SET sp500_member_flag = 
CASE
WHEN sp500_member_flag = 'Y' THEN 'Yes'
WHEN sp500_member_flag = 'N' THEN 'No'
ELSE 'Unknown'
END
WHERE Cleansed = 0


UPDATE qdl.ZachsMasterTable SET Cleansed = 1

COMMIT TRANSACTION

DROP TABLE #AssetTypeDescriptions