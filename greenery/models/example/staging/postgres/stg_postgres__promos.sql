WITH source AS (
    SELECT *
    FROM {{ source('postgres','promos') }}
)

, renamed_recast AS (
    SELECT
        promo_id AS promo_type
        , discount
        , status AS promo_status
    FROM source
)

SELECT *
FROM renamed_recast