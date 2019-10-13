# 2-
require(readr)
getHvarFiles <- function (varconf, asofdate,csvfile) {
  
  # csvfile <- read_csv (paste0("hvar_RGRP_", varType , "_",rundate, "_", fnames,".csv"))
  # varconf <- "ADBPRDVAR_ADBHVAR"
  # asofdate <- "18-09-19"
  # csvfile <- "GROUP"
  
  # path <- paste0("hvar_RGRP_", varType , "_",rundate,"R", "_", fnames,".csv")
  # 
  # print (paste0("vartype :", varType))
  # print (paste0("rundate :", rundate))
  # print (paste0("fnames :" , fnames) )
  
  filenames <- paste0("hvar_RGRP","_",varconf , "_",asofdate, "_", csvfile,".csv")
  
  csvfile <- read_csv (filenames)
                       # col_types = cols(ALTCCY = col_skip(), 
                       # GROUPID = col_integer(), GROUPIDX = col_integer(), 
                       # GROUPNUM = col_integer(), STANDARDDEV = col_skip()))
                       
                       
  return(csvfile)
}


# jgc <- function()
# {
#   .jcall("java/lang/System", method = "gc")
# } 

# getidentifier <- function(list_trade_by_assetclass) {
#   # name(list_trade)
#   
#   for (i in seq_along(list_trade_by_assetclass)) {
#     print(list_trade_by_assetclass$DESCRIPTION[i])  
#     list_trade_by_assetclass$IDENTIFIER [i] = str_split(list_trade_by_assetclass$DESCRIPTION[i], pattern = "/")[[1]][[4]]
#     return(list_trade_by_assetclass)
#   }
# }
# 
# 
# grouping <- HVAR_RGRP[[ Rundates[i] ]]$TRADE$TYPE
# split_trade <- split( HVAR_RGRP[[ Rundates[i] ]]$TRADE,grouping)
# 
# for (i in seq_along())
# 
# lapply(split_trade, getidentifier)
