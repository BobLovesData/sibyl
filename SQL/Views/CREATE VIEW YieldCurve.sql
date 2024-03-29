USE Reporting

GO

CREATE VIEW YieldCurve AS


SELECT
d.FullDateUSA AS [Date],
tyc.[1Month] AS [.8],
tyc.[3Month] AS [.25],
tyc.[6Month] AS [.5],
tyc.[1Year] AS [1],
tyc.[2Year] AS [2],
tyc.[3Year] AS [3],
tyc.[5Year] AS [5],
tyc.[7Year] AS [7],
tyc.[10Year] AS [10],
tyc.[20Year] AS [20],
tyc.[30Year] AS [30]
FROM Sibyl.dw.FactTreasuryYieldCurve tyc
JOIN Sibyl.dw.DimDate d
ON d.DateCK = tyc.AsOfDateCK