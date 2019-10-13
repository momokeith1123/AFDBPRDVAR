
# require(XLConnect)
require(xts)
require(xlsx)



setwd(DIR[["load"]])
source("initial.R")



xlsx.writeMultipleData("ADBPRDVAR.xlsx", HVAR_RGRP[["GROUP"]],
                                    HVAR_RGRP[["GRP"]])
# Add a worksheet to my_book, named "data_summary"
# createSheet(wb,names(HVAR_RGRP))
# 
# for ( i in 1:length(HVAR_RGRP)) {
# # for ( i in 1:2) {
#   createSheet(wb,name =names(HVAR_RGRP)[i])
#   writeWorksheet(wb,HVAR_RGRP[[i]],sheet = names(HVAR_RGRP[i]))
# }

# writeWorksheet(wb,HVAR_RGRP[[1]],"data_summary", startRow = 1, startCol = 1 )
saveWorkbook(wb, "tEST3.xlsx")

rm( list = setdiff(ls(), c("CONFIG", "DIR", "rundate", "svar", "var" , "HVAR_RGRP", "wb")))


gc()
