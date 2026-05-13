-------------------------------------------------------------------------------------------------------------------
---------------------------------------------2025 Counts for Marketing---------------------------------------------
-------------------------------------------------------------------------------------------------------------------


select 'msn' as site_name
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
from public.viewlift_events ve --inner join mapping_cid_name mp on ve.cid = mp.cid
LEFT JOIN (
            SELECT DISTINCT id, title, islive
            FROM appcms.vl_film
        ) vf ON ve.vid = vf.id
where tstamp >= '2025-01-01 00:00:00' and tstamp <'2026-01-01 00:00:00'
group by all order by 1;



----------------chsn--------------

select 'chsn' as site_name
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
from public.viewlift_events ve --inner join mapping_cid_name mp on ve.cid = mp.cid
LEFT JOIN (
            SELECT DISTINCT id, title, islive
            FROM appcms.vl_film
        ) vf ON ve.vid = vf.id
where tstamp >= '2025-01-01 00:00:00' and tstamp <'2026-01-01 00:00:00'
group by all order by 1;


----------------VL_ONE Prod DB ------------------------------------------


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
where tstamp >= '2025-01-01 00:00:00' and tstamp <'2026-01-01 00:00:00'
group by all order by 1;

select ve.cid, site_name ,min(tstamp) , max(tstamp)
from public.viewlift_events ve 
		inner join mapping_cid_name mp on ve.cid = mp.cid
--where cid = '8b3df2c4-8f29-43a5-aa74-170b51a2051c'
group by 1,2 order by 2
;

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
,sum()

,count(distinct country) as no_of_countries
,sum(numplays)/count(distinct user_id) as avg_views_per_user
--,Live_Streams/count(distinct case when islive in ('1','True','true') then user_id end) avg_views_per_user_live
from public.tableau_content_report_table_new_overall tb left join appcms.vl_site vs on lower(tb.cid)=lower(vs.id)
where tstamp between '2025-01-01 00:00:00' and '2025-12-31 00:00:00'
and lower(vs.site_name) not like 'usanetwork'
group by all
order by 3 desc;

GRANT ALL
ON TABLE public.vl_pa_pas_v2_20260502
TO sparshgupta;

commit;

select count(*) from public.vl_pa_pas_v2_20260502;
