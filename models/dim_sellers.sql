-- dim_sellers
CREATE OR REPLACE VIEW olist.dim_seller AS
SELECT 
	seller_id,
	seller_zip_code_prefix AS zip_code_prefix,
	seller_city AS city,
	seller_state AS state
FROM sellers


-- sanity checks
SELECT COUNT(*) FROM olist.dim_seller; 

SELECT seller_id, COUNT(*) FROM olist.dim_seller
GROUP BY seller_id HAVING COUNT(*) > 1;
