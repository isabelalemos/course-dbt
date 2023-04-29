SELECT
    s.user_guid
    , u.first_name || ' ' || u.last_name AS user_name
    , u.email AS user_email
    , s.session_guid
    , s.first_session_event_at AS session_started_at
    , s.total_page_views
    , s.total_add_to_carts
    , s.total_checkouts
    , s.total_package_shippeds
    , s.order_guid

FROM {{ ref('int_user_sessions_agg') }} AS s
LEFT JOIN {{ ref('stg_postgres__users') }} AS u
    USING(user_guid)