
--SELLER REVENUE

DROP TABLE IF EXISTS tmp_seller_revenue;

CREATE TEMP TABLE tmp_seller_revenue AS 

WITH seller_rev AS (
SELECT 
	i.seller_id,
	SUM(i.price + i.freight_value) AS revenue
FROM order_items i
JOIN orders o
	ON o.order_id = i.order_id
WHERE o.order_status = 'delivered'
GROUP BY seller_id
),
	ranked AS (
SELECT *
	ROW_NUMBER() OVER (ORDER BY revenue DESC) AS rank,
	100.0 * SUM(revenue) OVER (ORDER BY revenue DESC) / SUM(revenue) OVER () AS cumulative_pct,
	100.0 * revenue / SUM(revenue) OVER () AS pct_of_total,
	NTILE(100) OVER (ORDER BY revenue DESC) AS percentile
FROM seller_rev
ORDER BY rank
) 
SELECT * FROM ranked;

--pareto summary

SELECT 
    'Top 1%'  AS bucket, MAX(cumulative_pct) FILTER (WHERE percentile <= 1)  AS cumulative_revenue_pct 
	FROM tmp_seller_revenue
	UNION ALL SELECT 'Top 5%',  MAX(cumulative_pct) FILTER (WHERE percentile <= 5)  FROM tmp_seller_revenue
	UNION ALL SELECT 'Top 10%', MAX(cumulative_pct) FILTER (WHERE percentile <= 10) FROM tmp_seller_revenue
	UNION ALL SELECT 'Top 20%', MAX(cumulative_pct) FILTER (WHERE percentile <= 20) FROM tmp_seller_revenue
	UNION ALL SELECT 'Top 50%', MAX(cumulative_pct) FILTER (WHERE percentile <= 50) FROM tmp_seller_revenue;


