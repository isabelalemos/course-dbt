WITH source AS (
    SELECT *
    FROM {{ source('postgres','products') }}
)

, renamed_recast AS (
    SELECT
        product_id AS product_guid
        , name AS product_name
        , price
        , CAST(inventory AS INT) AS inventory
    FROM source
)

SELECT *
FROM renamed_recast