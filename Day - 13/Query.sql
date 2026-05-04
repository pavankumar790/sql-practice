with all_spend as (
    select spend_date, user_id, max(platform) as platform, sum(amount) as amount from spending
    group by spend_date, user_id having count(distinct platform) = 1
    union all
    select spend_date, user_id, 'both' as platform, sum(amount) as amount from spending
    group by spend_date, user_id having count(distinct platform) = 2
    union all
    select distinct spend_date, null as user_id, 'both' as platform, 0 as amount from spending
)
select spend_date, platform, sum(amount) as total_amount, count(distinct user_id) as total_users
from all_spend
group by spend_date, platform
order by spend_date, platform desc