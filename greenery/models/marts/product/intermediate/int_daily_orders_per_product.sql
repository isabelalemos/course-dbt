SELECT
    DATE(DATE_TRUNC('DAY', o.created_at)) AS reference_date
    , oi.PRODUCT_GUID
    , COUNT(DISTINCT oi.order_guid) AS total_orders_with_product

FROM {{ ref('stg_postgres__order_items') }} AS oi
LEFT JOIN {{ ref('stg_postgres__orders') }} AS o
    USING(order_guid)
GROUP BY 1,2