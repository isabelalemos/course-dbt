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
For all the models I've created, I first idealised how I would like to have the final marts model to reply the questions from the business. In Core, the marts model are still very basic, thus no intermeadiate models were needed. For product, some level of aggregation was needed for reporting the metrics, and also making combinations (joins) of data living in different tables, thus the need of intermediate models.

The final fact table (fact_product_conversion) aims to report the conversion per product on a daily basis. Daily based report are usually granular enough for most questions from the business, specially when they can be easily rolled up to less granular levels, such as week or month. 

To achieve that, 3 information types were needed: count of events, count of orders with each product, product details (just so it could be reported with the product name, which is usually more meaninful than a GUID). The last one could be obtained directly from product model available in staging layer, while the other 2 still needed some tweaks and aggregations to be presented in the way they were needed, therefore they were created in intermediate layer. The events required only reorganising a table from staging, while the orders per product actually required information from 2 staging tables, so also a join was needed in this model.

So overall, marts model point to: staging models, if in correct level, and intermediate models, if data transformations were needed for the required level. Joins are included in this model, as it is a more complex model. Intermediante models point to staging models, but also joins might be included in needed.

## Part 2. Tests

#### What assumptions are you making about each model? (i.e. why are you adding each test?)
I mostly applied tests on the staging layer, as in validating data quality (and not calculations/modeling, as the models are mostly simple so far). On a real life scenario, I would apply more tests in marts models to make sure the conditions I am cleaning data through SQL are all being met.

Mostly, I am validating primary keys (unique), fields that are not null, fields that have to be positive, relationships (all these generic tests), and also created a singular test comparing delivery date as later than created date. I did not apply those to ALL fields, as essentially I am not requiring all source data to be perfect at the moment. E.g. I don't mind that not all addresses are not filled in the 'stg_postgrees__address' model as long as the addresses are filled in for addresses connected to the orders.

#### Did you find any “bad” data as you added and ran tests on your models? How did you go about either cleaning the data in the dbt model or adjusting your assumptions/tests?
I got one error in a test, but as a SQL compilation error which I was not able to figure out why (it does not point to any column in particular, but to the test itself, even though the test had been applied to many other columns).

Besides that, I got no further errors - the tests created in marts worked well with the filtering/assumptions I have done during modelling.

#### Your stakeholders at Greenery want to understand the state of the data each day. Explain how you would ensure these tests are passing regularly and how you would alert stakeholders about bad data getting through.
I would schedule all the tests to run in a DAG right after dbt run, so all the data could be validated as soon as the models are refreshed. In case any tests fail, this could trigger an alert just so someone can manually investigate it and identify the root cause and if/how it can be fixed.

## Part 3. dbt snapshots
4 products changed quantities: Philodendron, Pothos, String of pearls and Monstera

```
SELECT *
, LEAD(inventory) OVER (PARTITION BY product_id ORDER  BY dbt_updated_at) AS new_inventory
FROM dev_db.dbt_isabelalemoslivecom.inventory_snapshot
QUALIFY dbt_valid_to IS NOT NULL
;
```
