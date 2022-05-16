-- =============================================
-- Author: Deborah Wangerin
-- Create date: January 2017
-- Description: Clean EOD Asset Stage Data
-- 20170115 Original Proc
-- =============================================

USE [ODS]
GO

/****** Object:  StoredProcedure [dbo].[sp_CleanEODAssetData]    Script Date: 1/6/2017 11:54:01 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[sp_CleanEODAssetData] AS BEGIN

----Convert NULLS to empty strings
UPDATE [eod].[Asset]  
SET [Symbol] = ''  
WHERE [Symbol] IS NULL

END

GO
