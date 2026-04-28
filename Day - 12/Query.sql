-- Step 1: Build base dataset with all sellers and their orders
WITH a AS (
    SELECT 
        users.user_id AS sel_id,                -- seller id
        users.favorite_brand,                  -- seller's favorite brand
        
        orders.order_id,
        orders.order_date,
        orders.item_id,
        items.item_brand,                      -- brand of item sold
        orders.buyer_id,
        
        -- total number of sales per seller
        COUNT(order_id) OVER (
            PARTITION BY users.user_id
        ) AS totl_sal,
        
        -- rank orders by date for each seller (1 = first sale, 2 = second sale, etc.)
        ROW_NUMBER() OVER (
            PARTITION BY users.user_id 
            ORDER BY order_date
        ) AS sales_rnk
        
    FROM users

    -- LEFT JOIN to include sellers even if they have no orders
    LEFT JOIN orders 
        ON users.user_id = orders.seller_id

    -- LEFT JOIN to get item brand details
    LEFT JOIN items
        ON orders.item_id = items.item_id
),

-- Step 2: Apply business logic
b AS (
    SELECT 
        a.sel_id,
        
        -- check if 2nd sold item matches favorite brand
        CASE 
            WHEN (a.item_brand = a.favorite_brand) 
                 AND a.sales_rnk = 2 
            THEN 'yes' 
            ELSE 'no' 
        END AS fav_brand,

        -- flag to filter required rows:
        -- include:
        --   1) sellers with < 2 sales
        --   2) only the 2nd sale row for sellers with >= 2 sales
        CASE 
            WHEN totl_sal < 2 OR sales_rnk = 2 
            THEN 1 
            ELSE 0 
        END AS flg 

    FROM a
)

-- Step 3: Final result
SELECT * 
FROM b 
WHERE flg = 1;