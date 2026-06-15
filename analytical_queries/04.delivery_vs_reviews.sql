
--DELIVERY PERFORMANCE

WITH delivery_base AS (
SELECT 
	(o.order_delivered_customer_date::date - o.order_estimated_delivery_date::date) AS days_late,
	r.review_score
FROM orders o
JOIN order_reviews r
	ON o.order_id = r.order_id
WHERE o.order_status = 'delivered' AND o.order_delivered_customer_date IS NOT NULL
),
	bucketed AS (
SELECT *,
	CASE WHEN days_late <= 0 THEN '01. on time'
		 WHEN days_late BETWEEN 1 AND 3 THEN '02. late 1-3 days'
		 WHEN days_late BETWEEN 4 AND 7 THEN '03. late 4-7 days'
		 WHEN days_late >= 8 THEN '04. late 8+ days'
	END AS delivery_status
FROM delivery_base
)
SELECT 
    delivery_status,
    COUNT(*) AS n_orders,
    ROUND(100.0 * COUNT(*) / SUM(COUNT(*)) OVER (), 1) AS pct_of_total,
    ROUND(AVG(review_score)::numeric, 2) AS avg_score,
    ROUND(100.0 * COUNT(*) FILTER (WHERE review_score = 1) / COUNT(*), 1) AS pct_1star,
    ROUND(100.0 * COUNT(*) FILTER (WHERE review_score = 5) / COUNT(*), 1) AS pct_5star,
    ROUND(100.0 * COUNT(*) FILTER (WHERE review_score <= 2) / COUNT(*), 1) AS pct_bad_review
FROM bucketed
GROUP BY delivery_status
ORDER BY delivery_status












