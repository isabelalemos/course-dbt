WITH events AS (
    SELECT * FROM {{ ref('stg_postgres__events') }}
)

SELECT
    user_guid
    , session_guid
    , SUM(CASE WHEN event_type = 'page_view' THEN 1 ELSE 0 END) AS total_page_views
    , SUM(CASE WHEN event_type = 'add_to_cart' THEN 1 ELSE 0 END) AS total_add_to_carts
    , SUM(CASE WHEN event_type = 'checkout' THEN 1 ELSE 0 END) AS total_chekouts
    , SUM(CASE WHEN event_type = 'package_shipped' THEN 1 ELSE 0 END) AS total_package_shippeds
    , MIN(created_at) AS first_session_event_at
    , MAX(created_at) AS last_session_event_at
FROM events
GROUP BY 1,2