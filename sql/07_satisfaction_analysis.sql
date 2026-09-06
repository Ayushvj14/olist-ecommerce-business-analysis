/*05_satisfaction_DASBOARD_KPI'S*/

/*1. overall satisfaction of customers on the platform*/
SELECT ROUND(avg(review_score),2)
FROM reviews

/*KPI 2: Rating Distribution*/
SELECT review_score,
       count(review_id)
FROM reviews 
GROUP BY review_score
ORDER BY count(review_id) DESC

/*3.How does customer satisfaction vary by state?*/

SELECT c.customer_state AS states,
       ROUND(AVG(review_score),2),
	   count(r.*) AS total_reviews
FROM customers c
JOIN orders o
ON c.customer_id = o.customer_id
JOIN reviews r 
ON o.order_id = r.order_id
GROUP BY c.customer_state
HAVING COUNT(r.*)>500
ORDER BY AVG(review_score)  DESC 

/*4. How much does delivery performance affect customer satisfaction?*/
SELECT CASE
             WHEN o.order_delivered_customer_date >
                  o.order_estimated_delivery_date
             THEN 'Delayed'
             ELSE 'On Time'
       END AS delivery_status,
       ROUND(AVG(r.review_score),2) AS avg_rating
FROM orders o
JOIN reviews r
ON o.order_id = r.order_id
GROUP BY delivery_status;

