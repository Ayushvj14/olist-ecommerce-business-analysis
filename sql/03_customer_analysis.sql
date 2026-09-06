/*02_CUSTOMER_DASBOARD_KPI'S*/

/*1. repeat_customer_%_by_state*/

WITH orders_per_customer AS (SELECT c.customer_state AS states,
       c.customer_unique_id AS customers,
	   COUNT(o.order_id) AS total_order
FROM customers c
JOIN orders o
ON c.customer_id = o.customer_id
GROUP BY c.customer_state,c.customer_unique_id)
                            SELECT states,
							       ROUND(
                                     SUM(
                                         CASE WHEN total_order>1 THEN 1
										 ELSE 0
										 END 
									 )*100.00/COUNT(customers),
								   2) AS repeat_customer_pct
							FROM orders_per_customer
                            GROUP BY states 
							ORDER BY repeat_customer_pct DESC

/* LOYALTY REVENUE BY STATE*/
WITH revenue_per_customer AS(SELECT c.customer_state AS states,
       c.customer_unique_id,
	   COUNT(o.order_id) AS total_orders,
	   SUM(p.payment_value) AS revenue
FROM customers c
JOIN orders o
ON c.customer_id = o.customer_id
JOIN payments p
ON o.order_id = p.order_id
GROUP BY c.customer_state, c.customer_unique_id)
                               SELECT states,
							          ROUND(
                                         SUM(
                                             CASE WHEN total_orders>1 THEN revenue
											 ELSE 0
											 END
										 )*100/SUM(revenue),
									  2) AS loyalty_revenue_pct
							   FROM revenue_per_customer
							   GROUP BY states
							   ORDER BY loyalty_revenue_pct DESC

/*customer base by state*/
SELECT customer_state AS states,
       COUNT(DISTINCT customer_id) AS total_customers
FROM customers
GROUP BY customer_state
ORDER BY total_customers DESC


/*Revenue per Customer by State*/
WITH revenue_per_customer AS(SELECT c.customer_state AS states,
       c.customer_unique_id AS customers,
       SUM(p.payment_value) AS revenue
FROM customers c
JOIN orders o
ON c.customer_id = o.customer_id
JOIN payments p 
ON o.order_id = p.order_id
GROUP BY c.customer_state,c.customer_unique_id)
                                SELECT states,
								      ROUND(
									  sum(revenue)/count(customers),2)AS revenue_per_customer
								FROM revenue_per_customer
								group by states
								ORDER BY revenue_per_customer desc
                                LIMIT 5

