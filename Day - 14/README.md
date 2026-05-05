# Recursive CTE for Expanding Date Ranges and Yearly Sales Aggregation

## 📌 Problem

Given a sales table with:

* product_id
* period_start
* period_end
* average_daily_sales

Each row represents a **date range** with a constant daily sales value.

### Goal:

* Expand each date range into **individual daily rows**
* Extract **year from each date**
* Calculate **total yearly sales per product**

---

## 🧠 Approach

We use a **Recursive Common Table Expression (CTE)** to:

1. Start from `period_start`
2. Increment date by 1 day
3. Stop when `period_start = period_end`

---

## ⚙️ Query

```sql
WITH RECURSIVE a AS (
    -- Base case
    SELECT 
        product_id,
        period_start,
        period_end,
        average_daily_sales
    FROM sales

    UNION ALL

    -- Recursive step
    SELECT 
        product_id,
        period_start + INTERVAL 1 DAY,
        period_end,
        average_daily_sales
    FROM a
    WHERE period_start < period_end
)

SELECT 
    product_id,
    YEAR(period_start) AS year,
    SUM(average_daily_sales) AS total_sales
FROM a
GROUP BY product_id, YEAR(period_start)
ORDER BY product_id, year;
```

---

## 🔁 How It Works

* The base query loads initial rows.
* The recursive query:

  * Takes previous rows
  * Adds 1 day to `period_start`
  * Repeats until `period_start < period_end` is false

Each row is processed **independently**, so no mixing happens between products.

---

## ⚡ Key Concepts

* Recursive CTE behaves like a **loop**
* `UNION ALL` is used to **accumulate results**
* Each row carries its own:

  * product_id
  * period_start
  * period_end

---

## ⚠️ Important Notes

* SQL tables are **unordered**

* Output may look ordered, but always use:

  ```sql
  ORDER BY product_id, period_start
  ```

* Removing the `WHERE` condition may cause:

  * infinite recursion
  * query failure

---

## 🚀 Learning Insight

This pattern converts:

> Range-based data → Row-based data

Useful for:

* Time series analysis
* Calendar expansion
* Interval problems

---

## 💡 Mental Model

Think of it like:

```
for each row:
    while start_date < end_date:
        emit row
        start_date += 1
```

---

## 🧪 Suggested Experiments

* Change condition to `<=`
* Remove `WHERE` clause
* Increase step (`+2 days`)
* Add a step counter column

---

## ✅ Conclusion

Recursive CTE allows us to simulate loops in SQL and transform ranges into detailed row-level data for aggregation and analysis.

---
