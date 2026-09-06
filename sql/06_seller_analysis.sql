/*05_SELLER_DASBOARD_KPI'S*/

/* 1. premium, volume revenue per unit by sellers*/
SElECT seller_id, 
       SUM(price) AS revenue
	   ,
	   COUNT(order_item_id) AS item_sold,
	   ROUND(
             SUM(price)/
			         COUNT(order_item_id)
	   ,2) AS revenue_per_unit
FROM order_items 
GROUP BY seller_id
ORDER BY SUM(price) DESC
LIMIT 10

/*2. Which sellers have the highest and lowest average ratings?*/
SELECT oi.seller_id,
       COUNT(r.*) AS total_reviews,
	   SUM(oi.price) As Revenue,
	   AVG(review_score) AS avg_rating
FROM order_items oi 
JOIN reviews r
ON oi.order_id = r.order_id
GROUP BY oi.seller_id 
HAVING COUNT(r.*) > 500
ORDER BY Revenue DESC
limit 10

/* investigation why some sellers have low ratings*/

/* 1. Delay pct by sellers*/
SELECT
    oi.seller_id,
    COUNT(DISTINCT o.order_id) AS total_orders,
    ROUND(
        COUNT(DISTINCT CASE
              WHEN o.order_delivered_customer_date >
                   o.order_estimated_delivery_date
              THEN o.order_id
        END) * 100.0
        /
        COUNT(DISTINCT o.order_id)
    ,2) AS delay_pct
FROM orders o
JOIN order_items oi
ON o.order_id = oi.order_id
WHERE o.order_status = 'delivered'
GROUP BY oi.seller_id
HAVING COUNT(DISTINCT o.order_id) > 500
ORDER BY delay_pct DESC;


/*Which product categories contribute most of this seller's(7c67e1448b00f6e969d365cea6b010ab) revenue and sales?*/
SELECT oi.seller_id,
       p.product_category_name AS product_category,
	   SUM(oi.price) AS revenue,
	   count(oi.order_item_id) AS  items_sold
FROM products p
JOIN order_items oi 
ON p.product_id = oi.product_id
WHERE oi.seller_id = '7c67e1448b00f6e969d365cea6b010ab'
GROUP BY oi.seller_id, p.product_category_name

/* top revenue seller had one of the lowest rating*/
SELECT oi.seller_id,
       p.product_category_name AS product_category,
	   SUM(oi.price) AS revenue,
	   count(oi.order_item_id) AS  items_sold
FROM products p
JOIN order_items oi 
ON p.product_id = oi.product_id
WHERE oi.seller_id = 'fa1c13f2614d7b5c4749cbc52fecda94'
GROUP BY oi.seller_id, p.product_category_name

/* total active seller*/
Select Count(Distinct seller_id) As active_seller
From sellers

/* overall seller delay rate*/
WITH seller_orders AS (
    SELECT DISTINCT
        oi.order_id,
        oi.seller_id
    FROM order_items oi
),
seller_delivery AS (
    SELECT
        so.order_id,
        so.seller_id,
        o.order_delivered_customer_date,
        o.order_estimated_delivery_date
    FROM seller_orders so
    JOIN orders o
        ON so.order_id = o.order_id
    WHERE o.order_delivered_customer_date IS NOT NULL
)
SELECT
    ROUND(
        100.0 * SUM(
            CASE
                WHEN order_delivered_customer_date > order_estimated_delivery_date
                THEN 1
                ELSE 0
            END
        ) / COUNT(*),
        2
    ) AS overall_seller_delay_rate
FROM seller_delivery;
