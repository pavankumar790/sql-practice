WITH first_visit AS (
    SELECT customer_id, MIN(order_date) AS first_visit_date
    FROM customer_orders
    GROUP BY customer_id
)
SELECT co.order_date,
       SUM(CASE WHEN co.order_date = fv.first_visit_date THEN 1 ELSE 0 END) AS first_visit_flag,
       SUM(CASE WHEN co.order_date != fv.first_visit_date THEN 1 ELSE 0 END) AS repeat_visit_flag
FROM customer_orders co
INNER JOIN first_visit fv ON co.customer_id = fv.customer_id
GROUP BY co.order_date;
