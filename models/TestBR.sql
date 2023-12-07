WITH raw_customers AS (

  SELECT * 
  
  FROM {{ ref('raw_customers')}}

),

raw_orders AS (

  SELECT * 
  
  FROM {{ ref('raw_orders')}}

),

Join_1 AS (

  SELECT 
    in0.first_name AS first_name,
    in0.last_name AS last_name,
    in1.order_date AS order_date,
    in1.status AS status
  
  FROM raw_customers AS in0
  INNER JOIN raw_orders AS in1
     ON in0.id = in1.user_id

),

OrderBy_1 AS (

  SELECT * 
  
  FROM Join_1 AS in0
  
  ORDER BY ORDER_DATE ASC

),

Limit_1 AS (

  SELECT * 
  
  FROM OrderBy_1 AS in0
  
  LIMIT 1000

)

SELECT *

FROM Limit_1
