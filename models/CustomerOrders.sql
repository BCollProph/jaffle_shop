WITH orders AS (

  SELECT * 
  
  FROM {{ ref('orders')}}

),

customers AS (

  SELECT * 
  
  FROM {{ ref('customers')}}

),

SubQueryCount AS (

  SELECT 
    customer_id,
    count(order_id) AS cnt_orders
  
  FROM (
    SELECT *
    
    FROM {{ ref('orders')}}
  ) AS all_orders
  
  GROUP BY 1

),

JoinOnIDs AS (

  SELECT 
    customers_1.FIRST_NAME AS FIRST_NAME,
    customers_1.LAST_NAME AS LAST_NAME,
    customers_1.FIRST_ORDER AS FIRST_ORDER,
    customers_1.MOST_RECENT_ORDER AS MOST_RECENT_ORDER,
    customers_1.TOTAL_ORDERS AS TOTAL_ORDERS,
    customers_1.CUSTOMER_LIFETIME_VALUE AS CUSTOMER_LIFETIME_VALUE,
    orders.CUSTOMER_ID AS CUSTOMER_ID,
    orders.ORDER_DATE AS ORDER_DATE,
    orders.GIFT_CARD_AMOUNT AS GIFT_CARD_AMOUNT,
    orders.AMOUNT AS AMOUNT,
    orders.ORDER_ID AS ORDER_ID,
    orders.CREDIT_CARD_AMOUNT AS CREDIT_CARD_AMOUNT,
    orders.STATUS AS STATUS,
    orders.BANK_TRANSFER_AMOUNT AS BANK_TRANSFER_AMOUNT,
    orders.COUPON_AMOUNT AS COUPON_AMOUNT
  
  FROM orders
  INNER JOIN customers AS customers_1
     ON orders.CUSTOMER_ID = customers_1.CUSTOMER_ID

),

Aggregate_1 AS (

  SELECT 
    SUM(AMOUNT) AS TOTAL_PURCHASE_HISTORY,
    any_value(STATUS) AS STATUS,
    any_value(FIRST_NAME) AS FIRST_NAME,
    any_value(LAST_NAME) AS LAST_NAME,
    any_value(CUSTOMER_LIFETIME_VALUE) AS CUSTOMER_LIFETIME_VALUE,
    any_value(CUSTOMER_ID) AS CUSTOMER_ID
  
  FROM JoinOnIDs AS in0
  
  GROUP BY CUSTOMER_ID

),

AddCount AS (

  SELECT 
    in0.CUSTOMER_ID AS CUSTOMER_ID,
    in0.CNT_ORDERS AS CNT_ORDERS,
    in1.STATUS AS STATUS,
    in1.FIRST_NAME AS FIRST_NAME,
    in1.LAST_NAME AS LAST_NAME,
    in1.CUSTOMER_LIFETIME_VALUE AS CUSTOMER_LIFETIME_VALUE,
    in1.TOTAL_PURCHASE_HISTORY AS TOTAL_PURCHASE_HISTORY
  
  FROM SubQueryCount AS in0
  INNER JOIN Aggregate_1 AS in1
     ON in0.CUSTOMER_ID = in1.CUSTOMER_ID

),

Filter_on_Status AS (

  SELECT * 
  
  FROM AddCount AS in0
  
  WHERE STATUS = 'completed'

)

SELECT *

FROM Filter_on_Status
