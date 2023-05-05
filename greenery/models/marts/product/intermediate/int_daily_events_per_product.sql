SELECT 
    DATE(DATE_TRUNC('DAY', created_at)) AS reference_date
    , product_guid
    , SUM(CASE WHEN event_type = 'page_view' THEN 1 ELSE 0 END) AS total_page_views
    , SUM(CASE WHEN event_type = 'add_to_cart' THEN 1 ELSE 0 END) AS total_add_to_carts
    --, COUNT(DISTINCT (CASE WHEN event_type = 'page_view' THEN session_guid END)) AS total_sessions_with_pageviews
    --, COUNT(DISTINCT (CASE WHEN event_type = 'add_to_cart' THEN session_guid END)) AS total_sessions_with_add_to_cart
    {{ count_sessions_per_event_type() }}
    , COUNT(DISTINCT (CASE WHEN event_type = 'page_view' THEN user_guid END)) AS total_users_with_page_view
    , COUNT(DISTINCT (CASE WHEN event_type = 'add_to_cart' THEN user_guid END)) AS total_users_with_add_to_cart

FROM {{ ref('stg_postgres__events') }}
WHERE product_guid IS NOT NULL
GROUP BY 1,2