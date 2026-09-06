/*============================*/
/*05_SELLER_DASBOARD_KPI'S*/
/*============================*/

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

/* INSIGHTS
Seller Performance Analysis
While delivery delays negatively impact customer satisfaction at the overall platform level, 
seller-level analysis shows that delay rates alone do not explain seller ratings.

Several high-rated sellers and low-rated sellers exhibit similar delayed delivery percentages (approximately 10%),
suggesting that factors such as product quality, packaging, product category, 
or customer expectations may play a larger role in determining seller ratings.

This highlights the importance of investigating seller operations beyond delivery performance when evaluating customer satisfaction.
*/

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
/*One of the largest sellers on the platform had a significantly lower average rating (3.35) 
despite having a delivery delay rate similar to high-rated sellers. Further root-cause 
analysis showed that over 90% of the seller's revenue came from the Office Furniture category, 
which was also the lowest-rated major product category on the platform (3.49 average rating).
This suggests that product-category characteristics, rather than delivery performance,
were the primary driver of poor customer satisfaction.*/
SELECT oi.seller_id,
       p.product_category_name AS product_category,
	   SUM(oi.price) AS revenue,
	   count(oi.order_item_id) AS  items_sold
FROM products p
JOIN order_items oi 
ON p.product_id = oi.product_id
WHERE oi.seller_id = 'fa1c13f2614d7b5c4749cbc52fecda94'
GROUP BY oi.seller_id, p.product_category_name
/*A top-revenue seller had one of the lowest customer ratings (3.35). 
I hypothesized that delivery delays were responsible, 
but seller-level delay analysis showed similar delay 
rates among both high-rated and low-rated sellers. 
Further investigation revealed that over 90% 
of the low-rated seller's revenue came from the Office Furniture category, 
which was the lowest-rated major category on the platform. 
This suggested that product-category characteristics
were a stronger driver of customer satisfaction 
than delivery performance for that seller.*/

Select Count(Distinct seller_id) As active_seller
From sellers

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
