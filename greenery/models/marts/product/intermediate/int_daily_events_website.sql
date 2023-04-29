SELECT 
    DATE(DATE_TRUNC('DAY', created_at)) AS reference_date
    , SUM(CASE WHEN event_type = 'page_view' THEN 1 ELSE 0 END) AS total_pageviews
    , SUM(CASE WHEN event_type = 'add_to_cart' THEN 1 ELSE 0 END) AS total_add_to_cart
    , COUNT(DISTINCT (CASE WHEN event_type = 'page_view' THEN session_guid END)) AS total_sessions_with_pageviews
    , COUNT(DISTINCT (CASE WHEN event_type = 'add_to_cart' THEN session_guid END)) AS total_sessions_with_add_to_cart
    , COUNT(DISTINCT (CASE WHEN event_type = 'checkout' THEN session_guid END)) AS total_sessions_with_checkout
    , COUNT(DISTINCT (CASE WHEN event_type = 'page_view' THEN user_guid END)) AS total_users_with_pageviews
    , COUNT(DISTINCT (CASE WHEN event_type = 'add_to_cart' THEN user_guid END)) AS total_users_with_add_to_cart

FROM {{ ref('stg_postgres__events') }}
GROUP BY 1