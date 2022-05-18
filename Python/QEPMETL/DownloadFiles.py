import wget
import os
import quandl
import contextlib


root_directory = ''
yield_curve_data_directory = 'DailyTreasuryYieldCurveData/In/'
yield_curve_url = 'http://data.treasury.gov/feed.svc/DailyTreasuryYieldCurveRateData?$filter=month(NEW_DATE)%20eq%2011%20and%20year(NEW_DATE)%20eq%202017'

quarterly_real_gdp_data_directory = 'QuarterlyRealGrossDomesticProduct/In/'
annual_real_gdp_data_directory = 'AnnualRealGrossDomesticProduct/In/'

# Get Yield Curve Data
with contextlib.suppress(FileNotFoundError):
    os.remove(os.path.join(root_directory, yield_curve_data_directory,'YieldCurveData.xml'))
wget.download(yield_curve_url, os.path.join(root_directory, yield_curve_data_directory,'YieldCurveData.xml'))

# Get Quarterly Real Gross Domestic Product
quarterly_real_gdp = quandl.get("FRED/GDPC1", authtoken="")
quarterly_real_gdp.to_csv(os.path.join(root_directory,quarterly_real_gdp_data_directory,'quarterly_real_gdp.csv'))

# Get Annual Real Gross Domestic Product
annual_real_gdp = quandl.get("FRED/GDPCA", authtoken="")
annual_real_gdp.to_csv(os.path.join(root_directory,annual_real_gdp_data_directory,'annual_real_gdp.csv'))
