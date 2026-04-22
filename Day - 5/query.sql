with a as (select 
  emp_id, 
  sum(case when salary_component_type = 'salary' then val else null end) as sal, 
  sum(case when salary_component_type = 'bonus' then val else null end) as bonus, 
  sum(case when salary_component_type = 'hike_percent' then val else null end) as hike_percent
from 
  emp_compensation
group by 
  emp_id)
  
select emp_id, sal, 'salary' as "type" from a
union all
select emp_id, bonus, 'bonus' as "type" from a
union all
select emp_id, hike_percent, 'hike_percent' as "type" from a 
order by emp_id