WITH daily_events_website AS (
    SELECT *
    FROM {{ ref('int_daily_events_website') }}
)

SELECT
    reference_date
    , total_sessions
    , total_sessions_with_page_view
    , total_sessions_with_add_to_cart
    , total_sessions_with_checkout

FROM daily_events_website