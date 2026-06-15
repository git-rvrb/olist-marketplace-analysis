
--COHORT & RETENTION ANALYSIS

WITH cohort AS (
SELECT 
	customer_unique_id,
	DATE_TRUNC('month', MIN(order_purchase_timestamp)) AS cohort_month
FROM customers c 
JOIN orders o
	ON c.customer_id = o.customer_id
	WHERE order_status = 'delivered'
GROUP BY customer_unique_id
),
	order_with_cohort AS (
SELECT
	o.order_id,
	c.customer_unique_id,
	ch.cohort_month,
	DATE_TRUNC('month', order_purchase_timestamp) AS order_month
FROM orders o
JOIN customers c
	ON o.customer_id = c.customer_id
JOIN cohort ch
	ON c.customer_unique_id = ch.customer_unique_id
WHERE o.order_status = 'delivered'
),
	months_since_cohort AS (
SELECT *,
	EXTRACT (YEAR FROM AGE(order_month, cohort_month)) * 12 +
	EXTRACT (MONTH FROM AGE(order_month, cohort_month)) AS months_between
FROM order_with_cohort
),
cohort_counts AS (
    SELECT 
        cohort_month,
        months_between,
        COUNT(DISTINCT customer_unique_id) AS n_users
FROM months_since_cohort
WHERE cohort_month >= '2017-01-01'
GROUP BY cohort_month, months_between
)
SELECT 
    cohort_month,
    months_between,
    n_users,
    MAX(n_users) OVER (PARTITION BY cohort_month) AS cohort_size,
    ROUND(100.0 * n_users / MAX(n_users) OVER (PARTITION BY cohort_month), 2) AS retention_pct
FROM cohort_counts
ORDER BY cohort_month, months_between;



--what this script does: 

-- Step 1: For each unique customer, find their first purchase month
-- Step 2: Join that back to orders so every order knows its customer's cohort
-- Step 3: Compute months between cohort month and order month
-- Step 4: Count distinct customers per (cohort, months_since_cohort)


























