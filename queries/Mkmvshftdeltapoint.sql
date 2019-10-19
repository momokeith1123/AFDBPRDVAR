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
and to_date(s.Name, 'YYYYMMDD') >= to_date('pDate', 'YYYYMMDD')
and substr(name2,9,8)=d2.id
and d2.ClassName = 'ADBVAR'
and d2.ccy1 = 'pCur'
and d2.dmindex = 'pIndex'
and d.dmdate < 0.001

