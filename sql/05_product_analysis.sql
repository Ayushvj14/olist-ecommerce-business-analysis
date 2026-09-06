/*04_products_DASBOARD_KPI'S*/

/*01. Which product categories generate the most revenue?*/
SELECT pr.product_category_name  AS product_category,
       SUM(oi.price) AS revenue
FROM products pr
JOIN order_items oi
ON pr.product_id = oi.product_id
GROUP BY pr.product_category_name
ORDER BY SUM(oi.price) DESC
LIMIT 10



/*2.Which categories sell the most units?*/
SELECT pr.product_category_name  AS product_category,
       COUNT(oi.order_id) AS total_orders
FROM products pr
JOIN order_items oi
ON pr.product_id = oi.product_id
GROUP BY pr.product_category_name
ORDER BY count(oi.order_id)DESC
LIMIT 10


/*3.Which categories generate the highest revenue per unit sold?*/
SELECT pr.product_category_name  AS product_category,
       ROUND(
	            SUM(oi.price)/
				              COUNT(oi.order_id)
	         ,2) AS revenue_per_unit
FROM products pr
JOIN order_items oi
ON pr.product_id = oi.product_id
GROUP BY pr.product_category_name
ORDER BY revenue_per_unit DESC
LIMIT 10

/* 4. Which products generate the most revenue? OR star products*/
SELECT product_id AS products,
       SUM(price) AS revenue
FROM order_items oi
GROUP BY products
ORDER BY revenue DESC
LIMIT 10


/*5.Which products sell the most units?*/
SELECT product_id AS products,
       COUNT(order_id) AS unit_solds
FROM order_items 
GROUP  BY product_id 
ORDER BY COUNT(order_id) desc
limit  10


/*6. Which category do these star products belong to?*/
SELECT
    oi.product_id,
    p.product_category_name,
    SUM(oi.price) AS revenue,
    COUNT(*) AS units_sold
FROM order_items oi
JOIN products p
ON oi.product_id = p.product_id
WHERE oi.product_id IN (
'aca2eb7d00ea1a7b8ebd4e68314663af',
'99a4788cb24856965c36a24e339b6058',
'53b36df67ebb7c41585e8d54d6772e08',
'd1c427060a0f73f6b889a5c7c61f2ac4',
'3dd2a17168ec895c781a9191c1e95ad7'
)
GROUP BY oi.product_id, p.product_category_name;

/* 7. Which product categories make customers happiest?*/
SELECT
    p.product_category_name,
    COUNT(*) AS total_reviews,
    ROUND(AVG(r.review_score),2) AS avg_rating
FROM products p
JOIN order_items oi
ON p.product_id = oi.product_id
JOIN reviews r
ON oi.order_id = r.order_id
GROUP BY p.product_category_name
HAVING COUNT(*) > 100
ORDER BY avg_rating DESC;

/*Which product categories contribute the most revenue while maintaining high customer satisfaction?*/
SELECT p.product_category_name AS product_category,
       SUM(oi.price) AS revenue,
	   COUNT(oi.order_item_id) AS unit_sold,
	   ROUND(
           AVG(r.review_score),
	   2) AS avg_rating
FROM products p
JOIN order_items oi
ON p.product_id = oi.product_id
JOIN orders o
ON oi.order_id = o.order_id
JOIN reviews r
ON o.order_id = r.order_id
GROUP BY p.product_category_name
HAVING COUNT(oi.order_item_id) > 100
ORDER BY revenue desc

Select Count(Distinct product_category_name) AS Total_Product_Category
From products








