## Part 1. Models
#### What is our overall conversion rate?

#### What is our conversion rate by product?

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



