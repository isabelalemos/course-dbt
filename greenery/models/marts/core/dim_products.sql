SELECT
    product_guid
    , product_name
FROM {{ ref('stg_postgres__products') }}