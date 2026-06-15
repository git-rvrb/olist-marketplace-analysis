-- dim_customer
CREATE OR REPLACE VIEW olist.dim_customer AS
WITH all_customer_orders AS (
SELECT 
	c.customer_unique_id,
    c.customer_zip_code_prefix,
    c.customer_city,
    c.customer_state,
    o.order_purchase_timestamp,
    ROW_NUMBER() OVER (PARTITION BY c.customer_unique_id ORDER BY o.order_purchase_timestamp DESC) AS row_num
FROM customers c
JOIN orders o 
	ON o.customer_id = c.customer_id
),
	delivered_aggregates AS (
SELECT 
	c.customer_unique_id,
    COUNT(*) AS total_orders,
    MIN(o.order_purchase_timestamp) AS first_purchase_date,
    MAX(o.order_purchase_timestamp) AS last_purchase_date
FROM customers c
JOIN orders o
	ON o.customer_id = c.customer_id
WHERE o.order_status = 'delivered'
GROUP BY c.customer_unique_id
)
SELECT 
    a.customer_unique_id,
    a.customer_zip_code_prefix AS zip_code_prefix,
    a.customer_city AS city,
    a.customer_state AS state,
    d.first_purchase_date,
    d.last_purchase_date,
    d.total_orders
FROM all_customer_orders a
LEFT JOIN delivered_aggregates d ON d.customer_unique_id = a.customer_unique_id
WHERE a.row_num = 1;
