SELECT 
    u.user_guid
    , CONCAT(u.first_name, ' ', u.last_name) AS customer_name
    , u.email
    , u.phone_number
    , u.created_at
    , u.address_guid
    , a.address
    , a.zipcode
    , a.state
    , a.country
FROM {{ ref('stg_postgres__users') }} AS u
LEFT JOIN {{ ref('stg_postgres__addresses') }} AS a
    USING(address_guid)