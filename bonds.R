con <- BdlConnection(user = 'dl783324', 
                    pw = 'nV0SJlTQtC,A-p[y',
                    key = '/BX_Vhrk')


#######################
#Sync call

history <- GetHistory(con, 
                      fields = c('PX_OPEN', 'PX_HIGH', 'PX_LOW'), 
                      tickers = c('SPX Index', 'SMI Index', 'IBM US Equity', '120421Q FP Equity'),
                      fromDate = "2015-05-01", toDate = "2015-05-08",
                      verbose = TRUE)

#the call blocks, and after 5 minutes or so, you get the reply
if(history$success) {
  history$reply
  #or extract single column:
  history$reply$SPX_Index.PX_HIGH
}

#To see the downloaded file content:
cat(history$response)

#Or, if you prefer a list with one xts object per security:
history <- GetHistory(con, 
                      fields = c('PX_OPEN', 'PX_HIGH', 'PX_LOW'), 
                      tickers = c('SPX Index', 'SMI Index', 'IBM US Equity', '120421Q FP Equity'),
                      fromDate = "2015-05-01", toDate = "2015-05-08",
                      parser = GetHistoryListParser,
                      verbose = TRUE)


#######################
#Async call

history <- GetHistory(con, 
                      fields = c('PX_OPEN', 'PX_HIGH', 'PX_LOW', 'PX_LAST'), 
                      tickers = c('SPX Index', 'SMI Index', 'IBM US Equity', '120421Q FP Equity'),
                      fromDate = "2015-05-01", toDate = "2015-05-08",
                      sync = FALSE,
                      verbose = TRUE)

#the method returns after uploading. 5 minutes later, you can request to download
#the reply using the callback:
reply <- history$GetReply()
if(!is.null(reply)) {
  #do something with the data
}

data <- GetData(con,fields ,tickers = 'US00764MFC64 US|ISIN')

######################
#Re-download an existing file

TryGetBdlData(con, history$replyFileName)


# fields <- c('NAME','RTG_MOODY', 'RTG_FITCH','RTG_SP', 'RTG_SP_GSR','RTG_SP_LONG','RTG_SP_SHORT','RTG_SP_GSR_DT', , 'RTG_DBRS', 'RTG_AMBEST', 'RTG_JCR')

fields <- c('NAME','RTG_MOODY', 'RTG_FITCH','RTG_SP', 'RTG_SP_GSR', 'RTG_DBRS', 'RTG_AMBEST')

tickers = c('US004375DF58 US|ISIN', 'US00764MFC64 US|ISIN', 'US02147DAU54 US|ISIN')

US912796QU67
US912796PB95
US9127952M28

## End(Not run)