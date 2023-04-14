WITH source AS (
    SELECT *
    FROM {{ source('postgres','order_items') }}
)

, renamed_recast AS (
    SELECT
        order_id AS order_guid
        , product_id AS product_guid
        , CAST(quantity AS INT) AS quantity
    FROM source
)

SELECT *
FROM renamed_recast