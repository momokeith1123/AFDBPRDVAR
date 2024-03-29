# 3-
# 
library('data.table')
library('dplyr')
library('openxlsx')
library(stringr)
library(rebus)  # for the regular expressions String Manipulation in R with stringr

setwd(DIR[["function"]])
source("loadHvarResultFile.R")
# source("getSQL.r")
source("functionSQL.r")

# Load Security Fiter given a perfvalo run
sqlq <- getSQL(filepathSec)
sqlq <- ApplyFunctionParam  (ImpTimeStamp, sqlq)
secFilter <- sqlQuery(con,sqlq)

setwd(DIR[["root"]])
if ("S.R" %in% list.files()) {
  source("S.R")
} else {
  S <- c( "GROUP", "GRP", "GRPSFT", "IDENTIFIER", "TRADE", "TRDGRPSFT")
  dump(list = "S", "S.R")
}

invalid <- character(0)
if("invalid.R" %in% list.files()) source("invalid.R")

HVAR_RGRP <- list ()

# For each each run dates
for (i in seq_along(Rundates)) {
   
  print (i)
    # print(paste0(DIR[["data"]],"/", "spool", "_",Rundate[i], "/", "HVAR"))
    setwd(paste0(DIR[["root"]],"/", "spool", "_",Rundates[i], "/", "HVAR"))
    
    #  For each files within the run
    for(s in S){
        suppressWarnings(
        HVAR_RGRP[[ Rundates[i] ]][[s]]  <- getHvarFiles(CONFIG[["ADBPRDVAR"]][[i]] ,Rundates[i],s)
      )
    }

# We update the column RCLASSID for GROUP in order to put ADB as riskfactor in global level
# we first identif the row number corrsponding GLOBAL in group file
    
  grp <- HVAR_RGRP[[ Rundates[i] ]][["GROUP"]] 
  grp_row <- which(grp["GROUPID"]== "GLOBAL")
  
  # Address groupidx 
  grp$GROUPIDX <- grp$GROUPIDX-1
  grp <- grp %>% left_join(dt, by = c("GROUPNUM"))
  HVAR_RGRP[[ Rundates[i] ]][["GROUP"]] <- grp
  
  grpx <- grp %>% select(GROUPNUM,GROUPIDX,RCLASSID,DMINDEX, CCY1)
  #  Amend the others tab
  HVAR_RGRP[[ Rundates[i] ]][["GRP"]] <- HVAR_RGRP[[ Rundates[i] ]][["GRP"]] %>% left_join(grpx, by = "GROUPIDX")
  grpsft <- HVAR_RGRP[[ Rundates[i] ]][["GRPSFT"]] %>% left_join(grpx, by = "GROUPIDX")
 
   HVAR_RGRP[[ Rundates[i] ]][["GRPSFT"]] <- grpsft %>%
    mutate (RISKTYPE = case_when(
      str_detect(DMINDEX, pattern = ANY_CHAR %R% "_F" %R% ANY_CHAR) == TRUE ~ "CS_VaR",
      str_detect(DMINDEX, pattern = ANY_CHAR %R% "_G" %R% ANY_CHAR) == TRUE ~ "CS_VaR",
      str_detect(DMINDEX, pattern = ANY_CHAR %R% "_Y" %R% ANY_CHAR) == TRUE ~ "CS_VaR",
      str_detect(DMINDEX, pattern = ANY_CHAR %R% "_S" %R% ANY_CHAR) == TRUE ~ "CS_VaR",
      str_detect(DMINDEX, pattern = ANY_CHAR %R% "_C" %R% ANY_CHAR) == TRUE ~ "CS_VaR",
      # str_detect(DMINDEX, pattern = ANY_CHAR %R% "PRDEUR" %R% ANY_CHAR) == TRUE ~ "PRDEUR",
      # str_detect(DMINDEX, pattern = ANY_CHAR %R% "PRDGBP" %R% ANY_CHAR) == TRUE ~ "PRDGBP",
      # str_detect(DMINDEX, pattern = ANY_CHAR %R% "PRDUSD" %R% ANY_CHAR) == TRUE ~ "PRDUSD",
      # str_detect(DMINDEX, pattern = ANY_CHAR %R% "PRDUSD" %R% ANY_CHAR) == TRUE ~ "PRDUSD",
      # str_detect(DMINDEX, pattern = ANY_CHAR %R% "R2RUSD" %R% ANY_CHAR) == TRUE ~ "R2RUSD",
      TRUE ~"IR"
    ))
  # grpsft <- grpsft %>%  select(GROUPIDX)                        )
  # HVAR_RGRP[[ Rundates[i] ]][["TRDGRPSFT"]] <- HVAR_RGRP[[ Rundates[i] ]][["GRP"]] %>% left_join(grpx, by = "GROUPIDX")
  
  # HVAR_RGRP[[ Rundates[i] ]][["GRP"]] <-  HVAR_RGRP[[ Rundates[i] ]][["GRP"]] %>% left_join(dt, )
  
  HVAR_RGRP[[ Rundates[i] ]][["GROUP"]] [["RCLASSID"]][[grp_row]] <- "ADBVAR"
  
  #  adding the desk and ccy in TRADE
  trd <- HVAR_RGRP[[ Rundates[i] ]][["TRADE"]]
  
  HVAR_RGRP[[ Rundates[i] ]][["TRADE"]] <- trd %>%
      mutate (DESK = case_when(
                      str_detect(ALTID, pattern = ANY_CHAR %R% "GKEY" %R% ANY_CHAR) == TRUE ~ "GKEY",
                      str_detect(ALTID, pattern = ANY_CHAR %R% "MARGEUR" %R% ANY_CHAR) == TRUE ~ "MARGEUR",
                      str_detect(ALTID, pattern = ANY_CHAR %R% "MARGUSD" %R% ANY_CHAR) == TRUE ~ "MARGUSD",
                      str_detect(ALTID, pattern = ANY_CHAR %R% "OPPGBP" %R% ANY_CHAR) == TRUE ~ "OPPGBP",
                      str_detect(ALTID, pattern = ANY_CHAR %R% "OPPUSD" %R% ANY_CHAR) == TRUE ~ "OPPUSD",
                      str_detect(ALTID, pattern = ANY_CHAR %R% "PRDEUR" %R% ANY_CHAR) == TRUE ~ "PRDEUR",
                      str_detect(ALTID, pattern = ANY_CHAR %R% "PRDGBP" %R% ANY_CHAR) == TRUE ~ "PRDGBP",
                      str_detect(ALTID, pattern = ANY_CHAR %R% "PRDUSD" %R% ANY_CHAR) == TRUE ~ "PRDUSD",
                      str_detect(ALTID, pattern = ANY_CHAR %R% "PRDUSD" %R% ANY_CHAR) == TRUE ~ "PRDUSD",
                      str_detect(ALTID, pattern = ANY_CHAR %R% "R2RUSD" %R% ANY_CHAR) == TRUE ~ "R2RUSD",
                      TRUE ~"OTHERS"
      )) %>%
      mutate (RISKCCY = case_when(
                          str_detect(DESCRIPTION, pattern = ANY_CHAR %R% "USD" %R% ANY_CHAR) == TRUE ~ "USD",
                          str_detect(DESCRIPTION, pattern = ANY_CHAR %R% "EUR" %R% ANY_CHAR) == TRUE ~ "EUR",
                          str_detect(DESCRIPTION, pattern = ANY_CHAR %R% "GBP" %R% ANY_CHAR) == TRUE ~ "GBP",
                          str_detect(DESCRIPTION, pattern = ANY_CHAR %R% "JPY" %R% ANY_CHAR) == TRUE ~ "JPY",
                          str_detect(DESCRIPTION, pattern = ANY_CHAR %R% "CHF" %R% ANY_CHAR) == TRUE ~ "CHF",
                          str_detect(DESCRIPTION, pattern = ANY_CHAR %R% "CNH" %R% ANY_CHAR) == TRUE ~ "CNH",
                          str_detect(DESCRIPTION, pattern = ANY_CHAR %R% "CAD" %R% ANY_CHAR) == TRUE ~ "CAD",
                          str_detect(DESCRIPTION, pattern = ANY_CHAR %R% "ZAR" %R% ANY_CHAR) == TRUE ~ "ZAR",
                          str_detect(DESCRIPTION, pattern = ANY_CHAR %R% "CNY" %R% ANY_CHAR) == TRUE ~ "CNY",
                          # str_detect(DESCRIPTION, pattern = ANY_CHAR %R% "OTHERS" %R% ANY_CHAR) == TRUE ~ "OTHERS",
        TRUE ~"OTHERS"
      )) %>% arrange(DESK)
      
  trd <-HVAR_RGRP[[ Rundates[i] ]][["TRADE"]]
  
  #  adding the contract or secid
  for (row in 1:nrow (trd)) {
    if (trd[["TYPE"]][[row]] == "BOND") {
      trd [["SECID"]][[row]]= str_split(trd[["ALTID"]][[row]], "\\|")[[1]][[1]]
    } else if (trd[["TYPE"]][[row]] == "FUT") {
      trd [["SECID"]][[row]]= paste0 (str_split(trd[["ALTID"]][[row]], "\\|")[[1]][[1]],str_split(trd[["ALTID"]][[row]], "\\|")[[1]][[2]])
    } else  {
      trd [["SECID"]][[row]]= ""
    }
  }
     
  
  # adding Desk and Tradetype in TRDGRPSFT
  # trdgpsft <- HVAR_RGRP[[ Rundates[i] ]][["TRADE"]]%>%select(TRADEIDX,DESK,TYPE,RISKCCY)
  trdgpsft <- trd%>%select(-ID, ALTID, -VERSION, -DESCRIPTOR)
  trd_gpsft <- left_join(HVAR_RGRP[[ Rundates[i] ]] [["TRDGRPSFT"]], trdgpsft , by = "TRADEIDX")
  trd_gpsft <-  trd_gpsft %>% left_join(grpx, by = "GROUPIDX")
  
  # removing dmindex because not correct
  # trd_gpsft
  # adding column from secfilter
  trd_gpsft <- trd_gpsft %>% left_join(secFilter, by = "SECID")
  HVAR_RGRP[[ Rundates[i] ]] [["TRDGRPSFT"]] <- trd_gpsft
  
  # grp_sft <- HVAR_RGRP[[ Rundates[i] ]] [["GRPSFT"]]
  # grp_pnl <- grp_sft %>% filter()    
  # grouping <- HVAR_RGRP[[ Rundates[i] ]]$TRADE$TYPE
  # split_trade <- split( HVAR_RGRP[[ Rundates[i] ]]$TRADE,grouping)
  # 
  # BOND <- split_trade$BOND %>% mutate (IDENTIFIER = str_split(DESCRIPTION, pattern = "/")[[1]][[4]] )
 
  
  dat <- HVAR_RGRP[[ Rundates[i] ]]
    wb <- createWorkbook()
    Map(function(data, name){

     addWorksheet(wb, name)
     writeData(wb, name, data)

   }, dat, names(dat))

   
    ## Save workbook to working directory
    saveWorkbook(wb, file = paste(CONFIG[["ADBPRDVAR"]],Rundates[[i]], "_AGG.xlsx"), overwrite = TRUE)
                     
}




