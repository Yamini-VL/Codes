
create table tableau_content_report_table_new_overall_NHL_TV as  (
        SELECT
            (ve.tstamp::DATE)::TIMESTAMP AS tstamp,
            ve.cid,
            ve.vid,
            vf.title,
            ve.tstamp::DATE AS eventdate,
            pfm_std.pfm_standardized AS pfm,
            vf.islive,
            ve.countryname AS country,
            ve.subdivision_en_name AS subdivision,
            ve.cityname AS city,
            ve.uid AS user_id,
            CASE
                WHEN cvu.id IS NOT NULL THEN 1
                ELSE 0
            END AS isRegActiviewlift_events,
            CASE
                WHEN pas_history.pa_user_id IS NOT NULL THEN 1
                ELSE 0
            END AS isSubActiviewlift_events,
            CASE
                WHEN tve.userid IS NOT NULL THEN 1
                ELSE 0
            END AS tve_flag,
            CASE
                WHEN LOWER(profid) LIKE '%guest-%' THEN 1
                ELSE 0
            END AS isguest,
            SUM(CASE WHEN pa = 'PING' THEN 0.5 ELSE 0 END) AS duration,
            SUM(CASE WHEN pa = 'PLAY' THEN 1 ELSE 0 END) AS numplays
        FROM
            viewlift_events ve
        LEFT JOIN (
            SELECT DISTINCT pfm, pfm_standardized
            FROM public.lkup_pfm_standardized
        ) pfm_std
            ON ve.pfm = pfm_std.pfm
        LEFT JOIN (
            SELECT DISTINCT id, title, islive
            FROM appcms.vl_film
        ) vf
            ON ve.vid = vf.id
        LEFT JOIN (
            SELECT DISTINCT userid
            FROM Tableau_TVE_Report_Data
        ) tve
            ON tve.userid = ve.uid
        LEFT JOIN (Select Distinct id from appcms.vl_user_v2) cvu
            ON ve.uid = cvu.id
        LEFT JOIN (
            SELECT
                a.*,
                NVL(
                    LEAD(pas_created_at, 1) OVER (
                        PARTITION BY pa_user_id
                        ORDER BY pas_created_at, pas_id ASC
                    ),
                    SYSDATE + 3
                ) AS next_pas_created_at,
                NVL(
                    LEAD(pas_state, 1) OVER (
                        PARTITION BY pa_user_id
                        ORDER BY pas_state, pas_id ASC
                    ),
                    pas_state
                ) AS next_pas_state
            FROM appcms.vl_pa_pas_v2 a
            WHERE UPPER(pas_state) IN (
                'COMPLETED', 'SUSPENDED', 'HOLD', 'PAUSE', 'CANCELLED',
                'DEFERRED_CANCELLATION', 'DEFFERED_CANCELLATION',
                'DEFERRED_CANCELATION', 'DEFFERED_CANCELATION'
            )
            ORDER BY pa_user_id, pas_created_at, pas_id
        ) pas_history
            ON ve.uid = pas_history.pa_user_id
            AND DATE_ADD('day', 1, DATE_TRUNC('day', ve.tstamp)) >= pas_history.pas_created_at
            AND DATE_ADD('day', 1, DATE_TRUNC('day', ve.tstamp)) < pas_history.next_pas_created_at
            AND UPPER(pas_state) IN (
                'COMPLETED', 'DEFERRED_CANCELLATION', 'DEFFERED_CANCELLATION',
                'DEFERRED_CANCELATION', 'DEFFERED_CANCELATION'
            )
      
     WHERE
            trunc(tstamp) >= '2016-01-01' and trunc(tstamp) < '20'
            and cid in ('74579540-118a-11ee-83aa-dfe1e69d1859')
    
GROUP BY
            1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15
    );


end transaction;

commit; 
 rollback;
begin transaction;
 delete from tableau_content_report_table_new_overall 
 where  TRUNC(tstamp) >={added_from} and trunc(tstamp) < {added_to};

insert into tableau_content_report_table_new_overall  (
        SELECT
            (ve.tstamp::DATE)::TIMESTAMP AS tstamp,
            ve.cid,
            ve.vid,
            vf.title,
            ve.tstamp::DATE AS eventdate,
            pfm_std.pfm_standardized AS pfm,
            vf.islive,
            ve.countryname AS country,
            ve.subdivision_en_name AS subdivision,
            ve.cityname AS city,
            ve.uid AS user_id,
            CASE
                WHEN cvu.id IS NOT NULL THEN 1
                ELSE 0
            END AS isRegActiviewlift_events,
            CASE
                WHEN pas_history.pa_user_id IS NOT NULL THEN 1
                ELSE 0
            END AS isSubActiviewlift_events,
            CASE
                WHEN tve.userid IS NOT NULL THEN 1
                ELSE 0
            END AS tve_flag,
            CASE
                WHEN LOWER(profid) LIKE '%guest-%' THEN 1
                ELSE 0
            END AS isguest,
            SUM(CASE WHEN pa = 'PING' THEN 0.5 ELSE 0 END) AS duration,
            SUM(CASE WHEN pa = 'PLAY' THEN 1 ELSE 0 END) AS numplays
        FROM
            viewlift_events ve
        LEFT JOIN (
            SELECT DISTINCT pfm, pfm_standardized
            FROM public.lkup_pfm_standardized
        ) pfm_std
            ON ve.pfm = pfm_std.pfm
        LEFT JOIN (
            SELECT DISTINCT id, title, islive
            FROM appcms.vl_film
        ) vf
            ON ve.vid = vf.id
        LEFT JOIN (
            SELECT DISTINCT userid
            FROM Tableau_TVE_Report_Data
        ) tve
            ON tve.userid = ve.uid
        LEFT JOIN (Select Distinct id from appcms.vl_user_v2) cvu
            ON ve.uid = cvu.id
        LEFT JOIN (
            SELECT
                a.*,
                NVL(
                    LEAD(pas_created_at, 1) OVER (
                        PARTITION BY pa_user_id
                        ORDER BY pas_created_at, pas_id ASC
                    ),
                    SYSDATE + 3
                ) AS next_pas_created_at,
                NVL(
                    LEAD(pas_state, 1) OVER (
                        PARTITION BY pa_user_id
                        ORDER BY pas_state, pas_id ASC
                    ),
                    pas_state
                ) AS next_pas_state
            FROM appcms.vl_pa_pas_v2 a
            WHERE UPPER(pas_state) IN (
                'COMPLETED', 'SUSPENDED', 'HOLD', 'PAUSE', 'CANCELLED',
                'DEFERRED_CANCELLATION', 'DEFFERED_CANCELLATION',
                'DEFERRED_CANCELATION', 'DEFFERED_CANCELATION'
            )
            ORDER BY pa_user_id, pas_created_at, pas_id
        ) pas_history
            ON ve.uid = pas_history.pa_user_id
            AND DATE_ADD('day', 1, DATE_TRUNC('day', ve.tstamp)) >= pas_history.pas_created_at
            AND DATE_ADD('day', 1, DATE_TRUNC('day', ve.tstamp)) < pas_history.next_pas_created_at
            AND UPPER(pas_state) IN (
                'COMPLETED', 'DEFERRED_CANCELLATION', 'DEFFERED_CANCELLATION',
                'DEFERRED_CANCELATION', 'DEFFERED_CANCELATION'
            )
      
     WHERE
            trunc(tstamp) >= '2026-04-14' and trunc(tstamp) < '2026-05-08'
            and cid in ('74579540-118a-11ee-83aa-dfe1e69d1859')
    
GROUP BY
            1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15
    );


end transaction;

commit;

select * from appcms.qos_user_stream_level_materialized quslm
LEFT JOIN (
            SELECT DISTINCT id, title, islive
            FROM appcms.vl_film
        ) vf
            ON quslm.vid = vf.id
where cid='74579540-118a-11ee-83aa-dfe1e69d1859'
order by watchdate desc
limit 100;

select min(watchdate),max(watchdate) from appcms.qos_user_stream_level_materialized quslm  
LEFT JOIN (
            SELECT DISTINCT id, title, islive
            FROM appcms.vl_film
        ) vf
            ON quslm.vid = vf.id
where cid='74579540-118a-11ee-83aa-dfe1e69d1859'
limit 100;

--2024-01-01 00:00:01.000	2026-05-11 02:41:53.000

select *
--min(update_date),max(update_date) 
FROM Tableau_TVE_Report_Data 
where cid='74579540-118a-11ee-83aa-dfe1e69d1859'
limit 100;

select * from tableau_content_report_table_new_overall
where cid='74579540-118a-11ee-83aa-dfe1e69d1859'
and title is null
limit 100;

select * from appcms.vl_film 
where site_id='74579540-118a-11ee-83aa-dfe1e69d1859'
and id in ('ba8516c9-3576-4dd5-816d-6cddb767058b','d66220ce-c506-48bd-bb2f-86df9f6614a5','ba9f87a8-e602-4e88-9b83-18370bd856bc','694bfbce-1272-4ec9-a268-4d221157a073')
order by update_date desc
limit 100;

select * from appcms.identity_user_raw
where site ilike 'nhl-tv-app' limit 100;

create temp table vl_user_2_nhl as
(
    SELECT
        raw_dat.site,
        vl_site.uuid AS site_id,
        raw_dat.userid AS id,
        raw_dat.email AS email,
        raw_dat.name AS full_name,
        CONVERT_TIMEZONE('US/Eastern', CAST(NULLIF(raw_dat.registeredon, '') AS TIMESTAMP)) AS joined,
        raw_dat.provider AS registration_type,
        CONVERT_TIMEZONE('US/Eastern', CAST(NULLIF(raw_dat.updatedate, '') AS TIMESTAMP)) AS update_date,
        raw_dat.campaign AS campaign,
        raw_dat.campaignsource AS campaign_source,
        raw_dat.campaignmedium AS campaign_medium,
        raw_dat.registeredVia AS registered_via_platform,
        raw_dat.country AS country_of_registration,
        case WHEN raw_dat.isactive ~ '^[0-9]+(\.[0-9]+)?$'
    THEN CAST(CAST(raw_dat.isactive AS NUMERIC) AS INT) END AS active_flag
    FROM (
        SELECT *,
        RANK() OVER (
                   PARTITION BY userid 
                   ORDER BY nvl(cast(createdat as varchar(100)),updatedate) DESC, RANDOM()
               ) AS change_number_desc
        FROM  appcms.identity_user_raw
        WHERE (
    (
        CONVERT_TIMEZONE('US/Eastern',TRY_CAST(REPLACE(REPLACE(registeredon, 'T', ' '), 'Z', '')AS TIMESTAMP)) >= TIMESTAMP '2024-01-01'
        AND
        CONVERT_TIMEZONE('US/Eastern',TRY_CAST(REPLACE(REPLACE(registeredon, 'T', ' '), 'Z', '')AS TIMESTAMP)) < TIMESTAMP '2026-05-11'            
    )
    OR
    (
        CONVERT_TIMEZONE('US/Eastern',TRY_CAST(NULLIF(NULLIF(updatedate, ''), 'None') AS TIMESTAMP)) >= TIMESTAMP '2024-01-01'
        AND
        CONVERT_TIMEZONE(
            'US/Eastern',
            TRY_CAST(NULLIF(NULLIF(updatedate, ''), 'None') AS TIMESTAMP)
        ) < TIMESTAMP '2026-05-11'
    )
    OR
    (
        CONVERT_TIMEZONE(
            'US/Eastern',
            TRY_CAST(
                REPLACE(REPLACE(createdat, 'T', ' '), 'Z', '')
                AS TIMESTAMP
            )
        ) >= TIMESTAMP '2024-01-01'
        AND
        CONVERT_TIMEZONE(
            'US/Eastern',
            TRY_CAST(
                REPLACE(REPLACE(createdat, 'T', ' '), 'Z', '')
                AS TIMESTAMP
            )
        ) < TIMESTAMP '2026-05-11'
    )
    
)
            AND UPPER(eventname) IN ('MODIFY', 'INSERT','UPDATE','REPLACE')
            AND LOWER(TRIM(site)) IN ('nhl-tv-app')
    ) raw_dat
    LEFT JOIN appcms.vl_site
        ON raw_dat.site = vl_site.site_internal_name
    WHERE raw_dat.change_number_desc = 1
      
      );
Select joined::date,count(id) from vl_user_2_nhl --where SITE ilike '%nhl%' 
group by 1
limit 100;


select * from appcms.vl_pa_pas_v2 --This is purchase data will not br available for nhl-tv
where LOWER(TRIM(site)) IN ('nhl-tv-app')
limit 100;

create temp table nhl_content_data as (
SELECT
            (ve.WATCHDATE::DATE)::TIMESTAMP AS tstamp,
            ve.cid,
            ve.vid,
            vf.title,
            ve.WATCHDATE::DATE AS eventdate,
            pfm_std.pfm_standardized AS pfm,
            vf.islive,
            ve.country AS country,
            ve.subdivision AS subdivision,
            ve.city AS city,
            ve.uid AS user_id,
            case WHEN cvu.id IS NOT NULL THEN 1 ELSE 0 END AS isRegActiviewlift_events,
            0 AS isSubActiviewlift_events,
            0 AS tve_flag,
            0 as isguest,
            SUM(duration)/60 AS duration,
            count(distinct CASE WHEN upper(failedtostartindicator) = 'N' THEN stream_id END) AS numplays
        FROM
            appcms.qos_user_stream_level_materialized ve
        LEFT JOIN (
			            SELECT DISTINCT pfm, pfm_standardized
			            FROM public.lkup_pfm_standardized
			      ) pfm_std ON ve.platform = pfm_std.pfm
        LEFT JOIN (
			            SELECT DISTINCT id, title, islive
			            FROM appcms.vl_film
			       ) vf
            ON ve.vid = vf.id
        LEFT JOIN (Select distinct id from vl_user_2_nhl ) cvu ON ve.uid = cvu.id
      
     where trunc(tstamp) >= '2024-01-01' and trunc(tstamp) < '2026-05-11'
            and cid in ('74579540-118a-11ee-83aa-dfe1e69d1859')
    
GROUP by ALL
    );


select * from nhl_content_data limit 100;

select eventdate,sum(numplays) as views, sum(duration)/60 as watch_hours
from nhl_content_data 
where eventdate>= '2026-04-14'
group by 1 order by 1;

--Check from tableau_content_report_table_new_overall for same dates

select eventdate,sum(numplays) as views, sum(duration)/60 as watch_hours from tableau_content_report_table_new_overall
where cid='74579540-118a-11ee-83aa-dfe1e69d1859'
group by 1 order by 1;
limit 100;

select title,sum(numplays) as views, sum(duration)/60 as watch_hours from tableau_content_report_table_new_overall
where cid='74579540-118a-11ee-83aa-dfe1e69d1859'
--and lower(islive) in ('true','t','1')
group by 1 order by 2 desc
limit 100;

select watchdate::date
, sum(duration)/3600 as watch_duration_minutes
, count(stream_id) as count_streams
, count(distinct stream_id) as uniq_streams
, count(distinct CASE WHEN upper(failedtostartindicator) = 'N' THEN stream_id END) as uniq_streams_not_failed
from appcms.qos_user_stream_level_materialized quslm
LEFT JOIN (
            SELECT DISTINCT id, title, islive
            FROM appcms.vl_film
        ) vf
            ON quslm.vid = vf.id
where cid='74579540-118a-11ee-83aa-dfe1e69d1859'
--and watchdate >= '2026-04-14'
group by 1 order by 1;
limit 100;

select tstamp::date as date
,SUM(CASE WHEN pa = 'PING' THEN 0.5 ELSE 0 END)/60 AS duration
,SUM(CASE WHEN pa = 'PLAY' THEN 1 ELSE 0 END) AS numplays
from viewlift_events ve
 where trunc(tstamp) >= '2026-04-14' and trunc(tstamp) < '2026-05-11'
and cid in ('74579540-118a-11ee-83aa-dfe1e69d1859')
group by 1 order by 1;

----------------------------------------------------------------------------------------------------------------
--Tables used in NHL Dashboard--

public.content_new_query
public.

delete from tableau_content_report_table_new_overall
where cid='74579540-118a-11ee-83aa-dfe1e69d1859';

insert into tableau_content_report_table_new_overall
(select * from nhl_content_data);

select * from nhl_content_data limit 100;

select * from tableau_content_report_table_new_overall limit 100;

Select * from public.tableau_qos_report_table where cid = '74579540-118a-11ee-83aa-dfe1e69d1859'
and daterange < '2026-04-14'
limit 100;

Select daterange::date,sum(numplays) as views from public.tableau_qos_report_table where cid = '74579540-118a-11ee-83aa-dfe1e69d1859'
group by 1 order by 1;

Select eventdate
,sum(unique_streams)
from concurrency_report_table_overall where cid = '74579540-118a-11ee-83aa-dfe1e69d1859'
group by 1 order by 1;
