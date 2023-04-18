## Questions from W1
#### How many users do we have?
130 users

SELECT COUNT(DISTINCT user_guid) AS total_users
FROM dev_db.dbt_isabelalemoslivecom.stg_postgres__users;


#### On average, how many orders do we receive per hour?
7.5 orders per hour

WITH orders_per_hour AS (
    SELECT
        DATE_TRUNC(HOUR, created_at) AS hour_of_the_day
        , COUNT(DISTINCT order_guid) AS total_orders
    FROM dev_db.dbt_isabelalemoslivecom.stg_postgres__orders
    GROUP BY 1
)

SELECT AVG(total_orders)
FROM orders_per_hour ;

#### On average, how long does an order take from being placed to being delivered?
3.9 days

SELECT AVG(DATEDIFF("minute", created_at, delivered_at))/(60*24) AS days_to_deliver
FROM dev_db.dbt_isabelalemoslivecom.stg_postgres__orders
WHERE delivered_at IS NOT NULL --filtering only delivered orders
;

#### How many users have only made one purchase? Two purchases? Three+ purchases?
#### Note: you should consider a purchase to be a single order. In other words, if a user places one order for 3 products, they are considered to have made 1 purchase.

WITH orders_per_user AS (
    SELECT
        user_guid
        , CAST(COUNT(DISTINCT order_guid) AS STRING) AS total_orders
    FROM dev_db.dbt_isabelalemoslivecom.stg_postgres__orders
    GROUP BY 1
)

SELECT 
    total_orders
    , COUNT(user_guid) AS count_users
FROM orders_per_user
GROUP BY 1
ORDER BY 1
;

#### On average, how many unique sessions do we have per hour?
On average, 16.2 sessions

WITH sessions_per_hour AS (
SELECT
    DATE_TRUNC(HOUR, created_at) AS hour_of_the_day
    , COUNT(DISTINCT session_guid) AS total_sessions
FROM dev_db.dbt_isabelalemoslivecom.stg_postgres__events
GROUP BY 1
)

SELECT AVG(total_sessions) AS avg_sessions_per_hour
FROM sessions_per_hour
;