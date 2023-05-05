SELECT
    de.reference_date
    , de.product_guid
    , p.product_name
    --, de.total_pageviews
    --, de.total_add_to_cart
    --, do.total_orders_with_product
    , total_sessions_with_page_view
    , total_sessions_with_add_to_cart
    , total_sessions_with_checkout

FROM {{ ref('int_daily_events_per_product') }} AS de
LEFT JOIN {{ ref('stg_postgres__products') }} AS p
    USING(product_guid)
LEFT JOIN {{ ref('int_daily_orders_per_product') }} AS do
    USING(product_guid, reference_date)