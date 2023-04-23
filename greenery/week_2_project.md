## Part 1. Models
#### What is our user repeat rate?
80% is the repeat rate (80% of the users have placed more than 1 order)

```
WITH orders_per_user AS (
    SELECT
        user_guid
        , CAST(COUNT(DISTINCT order_guid) AS STRING) AS total_orders
    FROM dev_db.dbt_isabelalemoslivecom.stg_postgres__orders
    GROUP BY 1
)

, users_per_number_of_orders AS (
    SELECT 
        total_orders
        , COUNT(user_guid) AS count_users
    FROM orders_per_user
    GROUP BY 1
    ORDER BY 1
)

SELECT  SUM(CASE WHEN total_orders > 1 THEN count_users ELSE 0 END)/SUM(count_users) AS repeat_rate
FROM users_per_number_of_orders
```

#### What are good indicators of a user who will likely purchase again? What about indicators of users who are likely NOT to purchase again? If you had more data, what features would you want to look into to answer this question?

Overall trend for repeat rate:
- how long does a user usually takes to place the next orders? This is important to understand the expected interval between purchases for users that just recently placed an order, allows differentiation between a user that is likely to still be active x churned ones

Experience after purchase:
- influence of delivery times
- influence of delivery times comparing to estimated delivery times

Amount spent and order details:
- influence of usage of promo codes
- product types (are users who bought certain products more likely to buy again?)
- amount of products (are users placing an order with more/less items more likely to buy again?)
- total cost of the order (are users placing a higher/lower cost order more likely to buy again?)

Behaviour before order:
- influence of events done by a user (are users more/less indecisive, adding multiple items to the cart, most likely to return?)

User's attributes:
- demographics information

If more data is available, many other analysis could eventually be performed. As examples in each one of the buckets above mentioned:
- experience after purchase: NPS/product feedback, contact rate (if customer reached out to support)
- order details: products or type of items that are most likely to be ordered regularly
- before order: customer segment, marketing campaign, time through funnel since first website visit to conversion
- user's profile: age, demographic information, device, persona analysis to define returning customers


#### Explain the product mart models you added. Why did you organize the models in the way you did?


## Part 2. Tests

#### ?



## Part 3. dbt snapshots
4 products changed quantities: Philodendron, Pothos, String of pearls and Monstera

```
SELECT *
, LEAD(inventory) OVER (PARTITION BY product_id ORDER  BY dbt_updated_at) AS new_inventory
FROM dev_db.dbt_isabelalemoslivecom.inventory_snapshot
QUALIFY dbt_valid_to IS NOT NULL
;
```
