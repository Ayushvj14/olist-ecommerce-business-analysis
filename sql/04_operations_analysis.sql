/*03_OPERATION'S_DASBOARD_KPI'S*/

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


--7. on time delivery pct
SELECT ROUND(
            SUM(
               CASE WHEN order_delivered_customer_date<=order_estimated_delivery_date THEN 1
			   ELSE 0
			   END
			)*100.00/COUNT(order_id)
         ,2) AS on_time_delivery_pct
FROM orders
WHERE order_status = 'delivered'



