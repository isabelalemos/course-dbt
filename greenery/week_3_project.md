## Part 1. Models
#### What is our overall conversion rate?
62%

```
SELECT
    SUM(total_checkouts)/COUNT(session_guid) AS overall_conversion
FROM dev_db.dbt_isabelalemoslivecom.fact_user_conversion
```

#### What is our conversion rate by product?

| PRODUCT_NAME |	PRODUCT_CONVERSION |
| ------------ | --------------------- |
| String of pearls |	0.61 |
| Arrow Head |	0.56 |
| Pilea Peperomioides |	0.47 |
| Philodendron |	0.48 |
| Rubber Plant |	0.52 |
| Money Tree |	0.46 |
| Aloe Vera |	0.49 |
| Angel Wings Begonia |	0.39 |
| Birds Nest Fern |	0.42 |
| Pink Anthurium |	0.42 |
| Pothos |	0.34 |
| Alocasia Polly |	0.41 |
| Calathea Makoyana |	0.51 |
| Snake Plant |	0.4 |
| Monstera |	0.51 |
| ZZ Plant |	0.54 |
| Devil's Ivy |	0.49 |
| Ponytail Palm |	0.4 |
| Ficus |	0.43 |
| Spider Plant |	0.47 |
| Bamboo |	0.54 |
| Fiddle Leaf Fig |	0.5 |
| Bird of Paradise |	0.45 |
| Peace Lily |	0.41 |
| Jade Plant |	0.48 |
| Boston Fern |	0.41 |
| Cactus |	0.55 |
| Orchid |	0.45 |
| Dragon Tree |	0.47 |
| Majesty Palm |	0.49 |

```
SELECT
    product_name
    , ROUND(SUM(total_orders_with_product)/SUM(total_sessions_with_pageviews),2) AS product_conversion
FROM dev_db.dbt_isabelalemoslivecom.fact_product_conversion
GROUP BY 1
```

## Part 5. DAG improvements


## Part 6. dbt snapshots
#### Which products had their inventory change from week 2 to week 3?
| NAME	|  PREVIOUS_INVENTORY	|  NEW_INVENTORY | 
| ----- | --------------------- | -------------- |
| Monstera| 64	| 50	|
| Pothos | 20 | 0	|
| String of pearls	| 10	| 0	|
| Bamboo	| 56	| 44	|
| ZZ Plant	| 89	| 53	|
| Philodendron	| 25	| 15	|

```
SELECT
name
, inventory AS previous_inventory
, LEAD(inventory) OVER (PARTITION BY product_id ORDER  BY dbt_updated_at) AS new_inventory
FROM dev_db.dbt_isabelalemoslivecom.inventory_snapshot
QUALIFY DATE(dbt_valid_to) = DATE('2023-04-29') -- latest snapshot date
``` 



