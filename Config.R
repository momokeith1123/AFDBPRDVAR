# 1-

# Remarqures d'ordre generale
# Il ya un decalage dans le numero du GROUPIDX entre le fichier GROUP, et le fichier GRP
# Le fichier GROUP est celui qui doit etre corrig?, il doit etre ? -1.
rm(list = setdiff(ls(), c( "DIR")))
gc()

library(dplyr)
library(RODBC)
con <- odbcConnect("SUMMITP", 
                   uid ="v60report", 
                   pwd = "v#60#ReporT789",
                   believeNRows= FALSE)
sqlQuery(con, "alter session set current_schema= v60")


options(java.parameters = "-Xmx4g") 
DIR <- list()
DIR[["root"]] <- "//afdbsmtprd/Summit_U_afdbsmtprd/SummitApps/PROD_AFDB_SSA/spool"
# DIR[["root"]] <- "//afdbsmtprd/Summit_U_afdbsmtprd/SummitApps/PROD_AFDB_SSA/spool_arch"

# Dev

DIR[["data"]] <- "D:/repos/AFDBPRDVAR"
DIR[["vardata"]] <- "D:/repos/AFDBPRDVAR"
DIR[["function"]] <- "D:/repos/AFDBPRDVAR"
DIR[["queries"]] <- "D:/repos/AFDBPRDVAR/queries/"
filepathSec = "D:/repos/AFDBPRDVAR/queries/StaticSecurityFilter.sql"
ImpTimeStamp <- "2019-10-15 17:05:26.986"
# DIR[["load"]] <- "D:/repos/AFDBPRDVAR/"
# DIR[["compute"]] <- "D:/repos/AFDBPRDVAR/"
# DIR[["plan"]] <- "//afdbsumdev/Y/Users/Mamadou/01-Dev/04-ScriptR/AfdbVaR/plan/"
# DIR[["model"]] <- "//afdbsumdev/Y/Users/Mamadou/01-Dev/04-ScriptR/AfdbVaR/model/"

# Production

# DIR[["data"]] <- "//afdbsumdev/Y/Users/Mamadou/VaR_Results"
# DIR[["vardata"]] <- "//afdbsumdev/Y/Users/Mamadou/01-Dev/04-ScriptR/AfdbVaR/data"
# DIR[["function"]] <- "//afdbsumdev/Y/Users/Mamadou/01-Dev/04-ScriptR/AfdbVaR/function"
# DIR[["load"]] <- "//afdbsumdev/Y/Users/Mamadou/01-Dev/04-ScriptR/AfdbVaR/load"
# DIR[["compute"]] <- "//afdbsumdev/Y/Users/Mamadou/01-Dev/04-ScriptR/AfdbVaR/compute

# DIR[["plan"]] <- "//afdbsumdev/Y/Users/Mamadou/01-Dev/04-ScriptR/AfdbVaR/plan/"
# DIR[["model"]] <- "//afdbsumdev/Y/Users/Mamadou/01-Dev/04-ScriptR/AfdbVaR/model/"
# DIR[["queries"]] <- "//afdbsumdev/Y/Users/Mamadou/01-Dev/03-ScriptSQL/07-SecurityFilter/"


CONFIG <- list ()

CONFIG[["isUNIX"]] <- FALSE
CONFIG[["workers"]] <- 4

# Run parameters

Rundates <- "30-09-19"
# varFilter <- "ADB"
varFilter <- "ADBPRDVAR"
svarFilter <- "SADBPRDVAR"

varIdent <- "ADBHVAR"
svarIdent <- "STRESSADBHVAR"

hedgeconfig <- "ADBVAR"
CONFIG[["ADBPRDVAR"]] <- c(paste0(varFilter, "_", varIdent),paste0(svarFilter,svarIdent))

CONFIG[["GROUP_0"]]<-c("GROUPIDX_0", "GROUPID_0", "EXPCCY_0", "RISKCCY_0", "ALTCCY_0", "RCLASSID_0", "GROUPNUM_0", "VARAMOUNT_0")
CONFIG[["GROUP_1"]]<-c("GROUPIDX_1", "GROUPID_1", "EXPCCY_1", "RISKCCY_1", "ALTCCY_1", "RCLASSID_1", "GROUPNUM_1","MEAN_1","PLUP_1","PLDOWN_1")

CONFIG[["RefPeriod"]][["AsOfYear"]] = 2019
CONFIG[["RefPeriod"]][["AsOfPeriod"]] = 10

CONFIG[["PrevPeriod"]][["AsOfYear"]] = 2019
CONFIG[["PrevPeriod"]][["AsOfYear"]] = 7

usdua_ref <- sqlQuery(con,"select rate from cdmrateua where ccy = 'USD' and asofyear = to_char(to_date('20190701', 'YYYYMMDD'),'YYYY')  
                                                                     and asofperiod = to_char(to_date('20190701', 'YYYYMMDD'),'MM')" )
usdua_prv <- sqlQuery(con,"select rate from cdmrateua where ccy = 'USD' and asofyear = to_char(to_date('20190401', 'YYYYMMDD'),'YYYY')  
                                                                     and asofperiod = to_char(to_date('20190401', 'YYYYMMDD'),'MM')" )
dmriskdata <- sqlQuery(con, "select * from dmrisk_data where classname = 'ADBVAR'")
dt <- dmriskdata %>% select (c(CLASSNAME, TYPE, CCY1,DMINDEX, SHIFTTYPE,GROUPNUM, TRADETYPE,ID,REFCCY ,REFINDEX,MCTYPE,SHIFTFORMAT))%>% arrange(TYPE,CCY1, DMINDEX,GROUPNUM)
              

# df <- tibble(dmriskdata)
# CONFIG[["ADBPRDVAR"]] <- "HVAR280619R_ADBHVAR"

# CONFIG[["SADBPRDVAR"]] <- "SADBPRDVAR_STRESSADBHVAR"

setwd(DIR[["root"]])

