alter session set current_schema = v60;

select distinct cdmperfvalo.datetimestamp
from cdmperfvalo_bis;


select tradeid, tradetype, company, book, desk, ccy, status, commmodity, 
from cdmperfvalo_bis
where datetimestamp = '2019-06-19 10:24:03.640'
and tradeid = '0000007795';

