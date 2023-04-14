WITH source AS (
    SELECT *
    FROM {{ source('postgres','orders') }}
)

, renamed_recast AS (
    SELECT
        order_id AS order_guid
        , user_id AS user_guid
        , promo_id AS promo_type
        , address_id AS address_guid
        , created_at
        , order_cost
        , shipping_cost
        , order_total
        , tracking_id AS tracking_guid
        , shipping_service
        , estimated_delivery_at
        , delivered_at
        , status AS order_status
    FROM source
)

SELECT *
FROM renamed_recast