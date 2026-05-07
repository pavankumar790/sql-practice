-- Step 1:
-- Take the orders table twice.
-- We are comparing products WITHIN the same order.

select
    p1.name as product_1,
    p2.name as product_2,
    
    -- Count how many times this pair appeared together
    count(*) as purchase_frequency

from orders o1

-- Self join:
-- Match rows from the same order
join orders o2
    on o1.order_id = o2.order_id

    -- Important condition:
    -- Prevents:
    -- A-A
    -- B-B
    -- A-B and B-A duplicates
    and o1.product_id < o2.product_id

-- Join products table to get product names for first product
join products p1
    on o1.product_id = p1.id

-- Join products table again for second product
join products p2
    on o2.product_id = p2.id

-- Group by each unique pair
group by
    p1.name,
    p2.name

-- Highest frequency first
order by purchase_frequency desc;