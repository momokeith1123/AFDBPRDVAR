library(RODBC)
con <- odbcConnect("SUMMITP", 
                   uid ="v60report", 
                   pwd = "v#60#ReporT789",
                   believeNRows= FALSE)
sqlQuery(con, "alter session set current_schema= v60")


sDate = '20190329'
CurveId = 'HVAR'
Index = '3A_G'
Currency ='USD'


cdmrateua <- sqlQuery(con,"select * from cdmrateua where ccy = 'USD' and asofyear = to_char(to_date('20190701', 'YYYYMMDD'),'YYYY') ) 
                                                                     and asofperiod = to_char(to_date('20190701', 'YYYYMMDD'),'MM'))"

AND ( ASOFPERIOD = to_char(to_date(&dto, 'YYYYMMDD'),'MM') 
      AND  ASOFYEAR = to_char(to_date(&dto, 'YYYYMMDD'),'YYYY') )
