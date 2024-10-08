SELECT product_name, product_id, product_size
FROM product
ORDER BY product_name, product_size
LIMIT 5;

SELECT market_date, customer_id, vendor_id, 
	ROUND(quantity * cost_to_customer_per_qty, 2) AS 'Price'
FROM customer_purchases
LIMIT 10;

SELECT customer_id,
	UPPER(CONCAT (customer_first_name, " ", customer_last_name)) AS 'FullName'
FROM customer
ORDER BY customer_last_name;

