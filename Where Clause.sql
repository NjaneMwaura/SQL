SELECT product_id, product_category_id, product_name
FROM product
WHERE product_category_id = 1;

SELECT market_date, 
 customer_id, 
 vendor_id, product_id,
 quantity, 
 quantity * cost_to_customer_per_qty AS price 
FROM customer_purchases
WHERE customer_id = 4 OR customer_id = 3
ORDER BY market_date, vendor_id, product_id;

SELECT product_id, product_name
FROM product
WHERE (product_id = 10 OR product_id > 3) AND ( product_id < 8);

SELECT
 customer_id, 
 customer_first_name,
 customer_last_name
FROM farmers_market.customer
WHERE
 customer_first_name = 'Carlos' 
 OR customer_last_name = 'Diaz';
 
 SELECT *
 FROM vendor_booth_assignments
 WHERE vendor_id = 7
	AND market_date BETWEEN '2019-01-01' AND '2020-12-30'
ORDER BY market_date;

SELECT customer_id, customer_first_name, customer_last_name
FROM customer
WHERE customer_last_name IN ('Diaz', 'Edwards', 'Wilson');

SELECT customer_id, customer_first_name, customer_last_name
FROM customer
WHERE customer_first_name LIKE 'Jer%';

SELECT * 
FROM product
WHERE 
 product_size IS NULL 
 OR TRIM(product_size) = '';
 
 SELECT m.market_rain_flag, m.market_day, m.market_date, c.quantity
 FROM market_date_info M
 JOIN customer_purchases c 
 USING (market_date)
 WHERE m.market_rain_flag = 1
