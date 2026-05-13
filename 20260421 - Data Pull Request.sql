/*
I wanted to request your support in pulling together analytics for all clients 
(legacy included) for the year 2025. Specifically, it would be helpful to get a consolidated view with the following details:
1) Total hours of content delivered - Watch Hours
2) Number of events covered
3) Countries served
4) Average views per user

Additionally, if possible, it would be great to include a few more insights to enrich the analysis:
a) Any notable consumption patterns or spikes during major events
b) Any high Concurrent spike
*/




select distinct upper(aid) from viewlift_events	   
where tstamp between '2025-02-01' and '2025-06-30'
and upper(aid) like in ('LIGHTNING','SCHN','ALTITUDE','USANETWORK','NESN','CALIENTE','CHSN'
						,'MYOUTDOORTV','VEGAS-GOLDEN-KNIGHTS','DIRTVISION','FP','GXR','LNP'
						,'LIV-GOLF','ROOTSPORTS','TEST','SDSD','SFC'
					   )
;
/*
LIGHTNING
SCHN
ALTITUDE
USANETWORK
NESN
CALIENTE
MYOUTDOORTV
VEGAS-GOLDEN-KNIGHTS
DIRTVISION
 */

select aid as site
,title as content_title
,vid
,SUM(CASE WHEN pa = 'PING' THEN 0.5 ELSE 0 END) AS duration
,Count(Distinct case when lower(pa) IN ('play','ping') then stream_id end) AS total_views
,Count(Distinct case when lower(pa) in ('play','ping') then uid end) as Total_Streaming_Users 
from viewlift_events	   
where tstamp >= '2025-01-01 00:00:00' and tstamp < '2026-01-01 00:00:00'
and site in ('')
group by all order by 1,2,3,4 desc;



select aid as site
,title as content_title
,count(distinct vid) no_of_distinct_content
,count(distinct case when )
,SUM(CASE WHEN pa = 'PING' THEN 0.5 ELSE 0 END) AS duration
,Count(Distinct case when lower(pa) IN ('play','ping') then stream_id end) AS total_views
,Count(Distinct case when lower(pa) in ('play','ping') then uid end) as Total_Streaming_Users 
from viewlift_events	   
where tstamp >= '2025-01-01 00:00:00' and tstamp < '2026-01-01 00:00:00'
group by all order by 1,2,3,4 desc;

select * from public.tableau_content_report_table_chsn
where tstamp between '2025-01-01' and '2025-01-02' limit 100;

select min(tstamp), max(tstamp) from public.tableau_content_report_table_chsn
where tstamp between '2025-01-01 00:00:00' and '2025-12-31 00:00:00'; 

select distinct tstamp as time from public.tableau_content_report_table_chsn
where tstamp >= '2025-01-01' order by 1;


select distinct islive from public.tableau_content_report_table_chsn
where tstamp_v1 between '2025-01-01' and '2025-01-02' limit 100;

select country, sum(numplays) as views from public.tableau_content_report_table_chsn
where tstamp_v1 between '2025-01-01' and '2025-01-02'
group by 1 order by 2 desc;

--Use Tableau tables to get the data, following are the list of active customers

/*
CHSN
Fox One
USA Network
Altitude
NESN
Spacecity
Liv Golf
MSN
MOTV
Florida Panthers
VGK
Lightning(TampaBay)
HereTv
Bek-TV-Plus
Dirtvision
PFL
SFC
*/

--CHSN

--Total Hours
--No of event
--No of Live events
--Countries
--Avg views per user

select islive,count(*) from public.tableau_content_report_table_chsn
where tstamp between '2025-01-01 00:00:00' and '2025-12-31 00:00:00'
group by 1 order by 2 desc
;
/*
islive|count  |
------+-------+
1     |1108287|
0     | 855526|
True  | 598520|
False |  85728|
true  |  58792|
      |  49951|
false |   4502|
FALSE |   1256|
 */

select 'chsn' as site 
,'2025' as Period
,sum(duration) as watch_mins
,count(distinct vid) as distinct_content_count
,count(distinct case when islive in ('1','True','true') then vid end) as distinct_Live_content_count
,count(distinct case when (islive is null or islive in ('','0','False','false','FALSE')) then vid end) as distinct_VOD_content_count
,sum(numplays) as Total_streams
,sum(case when islive in ('1','True','true') then numplays end ) as Live_Streams
,sum(case when (islive is null or islive in ('','0','False','false','FALSE')) then numplays end ) as VOD_Streams
,sum(duration)/60 as watch_hours
,sum(case when islive in ('1','True','true')then duration end )/60 as Live_Watch_Hours
,sum(case when (islive is null or islive in ('','0','False','false','FALSE')) then duration end )/60 as VOD_Watch_Hours
,count(distinct country) as no_of_countries
,sum(numplays)/count(distinct user_id) as avg_views_per_user
--,Live_Streams/count(distinct case when islive in ('1','True','true') then user_id end) avg_views_per_user_live
from public.tableau_content_report_table_chsn
where tstamp between '2025-01-01 00:00:00' and '2025-12-31 00:00:00';

/*
site|period|watch_mins |distinct_content_count|distinct_live_content_count|distinct_vod_content_count|total_streams|live_streams|vod_streams|watch_hours |live_watch_hours|vod_watch_hours|no_of_countries|avg_views_per_user|avg_views_per_user_live|
----+------+-----------+----------------------+---------------------------+--------------------------+-------------+------------+-----------+------------+----------------+---------------+---------------+------------------+-----------------------+
chsn|2025  |118667678.0|                  5925|                        689|                      5230|      6542967|     5319726|    1139678|1977794.6333|    1868369.1250|     76234.7833|            160|                23|                     38|
*/

select 'chsn' as client,country, sum(numplays) as views 
from public.tableau_content_report_table_chsn
where tstamp between '2025-01-01 00:00:00' and '2025-12-31 00:00:00'
group by all order by 3 desc;

------------------------------------------vl-one DB-----------------------------------
select lower(vs.site_name) as client
,'2025' as Period
,sum(duration) as watch_mins
,count(distinct vid) as distinct_content_count
,count(distinct case when islive in ('1','True','true') then vid end) as distinct_Live_content_count
,count(distinct case when (islive is null or islive in ('','0','False','false','FALSE')) then vid end) as distinct_VOD_content_count
,sum(numplays) as Total_streams
,sum(case when islive in ('1','True','true') then numplays end ) as Live_Streams
,sum(case when (islive is null or islive in ('','0','False','false','FALSE')) then numplays end ) as VOD_Streams
,sum(duration)/60 as watch_hours
,sum(case when islive in ('1','True','true')then duration end )/60 as Live_Watch_Hours
,sum(case when (islive is null or islive in ('','0','False','false','FALSE')) then duration end )/60 as VOD_Watch_Hours
,count(distinct country) as no_of_countries
,sum(numplays)/count(distinct user_id) as avg_views_per_user
--,Live_Streams/count(distinct case when islive in ('1','True','true') then user_id end) avg_views_per_user_live
from public.tableau_content_report_table_new_overall tb left join appcms.vl_site vs on lower(tb.cid)=lower(vs.id)
where tstamp between '2025-01-01 00:00:00' and '2025-12-31 00:00:00'
and lower(vs.site_name) not like 'usanetwork'
group by all
order by 3 desc;


select lower(vs.site_name) as client
,country, sum(numplays) as views 
from public.tableau_content_report_table_new_overall tb left join appcms.vl_site vs on lower(tb.cid)=lower(vs.id)
where tstamp between '2025-01-01 00:00:00' and '2025-12-31 00:00:00'
group by all
order by 1,3 desc;

--Here-TV have country codes in country name map them in a way we get country names

select lower(site_name),* from appcms.vl_site vs order by 1;

select 'here-tv' as client,countryname
, Count(Distinct case when lower(pa) IN ('play','ping') then stream_id end) as views 
from public.viewlift_events
where tstamp >= '2025-01-01 00:00:00' and tstamp <'2026-01-01 00:00:00'
and cid = '8b3df2c4-8f29-43a5-aa74-170b51a2051c'
group by all order by 3 desc;

select * from public.viewlift_events
where tstamp >= '2025-01-01 00:00:00' and tstamp <'2026-01-01 00:00:00'
and cid = '8b3df2c4-8f29-43a5-aa74-170b51a2051c';

select lower(vs.site_name) as client
,'2025' as Period
,sum(duration) as watch_mins
,sum(duration)/60 as watch_hours
,count(distinct vid) as distinct_content_count
,count(distinct case when islive = 1 then vid end) as distinct_live_content_count
,count(distinct country) as no_of_coubtries
,sum(numplays)/count(distinct user_id) as avg_views_per_user
from public.tableau_content_report_table_new_overall tb left join appcms.vl_site vs on lower(tb.cid)=lower(vs.id)
where tstamp between '2025-01-01 00:00:00' and '2025-12-31 00:00:00'
and lower(vs.site_name) like 'here-tv'
group by all
order by 3 desc;


SELECT
            (ve.tstamp::DATE)::TIMESTAMP AS tstamp,
            ve.cid,
            --ve.vid,
            --vf.title,
            --ve.tstamp::DATE AS eventdate,
            --pfm_std.pfm_standardized AS pfm,
            --vf.islive,
            ve.countryname AS country,
            --ve.subdivision_en_name AS subdivision,
            --ve.cityname AS city,
            --ve.uid AS user_id,
            SUM(CASE WHEN pa = 'PING' THEN 0.5 ELSE 0 END) AS duration,
            SUM(CASE WHEN pa = 'PLAY' THEN 1 ELSE 0 END) AS numplays
        FROM
            viewlift_events ve
            where tstamp >= '2025-01-01 00:00:00' and tstamp < '2026-01-01 00:00:00'
and cid = '8b3df2c4-8f29-43a5-aa74-170b51a2051c'
group by all
order by duration desc
;

select lower(vs.site_name) as client
,cid
,sum(duration) as watch_mins
,sum(duration)/60 as watch_hours
,count(distinct vid) as distinct_content_count
,count(distinct case when islive = 1 then vid end) as distinct_live_content_count
,count(distinct country) as no_of_coubtries
,sum(numplays)/count(distinct user_id) as avg_views_per_user
from public.tableau_content_report_table_new_overall tb left join appcms.vl_site vs on lower(tb.cid)=lower(vs.id)
where tstamp between '2026-04-01 00:00:00' and '2026-04-20 00:00:00'
and lower(vs.site_name) like 'here-tv'
group by all
order by 3 desc;
/*
client |cid                                 |watch_mins|watch_hours|distinct_content_count|distinct_live_content_count|no_of_coubtries|avg_views_per_user|
-------+------------------------------------+----------+-----------+----------------------+---------------------------+---------------+------------------+
here-tv|8b3df2c4-8f29-43a5-aa74-170b51a2051c|  415114.5|  6918.5750|                  1106|                          0|            213|                 2|
 */

SELECT
            --(ve.tstamp::DATE)::TIMESTAMP AS tstamp,
            ve.cid,
            --ve.vid,
            --vf.title,
            --ve.tstamp::DATE AS eventdate,
            --pfm_std.pfm_standardized AS pfm,
            --vf.islive,
            --ve.countryname AS country,
            --ve.subdivision_en_name AS subdivision,
            --ve.cityname AS city,
            --ve.uid AS user_id,
            SUM(CASE WHEN pa = 'PING' THEN 0.5 ELSE 0 END) AS duration,
            SUM(CASE WHEN pa = 'PLAY' THEN 1 ELSE 0 END) AS numplays
        FROM
            viewlift_events ve
            where tstamp >= '2026-04-01 00:00:00' and tstamp < '2026-04-21 00:00:00'
and cid = '8b3df2c4-8f29-43a5-aa74-170b51a2051c'
group by all
order by duration desc
;

-------------------------Foxone, Dirtvision, versant----------------------------------

select lower(vs.site_name) as client
,'2025' as Period
,sum(duration) as watch_mins
,count(distinct vid) as distinct_content_count
,count(distinct case when islive in ('1','True','true') then vid end) as distinct_Live_content_count
,count(distinct case when (islive is null or islive in ('','0','False','false','FALSE')) then vid end) as distinct_VOD_content_count
,sum(numplays) as Total_streams
,sum(case when islive in ('1','True','true') then numplays end ) as Live_Streams
,sum(case when (islive is null or islive in ('','0','False','false','FALSE')) then numplays end ) as VOD_Streams
,sum(duration)/60 as watch_hours
,sum(case when islive in ('1','True','true')then duration end )/60 as Live_Watch_Hours
,sum(case when (islive is null or islive in ('','0','False','false','FALSE')) then duration end )/60 as VOD_Watch_Hours
,count(distinct country) as no_of_countries
,sum(numplays)/count(distinct user_id) as avg_views_per_user
--,Live_Streams/count(distinct case when islive in ('1','True','true') then user_id end) avg_views_per_user_live
from public.tableau_content_report_table_caliente tb left join appcms.vl_site vs on lower(tb.cid)=lower(vs.id)
where tstamp between '2025-01-01 00:00:00' and '2025-12-31 00:00:00'
group by all

union all

select lower(vs.site_name) as client
,'2025' as Period
,sum(duration) as watch_mins
,count(distinct vid) as distinct_content_count
,count(distinct case when islive in ('1','True','true') then vid end) as distinct_Live_content_count
,count(distinct case when (islive is null or islive in ('','0','False','false','FALSE')) then vid end) as distinct_VOD_content_count
,sum(numplays) as Total_streams
,sum(case when islive in ('1','True','true') then numplays end ) as Live_Streams
,sum(case when (islive is null or islive in ('','0','False','false','FALSE')) then numplays end ) as VOD_Streams
,sum(duration)/60 as watch_hours
,sum(case when islive in ('1','True','true')then duration end )/60 as Live_Watch_Hours
,sum(case when (islive is null or islive in ('','0','False','false','FALSE')) then duration end )/60 as VOD_Watch_Hours
,count(distinct country) as no_of_countries
,sum(numplays)/count(distinct user_id) as avg_views_per_user
--,Live_Streams/count(distinct case when islive in ('1','True','true') then user_id end) avg_views_per_user_live
from public.tableau_content_report_table_dirtvision tb left join appcms.vl_site vs on lower(tb.cid)=lower(vs.id)
where tstamp between '2025-01-01 00:00:00' and '2025-12-31 00:00:00'
group by all

union all 

select lower(vs.site_name) as client
,'2025' as Period
,sum(duration) as watch_mins
,count(distinct vid) as distinct_content_count
,count(distinct case when islive in ('1','True','true') then vid end) as distinct_Live_content_count
,count(distinct case when (islive is null or islive in ('','0','False','false','FALSE')) then vid end) as distinct_VOD_content_count
,sum(numplays) as Total_streams
,sum(case when islive in ('1','True','true') then numplays end ) as Live_Streams
,sum(case when (islive is null or islive in ('','0','False','false','FALSE')) then numplays end ) as VOD_Streams
,sum(duration)/60 as watch_hours
,sum(case when islive in ('1','True','true')then duration end )/60 as Live_Watch_Hours
,sum(case when (islive is null or islive in ('','0','False','false','FALSE')) then duration end )/60 as VOD_Watch_Hours
,count(distinct country) as no_of_countries
,sum(numplays)/count(distinct user_id) as avg_views_per_user
--,Live_Streams/count(distinct case when islive in ('1','True','true') then user_id end) avg_views_per_user_live
from public.tableau_content_report_table_versant tb left join appcms.vl_site vs on lower(tb.cid)=lower(vs.id)
where tstamp between '2025-01-01 00:00:00' and '2025-12-31 00:00:00'
group by all
order by 3 desc;


--Countrywise counts
select lower(vs.site_name) as client
,country, sum(numplays) as views 
from public.tableau_content_report_table_versant tb left join appcms.vl_site vs on lower(tb.cid)=lower(vs.id)
where tstamp between '2025-01-01 00:00:00' and '2025-12-31 00:00:00'
group by all

union all

select lower(vs.site_name) as client
,country, sum(numplays) as views 
from public.tableau_content_report_table_caliente tb left join appcms.vl_site vs on lower(tb.cid)=lower(vs.id)
where tstamp between '2025-01-01 00:00:00' and '2025-12-31 00:00:00'
group by all

union all

select lower(vs.site_name) as client
,country, sum(numplays) as views 
from public.tableau_content_report_table_dirtvision tb left join appcms.vl_site vs on lower(tb.cid)=lower(vs.id)
where tstamp between '2025-01-01 00:00:00' and '2025-12-31 00:00:00'
group by all
order by 1,3 desc;


select islive, count(distinct case when islive in ('1','True','true')then when vid) ,sum(numplays) as streams
from public.tableau_content_report_table_dirtvision tb 
where tstamp between '2025-01-01 00:00:00' and '2025-12-31 00:00:00'
group by 1 order by 2 desc;

--Check in FoxOne as they have more than 2K live events in 2025, any spike

select lower(vs.site_name) as client
--,vid
--,title
,date(tstamp) as date
--,sum(duration) as watch_mins
,sum(duration)/60 as watch_hours
--,count(distinct vid) as distinct_content_count
--,count(distinct case when islive = 1 then vid end) as distinct_live_content_count
--,count(distinct country) as no_of_coubtries
,sum(numplays) as views
from public.tableau_content_report_table_caliente tb left join appcms.vl_site vs on lower(tb.cid)=lower(vs.id)
where tstamp between '2025-01-01 00:00:00' and '2025-12-31 00:00:00'
group by all --having sum(duration) > 1000000
order by date;

select lower(vs.site_name) as client
--,vid
,title
,date(tstamp) as date
--,sum(duration) as watch_mins
,sum(duration)/60 as watch_hours
--,count(distinct vid) as distinct_content_count
--,count(distinct case when islive = 1 then vid end) as distinct_live_content_count
--,count(distinct country) as no_of_coubtries
,sum(numplays) as views
from public.tableau_content_report_table_caliente tb left join appcms.vl_site vs on lower(tb.cid)=lower(vs.id)
where tstamp between '2025-01-01 00:00:00' and '2025-12-31 00:00:00'
group by all having sum(duration) > 1000000
order by watch_hours desc;

select distinct cid from public.tableau_content_report_table_caliente tb left join appcms.vl_site vs on lower(tb.cid)=lower(vs.id)
where tstamp between '2025-01-01 00:00:00' and '2025-12-31 00:00:00';

select lower(vs.site_name) as client
--,vid
,title
,date(tstamp) as date
--,sum(duration) as watch_mins
,sum(duration)/60 as watch_hours
--,count(distinct vid) as distinct_content_count
--,count(distinct case when islive = 1 then vid end) as distinct_live_content_count
--,count(distinct country) as no_of_coubtries
,sum(numplays) as views
from public.tableau_content_report_table_caliente tb left join appcms.vl_site vs on lower(tb.cid)=lower(vs.id)
where date(tstamp) in ('2025-01-10','2025-01-22','2025-01-29','2025-01-31','2025-04-16')
group by all having sum(duration) > 1000000
order by watch_hours desc;

select lower(vs.site_name) as client,
        vf.title,
        trunc( ve.tstamp) eventdate,
        --date_trunc('minute', ve.tstamp) AS minute_timestamp,
        count(distinct ve.uid) AS unique_streaming_users,
        count(distinct ve.stream_id + ve.uid) AS unique_streams,
        count(case when upper(pa) = 'PLAY' THEN pa END) AS play_started
   from  (select * from viewlift_events ve
              where date(ve.tstamp) in ('2025-01-10','2025-01-22','2025-01-29','2025-01-31','2025-04-16')
              and ve.cid = 'f092b320-0515-4053-b167-33cae392520c'
         ) ve  inner join appcms.vl_film vf on  vf.id = ve.vid 
    left join appcms.vl_site vs on lower(ve.cid)=lower(vs.id)
    where lower(vf.islive) in ( 'true',1,'t')
   group by all order by eventdate,unique_streaming_users desc;
 
----------------------------------------MSN-----------------------------------------------

select islive,count(distinct id) from appcms.vl_film
where update_date >= '2025-01-01' group by 1 order by 1;

select 'monumental-network' as site 
,'2025' as Period
,SUM(CASE WHEN pa = 'PING' THEN 0.5 ELSE 0 END) as watch_mins
,count(distinct vid) as distinct_content_count
,count(distinct case when vf.islive in ('1','True','true') then vid end) as distinct_live_content_count
,count(distinct case when (vf.islive is null or vf.islive in ('','0','False','false')) then vid end) as distinct_VOD_content_count
--Streams
,Count(Distinct case when lower(pa) IN ('play','ping') then stream_id end) as Total_Streams
,Count(Distinct case when lower(pa) IN ('play','ping') and vf.islive in ('1','True','true') 
				then stream_id end) as Total_live_Streams
,Count(Distinct case when lower(pa) IN ('play','ping') and 
							(vf.islive is null or vf.islive in ('','0','False','false'))
								then stream_id end) as Total_VOD_Streams
--Watch Hours
,watch_mins/60 as Total_watch_hours
,SUM(CASE WHEN pa = 'PING' and vf.islive in ('1','True','true') THEN 0.5 ELSE 0 END)/60 as Live_Watch_Hours
,SUM(CASE WHEN pa = 'PING' and 
			(vf.islive is null or vf.islive in ('','0','False','false')) THEN 0.5 ELSE 0 END)/60 as VOD_Watch_Hours
,count(distinct countryname) as no_of_countries
,Count(Distinct case when lower(pa) IN ('play','ping') then stream_id end)/count(distinct uid) as avg_views_per_user
--,min(tstamp),max(tstamp)
from public.viewlift_events ve 
LEFT JOIN (
            SELECT DISTINCT id, title, islive
            FROM appcms.vl_film
        ) vf ON ve.vid = vf.id
where tstamp >= '2025-01-01 00:00:00' and tstamp <'2026-01-01 00:00:00';

/*
site|watch_hours|distinct_content_count|distinct_content_count|
----+-----------+----------------------+----------------------+
chsn|118667678.0|                  5925|                   640|
*/

select 'monumental-network' as client,countryname
, Count(Distinct case when lower(pa) IN ('play','ping') then stream_id end) as views 
from public.viewlift_events
where tstamp >= '2025-01-01 00:00:00' and tstamp <'2026-01-01 00:00:00'
group by all order by 3 desc;


---------------------------------------Bek-TV-Plus-----------------------------------------------

select * from public.viewlift_events 
where tstamp >= '2025-01-01 00:00:00' and tstamp <'2026-01-01 00:00:00'
order by public.viewlift_events.tstamp limit 100;

select title,vid,SUM(CASE WHEN pa = 'PING' THEN 0.5 ELSE 0 END) AS duration,
       Count(Distinct case when lower(pa) IN ('play','ping') then stream_id end) AS total_views,
	  Count(Distinct case when lower(pa) in ('play','ping') then uid end) as Total_Streaming_Users from viewlift_events	  
where aid = 'myoutdoortv'
and vid = '6bc85777-3934-4171-968c-c66623a83961'
and tstamp >= '2026-04-06 00:00:00' and tstamp <'2026-04-08 00:00:00'
group by title,vid;

select distinct islivestream from public.viewlift_events 
where tstamp >= '2025-01-01 00:00:00' and tstamp <'2026-01-01 00:00:00';


select aid
,'2025' as Period
,SUM(CASE WHEN pa = 'PING' THEN 0.5 ELSE 0 END) as watch_mins
,watch_mins/60 as watch_hours
,count(distinct vid) as distinct_content_count
,count(distinct case when islivestream like 'true' then vid end) as distinct_live_content_count
,count(distinct countryname) as no_of_coubtries
,Count(Distinct case when lower(pa) IN ('play','ping') then stream_id end)/count(distinct uid) as avg_views_per_user
--,min(tstamp),max(tstamp)
from public.viewlift_events
where tstamp >= '2025-01-01 00:00:00' and tstamp <'2026-01-01 00:00:00';

/*
site|watch_hours|distinct_content_count|distinct_content_count|
----+-----------+----------------------+----------------------+
chsn|118667678.0|                  5925|                   640|
*/

select 'monumental-network' as client,countryname
, Count(Distinct case when lower(pa) IN ('play','ping') then stream_id end) as views 
from public.viewlift_events
where tstamp >= '2025-01-01 00:00:00' and tstamp <'2026-01-01 00:00:00'
group by all order by 3 desc;

select 'monumental-network' as client,countryname, countryisocode
, Count(Distinct case when lower(pa) IN ('play','ping') then stream_id end) as views 
from public.viewlift_events
where tstamp >= '2025-01-01 00:00:00' and tstamp <'2026-01-01 00:00:00'
group by all order by 4 desc;



-------------------------------------------------------------------------------------------------------------------------------
--Lets identify dates with maximum traffic across clients

select SUM(CASE WHEN pa = 'PING' THEN 0.5 ELSE 0 END)/365 as avg_watch_min_per_day from public.viewlift_events
where tstamp >= '2025-01-01 00:00:00' and tstamp <'2026-01-01 00:00:00';
--Avg Wact mins per day= 220391.1753 minutes

select 'monumental-network' as site 
,vid,title
--,DATE(tstamp) AS date
,SUM(CASE WHEN pa = 'PING' THEN 0.5 ELSE 0 END) as watch_mins
--,watch_mins/60 as watch_hours
--,count(distinct vid) as distinct_content_count
--,count(distinct case when islivestream like 'true' then vid end) as distinct_live_content_count
--,count(distinct countryname) as no_of_coubtries
--,Count(Distinct case when lower(pa) IN ('play','ping') then stream_id end)/count(distinct uid) as avg_views_per_user
--,min(tstamp),max(tstamp)
from public.viewlift_events
where tstamp >= '2025-01-01 00:00:00' and tstamp <'2026-01-01 00:00:00'
group by all having SUM(CASE WHEN pa = 'PING' THEN 0.5 ELSE 0 END) > 1000000
order by 4 desc --limit 20
;

SELECT cid,
    DATE(tstamp) AS date,
    SUM(numplays) AS total_views,
    COUNT(DISTINCT user_id) AS active_users,
    SUM(duration) AS total_watch_time
FROM your_table
GROUP BY 1
ORDER BY total_views DESC
LIMIT 20;

select --lower(vs.site_name) as client
--,vid
--,title
date(tstamp) as date
,sum(duration) as watch_mins
--,sum(duration)/60 as watch_hours
--,count(distinct vid) as distinct_content_count
--,count(distinct case when islive = 1 then vid end) as distinct_live_content_count
--,count(distinct country) as no_of_coubtries
,sum(numplays) as views
from public.tableau_content_report_table_new_overall tb left join appcms.vl_site vs on lower(tb.cid)=lower(vs.id)
where tstamp between '2025-01-01 00:00:00' and '2025-12-31 00:00:00'
and lower(vs.site_name) not like 'usanetwork'
group by all --having sum(duration) > 1000000
order by 2 desc;

select lower(vs.site_name) as client
,vid
,title
,date(tstamp) as date
,sum(duration) as watch_mins
--,sum(duration)/60 as watch_hours
--,count(distinct vid) as distinct_content_count
--,count(distinct case when islive = 1 then vid end) as distinct_live_content_count
--,count(distinct country) as no_of_coubtries
,sum(numplays) as views
from public.tableau_content_report_table_new_overall tb left join appcms.vl_site vs on lower(tb.cid)=lower(vs.id)
where date(tstamp) = '2025-04-05'
and lower(vs.site_name) not like 'usanetwork'
group by all --having sum(duration) > 1000000

union all
select lower(vs.site_name) as client
,vid
,title
,date(tstamp) as date
,sum(duration) as watch_mins
--,sum(duration)/60 as watch_hours
--,count(distinct vid) as distinct_content_count
--,count(distinct case when islive = 1 then vid end) as distinct_live_content_count
--,count(distinct country) as no_of_coubtries
,sum(numplays) as views
from public.tableau_content_report_table_new_overall tb left join appcms.vl_site vs on lower(tb.cid)=lower(vs.id)
where date(tstamp) = '2025-04-05'
and lower(vs.site_name) not like 'usanetwork'
group by all --having sum(duration) > 1000000


order by watch_mins desc;

select * from appcms.vl_site  order by id;


select 'MOTV' as site 
,'2025' as Period
,SUM(CASE WHEN pa = 'PING' THEN 0.5 ELSE 0 END) as watch_mins
,count(distinct vid) as distinct_content_count
,count(distinct case when lower(vf.islive) in ('1','t','true')  then vid end) as distinct_live_content_count
,count(distinct case when (vf.islive is null or lower(vf.islive) in ('','0','false','f')) then vid end) as distinct_VOD_content_count
--Streams
,Count(Distinct case when lower(pa) IN ('play','ping') then stream_id end) as Total_Streams
,Count(Distinct case when lower(pa) IN ('play','ping') and lower(vf.islive) in ('1','t','true') 
				then stream_id end) as Total_live_Streams
,Count(Distinct case when lower(pa) IN ('play','ping') and 
							(vf.islive is null or lower(vf.islive) in ('','0','false','f'))
								then stream_id end) as Total_VOD_Streams
--Watch Hours
,watch_mins/60 as Total_watch_hours
,SUM(CASE WHEN pa = 'PING' and lower(vf.islive) in ('1','t','true')  THEN 0.5 ELSE 0 END)/60 as Live_Watch_Hours
,SUM(CASE WHEN pa = 'PING' and 
			(vf.islive is null or lower(vf.islive) in ('','0','false','f')) THEN 0.5 ELSE 0 END)/60 as VOD_Watch_Hours
,count(distinct countryname) as no_of_countries
,Count(Distinct case when lower(pa) IN ('play','ping') then stream_id end)/count(distinct uid) as avg_views_per_user
--,min(tstamp),max(tstamp)
from public.viewlift_events ve 
LEFT JOIN (
            SELECT DISTINCT id, title, islive
            FROM appcms.vl_film
        ) vf ON ve.vid = vf.id
where tstamp >= '2025-01-01 00:00:00' and tstamp <'2026-01-01 00:00:00'
and cid = '1c2cf214-62ec-46af-938d-16c42c8f2661';


--usanetwork

select * from appcms.vl_site  order by id;


select 'usanetwork' as site 
,'2025' as Period
,SUM(CASE WHEN pa = 'PING' THEN 0.5 ELSE 0 END) as watch_mins
--Content Count
,count(distinct vid) as distinct_content_count
,count(distinct case when lower(vf.islive) in ('1','t','true')  then vid end) as distinct_live_content_count
,count(distinct case when (vf.islive is null 
							or lower(vf.islive) in ('','0','false','f')) then vid end) as distinct_VOD_content_count
--Views
,Count(Distinct case when lower(pa) IN ('play','ping') then stream_id end) as Total_Views
,Count(Distinct case when lower(pa) IN ('play','ping') and lower(vf.islive) in ('1','t','true') 
				then stream_id end) as Total_live_Views
,Count(Distinct case when lower(pa) IN ('play','ping') and 
							(vf.islive is null or lower(vf.islive) in ('','0','false','f'))
								then stream_id end) as Total_VOD_Views
--Watch Hours
,watch_mins/60 as Total_watch_hours
,SUM(CASE WHEN pa = 'PING' and lower(vf.islive) in ('1','t','true')  THEN 0.5 ELSE 0 END)/60 as Live_Watch_Hours
,SUM(CASE WHEN pa = 'PING' and 
			(vf.islive is null or lower(vf.islive) in ('','0','false','f')) THEN 0.5 ELSE 0 END)/60 as VOD_Watch_Hours
--Streams
,count(distinct ve.stream_id + ve.uid) AS unique_streams
,count(distinct case when lower(vf.islive) in ('1','t','true') then ve.stream_id + ve.uid end) AS unique_Live_streams
,count(distinct case when (vf.islive is null or lower(vf.islive) in ('','0','false','f')) 
					 then ve.stream_id + ve.uid end) AS unique_VOD_streams
--Misc
,count(distinct countryname) as no_of_countries
,Count(Distinct case when lower(pa) IN ('play','ping') then stream_id end)/count(distinct uid) as avg_views_per_user
--,min(tstamp),max(tstamp)
from public.viewlift_events ve 
LEFT JOIN (
            SELECT DISTINCT id, title, islive
            FROM appcms.vl_film
        ) vf ON ve.vid = vf.id
where tstamp >= '2025-09-30 00:00:00' and tstamp <'2026-01-01 00:00:00'
and cid = 'b13633d9-f778-40c6-a5ea-c330617cdf55';

select * from appcms.vl_site  order by id;


create temp table mapping_cid_name as 
(select distinct id as cid, site_name from appcms.vl_site 
	where id in 
	(   '22c07f3b-1d99-4edd-ab98-3c5e5a5fe393',
		'f092b320-0515-4053-b167-33cae392520c',
		'b13633d9-f778-40c6-a5ea-c330617cdf55',
		'3231df97-57ce-4f15-8c70-ab9ab1403872',
		'3e64aa33-00aa-4a5a-8104-e06bf55f7db5',
		'3635b621-15b8-46c6-b20f-923e10be7ec4',
		'9ed7dee0-c719-11ec-bc25-a195c2a34357',
		'00000151-11b4-d29b-a17d-55fdb2b80000',
		'1c2cf214-62ec-46af-938d-16c42c8f2661',
		'6b153918-609f-4492-9616-63852506f9f4',
		'29bb83d0-3745-11ee-966e-07f46be990da',
		'bd68edb6-663d-427a-8f92-f0b984248b14',
		'8b3df2c4-8f29-43a5-aa74-170b51a2051c',
		'bee1978d-60a1-49db-bf69-07b6fb100abb',
		'f14b235e-42c1-4b6b-9035-28f8d0b8c6a7',
		'a58022ac-163c-4515-8f80-68304f82b4ee',
		'1ff4cfc4-7f92-432c-a5bf-e0c8b16445c3',
		'be2f249f-e16e-4ad8-98fb-0debe2f34923',
		'8b4135f6-3f59-428d-ae27-8c9e27064112',
		'c5f6f33e-12e3-400c-a10c-3ad33ee9c25f'
	)
);

--VL_PROD DB

select site_name
,'2025' as Period
,SUM(CASE WHEN lower(pa) = 'ping' THEN 0.5 ELSE 0 END) as watch_mins
--Content Count
,count(distinct vid) as distinct_content_count
,count(distinct case when lower(vf.islive) in ('1','t','true')  then vid end) as distinct_live_content_count
,count(distinct case when (vf.islive is null 
							or lower(vf.islive) in ('','0','false','f')) then vid end) as distinct_VOD_content_count
--Views
,Count(Distinct case when lower(pa) IN ('play','ping') then stream_id end) as Total_Views
,Count(Distinct case when lower(pa) IN ('play','ping') and lower(vf.islive) in ('1','t','true') 
				then stream_id end) as Total_live_Views
,Count(Distinct case when lower(pa) IN ('play','ping') and 
							(vf.islive is null or lower(vf.islive) in ('','0','false','f'))
								then stream_id end) as Total_VOD_Views
--Watch Hours
,watch_mins/60 as Total_watch_hours
,SUM(CASE WHEN lower(pa) = 'ping' and lower(vf.islive) in ('1','t','true')  THEN 0.5 ELSE 0 END)/60 as Live_Watch_Hours
,SUM(CASE WHEN lower(pa) = 'ping' and 
			(vf.islive is null or lower(vf.islive) in ('','0','false','f')) THEN 0.5 ELSE 0 END)/60 as VOD_Watch_Hours
--Streams
,count(distinct ve.stream_id + ve.uid) AS unique_streams
,count(distinct case when lower(vf.islive) in ('1','t','true') then ve.stream_id + ve.uid end) AS unique_Live_streams
,count(distinct case when (vf.islive is null or lower(vf.islive) in ('','0','false','f')) 
					 then ve.stream_id + ve.uid end) AS unique_VOD_streams
--Misc
,count(distinct countryname) as no_of_countries
,Count(Distinct case when lower(pa) IN ('play','ping') then stream_id end)/count(distinct uid) as avg_views_per_user
--,min(tstamp),max(tstamp)
from public.viewlift_events ve inner join mapping_cid_name mp on ve.cid = mp.cid
LEFT JOIN (
            SELECT DISTINCT id, title, islive
            FROM appcms.vl_film
        ) vf ON ve.vid = vf.id
where tstamp >= '2025-09-30 00:00:00' and tstamp <'2026-01-01 00:00:00'
group by all order by 1;

select ve.cid, site_name ,max(tstamp),min(tstamp) 
from public.viewlift_events ve 
		inner join mapping_cid_name mp on ve.cid = mp.cid
--where cid = '8b3df2c4-8f29-43a5-aa74-170b51a2051c'
group by 1,2 order by 2
;

select * from public.concurrency_report_table_overall limit 100;

select site_name
,sum(unique_streams) as streams
,sum(case when lower(vf.islive) in ('1','t','true')  then unique_streams end) as live_streams
,sum(case when (vf.islive is null or lower(vf.islive) in ('0','f','false')) then unique_streams end) as VOD_streams
from public.concurrency_report_table_overall conc left join appcms.vl_site vs on lower(conc.cid)=lower(vs.id)
LEFT JOIN (
            SELECT DISTINCT id, title, islive
            FROM appcms.vl_film
        ) vf ON conc.id = vf.id
where eventdate >= '2025-01-01' and eventdate <'2026-01-01'
--and lower(conc.id) = '8b3df2c4-8f29-43a5-aa74-170b51a2051c'
group by all order by 1; 

--------------------------------------------------------------------------------------------------------------------------------
--Check for here-tv why we don't see any events in viewlift_events table?
--------------------------------------------------------------------------------------------------------------------------------

select * 
from public.tableau_content_report_table_new_overall tb left join appcms.vl_site vs on lower(tb.cid)=lower(vs.id)
where tstamp between '2025-01-01 00:00:00' and '2025-12-31 00:00:00'
and lower(vs.site_name) like 'here-tv'
order by tstamp limit 100;


select * from public.viewlift_events ve 
where date(tstamp) = '2025-01-01'
and vid = 'acdfdaa0-0627-4dd1-8a7b-206212895da5' 
;