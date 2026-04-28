MARKET ANALYSIS - SQL PROBLEM

## Problem Statement:

Write an SQL query to find for each seller whether the brand of the second item (by order date) they sold is their favorite brand.

If a seller sold less than two items, the result should be 'no'.

---

## Approach:

This solution uses window functions and a step-by-step transformation.

1. Join all required tables:

   * users (to get favorite brand)
   * orders (to get seller transactions)
   * items (to get item brand)

2. Use window functions:

   * COUNT() OVER (PARTITION BY seller) to get total sales per seller
   * ROW_NUMBER() OVER (PARTITION BY seller ORDER BY order_date) to rank orders

3. Apply logic:

   * If seller has less than 2 orders -> output 'no'
   * If seller has 2 or more orders:
     check only the second order (rank = 2)
     compare item_brand with favorite_brand

4. Filter required rows:

   * Keep only:
     a) sellers with less than 2 orders
     b) second order row for sellers with 2+ orders

---

## SQL Solution:

WITH a AS (
SELECT
users.user_id AS sel_id,
users.favorite_brand,
orders.order_id,
orders.order_date,
orders.item_id,
items.item_brand,
orders.buyer_id,

```
    COUNT(order_id) OVER (
        PARTITION BY users.user_id
    ) AS totl_sal,

    ROW_NUMBER() OVER (
        PARTITION BY users.user_id 
        ORDER BY order_date
    ) AS sales_rnk

FROM users

LEFT JOIN orders 
    ON users.user_id = orders.seller_id

LEFT JOIN items
    ON orders.item_id = items.item_id
```

),

b AS (
SELECT
sel_id,

```
    CASE 
        WHEN item_brand = favorite_brand 
             AND sales_rnk = 2 
        THEN 'yes'
        ELSE 'no'
    END AS fav_brand,

    CASE 
        WHEN totl_sal < 2 OR sales_rnk = 2 
        THEN 1 
        ELSE 0 
    END AS flg

FROM a
```

)

SELECT sel_id, fav_brand
FROM b
WHERE flg = 1;

---

## Key Concepts Used:

* Window Functions (COUNT, ROW_NUMBER)
* Partitioning data by seller
* Ranking rows within each seller group
* Conditional logic using CASE
* LEFT JOIN to include sellers with no or few orders

---

## Edge Cases Handled:

* Sellers with no orders -> output 'no'
* Sellers with only one order -> output 'no'
* Sellers with multiple orders -> only second order is evaluated

---

## Possible Optimization:

Instead of generating all rows and filtering later, we can directly select the second order using JOIN conditions.
This reduces computation and improves readability.

---

## Learning Outcome:

* Learned how to use ROW_NUMBER to identify nth records
* Understood how to handle missing data using LEFT JOIN
* Explored filtering strategies using flags vs join conditions
* Improved ability to translate business logic into SQL

---
