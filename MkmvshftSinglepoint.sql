alter session set current_schema= v56;
clear;

define sDate = '20190531'
define CurveId = 'MOF'
define Index = 'LIBOR'
define Currency ='USD';

define CurveId = 'MOF';
define Index = 'LIBOR';
--accept Curveid  'Entre la courbe Id';
-- Curves Terms structure : Interest Market Data in Summit, give the terms sturcure and give the zspread in HVAR curve
SELECT b.ccy,
       b.dmindex as Basis_C,
       a.dmmktdataid,
	   b.asofdate,b.ID,'Rate' as type ,
       a.mktdate as Tenor,
       a.spread*100 as Spread,
       a.midrate as Rate, 
       c.mkttype, 
       c.term ,
       a.dmspecnum
       --,a.bidrate,a.askrate
FROM
	dmmktpoint a,
	dmmktdata b 
    ,dmmktspec c
WHERE
	a.dmmktdataid=b.dmmktdataid
    and a.hist_version =  b.hist_version 
    and b.dmmktdataid = c.dmmktdataid
    and b.hist_version = c.hist_version
    and b.id = 'MOF'
    and b.asofdate = '&sDate'
    and b.ccy in ('USD', 'EUR', 'GBP', 'JPY', 'CNY')
    and  b.dmindex in ('LIBOR','EURIB')
    and b.hist_current = 'Y'
    
    and c.mkttype = 'AIC'
    and trim(a.mktdate) = '5Y'
    --and a.mktdate = '5Y'
order by asofdate;