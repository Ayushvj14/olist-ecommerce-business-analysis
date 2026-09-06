/*============================*/
/*03_OPERATION'S_DASBOARD_KPI'S*/
/*============================*/

/*1.DELAYED_DELIVERY_PCT*/
SELECT ROUND(
          SUM(
            CASE WHEN order_delivered_customer_date>order_estimated_delivery_date THEN 1
			ELSE 0
			END
		  )*100.00/COUNT(order_id),
2)AS delayed_delivery_pct
FROM orders
WHERE order_status = 'delivered';

/*2.DELAYED_DELIVERY_PCT BY STATE*/
SELECT c.customer_state AS state,
        ROUND(
           SUM(
            CASE WHEN o.order_delivered_customer_date>o.order_estimated_delivery_date THEN 1
			ELSE 0
			END
		  )*100.00/COUNT(o.order_id),
2)AS delayed_delivery_pct
FROM customers c
JOIN orders o
ON c.customer_id = o.customer_id
WHERE order_status = 'delivered'
GROUP BY c.customer_state;

/*3.Do delayed deliveries hurt customer satisfaction?*/
WITH deliveries_time AS (SELECT r.review_score AS rating,
       CASE WHEN o.order_delivered_customer_date <= o.order_estimated_delivery_date THEN 'ontime'
	        WHEN o.order_delivered_customer_date>o.order_estimated_delivery_date THEN 'delayed'
	   END AS deliveries
FROM orders o
JOIN reviews r
ON o.order_id = r.order_id)
                      SELECT avg(rating) FILTER (WHERE deliveries = 'ontime') AS rating_ontime_deliveries,
					         AVG(rating) FILTER (WHERE deliveries = 'delayed') AS rating_delayed_deliveries
					 FROM deliveries_time;
/*insights
Delivery Performance Impact Analysis

Orders delivered on time receive an average review score of 4.30, while delayed orders receive an average review score of only 2.57.

This represents a decline of 1.73 rating points, indicating a strong negative relationship between delivery delays and customer satisfaction.

The findings suggest that improving delivery performance may directly improve customer experience, customer retention, and long-term revenue growth.

Business Recommendation:
Prioritize operational improvements in high-delay states and monitor delivery performance as a key driver of customer satisfaction.
*/

/*4.What percentage of orders are cancelled?*/
SELECT ROUND(
        SUM(
          CASE WHEN order_status = 'canceled' THEN 1
		  ELSE 0
		  END 
		) *100.00/COUNT(*),
2) AS cancelled_pct
FROM orders;

/*5.For delayed orders, how many days late are we on average?*/

SELECT ROUND(
       AVG(
           EXTRACT(
               EPOCH FROM (
                   order_delivered_customer_date
                   - order_estimated_delivery_date
               )
           ) / 86400
       )
,2) AS avg_days_late
FROM orders
WHERE order_delivered_customer_date >
      order_estimated_delivery_date;

/*insights 
Operational Risk:
8.11% of orders are delivered late, and delayed orders arrive
9.55 days after the promised delivery date on average.
These delays reduce customer ratings from 4.30 to 2.57,
indicating a strong negative impact on customer experience.*/

/*6. impact on revnue from delay deliveries*/
SELECT ROUND(
       SUM(
           CASE
               WHEN o.order_delivered_customer_date >
                    o.order_estimated_delivery_date
               THEN p.payment_value
               ELSE 0
           END
       ) * 100.0
       /
       SUM(p.payment_value)
,2) AS delayed_revenue_pct
FROM orders o
JOIN payments p
ON o.order_id = p.order_id;

/*insights 
Revenue Impact of Delivery Delays

8.44% of total revenue is associated with orders delivered after the promised delivery date.

This closely aligns with the delayed delivery rate of 8.11%, indicating that delivery delays affect a meaningful share of business activity rather than being isolated to low-value orders.

Delayed orders are delivered 9.55 days late on average and receive significantly lower customer ratings (2.57 vs 4.30 for on-time deliveries).

Business Recommendation:
Reducing delivery delays represents an opportunity to improve customer satisfaction across a substantial portion of revenue-generating orders.
*/
-- on time delivery pct
SELECT ROUND(
            SUM(
               CASE WHEN order_delivered_customer_date<=order_estimated_delivery_date THEN 1
			   ELSE 0
			   END
			)*100.00/COUNT(order_id)
         ,2) AS on_time_delivery_pct
FROM orders
WHERE order_status = 'delivered'



