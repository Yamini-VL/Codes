drop table pa_pas_v2;
create temp table pa_pas_v2 as 
(SELECT DISTINCT
    NULL AS pa_id,
    site,
    b.id AS site_id,
    userid AS pa_user_id,
    userid || NVL(updatedate, '') AS pas_id,
    CONVERT_TIMEZONE('US/Eastern', CAST(NULLIF(raw_dat.updatedate, '') AS TIMESTAMP)) AS pas_created_at,
    CONVERT_TIMEZONE('US/Eastern', CAST(NULLIF(raw_dat.updatedate, '') AS TIMESTAMP)) AS pas_updated_at,
    planid AS pas_plan_id,
    name AS plan_name,
    NULL AS pas_version,
    subscriptionstatus AS pas_state,
    paymenthandler AS pas_payment_handler,
    platform AS pas_subscribed_via_platform,
    CAST(
        CASE 
            WHEN LOWER(freetrial) IN (0, 'false') THEN FALSE 
            ELSE TRUE 
        END AS BOOLEAN
    ) AS free_trial_flag,
    countrycode AS country_of_subscription,
    CONVERT_TIMEZONE('US/Eastern', CAST(NULLIF(raw_dat.subscriptionstartdate, '') AS TIMESTAMP)) AS pas_subscription_start_date,
    CONVERT_TIMEZONE('US/Eastern', CAST(NULLIF(raw_dat.subscriptionenddate, '') AS TIMESTAMP)) AS pas_subscription_end_date,
    NULL AS pas_uuid,
    NULL AS environment
FROM (
    SELECT *,
        CASE 
            WHEN purchasetype IS NULL OR purchasetype = '' OR LOWER(purchasetype) = 'subscription' THEN 1 
            ELSE 0 
        END AS flag_purchase_type,
        ROW_NUMBER() OVER (
            PARTITION BY userid, nvl(updatedate ,addeddate)
            ORDER BY identity_sequence_number DESC
        ) AS rn
    FROM appcms.purchase_metadata_raw
	WHERE updatedate::date >= '2026-05-05' AND updatedate::date < '2026-05-12'
      and paymentstate = 'ENDED'
      and paymenthandler != 'TVE'
      and planid != '6a8610c7-6fb5-48f1-85bb-d1d58ca5eae2'
      AND LOWER(TRIM(site)) IN ( 'monumental-network')
      AND LOWER(eventname) IN ('insert', 'modify', 'replace')
      AND (
          LOWER(email) NOT LIKE '%yopmail%' AND
          LOWER(email) NOT LIKE '%@viewlift.com%' AND
          LOWER(email) NOT LIKE '%nexgeniots.com%' OR email IS NULL
      )
    ) raw_dat
LEFT JOIN (
    SELECT id, name 
    FROM appcms.vl_subscription_plan 
    GROUP BY id, name
) a ON raw_dat.planid = a.id
LEFT JOIN (
    SELECT distinct id, site_internal_name as site_name 
    FROM appcms.vl_site 
) b ON LOWER(raw_dat.site) = LOWER(b.site_name)
WHERE raw_dat.rn = 1
  AND raw_dat.flag_purchase_type = 1
)
  ;

select * from pa_pas_v2 order by pas_updated_at desc limit 100;

select count(*) from pa_pas_v2 where pas_updated_at >='2026-05-05';--3,327

select pas_updated_at::date as update_date,count(*) as row_count from pa_pas_v2 group by 1 order by 1;

select count(*) from appcms.vl_pa_pas_v2 
where pas_updated_at >='2026-05-05';--22

select * from appcms.vl_pa_pas_v2 
order by pas_updated_at desc limit 100;

select pas_updated_at::date as update_date,count(*) as row_count from appcms.vl_pa_pas_v2 
where pas_updated_at::date >='2026-05-05'
group by 1 order by 1;

--So a total of 3,305 rows are missing from appcms.vl_pa_pas_v2  since 5th May 2026


begin transaction;

DELETE FROM appcms.vl_pa_pas_v2
using appcms.purchase_metadata_raw as sstr
WHERE pas_id = sstr.userid || NVL(sstr.updatedate, '')
and pas_updated_at >= CONVERT_TIMEZONE('US/Eastern', CAST(NULLIF('2026-05-05', '') AS TIMESTAMP))
  AND pas_updated_at <  CONVERT_TIMEZONE('US/Eastern', CAST(NULLIF('2026-05-12', '') AS TIMESTAMP));
  


INSERT INTO appcms.vl_pa_pas_v2 (
    pa_id,
    site,
    site_id,
    pa_user_id,
    pas_id,
    pas_created_at,
    pas_updated_at,
    pas_plan_id,
    plan_name,
    pas_version,
    pas_state,
    pas_payment_handler,
    pas_subscribed_via_platform,
    free_trial_flag,
    country_of_subscription,
    pas_subscription_start_date,
    pas_subscription_end_date,
    pas_uuid,
    environment
)
SELECT DISTINCT
    NULL AS pa_id,
    site,
    b.id AS site_id,
    userid AS pa_user_id,
    userid || NVL(updatedate, '') AS pas_id,
    CONVERT_TIMEZONE('US/Eastern', CAST(NULLIF(raw_dat.updatedate, '') AS TIMESTAMP)) AS pas_created_at,
    CONVERT_TIMEZONE('US/Eastern', CAST(NULLIF(raw_dat.updatedate, '') AS TIMESTAMP)) AS pas_updated_at,
    planid AS pas_plan_id,
    name AS plan_name,
    NULL AS pas_version,
    subscriptionstatus AS pas_state,
    paymenthandler AS pas_payment_handler,
    platform AS pas_subscribed_via_platform,
    CAST(
        CASE 
            WHEN LOWER(freetrial) IN (0, 'false') THEN FALSE 
            ELSE TRUE 
        END AS BOOLEAN
    ) AS free_trial_flag,
    countrycode AS country_of_subscription,
    CONVERT_TIMEZONE('US/Eastern', CAST(NULLIF(raw_dat.subscriptionstartdate, '') AS TIMESTAMP)) AS pas_subscription_start_date,
    CONVERT_TIMEZONE('US/Eastern', CAST(NULLIF(raw_dat.subscriptionenddate, '') AS TIMESTAMP)) AS pas_subscription_end_date,
    NULL AS pas_uuid,
    NULL AS environment
FROM (
    SELECT *,
        CASE 
            WHEN purchasetype IS NULL OR purchasetype = '' OR LOWER(purchasetype) = 'subscription' THEN 1 
            ELSE 0 
        END AS flag_purchase_type,
        ROW_NUMBER() OVER (
            PARTITION BY userid, nvl(updatedate ,addeddate)
            ORDER BY identity_sequence_number DESC
        ) AS rn
    FROM appcms.purchase_metadata_raw
	WHERE updatedate >= {addeddate_from} AND updatedate < {addeddate_to}
    --WHERE updatedate < '2025-10-11 00:00:00'
      and paymentstate = 'ENDED'
      and paymenthandler != 'TVE'
      and planid != '6a8610c7-6fb5-48f1-85bb-d1d58ca5eae2'
      AND LOWER(TRIM(site)) IN ( 'monumental-network')
      AND LOWER(eventname) IN ('insert', 'modify', 'replace')
      AND (
          LOWER(email) NOT LIKE '%yopmail%' AND
          LOWER(email) NOT LIKE '%@viewlift.com%' AND
          LOWER(email) NOT LIKE '%nexgeniots.com%' OR email IS NULL
      )
    ) raw_dat
LEFT JOIN (
    SELECT id, name 
    FROM appcms.vl_subscription_plan 
    GROUP BY id, name
) a ON raw_dat.planid = a.id
LEFT JOIN (
    SELECT distinct id, site_internal_name as site_name 
    FROM appcms.vl_site 
) b ON LOWER(raw_dat.site) = LOWER(b.site_name)
WHERE raw_dat.rn = 1
  AND raw_dat.flag_purchase_type = 1;

  commit;
end transaction;

