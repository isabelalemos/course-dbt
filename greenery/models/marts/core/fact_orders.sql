SELECT 
    o.order_guid
    , o.user_guid
    , o.promo_type
    , COALESCE(p.discount,0) AS discount
    , o.created_at
    , o.order_cost
    , o.shipping_cost
    , o.order_total
    , o.tracking_guid
    , o.shipping_service
    , o.order_status
    , o.estimated_delivery_at
    , o.delivered_at
    , CASE
        WHEN o.estimated_delivery_at < o.delivered_at THEN TRUE
        WHEN o.estimated_delivery_at > o.delivered_at THEN FALSE
        ELSE NULL END AS was_delivery_late
    , a.state
    , SUM(oi.quantity) AS total_items
FROM {{ ref('stg_postgres__orders') }} AS o
LEFT JOIN {{ ref('stg_postgres__promos') }} AS p
    USING(promo_type)
LEFT JOIN {{ ref('stg_postgres__order_items') }} AS oi
    USING(order_guid)
LEFT JOIN {{ ref('stg_postgres__addresses') }} AS a
    USING(address_guid)
GROUP BY 1,2,3,4,5,6,7,8,9,10,11,12,13,14,15