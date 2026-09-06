CREATE TABLE reviews (
    review_id VARCHAR(50),
    order_id VARCHAR(50),
    review_score SMALLINT,
    review_comment_title TEXT,
    review_comment_message TEXT,
    review_creation_date TIMESTAMP,
    review_answer_timestamp TIMESTAMP
);

/*AUDIT*/
SELECT COUNT(*),
count(distinct review_id),
count(distinct order_id)
FROM reviews;

SELECT
COUNT(*) FILTER (WHERE review_id IS NULL) AS review_id_nulls,
COUNT(*) FILTER (WHERE order_id IS NULL) AS order_id_nulls,
COUNT(*) FILTER (WHERE review_score IS NULL) AS review_score_nulls,
COUNT(*) FILTER (WHERE review_comment_title IS NULL) AS title_nulls,
COUNT(*) FILTER (WHERE review_comment_message IS NULL) AS message_nulls
FROM reviews;
ALTER TABLE reviews
ADD PRIMARY KEY(review_id)

ALTER TABLE orders
ADD CONSTRAINT fk_orders_customers
FOREIGN KEY(customer_id)
REFERENCES customers(customer_id);

ALTER TABLE order_items
ADD CONSTRAINT fk_order_items_orders
FOREIGN KEY (order_id)
REFERENCES orders(order_id);

ALTER TABLE order_items
ADD CONSTRAINT fk_order_items_products
FOREIGN KEY (product_id)
REFERENCES products(product_id);

ALTER TABLE order_items
ADD CONSTRAINT fk_order_items_sellers
FOREIGN KEY (seller_id)
REFERENCES sellers(seller_id);

ALTER TABLE reviews
ADD CONSTRAINT fk_reviews_orders
FOREIGN KEY (order_id)
REFERENCES orders(order_id);