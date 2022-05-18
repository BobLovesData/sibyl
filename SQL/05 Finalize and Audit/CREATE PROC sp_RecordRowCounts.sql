-- =============================================
-- Author: Bob Wakefield
-- Create date: 15Oct17
-- Description: Records how many records each fact table is getting loaded with.
-- =============================================

USE ODS
GO

IF object_id('sp_RecordRowCounts') IS NOT NULL
BEGIN
DROP PROCEDURE sp_RecordRowCounts
END

GO

CREATE PROCEDURE sp_RecordRowCounts AS
BEGIN

--for testing
--DECLARE @Random INT;
--DECLARE @Upper INT;
--DECLARE @Lower INT;
--SET @Lower = 1 ---- The lowest random number
--SET @Upper = 20 ---- The highest random number
--SELECT @Random = ROUND(((@Upper - @Lower -1) * RAND() + @Lower), 0)

--DECLARE @counter smallint;
--SET @counter = 1;
--WHILE @counter < @Random
--   BEGIN
--      INSERT INTO [BI360DW].[dbo].[f_Trans_GL_Backup]([Scenario],[Entity],[Account], [TransactionID], [HasLID], [TimePeriod])
--      SELECT 1,2,182,RAND(),1,20150801
--      SET @counter = @counter + 1
--   END;
--GO

--
BEGIN TRANSACTION

CREATE TABLE #counts(table_name nvarchar(255), row_count int)
CREATE TABLE #date_of_last_observations(table_id INT, row_count INT, date_of_last_observation DATETIME)

EXEC FSA..sp_MSforeachtable @command1='INSERT #counts (table_name, row_count) SELECT ''?'', COUNT(*) FROM ?'


MERGE ODS.[vol].[Tables] as target
USING(
SELECT REPLACE(SUBSTRING(table_name,8,LEN(table_name)),']','') AS table_name, CURRENT_TIMESTAMP AS date_measured, row_count 
FROM #counts 
WHERE table_name LIKE '%Fact%' 
) AS source
ON source.table_name COLLATE DATABASE_DEFAULT = target.TableName COLLATE DATABASE_DEFAULT

WHEN NOT MATCHED THEN
INSERT ([TableName],[DateCreated])
VALUES (source.table_name, CURRENT_TIMESTAMP);


INSERT INTO #date_of_last_observations(table_id,date_of_last_observation)
SELECT TableID, MAX([DateOfCurrentObservation]) AS DateOfLastObservation 
FROM ODS.[vol].[LoadObservations]
GROUP BY TableID

;
WITH PreviousObservations(DateOfLastObservation, LastRowCount, TableID)
AS(
SELECT lo.[DateOfCurrentObservation], lo.[RowCount], lo.TableID
FROM ODS.[vol].[LoadObservations] lo
JOIN #date_of_last_observations llo
ON lo.[DateOfCurrentObservation] = llo.date_of_last_observation
AND lo.[TableID] = llo.table_id
),
CurrentSDLevel(TableID, CurrentThreeSDLevel)
AS(
SELECT TableID, STDEV(ChangeFromLastObservation) * 3
FROM ODS.[vol].[LoadObservations]
WHERE ChangeFromLastObservation <> 0 --added 2Nov16
GROUP BY TableID
)
INSERT ODS.[vol].[LoadObservations]([TableID], [DateOfCurrentObservation], [DateOfLastObservation], [RowCount], [ChangeFromLastObservation], CurrentThreeSDLevel)
SELECT t.TableID, CURRENT_TIMESTAMP AS DateOfCurrentObservation, po.DateOfLastObservation, c.row_count, ABS(c.row_count - po.LastRowCount), ABS(sd.CurrentThreeSDLevel)
FROM #counts c
JOIN ODS.[vol].[Tables] t
ON REPLACE(SUBSTRING(table_name,8,LEN(c.table_name)),']','') COLLATE DATABASE_DEFAULT = t.TableName COLLATE DATABASE_DEFAULT
LEFT OUTER JOIN PreviousObservations po
ON  t.TableID = po.TableID
LEFT OUTER JOIN CurrentSDLevel sd
ON t.TableID = sd.TableID

--SELECT t.TableName, lo.*
--FROM ODS.[vol].[Tables] t
--LEFT OUTER JOIN ODS.[vol].[LoadObservations] lo
--ON t.TableID = lo.TableID
--WHERE t.TableID = 57

COMMIT TRANSACTION


DROP TABLE #counts
DROP TABLE #date_of_last_observations

END