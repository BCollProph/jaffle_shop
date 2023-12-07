WITH orders AS (

  SELECT * 
  
  FROM {{ ref('orders')}}

),

raw_orders AS (

  SELECT * 
  
  FROM {{ ref('raw_orders')}}

),

Join_1 AS (

  SELECT 
    orders.ORDER_ID AS ORDER_ID,
    orders.CUSTOMER_ID AS CUSTOMER_ID,
    orders.ORDER_DATE AS ORDER_DATE,
    orders.STATUS AS STATUS,
    orders.CREDIT_CARD_AMOUNT AS CREDIT_CARD_AMOUNT,
    orders.COUPON_AMOUNT AS COUPON_AMOUNT,
    orders.BANK_TRANSFER_AMOUNT AS BANK_TRANSFER_AMOUNT,
    orders.GIFT_CARD_AMOUNT AS GIFT_CARD_AMOUNT,
    orders.AMOUNT AS AMOUNT,
    raw_orders.id AS id,
    raw_orders.user_id AS user_id
  
  FROM raw_orders
  INNER JOIN orders
     ON raw_orders.order_date = orders.order_date AND raw_orders.status = orders.status

),

OrderBy_1 AS (

  SELECT * 
  
  FROM Join_1 AS in0
  
  ORDER BY ORDER_DATE ASC

)

SELECT *

FROM OrderBy_1
