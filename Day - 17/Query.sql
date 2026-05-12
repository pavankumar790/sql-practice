-- Step 1:
-- Get previous order date for each customer
-- using LAG window function

WITH a AS (

    SELECT
        *,
        
        LAG(order_date) OVER (
            PARTITION BY cust_id
            ORDER BY order_date
        ) AS prev_date

    FROM transactions
),

-- Step 2:
-- Calculate gap between current order
-- and previous order
-- Also create retention flag

b AS (

    SELECT
        *,
        
        -- Difference in days between orders
        order_date - prev_date AS gap,
        
        -- Extract month for cohort grouping
        DATE_TRUNC('month', order_date) AS m,
        
        -- Retention condition:
        -- Customer reordered within 20–60 days
        CASE
            WHEN order_date - prev_date > 20
             AND order_date - prev_date < 60
            THEN 1
            ELSE 0
        END AS retention

    FROM a
)

-- Step 3:
-- Count retained customers by month

SELECT
    m,
    
    COUNT(
        CASE
            WHEN retention = 1
            THEN 1
        END
    ) AS retained_customers

FROM b

GROUP BY m

ORDER BY m;