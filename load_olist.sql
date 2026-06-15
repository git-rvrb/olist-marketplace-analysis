\set csv_dir 'C:/Users/Aran/Documents/DE/Olist_EDA/archive'

DROP SCHEMA IF EXISTS olist CASCADE;
CREATE SCHEMA olist;
SET search_path TO olist;

CREATE TABLE customers (
    customer_id              TEXT,
    customer_unique_id       TEXT,
    customer_zip_code_prefix TEXT,
    customer_city            TEXT,
    customer_state           TEXT
);

CREATE TABLE geolocation (
    geolocation_zip_code_prefix TEXT,
    geolocation_lat             NUMERIC(10, 7),
    geolocation_lng             NUMERIC(10, 7),
    geolocation_city            TEXT,
    geolocation_state           TEXT
);

CREATE TABLE orders (
    order_id                      TEXT,
    customer_id                   TEXT,
    order_status                  TEXT,
    order_purchase_timestamp      TIMESTAMP,
    order_approved_at             TIMESTAMP,
    order_delivered_carrier_date  TIMESTAMP,
    order_delivered_customer_date TIMESTAMP,
    order_estimated_delivery_date TIMESTAMP
);

CREATE TABLE order_items (
    order_id            TEXT,
    order_item_id       INT,
    product_id          TEXT,
    seller_id           TEXT,
    shipping_limit_date TIMESTAMP,
    price               NUMERIC(10, 2),
    freight_value       NUMERIC(10, 2)
);

CREATE TABLE order_payments (
    order_id             TEXT,
    payment_sequential   INT,
    payment_type         TEXT,
    payment_installments INT,
    payment_value        NUMERIC(10, 2)
);

CREATE TABLE order_reviews (
    review_id               TEXT,
    order_id                TEXT,
    review_score            INT,
    review_comment_title    TEXT,
    review_comment_message  TEXT,
    review_creation_date    TIMESTAMP,
    review_answer_timestamp TIMESTAMP
);

CREATE TABLE products (
    product_id                 TEXT,
    product_category_name      TEXT,
    product_name_lenght        INT,
    product_description_lenght INT,
    product_photos_qty         INT,
    product_weight_g           INT,
    product_length_cm          INT,
    product_height_cm          INT,
    product_width_cm           INT
);

CREATE TABLE sellers (
    seller_id              TEXT,
    seller_zip_code_prefix TEXT,
    seller_city            TEXT,
    seller_state           TEXT
);

CREATE TABLE product_category_translation (
    product_category_name         TEXT,
    product_category_name_english TEXT
);

COPY customers                    FROM :'csv_dir' || '/olist_customers_dataset.csv'           WITH (FORMAT csv, HEADER true);
COPY geolocation                  FROM :'csv_dir' || '/olist_geolocation_dataset.csv'         WITH (FORMAT csv, HEADER true);
COPY orders                       FROM :'csv_dir' || '/olist_orders_dataset.csv'              WITH (FORMAT csv, HEADER true);
COPY order_items                  FROM :'csv_dir' || '/olist_order_items_dataset.csv'         WITH (FORMAT csv, HEADER true);
COPY order_payments               FROM :'csv_dir' || '/olist_order_payments_dataset.csv'      WITH (FORMAT csv, HEADER true);
COPY order_reviews                FROM :'csv_dir' || '/olist_order_reviews_dataset.csv'       WITH (FORMAT csv, HEADER true);
COPY products                     FROM :'csv_dir' || '/olist_products_dataset.csv'            WITH (FORMAT csv, HEADER true);
COPY sellers                      FROM :'csv_dir' || '/olist_sellers_dataset.csv'             WITH (FORMAT csv, HEADER true);
COPY product_category_translation FROM :'csv_dir' || '/product_category_name_translation.csv' WITH (FORMAT csv, HEADER true);

SELECT 'customers'                    AS table_name, COUNT(*) AS row_count FROM customers
UNION ALL SELECT 'geolocation',                  COUNT(*) FROM geolocation
UNION ALL SELECT 'orders',                       COUNT(*) FROM orders
UNION ALL SELECT 'order_items',                  COUNT(*) FROM order_items
UNION ALL SELECT 'order_payments',               COUNT(*) FROM order_payments
UNION ALL SELECT 'order_reviews',                COUNT(*) FROM order_reviews
UNION ALL SELECT 'products',                     COUNT(*) FROM products
UNION ALL SELECT 'sellers',                      COUNT(*) FROM sellers
UNION ALL SELECT 'product_category_translation', COUNT(*) FROM product_category_translation;
