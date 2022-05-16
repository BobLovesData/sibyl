/*
Create an insert statement for every variable that you create as a configuration value.
The PackageName is the name of the package MINUS the package extension.
PackageName functions as a filter that you select your variables on.
*/

USE SSISManagement

--Substitute the name of your package.

DELETE FROM SSISConfigurations
WHERE PackageName = 'LoadExchangeData'

INSERT INTO SSISConfigurations(PackageName, VariableName, VariableValue)
SELECT 'LoadExchangeData', 'BaseRemoteFolder', 'C:\EODDataTest\'
UNION ALL 
SELECT 'LoadExchangeData', 'ExchangeDataFileName', 'ExchangeList.xml'
UNION ALL 
SELECT 'LoadExchangeData', 'BaseLocalFolder', 'C:\InterfaceAndExtractFiles\MassStreet\'
UNION ALL 
SELECT 'LoadExchangeData', 'InFolderName', 'In\'
UNION ALL 
SELECT 'LoadExchangeData', 'OutFolderName', 'Out\'
UNION ALL 
SELECT 'LoadExchangeData', 'ArchiveFolderName', 'Archive\'
UNION ALL
SELECT 'LoadExchangeData', 'ExhangeSymbolListLocalFolder', 'ExchangeSymbolList\'


DELETE FROM SSISConfigurations
WHERE PackageName = 'LoadAMEXSymbolList'

INSERT INTO SSISConfigurations(PackageName, VariableName, VariableValue)
SELECT 'LoadAMEXSymbolList', 'ArchiveFolderName', 'Archive\'
UNION ALL
SELECT 'LoadAMEXSymbolList', 'BaseLocalFolder', 'C:\InterfaceAndExtractFiles\MassStreet\'
UNION ALL
SELECT 'LoadAMEXSymbolList', 'BaseRemoteFolder', 'C:\EODDataTest\'
UNION ALL
SELECT 'LoadAMEXSymbolList', 'DataFileName', 'SymbolList.xml'
UNION ALL
SELECT 'LoadAMEXSymbolList', 'LocalFolder', 'AMEXSymbolList\'
UNION ALL
SELECT 'LoadAMEXSymbolList', 'InFolderName', 'In\'
UNION ALL
SELECT 'LoadAMEXSymbolList', 'OutFolderName', 'Out\'
UNION ALL
SELECT 'LoadAMEXSymbolList', 'RemoteFolder', 'AMEX\'

DELETE FROM SSISConfigurations
WHERE PackageName = 'LoadINDEXSymbolList'

INSERT INTO SSISConfigurations(PackageName, VariableName, VariableValue)
SELECT 'LoadINDEXSymbolList', 'ArchiveFolderName', 'Archive\'
UNION ALL
SELECT 'LoadINDEXSymbolList', 'BaseLocalFolder', 'C:\InterfaceAndExtractFiles\MassStreet\'
UNION ALL
SELECT 'LoadINDEXSymbolList', 'BaseRemoteFolder', 'C:\EODDataTest\'
UNION ALL
SELECT 'LoadINDEXSymbolList', 'DataFileName', 'SymbolList.xml'
UNION ALL
SELECT 'LoadINDEXSymbolList', 'LocalFolder', 'INDEXSymbolList\'
UNION ALL
SELECT 'LoadINDEXSymbolList', 'InFolderName', 'In\'
UNION ALL
SELECT 'LoadINDEXSymbolList', 'OutFolderName', 'Out\'
UNION ALL
SELECT 'LoadINDEXSymbolList', 'RemoteFolder', 'INDEX\'

DELETE FROM SSISConfigurations
WHERE PackageName = 'LoadNASDAQSymbolList'

INSERT INTO SSISConfigurations(PackageName, VariableName, VariableValue)
SELECT 'LoadNASDAQSymbolList', 'ArchiveFolderName', 'Archive\'
UNION ALL
SELECT 'LoadNASDAQSymbolList', 'BaseLocalFolder', 'C:\InterfaceAndExtractFiles\MassStreet\'
UNION ALL
SELECT 'LoadNASDAQSymbolList', 'BaseRemoteFolder', 'C:\EODDataTest\'
UNION ALL
SELECT 'LoadNASDAQSymbolList', 'DataFileName', 'SymbolList.xml'
UNION ALL
SELECT 'LoadNASDAQSymbolList', 'LocalFolder', 'NASDAQSymbolList\'
UNION ALL
SELECT 'LoadNASDAQSymbolList', 'InFolderName', 'In\'
UNION ALL
SELECT 'LoadNASDAQSymbolList', 'OutFolderName', 'Out\'
UNION ALL
SELECT 'LoadNASDAQSymbolList', 'RemoteFolder', 'NASDAQ\'


DELETE FROM SSISConfigurations
WHERE PackageName = 'LoadNYSESymbolList'

INSERT INTO SSISConfigurations(PackageName, VariableName, VariableValue)
SELECT 'LoadNYSESymbolList', 'ArchiveFolderName', 'Archive\'
UNION ALL
SELECT 'LoadNYSESymbolList', 'BaseLocalFolder', 'C:\InterfaceAndExtractFiles\MassStreet\'
UNION ALL
SELECT 'LoadNYSESymbolList', 'BaseRemoteFolder', 'C:\EODDataTest\'
UNION ALL
SELECT 'LoadNYSESymbolList', 'DataFileName', 'SymbolList.xml'
UNION ALL
SELECT 'LoadNYSESymbolList', 'LocalFolder', 'NYSESymbolList\'
UNION ALL
SELECT 'LoadNYSESymbolList', 'InFolderName', 'In\'
UNION ALL
SELECT 'LoadNYSESymbolList', 'OutFolderName', 'Out\'
UNION ALL
SELECT 'LoadNYSESymbolList', 'RemoteFolder', 'NYSE\'


SELECT *
FROM SSISConfigurations
WHERE PackageName = 'LoadNYSESymbolList'
