WITH orders AS (

  SELECT * 
  
  FROM {{ ref('stg_orders')}}

),

payments AS (

  SELECT * 
  
  FROM {{ ref('stg_payments')}}

),

customer_payments AS (

  {#This gem provides a detailed view of customer payment transactions, allowing businesses to track individual payments made by customers for specific orders. By joining the payments and orders tables on the order_id identifier, businesses can gain insights into payment behavior, identify payment discrepancies, and improve payment processing efficiency.#}
  SELECT 
    orders.customer_id AS customer_id,
    amount
  
  FROM payments
  LEFT JOIN orders
     ON payments.order_id = orders.order_id

),

amount_per_customer AS (

  {#This gem provides a summary of the total payment amounts for each customer, allowing businesses to analyze customer payment behavior, track revenue generated from different customers, segment customers based on payment amounts, and evaluate payment performance. By summarizing the payment history at the customer level, businesses can make informed decisions, implement targeted strategies, and optimize their operations to maximize revenue and customer satisfaction.#}
  SELECT 
    customer_id,
    sum(amount) AS total_amount
  
  FROM customer_payments
  
  GROUP BY customer_id

),

customer_orders AS (

  SELECT 
    customer_id,
    min(order_date) AS first_order,
    max(order_date) AS most_recent_order,
    count(order_id) AS number_of_orders
  
  FROM orders
  
  GROUP BY customer_id

),

customers AS (

  SELECT * 
  
  FROM {{ ref('stg_customers')}}

),

customer_report AS (

  {#This gem provides a comprehensive report on customer behavior, including customer demographics, order history, and customer lifetime value (CLV). By merging customer information with order history and payment data, businesses can gain a holistic view of customer behavior, enabling them to make data-driven decisions related to customer retention, targeted marketing strategies, and overall business growth. The report includes customer ID, name, first and most recent order dates, total number of orders, and customer lifetime value.#}
  SELECT 
    customers.customer_id,
    customers.first_name,
    customers.last_name,
    customer_orders.first_order,
    customer_orders.most_recent_order,
    customer_orders.number_of_orders AS total_orders,
    amount_per_customer.total_amount AS customer_lifetime_value
  
  FROM customers
  LEFT JOIN customer_orders
     ON customers.customer_id = customer_orders.customer_id
  LEFT JOIN amount_per_customer
     ON customers.customer_id = amount_per_customer.customer_id

),

final_with_order AS (

  SELECT * 
  
  FROM customer_report
  
  ORDER BY total_orders DESC

)

SELECT *

FROM final_with_order
