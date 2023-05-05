SELECT 
    DATE(DATE_TRUNC('DAY', created_at)) AS reference_date
    , COUNT(DISTINCT session_guid) AS total_sessions
    --, COUNT(DISTINCT (CASE WHEN event_type = 'page_view' THEN session_guid END)) AS total_sessions_with_page_view
    --, COUNT(DISTINCT (CASE WHEN event_type = 'add_to_cart' THEN session_guid END)) AS total_sessions_with_add_to_cart
    --, COUNT(DISTINCT (CASE WHEN event_type = 'checkout' THEN session_guid END)) AS total_sessions_with_checkout
    {{ count_sessions_per_event_type() }}
    , COUNT(DISTINCT user_guid) AS total_users
    , COUNT(DISTINCT (CASE WHEN event_type = 'page_view' THEN user_guid END)) AS total_users_with_page_view
    , COUNT(DISTINCT (CASE WHEN event_type = 'add_to_cart' THEN user_guid END)) AS total_users_with_add_to_cart
    , COUNT(DISTINCT (CASE WHEN event_type = 'checkout' THEN user_guid END)) AS total_users_with_checkout

FROM {{ ref('stg_postgres__events') }}
GROUP BY 1