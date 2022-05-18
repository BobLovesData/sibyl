-- =============================================
-- Author: Bob Wakefield
-- Create date: 15Oct17
-- Description: Check Stage Tables for unprocessed records.
-- =============================================


USE ODS
GO

/****** Object:  StoredProcedure dbo.sp_CheckForUnprocessedRecords    Script Date: 2/5/2016 4:00:34 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'dbo.sp_CheckForUnprocessedRecords') AND type in (N'P', N'PC'))
DROP PROCEDURE dbo.sp_CheckForUnprocessedRecords
GO

/****** Object:  StoredProcedure dbo.sp_CheckForUnprocessedRecords    Script Date: 2/5/2016 4:00:34 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'dbo.sp_CheckForUnprocessedRecords') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE dbo.sp_CheckForUnprocessedRecords AS' 
END
GO


ALTER PROCEDURE dbo.sp_CheckForUnprocessedRecords
AS
BEGIN

--Check for unprocessed records
SELECT *
FROM [eod].[Assets]
WHERE Processed = 0


IF @@RowCount > 0
BEGIN
EXEC msdb.dbo.sp_send_dbmail
@profile_name = 'Monitoring',
@recipients = 'bob@MassStreet.net',
@subject = 'Unprocessed Records Exist',
@body = 'There are unprocessed records in the Assets Staging Table' ;
END

SELECT *
FROM [eod].[EODPrices]
WHERE Processed = 0

IF @@RowCount > 0
BEGIN
EXEC msdb.dbo.sp_send_dbmail
@profile_name = 'Monitoring',
@recipients = 'bob@MassStreet.net',
@subject = 'Unprocessed Records Exist',
@body = 'There are unprocessed records in the EOD Prices Staging Table' ;
END

SELECT *
FROM [eod].[Exchanges]
WHERE Processed = 0


IF @@RowCount > 0
BEGIN
EXEC msdb.dbo.sp_send_dbmail
@profile_name = 'Monitoring',
@recipients = 'bob@MassStreet.net',
@subject = 'Unprocessed Records Exist',
@body = 'There are unprocessed records in the Exchanges staging table.' ;
END


END
GO
