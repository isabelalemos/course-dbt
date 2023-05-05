## Part 1. dbt snapshots
#### Which products had their inventory change from week 3 to week 4? 

| NAME	|  PREVIOUS_INVENTORY	|  NEW_INVENTORY | 
| ----- | --------------------- | -------------- |
| Monstera	| 50	| 31	|
| Pothos	| 0	| 20	|
| String of pearls	| 0	| 10	|
| Bamboo	| 44	| 23	|
| ZZ Plant	| 53	| 41	|
| Philodendron	| 15	| 30	|

```
SELECT
name
, inventory AS previous_inventory
, LEAD(inventory) OVER (PARTITION BY product_id ORDER  BY dbt_updated_at) AS new_inventory
FROM dev_db.dbt_isabelalemoslivecom.inventory_snapshot
QUALIFY DATE(dbt_valid_to) = DATE('2023-04-29') -- latest snapshot date
```

#### Now that we have 3 weeks of snapshot data, can you use the inventory changes to determine which products had the most fluctuations in inventory? Did we have any items go out of stock in the last 3 weeks?
```
WITH inventory_changes AS (
    SELECT
    name
    , DATE(dbt_valid_to) AS inventory_change_date
    , inventory AS previous_inventory
    , LEAD(inventory) OVER (PARTITION BY product_id ORDER  BY dbt_valid_from) AS new_inventory
    FROM dev_db.dbt_isabelalemoslivecom.inventory_snapshot
    QUALIFY dbt_valid_to IS NOT NULL
)
```

The products which fluctuated the most were Philodendron, Monstera, Pothos and String of Pearls, all of them with 3 changes in total, which means weekly fluctuations.

```
SELECT
name
, count(*) AS inventory_changes
FROM inventory_changes
GROUP BY 1
ORDER BY 2 DESC
```

Pothos and String of pearls went out of stock

```
SELECT
*
FROM inventory_changes
WHERE previous_inventory = 0 OR new_inventory = 0
```


## Part 2. Modeling challenge

#### How are our users moving through the product funnel? Which steps in the funnel have largest drop off points?

```
SELECT
    ROUND(SUM(total_sessions_with_page_view)/SUM(total_sessions),2) AS conversion_session_to_pageview
    , ROUND(SUM(total_sessions_with_add_to_cart)/SUM(total_sessions),2) AS conversion_session_to_add_to_cart
    , ROUND(SUM(total_sessions_with_checkout)/SUM(total_sessions),2) AS conversion_session_to_checkout
FROM dev_db.dbt_isabelalemoslivecom.fact_daily_funnel
```

The biggest drop is between page view and add to cart (17% of sessions), followed by checkout (16% drop), indicating these are the steps where most optimizations could be implemented.

