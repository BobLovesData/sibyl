import quandl
import pandas

quandl.ApiConfig.api_key = ''
test = quandl.get('SF1/PFE_GP_MRQ')

print(test)
