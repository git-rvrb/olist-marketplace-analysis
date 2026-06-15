-- dim_product
CREATE OR REPLACE VIEW olist.dim_product AS
SELECT 
    p.product_id,
    p.product_category_name AS category_pt,
INITCAP(REPLACE(
    COALESCE(
        pc.product_category_name_english,
        CASE p.product_category_name
            WHEN 'portateis_cozinha_e_preparadores_de_alimentos' THEN 'portable kitchen and food preparers'
            WHEN 'pc_gamer' THEN 'pc gamer'
        END,
        '(unknown)'
    ),
    '_', ' '
)) AS category_en,
    p.product_weight_g AS weight_g,
    p.product_length_cm AS length_cm,
    p.product_height_cm AS height_cm,
    p.product_width_cm AS width_cm,
    (p.product_length_cm * p.product_height_cm * p.product_width_cm) AS volume_cm3,
    p.product_photos_qty AS photos_qty,
    p.product_name_lenght AS name_length,
    p.product_description_lenght AS description_length
FROM products p
LEFT JOIN product_category_translation pc
    ON pc.product_category_name = p.product_category_name;

