
--RFM segmentation

CREATE OR REPLACE VIEW olist.vw_rfm_segments AS
WITH summary AS (
SELECT
	customer_unique_id,
	MAX(order_purchase_timestamp) AS last_purchase_date,
	COUNT (DISTINCT o.order_id) AS n_orders,
	SUM(price + freight_value) AS total_spend
FROM orders o
JOIN customers c
	ON o.customer_id = c.customer_id
JOIN order_items i
	ON o.order_id = i.order_id
WHERE o.order_status = 'delivered'
GROUP BY customer_unique_id
),
	RFM AS (
SELECT *,
	NTILE(5) OVER (ORDER BY last_purchase_date) AS r_score,
	NTILE(5) OVER (ORDER BY total_spend) AS m_score,
	CASE
		WHEN n_orders = 1 THEN 1
		WHEN n_orders = 2 THEN 3
		WHEN n_orders >= 3 THEN 5
	END AS f_score
FROM summary
),
	segmented AS (
SELECT *,
CASE
    WHEN f_score = 5 AND r_score >= 4 THEN 'Loyal — Active'
    WHEN f_score = 5 AND r_score <= 3 THEN 'Loyal — Lapsing'
    WHEN f_score = 3 AND r_score >= 4 THEN 'Repeat — Active'
    WHEN f_score = 3 AND r_score <= 3 THEN 'Repeat — Lapsing'
    WHEN f_score = 1 AND r_score = 5 AND m_score >= 4 THEN 'New — High Value'
    WHEN f_score = 1 AND r_score = 5 AND m_score <= 3 THEN 'New — Low Value'
    WHEN f_score = 1 AND r_score >= 3 AND m_score >= 4 THEN 'Promising'
    WHEN f_score = 1 AND r_score >= 3 AND m_score <= 3 THEN 'Hibernating'
    WHEN f_score = 1 AND r_score <= 2 AND m_score >= 4 THEN 'Lapsed — High Value'
    WHEN f_score = 1 AND r_score <= 2 AND m_score <= 3 THEN 'Lapsed — Low Value'
END AS segment
FROM RFM
)
SELECT * FROM segmented;


--segment breakdown
SELECT 
    segment,
    COUNT(*) AS n_customers,
    ROUND(100.0 * COUNT(*) / SUM(COUNT(*)) OVER (), 1) AS pct,
    ROUND(AVG(total_spend), 2) AS avg_spend,
    ROUND(SUM(total_spend), 2) AS total_revenue,
    ROUND(AVG(n_orders), 2) AS avg_orders
FROM olist.vw_rfm_segments
GROUP BY segment
ORDER BY total_revenue DESC;


--what this script does: 

-- Step 1: For each customer (customer_unique_id), aggregate to a summary table with:
--         - last_order_date
--         - n_orders (count of distinct delivered orders)
--         - total_spend

-- Step 2: For each customer, compute:
--         - r_score - (NTILE(5) on recency (ordered so most recent = 5))
--         - f_score - (n_orders (used custom CASE statement as most customers have just 1 order))
--         - m_score - (NTILE(5) on total_spend (most spend = 5))
-- Step 3: classify into named segments

-- Temp view created to view outputs











