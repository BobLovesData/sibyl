import quandl
import pandas

quandl.ApiConfig.api_key = 'ZwazymZ9jtRzzPxqzHwd'
test = quandl.get('SF1/PFE_GP_MRQ')

print(test)
