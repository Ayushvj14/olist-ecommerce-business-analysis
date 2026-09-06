/*============================*/
/*05_satisfaction_DASBOARD_KPI'S*/
/*============================*/

/*1. overall satisfaction of customers on the platform*/
SELECT ROUND(avg(review_score),2)
FROM reviews

/*KPI 2: Rating Distribution*/
SELECT review_score,
       count(review_id)
FROM reviews 
GROUP BY review_score
ORDER BY count(review_id) DESC

/*The platform maintained a healthy average rating of 4.09/5, 
with approximately 77% of reviews receiving 4 or 5 stars. 
However, review distribution was highly polarized, 
with over 11,000 one-star reviews. This suggests that while most
customers had positive experiences, operational failures led 
to severe customer dissatisfaction rather than moderate dissatisfaction.*/

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
/*(4.30 - 2.57) / 4.30 × 100
1.73 stars diffrence
percentage drop : ≈ 40.23%

Orders delivered late receive ratings that are 
approximately 40% lower than orders delivered on
time (2.57 vs 4.30). This indicates that delivery
performance is one of the strongest drivers of customer
satisfaction on the platform.*/
