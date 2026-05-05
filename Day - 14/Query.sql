with recursive a as(
select product_id, period_start, average_daily_sales, period_end from sales
union all
select product_id, period_start + 1, average_daily_sales, period_end from a
where period_start < period_end),

b as(select *, EXTRACT(YEAR FROM period_start) as year from a)

select product_id, year, sum(average_daily_sales) as total_sales from b
group by product_id, year
order by product_id