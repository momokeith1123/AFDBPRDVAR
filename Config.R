# 1-

# Remarqures d'ordre generale
# Il ya un decalage dans le numero du GROUPIDX entre le fichier GROUP, et le fichier GRP
# Le fichier GROUP est celui qui doit etre corrig?, il doit etre ? -1.
rm(list = setdiff(ls(), c( "DIR")))
gc()


library(RODBC)
con <- odbcConnect("SUMMITP", 
                   uid ="v60report", 
                   pwd = "v#60#ReporT789",
                   believeNRows= FALSE)
sqlQuery(con, "alter session set current_schema= v60")


options(java.parameters = "-Xmx4g") 
DIR <- list()
DIR[["root"]] <- "//afdbsmtprd/Summit_U_afdbsmtprd/SummitApps/PROD_AFDB_SSA/spool_arch"

# DIR[["data"]] <- "U:/SummitApps/PROD_AFDB_SSA/spool_arch"                                                                                                             
# DIR[["data"]] <- "U:/SummitApps/PROD_AFDB_SSA/Spool/On_demand/VAR_20190701/Juin2019_4"

DIR[["data"]] <- "//afdbsumdev/Y/Users/Mamadou/VaR_Results"
DIR[["vardata"]] <- "//afdbsumdev/Y/Users/Mamadou/01-Dev/04-ScriptR/AfdbVaR/data"
DIR[["function"]] <- "//afdbsumdev/Y/Users/Mamadou/01-Dev/04-ScriptR/AfdbVaR/function"
DIR[["load"]] <- "//afdbsumdev/Y/Users/Mamadou/01-Dev/04-ScriptR/AfdbVaR/load"
DIR[["compute"]] <- "//afdbsumdev/Y/Users/Mamadou/01-Dev/04-ScriptR/AfdbVaR/compute/"
DIR[["plan"]] <- "//afdbsumdev/Y/Users/Mamadou/01-Dev/04-ScriptR/AfdbVaR/plan/"
DIR[["model"]] <- "//afdbsumdev/Y/Users/Mamadou/01-Dev/04-ScriptR/AfdbVaR/model/"
DIR[["queries"]] <- "//afdbsumdev/Y/Users/Mamadou/01-Dev/04-ScriptR/AfdbVaR/model/"



CONFIG <- list ()

CONFIG[["isUNIX"]] <- FALSE
CONFIG[["workers"]] <- 4


#  Update the rundate vectors according to what runs we wants.

# c("01-07-19","08-07-19","15-07-19","22-07-19")
#  Le Run date correspond ? l'extension que Farres met dans les noms fichiers de rerun comme
# hvar_RGRP_ HVAR280619R_ADBHVAR _ 28-06-19 .xlsx

Rundates <- "20-09-19"
CONFIG[["ADBPRDVAR"]] <- c("ADBPRDVAR_ADBHVAR","SADBPRDVAR_STRESSADBHVAR")

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


# CONFIG[["ADBPRDVAR"]] <- "HVAR280619R_ADBHVAR"

# CONFIG[["SADBPRDVAR"]] <- "SADBPRDVAR_STRESSADBHVAR"

setwd(DIR[["root"]])

 