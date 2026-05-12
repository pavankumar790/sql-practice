# Customer Retention Analysis Using SQL Window Functions

## Overview

This project analyzes customer retention behavior using SQL window functions.

The goal is to identify customers who placed another order within a retention window of **20–60 days** after their previous purchase.

The project demonstrates:

* Window functions (`LAG`)
* Temporal analysis
* Retention logic
* Cohort-style aggregation
* Date handling in SQL

---

## Dataset

### Table: `transactions`

| Column       | Type | Description             |
| ------------ | ---- | ----------------------- |
| `order_id`   | INT  | Unique order identifier |
| `cust_id`    | INT  | Customer identifier     |
| `order_date` | DATE | Date of order           |
| `amount`     | INT  | Order amount            |

---

## Sample Data

```sql
create table transactions(
    order_id int,
    cust_id int,
    order_date date,
    amount int
);

insert into transactions values 
(1,1,'2020-01-15',150),
(2,1,'2020-02-10',150),
(9,1,'2020-03-10',150),
(3,2,'2020-01-16',150),
(4,2,'2020-02-25',150),
(5,3,'2020-01-10',150),
(6,3,'2020-02-20',150),
(7,4,'2020-01-20',150),
(8,5,'2020-02-20',150);
```

---

# Business Problem

Find how many customers returned and placed another order within **20 to 60 days** of their previous purchase.

Group the retained customers by order month.

---

# SQL Solution

```sql
with a as (
    select *,
           lag(order_date) over(
               partition by cust_id
               order by order_date
           ) as prev_date
    from transactions
),

b as (
    select *,
           order_date - prev_date as gap,
           date_trunc('month', order_date) as m,
           case
               when order_date - prev_date > 20
                and order_date - prev_date < 60
               then 1
               else 0
           end as retention
    from a
)

select
    m,
    count(case when retention = 1 then 1 end) as retained_customers
from b
group by m
order by m;
```

---

# Explanation

## Step 1 — Get Previous Order Date

```sql
lag(order_date) over(
    partition by cust_id
    order by order_date
)
```

The `LAG()` window function retrieves the previous order date for each customer.

### Why `PARTITION BY`?

It creates separate timelines for each customer.

### Why `ORDER BY`?

It ensures orders are analyzed chronologically.

---

## Step 2 — Calculate Purchase Gap

```sql
order_date - prev_date as gap
```

This calculates the number of days between consecutive orders.

---

## Step 3 — Define Retention

```sql
case
    when gap > 20 and gap < 60
    then 1
    else 0
end
```

Customers are marked as retained if they place another order within 20–60 days.

---

## Step 4 — Monthly Retention Aggregation

```sql
date_trunc('month', order_date)
```

Groups retained customers by month.

---

# Concepts Used

* Common Table Expressions (CTEs)
* Window Functions
* `LAG()`
* Date Arithmetic
* Cohort Analysis
* Retention Analytics
* Conditional Aggregation

---

# Key Learning

Initially, the problem was explored using:

* Manual row comparisons
* Self joins
* Derived table joins

Later, the solution was optimized using window functions, which provide a cleaner and more scalable approach for sequential event analysis.

This project highlights why window functions are often preferred over self joins for timeline-based analytics.

---

# Expected Output

| Month      | Retained Customers |
| ---------- | ------------------ |
| 2020-02-01 | 3                  |
| 2020-03-01 | 1                  |

---

# Future Improvements

Possible extensions:

* Rolling retention analysis
* Cohort retention percentages
* Customer lifetime value (CLV)
* Repeat purchase frequency
* Revenue retention tracking
* Monthly cohort visualization

---

# Author

Pavan Kumar
SQL | Data Analytics | Window Functions | Retention Analysis 🚀
