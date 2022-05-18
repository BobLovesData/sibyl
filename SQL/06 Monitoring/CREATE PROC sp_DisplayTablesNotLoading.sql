-- =============================================
-- Author: Bob Wakefield
-- Create date: 11April16
-- Description: Displays tables that are not loading.
-- Unwanted tables are tables that don't load that often by design.
-- 10Mar17: Updated to take into account larger record counts
-- Int datatype was too small.
-- =============================================

USE [ODS]
GO

/****** Object:  StoredProcedure [dbo].[sp_DisplayTablesNotLoading]    Script Date: 4/11/2016 10:52:48 AM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[sp_DisplayTablesNotLoading]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[sp_DisplayTablesNotLoading]
GO

/****** Object:  StoredProcedure [dbo].[sp_DisplayTablesNotLoading]    Script Date: 3/10/2017 5:47:54 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[sp_DisplayTablesNotLoading]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[sp_DisplayTablesNotLoading] AS' 
END
GO

ALTER PROCEDURE [dbo].[sp_DisplayTablesNotLoading] AS
BEGIN

CREATE TABLE #UnWantedTables(TableID BIGINT)
CREATE CLUSTERED INDEX CIDX_UNWANTEDTABLES_TABLEID ON #UnWantedTables(TableID)

DECLARE @MostRecentDate DATETIME

SELECT @MostRecentDate =  MAX(DateOfCurrentObservation) FROM [vol].[LoadObservations]

INSERT INTO #UnWantedTables(TableID)
--Get rid of tables with no records
SELECT t.TableID
FROM [vol].[Tables] t
JOIN [vol].[LoadObservations] lo
ON t.TableID = lo.TableID
GROUP BY t.TableID
HAVING AVG(CAST(lo.[RowCount] AS BIGINT)) = 0
UNION
--Get rid of tables with no load variance
SELECT t.TableID
FROM [vol].[Tables] t
JOIN [vol].[LoadObservations] lo
ON t.TableID = lo.TableID
GROUP BY t.TableID
HAVING AVG(lo.CurrentThreeSDLevel) = 0

--Manually get rid of unwanted tables.
--INSERT INTO #UnWantedTables(TableID)
--SELECT 131



SELECT TableID, [TableName]
FROM  [vol].[Tables]
WHERE TableID IN (
SELECT t.TableID
FROM [vol].[Tables] t
JOIN [vol].[LoadObservations] lo
ON t.TableID = lo.TableID
WHERE t.TableID NOT IN (SELECT TableID FROM #UnWantedTables)
AND lo.DateOfCurrentObservation BETWEEN DATEADD(DD,-3,CURRENT_TIMESTAMP) AND CURRENT_TIMESTAMP
GROUP BY t.TableID
HAVING AVG(CAST(lo.ChangeFromLastObservation AS FLOAT)) = 0
)

DROP TABLE #UnWantedTables

END




GO


