select per.*,
       rat.classvalue as rating,  
       case trim(rat.classvalue)
            when 'AAA' then '3A'
            when 'AA+' then '2AP'
            when  'AA'  then '2A'
            when 'AA-' then '2AM'
            when 'A+'  then 'AP'
            when 'A'   then 'A'
            when 'A-' then 'AM'           
       end || '_' || decode(substr(secclass,1,1),'A','Y',substr(secclass,1,1)) as subindex, 
       'GMS_' || decode(substr(secclass,1,1),
                               'A','AGY',
                               'G','GOV',
                               'C','CORP',
                               'F', 'FIN',
                               'S', 'SUP','TBD')||'_' || per.ccy as SECFILTER
from    (  
        select  book,ccy,trim(secid) as secid,secdesc, identif2, sectype, secclass,
                sum(netassetvalueua) as NAVUA, avg(PRICE) as PRICE,sum(mktvalueua) as MKTVALUEUA 
        from cdmperfvalo_bis
        where datetimestamp = '2019-10-15 17:05:26.986'
        and tradetype = 'BOND'
        and company = 'ADB'
        --and sectype not in ('CP', 'CD')
        --and secclass not like '%ABS%'
        --and secclass not like '%MBS%'
        --and book not like 'EQB%'
        --and book not like 'FXINVEST%'
        group by book, ccy, secid, secdesc, identif2, 
        sectype, secclass, price, trim(secid)
        order by ccy, secid
        ) per,        
        (
        select sec.audit_version, trim(sec.sec) as secid2, sec.type, sec.ccy,clas.classvalue,sec.dmassetid
        from dmsec sec,
             dmsecclass clas
        where sec.audit_current = 'Y'
        and  sec.audit_version = clas.audit_version (+)
        and sec.sec = clas.secid
        and clas.name = 'ADB_AGCY'
        --and sec.sec = 'EFSF0125K0419'
        order by sec.sec
        ) rat
where per.secid = rat.secid2(+)
and per.ccy = rat.ccy
order by  SECFILTER