create table calendar_dim (id number constraint pk_id primary key, cal_date date , year varchar2(4 char) , day_year varchar2(4 char) ,
                            quarter varchar2(2 char) , month varchar2(2 char) , month_name varchar2(4 char),
                            month_day varchar2(2 char), week_month varchar2(2 char) , day_of_week varchar2(2 char),
                            day_wrd varchar2(10 char) , is_wknd varchar2(1 char));


insert into calendar_dim(id , cal_date , year, day_year ,
quarter , month , month_name,month_day , week_month, day_of_week, day_wrd , is_wknd )
select * from (
with rec_cte(lvl,cal_date,year,DAY_YEAR,Quarter,month,month_name,MONTH_DAY,WEEK_MONTH,DAY_OF_WEEK,DAY_WRD,IS_WKND)
as(
select 1 lvl,
to_date('20000101','yyyymmdd') cal_date , extract(year from to_date('20000101','yyyymmdd')) year , 
to_char(to_date('20000101','yyyymmdd'),'DDD') DAY_YEAR,
to_char(to_date('20000101','yyyymmdd'),'Q') Quarter,
to_char(to_date('20000101','yyyymmdd'),'MM') month ,
to_char(to_date('20000101','yyyymmdd'),'MON') month_name ,
to_char(to_date('20000101','yyyymmdd'),'DD') MONTH_DAY,
to_char(to_date('20000101','yyyymmdd'),'W') WEEK_MONTH,
to_char(to_date('20000101','yyyymmdd'),'D') DAY_OF_WEEK , 
trim(to_char(to_date('20000101','yyyymmdd'),'DAY')) DAY_WRD,
CASE WHEN trim(to_char(to_date('20000101','yyyymmdd'),'DAY')) in ('SATURDAY','SUNDAY') then 'Y' else 'N' end as IS_WKND
from dual
union all
select lvl+1  ,cal_date+1 cal_date , extract(year from cal_date+1) year , 
to_char(cal_date+1,'DDD') DAY_YEAR,
to_char(cal_date+1,'Q') Quarter,
to_char(cal_date+1,'MM') month ,
to_char(cal_date+1,'MON') month_name ,
to_char(cal_date+1,'DD') MONTH_DAY,
to_char(cal_date+1,'W') WEEK_MONTH,
to_char(cal_date+1,'D') DAY_OF_WEEK , 
trim(to_char(cal_date+1,'DAY')) DAY_WRD,
CASE WHEN trim(to_char(cal_date+1,'DAY')) in ('SATURDAY','SUNDAY') then 'Y' else 'N' end as IS_WKND
from rec_cte
where cal_date < = to_date('20501231','YYYYMMDD')
)
select lvl,cal_date,year,DAY_YEAR,Quarter,month,month_name,MONTH_DAY,WEEK_MONTH,DAY_OF_WEEK,DAY_WRD,IS_WKND 
from rec_cte );