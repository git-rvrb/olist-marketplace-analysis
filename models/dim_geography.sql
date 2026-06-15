-- dim_geography
DROP VIEW IF EXISTS olist.dim_geography CASCADE;

CREATE VIEW olist.dim_geography AS
WITH base_geo AS (
SELECT 
    geolocation_zip_code_prefix AS zip_code_prefix,
    MODE() WITHIN GROUP (ORDER BY geolocation_city)  AS city,
    MODE() WITHIN GROUP (ORDER BY geolocation_state) AS state,
    AVG(geolocation_lat)::numeric  AS latitude,
    AVG(geolocation_lng)::numeric AS longitude
FROM geolocation
GROUP BY geolocation_zip_code_prefix
),
orphan_customer_zips AS (
    -- Zips referenced by customers but missing from geolocation
SELECT DISTINCT 
    c.customer_zip_code_prefix AS zip_code_prefix,
    c.customer_city            AS city,
    c.customer_state           AS state,
    NULL::numeric              AS latitude,
    NULL::numeric              AS longitude
FROM customers c
LEFT JOIN base_geo bg 
	ON bg.zip_code_prefix = c.customer_zip_code_prefix
WHERE bg.zip_code_prefix IS NULL
),
orphan_seller_zips AS (
    -- Zips referenced by sellers but missing from geolocation
SELECT DISTINCT 
    s.seller_zip_code_prefix AS zip_code_prefix,
    s.seller_city            AS city,
    s.seller_state           AS state,
    NULL::numeric            AS latitude,
    NULL::numeric            AS longitude
FROM olist.sellers s
LEFT JOIN base_geo bg 
	ON bg.zip_code_prefix = s.seller_zip_code_prefix
WHERE bg.zip_code_prefix IS NULL
),
unioned AS (
    SELECT * FROM base_geo
    UNION
    SELECT * FROM orphan_customer_zips
    UNION
    SELECT * FROM orphan_seller_zips
),
deduped AS (
SELECT 
    zip_code_prefix,
    MODE() WITHIN GROUP (ORDER BY city)  AS city,
    MODE() WITHIN GROUP (ORDER BY state) AS state,
    AVG(latitude)  AS latitude,
    AVG(longitude) AS longitude
FROM unioned
GROUP BY zip_code_prefix
)
SELECT 
    zip_code_prefix,
    city,
    state,
    latitude,
    longitude,
    CASE
        WHEN state IN ('AC','AP','AM','PA','RO','RR','TO') THEN 'North'
        WHEN state IN ('AL','BA','CE','MA','PB','PE','PI','RN','SE') THEN 'Northeast'
        WHEN state IN ('DF','GO','MS','MT') THEN 'Central-West'
        WHEN state IN ('ES','MG','RJ','SP') THEN 'Southeast'
        WHEN state IN ('PR','RS','SC') THEN 'South'
        ELSE 'UNKNOWN — fix mapping'
    END AS region
FROM deduped;