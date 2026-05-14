/*
Issue- in the table appcms.vl_pa_pas_v2 the plan name is coming null for the latest dates
freshdesk ticket- https://viewlift.freshdesk.com/a/tickets/333551
Date- 13-05-2026

Rebecca Holmes reported via the portal 
3 days ago (Mon, 11 May 2026 at 7:50 AM)

Cc:cweilenmann@monumentalsports.com
Hi, 

It looks like there are no new rows in appcms.vl_pa_pas_v2 since 2026-05-05. Can we double check that table is updating properly? 

select top 100 *
from appcms.vl_pa_pas_v2
order by pas_created_at desc

Thanks

Hi sorry re-opening this. I this this happened overnight but all of the monthly plans is vl_pa_pas_v2 
are pulling through with a NULL plan name. Not just recent records, all monthly plans. 

Can we get that fixed ASAP? 

select top 100 *
from appcms.vl_pa_pas_v2 vppv
order by pas_created_at desc
 */

----------------------------Step 1 | Check appcms.vl_subscription_plan table-------------------------------
--i) check when was the last update date in appcms.site_config_transactional_raw table

select 	* from 	appcms.site_config_transactional_raw order by updatedate desc;
--

--monumental foundation row is not added to vl_site table 
select * from appcms.vl_site;

select
	raw_dat.id as id,
	raw_dat.id as uuid,
	raw_dat.name as site_name,
	raw_dat.siteinternalname as site_internal_name
from
(
	select 	*, rank() over (partition by id order by sequencenumber desc, random()) as change_number_desc
	from 	appcms.site_config_transactional_raw
	where 	(addeddate >= '2016-01-01' and	addeddate < '2026-05-13')
			or
			(updatedate >= '2016-01-01' and	updatedate < '2026-05-13')
			
			order by updatedate desc;
) as raw_dat
where change_number_desc = 1 and eventname in ('MODIFY', 'INSERT');

drop table public.vl_subscription_plan_backup;
create table public.vl_subscription_plan_backup as 
select
		raw_dat.id as id,
		raw_dat.identifier as identifier,
		null as version,
		CASE 
		    WHEN raw_dat.renewalcycleperiodmultiplier IS NULL THEN NULL
		    WHEN TRIM(raw_dat.renewalcycleperiodmultiplier) = '' THEN NULL
		    WHEN LOWER(TRIM(raw_dat.renewalcycleperiodmultiplier)) IN ('none','null','nan') THEN NULL
		    ELSE CAST(TRIM(raw_dat.renewalcycleperiodmultiplier) AS BIGINT)
		END AS billing_cycle_period_multiplier,
		raw_dat.renewalcycletype as billing_cycle_period_type,
		raw_dat.description as description,
		raw_dat.name as name,
		null as recurring_payment_amount,
		null as recurring_payment_currency_code,
		null as scheduled_from_date,
		null as scheduled_to_date,
		null as visible,
		raw_dat.id as uuid,
		vl_site.uuid as site_id,
		case when vl_site.site_internal_name is null then site else vl_site.site_internal_name end as site_internal_name,
		convert_timezone('US/Eastern', cast(substring(raw_dat.updatedate,1,19) as timestamp)) as update_date,
		null as seller_note
from
	(
		select	*,rank() over (partition by id order by createdat desc,case when sequencenumber is null then 1 else sequencenumber end ,random()) as change_number_desc
		from	appcms.subscription_metadata_transactional_raw
		where	(
					(addeddate >= '2016-01-01' and	addeddate < '2026-05-13')
					or
					(updatedate >= '2016-01-01' and	updatedate < '2026-05-13')
				)
				and	lower(objectkey) in ('plan','subscriptionplan')
				and eventname in ('MODIFY', 'INSERT')
				--and sequencenumber is null
	) raw_dat
	left join appcms.vl_site on raw_dat.site = vl_site.site_internal_name
where change_number_desc = 1 and eventname in ('MODIFY', 'INSERT');

select * from public.vl_subscription_plan_backup;

select id,count(*) from public.vl_subscription_plan_backup group by 1 order by 2 desc;
-- Every Plan has 1 entry and there are 72 distinct Plans for both msn and monumental foundation till date

select id,count(*) from appcms.vl_subscription_plan group by 1 order by 2 desc;
--here I see 161 distinct Plans
select * from appcms.vl_subscription_plan a left join appcms.subscription_metadata_transactional_raw s on a.id=s.id
where a.id not in (select id from public.vl_subscription_plan_backup)
and objectkey not in ('offer')
and id in (select distinct id from appcms.subscription_metadata_transactional_raw)
;

select distinct planid from appcms.purchase_metadata_raw
where planid not in (select id from public.vl_subscription_plan_backup);

select id,objectkey,site,max(updatedate),max(addeddate)
from	appcms.subscription_metadata_transactional_raw
where id in (select id from appcms.vl_subscription_plan
				where id not in (select id from public.vl_subscription_plan_backup))
--and objectkey <> 'offer'				
group by all				
            ;

--

select case when b.id is null then 'Not Present' end as flag
,c.site,c.objectkey 
,* from appcms.vl_subscription_plan a left join public.vl_subscription_plan_backup b on a.id=b.id
left join (select distinct id,site,objectkey from appcms.subscription_metadata_transactional_raw) c on a.id=c.id
;

-----------------------------------Step 2 recreate appcms.vl_pa_pas_v2--------------------------------------------------
drop table public.vl_pa_pas_v2_backup;
create table public.vl_pa_pas_v2_backup as
(select vp.pa_id,vp.site,vp.site_id,
    pa_user_id,
    pas_id,
    pas_created_at,
    pas_updated_at,
    pas_plan_id, --this column is from appcms.purchase_metadata_raw
    vl.name as plan_name, --Take the plan name from the new vl_subscription_plan table
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
 from appcms.vl_pa_pas_v2 vp left join public.vl_subscription_plan_backup vl on vp.pas_plan_id=vl.id
);

select plan_name,

select * from public.vl_pa_pas_v2_backup order by pas_updated_at desc limit 100;

--check the new created backup table with the original table, counts

with tab_new as 
(select date_part('year',pas_created_at) as year
,date_part('month',pas_created_at) as month
,count(distinct pa_user_id) as user_count
,count(*) as row_count
from public.vl_pa_pas_v2_backup
group by all)
,tab_og as 
(select date_part('year',pas_created_at) as year
,date_part('month',pas_created_at) as month
,count(distinct pa_user_id) as user_count
,count(*) as row_count
from appcms.vl_pa_pas_v2
group by all)
select a.year, a.month, a.row_count as old_row_count
,b.row_count as new_row_count
,new_row_count-old_row_count
from tab_og a inner join tab_new b on a.year||a.month=b.year||b.month
order by 1,2;

with tab_new as 
(select case when plan_name is null then 'NA' else plan_name end as plan_name
,date_part('year',pas_created_at) as year
,date_part('month',pas_created_at) as month
,count(distinct pa_user_id) as user_count
,count(*) as row_count
from public.vl_pa_pas_v2_backup
--where pas_created_at >= '2026-01-01'
group by all)
,tab_og as 
(select case when plan_name is null then 'NA' else plan_name end as plan_name
,date_part('year',pas_created_at) as year
,date_part('month',pas_created_at) as month
,count(distinct pa_user_id) as user_count
,count(*) as row_count
from appcms.vl_pa_pas_v2
--where pas_created_at >= '2026-01-01'
group by all)
select a.plan_name,a.year, a.month
, a.row_count as old_row_count
,b.row_count as new_row_count
,new_row_count-old_row_count
from tab_og a inner join tab_new b on a.plan_name =b.plan_name and a.year||a.month=b.year||b.month
order by 2,3,1;


select plan_name
,count(distinct pa_user_id) as user_count
,count(*) as row_count
from appcms.vl_pa_pas_v2
where pa_user_id in (select distinct pa_user_id from public.vl_pa_pas_v2_backup 
						where plan_name = 'Annual Plan' and pas_created_at::date between '2026-01-01' and '2026-01-31'
					)
and pas_created_at::date between '2026-01-01' and '2026-01-31'					
group by 1 order by 1;

--All looks good
