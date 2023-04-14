WITH source AS (
    SELECT *
    FROM {{ source('postgres','addresses') }}
)

, renamed_recast AS (
    SELECT
        address_id AS address_guid
        , address
        , lpad(zipcode,5,0) AS zipcode
        , state
        , country
    FROM source
)

SELECT *
FROM renamed_recast