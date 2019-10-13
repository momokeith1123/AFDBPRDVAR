setwd("//afdbsumdev/Y/Users/Mamadou/01-Dev/04-ScriptR/AfdbVaR")
source("Config.R")
source("function/loadHvarResultFile.R")
source("load/initial.R")

library(XLConnect)

# GROUP
grp0 <- HVAR_RGRP[["29-03-19R"]][["GROUP"]]
grp1 <- HVAR_RGRP[["28-06-19R6"]][["GROUP"]]

grp0_adbgrpnum <- grp0$GROUPNUM[ which(grp0["GROUPID"]== "GLOBAL") ]
grp0_adbgrpidx <- grp0$GROUPIDX[ which(grp0["GROUPID"]== "GLOBAL") ] -1

grp1_adbgrpnum <- grp1$GROUPNUM[ which(grp1["GROUPID"]== "GLOBAL") ]
grp1_adbgrpidx <- grp1$GROUPIDX[ which(grp1["GROUPID"]== "GLOBAL") ] -1

NewRiskFactor<-  grp1 %>% anti_join(grp0,  by = c("RCLASSID","GROUPNUM"))
deadRiskFactor<- grp0 %>% anti_join(grp1,  by = c("RCLASSID","GROUPNUM"))

InliveRiskfactor_grp1 <-  grp1 %>% semi_join(grp0,  by = c("RCLASSID","GROUPNUM"))
InliveRiskfactor_grp0 <-  grp0 %>% semi_join(grp1,  by = c("RCLASSID","GROUPNUM"))


sim_group0 <- grp0 %>% select(GROUPIDX,RCLASSID,GROUPNUM, VARAMOUNT)
sim_group1 <- grp1 %>% select(GROUPIDX,RCLASSID,GROUPNUM, VARAMOUNT)

#  On remplace les NA par 0
sim_group0[is.na(sim_group0)] <- 0
sim_group1[is.na(sim_group1)] <- 0

names(sim_group0) <- c("GROUPIDX_0","RCLASSID","GROUPNUM", paste0("VARAMOUNT", Rundates[1]))
names(sim_group1) <- c("GROUPIDX_1","RCLASSID","GROUPNUM", paste0("VARAMOUNT", Rundates[2]))

synth_group <- sim_group1 %>% left_join(sim_group0, by = c("RCLASSID","GROUPNUM"))%>% arrange(`VARAMOUNT28-06-19R6`) 
synth_group <- synth_group %>% mutate(DELTA = (`VARAMOUNT28-06-19R6` - `VARAMOUNT29-03-19R`)*(-1))

synth_group$`VARAMOUNT28-06-19R6` <- synth_group$`VARAMOUNT28-06-19R6`*(-1)
synth_group$`VARAMOUNT29-03-19R` <- synth_group$`VARAMOUNT29-03-19R` *(-1)

delta_ADB <- synth_group %>% filter( RCLASSID == "ADBVAR")

top_ten_increase <- synth_group %>% filter( RCLASSID != "ADBVAR") %>% arrange(desc(DELTA)) %>%head(10)
top_ten_decrease <- synth_group %>% filter( RCLASSID != "ADBVAR") %>% arrange((DELTA)) %>% head(10)

top_ten_high <- synth_group %>% arrange(desc(`VARAMOUNT28-06-19R6`)) %>%filter (RCLASSID != "ADBVAR") %>%head(10)
top_ten_low  <- synth_group %>% arrange(`VARAMOUNT28-06-19R6`)  %>%filter (RCLASSID != "ADBVAR") %>% head(10)


top <- list (top_ten_increase,top_ten_decrease,top_ten_high,top_ten_low)

# Marginal Var
trdgrpsft_0 <- HVAR_RGRP[[  Rundates[1]  ]] [["TRDGRPSFT"]]
trdgrpsft_1 <- HVAR_RGRP[[  Rundates[2]  ]] [["TRDGRPSFT"]]

trdgrpsft_0$TRADEPL[is.na(trdgrpsft_0$TRADEPL)]<-0
trdgrpsft_1$TRADEPL[is.na(trdgrpsft_1$TRADEPL)]<-0

# By Desk
trdgrpsft_desk_0 <-trdgrpsft_0 %>% filter(GROUPIDX != grp0_adbgrpidx)%>% group_by(SHIFT_T0, SHIFT_T1, DESK)%>% summarize(PnL_tot_usd = sum(as.numeric(TRADEPL)) )%>% arrange(DESK,SHIFT_T1, SHIFT_T0)
trdgrpsft_desk_1 <-trdgrpsft_1 %>% filter(GROUPIDX != grp1_adbgrpidx)%>% group_by(SHIFT_T0, SHIFT_T1, DESK)%>% summarize(PnL_tot_usd = sum(as.numeric(TRADEPL)) )%>% arrange(DESK,SHIFT_T1, SHIFT_T0)
grouping_desk0  <- trdgrpsft_desk_0$DESK
grouping_desk1  <- trdgrpsft_desk_1$DESK

split_trdgrpsft_desk_0 <- split(trdgrpsft_desk_0, grouping_desk0)
split_trdgrpsft_desk_1 <- split(trdgrpsft_desk_1, grouping_desk1)

var_desk0 <- sapply(split_trdgrpsft_desk_0, CalCulate99pctVar,"PnL_tot_usd" )
var_desk1 <- sapply(split_trdgrpsft_desk_1, CalCulate99pctVar,"PnL_tot_usd" )


#  By Tradetype
trdgrpsft_tradetype_0 <-trdgrpsft_0 %>% filter(GROUPIDX != grp0_adbgrpidx)%>% group_by(SHIFT_T0, SHIFT_T1, TYPE)%>% summarize(PnL_tot_usd  = sum(as.numeric(TRADEPL)) )%>% arrange(TYPE,SHIFT_T1, SHIFT_T0)
trdgrpsft_tradetype_1 <-trdgrpsft_1 %>% filter(GROUPIDX != grp1_adbgrpidx)%>% group_by(SHIFT_T0, SHIFT_T1, TYPE)%>% summarize(PnL_tot_usd  = sum(as.numeric(TRADEPL)) )%>% arrange(TYPE,SHIFT_T1, SHIFT_T0)
grouping_tradetype0  <- trdgrpsft_tradetype_0$TYPE
grouping_tradetype1  <- trdgrpsft_tradetype_1$TYPE

split_trdgrpsft_tradetype_0 <- split(trdgrpsft_tradetype_0, grouping_tradetype0)
split_trdgrpsft_tradetype_1 <- split(trdgrpsft_tradetype_1, grouping_tradetype1)

var_tradetype0 <- sapply(split_trdgrpsft_tradetype_0, CalCulate99pctVar,"PnL_tot_usd" )
var_tradetype1 <- sapply(split_trdgrpsft_tradetype_1, CalCulate99pctVar,"PnL_tot_usd" )



#  By CCY
trdgrpsft_ccy_0 <-trdgrpsft_0 %>% filter(GROUPIDX != grp0_adbgrpidx)%>% group_by(SHIFT_T0, SHIFT_T1, RISKCCY)%>% summarize(PnL_tot_usd  = sum(as.numeric(TRADEPL)) )%>% arrange(RISKCCY,SHIFT_T1, SHIFT_T0)
trdgrpsft_ccy_1 <-trdgrpsft_1 %>% filter(GROUPIDX != grp1_adbgrpidx)%>% group_by(SHIFT_T0, SHIFT_T1, RISKCCY)%>% summarize(PnL_tot_usd  = sum(as.numeric(TRADEPL)) )%>% arrange(RISKCCY,SHIFT_T1, SHIFT_T0)
grouping_ccy0  <- trdgrpsft_ccy_0$RISKCCY
grouping_ccy1  <- trdgrpsft_ccy_1$RISKCCY

split_trdgrpsft_ccy_0 <- split(trdgrpsft_ccy_0, grouping_ccy0)
split_trdgrpsft_ccy_1 <- split(trdgrpsft_ccy_1, grouping_ccy1)

var_ccy0 <- sapply(split_trdgrpsft_ccy_0, CalCulate99pctVar,"PnL_tot_usd" )
var_ccy1 <- sapply(split_trdgrpsft_ccy_1, CalCulate99pctVar,"PnL_tot_usd" )



#  Save results
my_book <- loadWorkbook("VaR_Result.xlsx")
createSheet(my_book, "data_summary")


writeWorksheet(my_book, delta_ADB ,"data_summary",startRow = 1, startCol = 1 )



writeWorksheet(my_book, "TOP 10 INCREASE" ,"data_summary",startRow = 4 ,startCol = 1 )
writeWorksheet(my_book, top_ten_increase ,"data_summary",startRow = 6 ,startCol = 1 )


writeWorksheet(my_book, "TOP 10 DECREASE" ,"data_summary",startRow = 4 ,startCol = 10 )
writeWorksheet(my_book, top_ten_decrease ,"data_summary",startRow = 6 ,startCol = 10)


writeWorksheet(my_book, "TOP 10 HIGHEST" ,"data_summary",startRow = 18 ,startCol = 1 )
writeWorksheet(my_book, top_ten_high ,"data_summary",startRow = 18 ,startCol = 1 )


writeWorksheet(my_book, "TOP 10 LOWEST" ,"data_summary",startRow = 18 ,startCol = 10 )
writeWorksheet(my_book, top_ten_low  ,"data_summary",startRow = 18 ,startCol = 10 )

saveWorkbook(my_book, "summary4.xlsx")


dat <- split_trdgrpsft_desk_1
wb <- createWorkbook()
Map(function(data, name){
  
  addWorksheet(wb, name)
  writeData(wb, name, data)
  
}, dat, names(dat))

## Save workbook to working directory
openxslx::saveWorkbook(wb, file = "AGGHVAR_DESK_Q2.xlsx")




