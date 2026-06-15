-- fact_order_items
CREATE OR REPLACE VIEW olist.fact_order_items AS
SELECT 
    -- Single-column surrogate key for Power BI
    oi.order_id || '-' || oi.order_item_id::text AS order_item_sk,
    
	oi.order_id,
    oi.order_item_id,
    o.order_status,
    c.customer_unique_id,
    oi.product_id,
    oi.seller_id,
    c.customer_zip_code_prefix,
    s.seller_zip_code_prefix,
    o.order_purchase_timestamp::date         AS purchase_date,
    o.order_delivered_customer_date::date    AS delivered_date,
    o.order_estimated_delivery_date::date    AS estimated_delivery_date,
    o.order_purchase_timestamp               AS purchase_timestamp,
    o.order_delivered_customer_date          AS delivered_timestamp,
    oi.price,
    oi.freight_value,
    (oi.price + oi.freight_value)            AS item_total,
    
    -- Derived measures
    (o.order_delivered_customer_date::date - o.order_purchase_timestamp::date) AS delivery_days_actual,
    (o.order_estimated_delivery_date::date - o.order_purchase_timestamp::date) AS delivery_days_estimated,
    (o.order_delivered_customer_date::date - o.order_estimated_delivery_date::date) AS days_late,
    (o.order_delivered_customer_date::date > o.order_estimated_delivery_date::date) AS is_late
FROM order_items oi
JOIN orders o      ON o.order_id = oi.order_id
JOIN customers c   ON c.customer_id = o.customer_id
JOIN sellers s     ON s.seller_id = oi.seller_id;
