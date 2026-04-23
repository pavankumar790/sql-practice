PARETO ANALYSIS USING SQL (80/20 RULE)

Problem:
The goal is to identify top products that contribute to 80% of total sales.

This follows the Pareto Principle:
80% of results come from 20% of inputs.

Dataset:
The table "orders" contains:

product_id
product_name
sales
quantity
discount
profit
and other order-related fields

Approach:

Step 1: Calculate total sales per product

with product_wise_sales as (
select
product_id,
sum(sales) as product_sales
from orders
group by product_id
)

Step 2: Calculate running total and total sales

cal_sales as (
select
product_id,
product_sales,
sum(product_sales) over (
order by product_sales desc
rows between unbounded preceding and current row
) as running_sales,
0.8 * sum(product_sales) over () as total_sales
from product_wise_sales
)

Step 3: Get products contributing to 80% sales

select *
from cal_sales
where running_sales <= total_sales;

Concepts Used:

CTE (WITH clause)
Window Functions (SUM OVER)
Running Total
Pareto Analysis

Output:
Returns products that together contribute to the first 80% of total sales.

Use Cases:

Identify top-selling products
Focus business efforts on high revenue items
Inventory and sales optimization

Notes:

Ordering by product_sales DESC is important
Window functions help avoid complex subqueries
This is a common interview-level SQL problem

Conclusion:
This query helps identify high-impact products using SQL and demonstrates strong analytical thinking.