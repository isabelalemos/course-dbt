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

#### Why might certain products be converting at higher/lower rates than others?
Without exploring the available data or thinking exactly at which data we have, here are some hypothesis:
- price and seasonal discounts/offers
- marketing campaigns, products that work as "showcase" bringing customers to website and not really converting and other way around
- popularity, market trends, seasonal events/periods
- product related reasons (information level in website page, AB tests, etc)

## Part 5. DAG improvements
- Using dbt package dbt_utils, the macro input happens automatically collecting all possible values existing in a column, without the need of manually adding them
- Using a macro for aggregating the event type, the same aggregation can be repeated multiple times. Another macro that does not only count the events, but instead the distinct values of session or user (in which this input can be passed as a macro argument) may also be very useful, as this aggregation is frequently needed in the models designed so far
- Using a macro for role permission, I make sure all the tables and schema within the project have the access grant applied right after the queries run, without the need of setting it individually per model by using the post hook to trigger that macro

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