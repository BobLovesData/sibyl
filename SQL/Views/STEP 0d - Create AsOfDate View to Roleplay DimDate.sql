USE [FSA]
GO

/****** Object:  View [dbo].[DimAsOfDate]    Script Date: 1/16/2017 5:11:19 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[DimAsOfDate] AS


SELECT [DateCK]
      ,[Date]
      ,[Day]
      ,[DaySuffix]
      ,[Weekday]
      ,[WeekDayName]
      ,[IsWeekend]
      ,[IsHoliday]
	  ,[HolidayText]
      ,[DOWInMonth]
      ,[DayOfYear]
      ,[WeekOfMonth]
      ,[WeekOfYear]
      ,[ISOWeekOfYear]
      ,[Month]
      ,[MonthName]
      ,[Quarter]
      ,[QuarterName]
      ,[Year]
      ,[MMYYYY]
      ,[MonthYear]
      ,[FirstDayOfMonth]
      ,[LastDayOfMonth]
      ,[FirstDayOfQuarter]
      ,[LastDayOfQuarter]
      ,[FirstDayOfYear]
      ,[LastDayOfYear]
      ,[FirstDayOfNextMonth]
      ,[FirstDayOfNextYear]
  FROM [FSA].[dbo].[DimDate]

GO


