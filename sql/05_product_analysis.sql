/*============================*/
/*04_products_DASBOARD_KPI'S*/
/*============================*/


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

/*| Category               | Revenue Rank | Units Rank |
| ---------------------- | ------------ | ---------- |
| beleza_saude           | #1           | #2         |
| cama_mesa_banho        | #3           | #1         |
| esporte_lazer          | #4           | #3         |
| informatica_acessorios | #5           | #5         |
| relogios_presentes     | #2           | #7         |
| moveis_decoracao       | #6           | #4         |
*/

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

/* star products  because these product are common in both tables
99a4788cb24856965c36a24e339b6058
d1c427060a0f73f6b889a5c7c61f2ac4
53b36df67ebb7c41585e8d54d6772e08
3dd2a17168ec895c781a9191c1e95ad7
aca2eb7d00ea1a7b8ebd4e68314663af*/

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





/*insights
1. Star Categories (High Revenue + High Rating)
| Category         | Revenue | Rating |
| ---------------- | ------: | -----: |
| Beauty & Health  |  ₹1.24M |   4.14 |
| Sports & Leisure |  ₹0.98M |   4.11 |
| Cool Stuff       |  ₹0.62M |   4.15 |
| Toys             |  ₹0.48M |   4.16 |


2. 2. Revenue at Risk
| Category               | Revenue |   Rating |
| ---------------------- | ------: | -------: |
| Bed, Bath & Table      |  ₹1.02M |     3.90 |
| Computer Accessories   |  ₹0.90M |     3.94 |
| Furniture & Decoration |  ₹0.72M |     3.91 |
| Office Furniture       |  ₹0.27M |     3.49 |

3. Premium Niche Categories
| Category            | Revenue | Units |
| ------------------- | ------: | ----: |
| PCs                 |   ₹214K |   200 |
| Technical Books     |    ₹19K |   263 |
| Musical Instruments |   ₹189K |   674 |

4. Highest Rated Categories

| Category           | Rating |
| ------------------ | -----: |
| General Books      |   4.45 |
| Technical Books    |   4.36 |
| Bags & Accessories |   4.31 |


/* INSIGHTS
Insight 1: Beauty & Health is the Business Engine

Evidence: 
 #1 Revenue Category
Revenue = ₹1.26M
Units Sold = 9,670
Rating = 4.14

interpretation:
Beauty & Health drives revenue through high demand,
not high product prices.

BUSINESS ACTION:
Protect inventory availability.
Invest in marketing.
Expand product assortment.

Insight 2: Watches are a Premium Category
Evidence
Revenue Rank = #2
Units Sold Rank = #7
Revenue Per Unit = ₹201

Interpretation:
Watches generate high revenue with relatively fewer sales.
Customers spend more per purchase.

Business Action :
Focus on premium product positioning.
Cross-sell accessories.

Insight 3: Bed, Bath & Table Wins Through Scale

Evidence:
#1 Units Sold
11,115 units
Revenue Rank = #3

Interpretation:
Customers buy these products frequently,
but average selling prices are lower.

Business Action:
Optimize inventory and logistics.
Focus on operational efficiency.

Insight 4: Informatica Accessories Has Multiple Star Products

Evidence:
Two products appear in both:
Top Revenue Products
+
Top Units Sold Products

Interpretation:
Revenue is diversified across multiple successful products,
reducing dependence on a single bestseller.

Business Action:
Continue expanding the category.
Low business risk.

Insight 5: Beauty & Health is Safer Than It Looks

Evidence:
#1 Revenue Category
No single product dominates Top Product Rankings

Interpretation:
Revenue comes from many products,
not one hero product.

Business Action:
Category is resilient.
Lower revenue concentration risk.


Insight 6: Books Have the Happiest Customers

Evidence:
Livros Interesse Geral = 4.45
Livros Tecnicos = 4.36

Interpretation:
Book categories consistently achieve the highest satisfaction scores.

Possible Reasons:
Easy shipping
Low damage rates
Clear customer expectations

Insight 7: Office Furniture Is a Problem Category

Evidence:
moveis_escritorio
Rating = 3.49
Reviews = 1,677

Interpretation:
This is not a small-sample issue.
Customers are genuinely less satisfied.

Business Risk:
Poor reviews
Lower retention
Potential future revenue loss

Insight 8: Furniture Categories Show a Pattern

Evidence:
moveis_escritorio = 3.49
moveis_decoracao = 3.91
cama_mesa_banho = 3.90

Interpretation:
Large and bulky products tend to receive lower ratings.

Hypothesis:
Shipping complexity
Delivery delays
Product damage
This connects directly to our Operations Dashboard.

Insight 9: Product Revenue Comes from Two Different Models

Volume Model
Beauty & Health
Bed, Bath & Table
Sports & Leisure

Revenue through:
Many customers
Many orders*/



