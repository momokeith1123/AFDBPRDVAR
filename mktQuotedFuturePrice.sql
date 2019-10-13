alter session set current_schema = v60;

select tradetype, count(tradetype) as nbtrade, sum(roi) total_roi ,sum(plua) totalplua, sum(netassetvalueua) Total_navua
from cdmperfvalo_bis
where company = 'PSF' 
and  datetimestamp = '2019-06-19 10:24:03.640'
group by tradetype;



select *
from cdmperfvalo_bis
where company = 'PSF' 
and  datetimestamp = '2019-06-19 10:24:03.640';
--group by tradetype;



select tradeid, tradetype, company, book, desk, ccy, status, commmodity, 
from cdmperfvalo_bis
where datetimestamp = '2019-06-19 10:24:03.640'
and tradeid = '0000007795';

select s.Name2, 
       s.name,
       d2.type, 
       d2.ccy1, 
       d2.dmindex,
       d2.id CurveID,
       d.dmcommodityid, 
       s.Name DateScenario,
       d.Value std_Shift,
       d.dmdate
from dmCOMMSET s,
     dmCOMMDATA d ,
     DMRISK_DATA d2
where s.dmCommodityId = d.dmCommodityId
and s.name2 like '#ADBVAR#%'
and to_date(s.Name, 'YYYYMMDD') = to_date('20190329', 'YYYYMMDD')
and substr(name2,9,8)=d2.id
and d2.ClassName = 'ADBVAR'
and d2.ccy1 = 'USD'
and d2.dmindex = 'LIBOR';
--and d.dmdate < 0.001;

select substr(s.name, 10,length(name)-9) as CONTRACT, 
       d.dmdate as DELIVERY,
       s.asofdate,
       d.value as VALUE
from dmcommset s,
     dmcommdata d
where s.dmcommodityid = d.dmcommodityid  
and s.hist_version = d.hist_version
and s.type = 'FUTCLOSE'
and s.hist_current = 'Y'
and s.name = 'FUTCLOSE/USD3MCME'
and s.asofdate >= '&stardate'
and s.asofdate <= '&endate'
and s.id = 'MOF'
and trim(d.dmdate) =  '&Maturity'
order by s.asofdate desc;

select * from dmcommdata;



