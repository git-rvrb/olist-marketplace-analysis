-- dim_date
CREATE OR REPLACE VIEW olist.dim_date AS 
WITH dates AS (
SELECT generate_series(
	'2016-01-01'::date,
	'2018-12-31'::date,
INTERVAL '1 day')::date AS date_key
)
SELECT
	date_key,
	EXTRACT(YEAR FROM date_key)::int AS year,
	EXTRACT(MONTH FROM date_key)::int AS month,
	EXTRACT(DAY FROM date_key)::int AS day,
	EXTRACT(QUARTER FROM date_key)::int AS quarter,
	EXTRACT(WEEK FROM date_key)::int AS week_of_year,
	EXTRACT(ISODOW FROM date_key)::int AS day_of_week,
	EXTRACT(ISODOW FROM date_key) >=6 AS is_weekend,
	TO_CHAR(date_key, '"Q"Q YYYY') AS quarter_label,
	TO_CHAR(date_key, 'FMMonth') AS month_name,
	TO_CHAR(date_key, 'Mon') AS month_short,
	TO_CHAR(date_key, 'YYYY-MM') AS year_month,
	TO_CHAR(date_key, 'FMDay') AS day_name
FROM dates;
