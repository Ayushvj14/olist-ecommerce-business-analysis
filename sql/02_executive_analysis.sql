/*============================*/
/*01_EXECUTIVE_DASBOARD_KPI'S*/
/*============================*/

/*KPI 1 : Total_revneue*/
SELECT 
    SUM(payment_value) AS revenue
FROM payments;

/* KPI 2 : Total_orders*/
SELECT 
    COUNT(*)
FROM orders;

/*KPI 3: AOV */ 
SELECT
     ROUND(
          SUM(payment_value)/ 
		              COUNT(DISTINCT order_id)
	      ,2) AS AOV
FROM payments

/*KPI 4 Revenue by state*/
SELECT c.customer_state,
       SUM(p.payment_value) AS revnue
FROM customers c
JOIN orders o
ON c.customer_id = o.customer_id
JOIN payments p 
ON o.order_id = p.order_id
GROUP BY c.customer_state
ORDER BY SUM(p.payment_value) DESC

SELECT c.customer_state,
       COUNT(o.order_id)
FROM customers c
JOIN orders o
ON c.customer_id = o.customer_id
GROUP BY c.customer_state
ORDER BY count(o.order_id) DESC

SELECT c.customer_state,
       COUNT(DISTINCT customer_unique_id)
FROM customers c
JOIN orders o
ON c.customer_id = o.customer_id
GROUP BY c.customer_state
ORDER BY  COUNT(DISTINCT customer_unique_id) DESC

SELECT c.customer_state,
       ROUND(
           sum(p.payment_value)/count(distinct o.order_id)
	   ,2) AS AOV
FROM customers c
JOIN orders o
ON c.customer_id = o.customer_id
JOIN payments p 
ON o.order_id = p.order_id
GROUP BY c.customer_state
ORDER BY AOV desc

/* insights KPI 4*/
/*State Revenue Analysis

Although São Paulo (SP) generates the highest revenue, it has the lowest Average Order Value (AOV) among all states at 143.69.

This indicates that SP's revenue leadership is driven by a large customer base and high order volume rather than higher customer spending.

In contrast, states such as Paraíba (PB), Acre (AC), and Rondônia (RO) exhibit significantly higher AOV values, suggesting stronger spending behavior per order despite contributing less total revenue.

Business Opportunity:
Investigate customer acquisition opportunities in high-AOV states while continuing to leverage the scale advantage of SP and RJ.
*/


/* Repeat_customer_pct*/
WITH customer_orders AS(SELECT c.customer_unique_id AS customer,
       COUNT(o.order_id) AS total_orders
FROM customers c
JOIN orders o
ON c.customer_id = o.customer_id
GROUP BY c.customer_unique_id)
                SELECT ROUND(
                         SUM(
                            CASE WHEN total_orders>1 THEN 1
							ELSE 0
							END)*100.00/COUNT(customer),
				          2) AS repeat_customer_pct
				FROM customer_orders

/* kpi insight*/
/*Customer Retention Analysis

The Repeat Customer Rate is only 3%, indicating that the vast majority of customers purchase only once and do not return for subsequent orders.

This suggests that business growth is heavily dependent on acquiring new customers rather than retaining existing ones.

A low repeat purchase rate can increase customer acquisition costs over time and may indicate opportunities to improve customer loyalty, post-purchase experience, and retention programs.

Business Recommendation:
Investigate factors influencing customer churn, such as delivery performance, customer satisfaction, and product quality, and develop retention strategies to encourage repeat purchases.
*/

WITH customer_orders AS (
    SELECT c.customer_unique_id,
           COUNT(o.order_id) AS total_orders
    FROM customers c
    JOIN orders o
    ON c.customer_id = o.customer_id
    GROUP BY c.customer_unique_id
)
SELECT
    COUNT(*) AS total_customers,
    SUM(CASE WHEN total_orders > 1 THEN 1 ELSE 0 END) AS repeat_customers
FROM customer_orders;

/*Loyalty revenue %*/

WITH customer_revenue AS(SELECT c.customer_unique_id AS customer,
       COUNT(o.order_id) AS total_orders,
	   SUM(p.payment_value) AS revenue
FROM customers c
JOIN orders o
ON c.customer_id = o.customer_id
JOIN payments p 
ON o.order_id = p.order_id
GROUP BY c.customer_unique_id)
              SELECT ROUND(
			           SUM(
			           CASE WHEN total_orders>1 then revenue
					   else 0
					   END)*100.00/SUM(revenue),
					   2)AS loyalty_revenue_pct
			  FROM customer_revenue

/*insights*/
/*Customer Loyalty Analysis

Only 3.12% of customers return to place additional orders, indicating a very low repeat purchase rate.

However, these repeat customers contribute 8.78% of total revenue, which is significantly higher than their share of the customer base.

This suggests that returning customers are substantially more valuable than one-time buyers and generate approximately 2.8 times more revenue relative to their population share.

Business Implication:
The business currently relies heavily on new customer acquisition for growth. Improving customer retention could have a meaningful impact on revenue growth while reducing dependence on acquisition spending.

Recommendation:
Investigate customer satisfaction, delivery performance, and post-purchase engagement strategies to encourage repeat purchases and increase customer lifetime value.
*/

/* Monthly revenue Trend*/
SELECT DATE_TRUNC('MONTH', o.order_purchase_timestamp) AS months,
       SUM(p.payment_value) AS revenue
FROM orders o
JOIN payments p
ON o.order_id  = p.order_id
GROUP by months
ORDER BY months asc

/*revenue growth % */ 
WITH monthly_revnue AS (SELECT DATE_TRUNC('MONTH', o.order_purchase_timestamp) AS months,
       SUM(p.payment_value) AS revenue
FROM orders o
JOIN payments p
ON o.order_id  = p.order_id
GROUP by months
ORDER BY months asc)
              SELECT months,
			         ROUND(
                         (
                           revenue - LAG(revenue) OVER(ORDER BY months)
						 )/LAG(revenue) OVER(ORDER BY months)
						 *100
					 ,2) as montly_revnue_growth_pct
              FROM monthly_revnue
/*insights*/
/*Revenue Growth Analysis

Monthly revenue growth shows considerable volatility throughout the observed period. After excluding startup and incomplete months, revenue growth fluctuates between positive and negative growth periods, indicating inconsistent expansion.

This variability may make revenue forecasting more challenging and suggests the business should monitor demand patterns closely.

Recommendation:
Implement category-level and product-level demand analysis to identify seasonal trends and improve forecasting accuracy.
*/

