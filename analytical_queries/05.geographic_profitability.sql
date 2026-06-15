
--GEOGRAPHIC PROFITABILITY

WITH state_summary AS (
SELECT 
	c.customer_state,
	COUNT(DISTINCT o.order_id) AS n_orders, 
	SUM(i.price) AS GMV,
	SUM(i.freight_value) AS freight,
	SUM(i.price) + SUM(i.freight_value) AS total_order_value,
	ROUND(SUM(i.price + i.freight_value) / COUNT(DISTINCT o.order_id), 2) AS avg_order_value,
	ROUND (100.0 * SUM(i.freight_value) / SUM(i.price), 2) AS freight_pct_of_gmv,
	ROUND(SUM(i.freight_value) / COUNT(DISTINCT o.order_id), 2) AS avg_freight_per_order
FROM customers c
JOIN orders o
	ON o.customer_id = c.customer_id
JOIN order_items i
	ON o.order_id = i.order_id
WHERE o.order_status = 'delivered'
GROUP BY c.customer_state
)
SELECT *
from state_summary
ORDER BY gmv DESC





