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

select 'chsn' as site 
,sum(duration) as watch_mins
,sum(duration)/60 as watch_hours
,count(distinct vid) as distinct_content_count
,count(distinct case when islive = 1 then vid end) as distinct_content_count
,count(distinct country) as no_of_coubtries
,sum(numplays)/count(distinct user_id) as avg_views_per_user
from public.tableau_content_report_table_chsn
where tstamp between '2025-01-01 00:00:00' and '2025-12-31 00:00:00';

/*
site|watch_hours|distinct_content_count|distinct_content_count|
----+-----------+----------------------+----------------------+
chsn|118667678.0|                  5925|                   640|
*/

select 'chsn' as client,country, sum(numplays) as views 
from public.tableau_content_report_table_chsn
where tstamp between '2025-01-01 00:00:00' and '2025-12-31 00:00:00'
group by all order by 3 desc;

------------------------------------------vl-one DB-----------------------------------
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
and lower(vs.site_name) not like 'usanetwork'
group by all
order by 3 desc;

/*
client              |period|watch_mins |watch_hours |distinct_content_count|distinct_live_content_count|no_of_coubtries|avg_views_per_user|
--------------------+------+-----------+------------+----------------------+---------------------------+---------------+------------------+
here-tv             |2025  |538675122.5|8977918.7083|                  1650|                          0|            239|                 2|
rootsports          |2025  |453949641.5|7565827.3583|                   245|                         15|            138|               250|
nesn                |2025  |237823006.5|3963716.7750|                  3000|                         75|            123|                91|
altitude            |2025  |179431058.5|2990517.6416|                  1214|                          8|            147|                85|
myoutdoortv         |2025  |170048719.5|2834145.3250|                 30499|                         19|            195|                39|
gxr                 |2025  |163338237.0|2722303.9500|                  2848|                        816|            195|                11|
--usanetwork          |2025  |134738563.0|2245642.7166|                  4678|                          0|            205|                13|
liv-golf            |2025  | 54842457.0| 914040.9500|                  1999|                        179|            225|                 4|
vegas-golden-knights|2025  | 45151714.0| 752528.5666|                   881|                        108|             78|               143|
fp                  |2025  | 29829613.0| 497160.2166|                  1271|                         59|            108|                85|
lightning           |2025  | 27433800.5| 457230.0083|                   400|                          0|             78|                18|
pfl                 |2025  |  3028578.0|  50476.3000|                  2838|                         16|            196|                15|
schn                |2025  |  2464194.0|  41069.9000|                   259|                          0|             70|                17|
sfc                 |2025  |    93219.0|   1553.6500|                   218|                         30|             40|                 6|
golfchannel         |2025  |    16265.0|    271.0833|                     2|                          0|              4|                 2|
                    |2025  |    15333.5|    255.5583|                    79|                          7|              8|                 6|
ballylive           |2025  |    13519.0|    225.3166|                    59|                         39|              3|                15|
shilo               |2025  |        2.5|      0.0416|                    22|                          0|             17|                 5|
*/

select lower(vs.site_name) as client
,country, sum(numplays) as views 
from public.tableau_content_report_table_new_overall tb left join appcms.vl_site vs on lower(tb.cid)=lower(vs.id)
where tstamp between '2025-01-01 00:00:00' and '2025-12-31 00:00:00'
group by all
order by 1,3 desc;

-------------------------Foxone, Dirtvision, versant----------------------------------

select lower(vs.site_name) as client
,'2025' as Period
,sum(duration) as watch_mins
,sum(duration)/60 as watch_hours
,count(distinct vid) as distinct_content_count
,count(distinct case when islive = 1 then vid end) as distinct_live_content_count
,count(distinct country) as no_of_coubtries
,sum(numplays)/count(distinct user_id) as avg_views_per_user
from public.tableau_content_report_table_caliente tb left join appcms.vl_site vs on lower(tb.cid)=lower(vs.id)
where tstamp between '2025-01-01 00:00:00' and '2025-12-31 00:00:00'
group by all

union all

select lower(vs.site_name) as client
,'2025' as Period
,sum(duration) as watch_mins
,sum(duration)/60 as watch_hours
,count(distinct vid) as distinct_content_count
,count(distinct case when islive = 1 then vid end) as distinct_live_content_count
,count(distinct country) as no_of_coubtries
,sum(numplays)/count(distinct user_id) as avg_views_per_user
from public.tableau_content_report_table_dirtvision tb left join appcms.vl_site vs on lower(tb.cid)=lower(vs.id)
where tstamp between '2025-01-01 00:00:00' and '2025-12-31 00:00:00'
group by all

union all 

select lower(vs.site_name) as client
,'2025' as Period
,sum(duration) as watch_mins
,sum(duration)/60 as watch_hours
,count(distinct vid) as distinct_content_count
,count(distinct case when islive = 1 then vid end) as distinct_live_content_count
,count(distinct country) as no_of_coubtries
,sum(numplays)/count(distinct user_id) as avg_views_per_user
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

----------------------------------------MSN-----------------------------------------------

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


select 'monumental-network' as site 
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
