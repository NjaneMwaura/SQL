SELECT vendor_id, MAX(original_price) AS Price
FROM farmers_market.vendor_inventory
GROUP BY vendor_id
ORDER BY vendor_id;

SELECT 
 vendor_id, 
 MAX(original_price) AS highest_price
FROM farmers_market.vendor_inventory
GROUP BY vendor_id
ORDER BY vendor_id;

SELECT * FROM(
	SELECT
		vendor_id, market_date, product_id, original_price,
		ROW_NUMBER() OVER ( PARTITION BY vendor_id ORDER BY original_price DESC) AS price_rank
	FROM vendor_inventory
	ORDER BY vendor_id, original_price DESC) X
WHERE X.Price_rank =1;

SELECT * FROM(
	SELECT 
	 vendor_id, 
	 market_date,
	 product_id, 
	 original_price,
	 RANK() OVER (PARTITION BY vendor_id ORDER BY original_price DESC) AS 
	price_rank
	 FROM farmers_market.vendor_inventory
	ORDER BY vendor_id, original_price DESC) X
WHERE Price_rank=1;

SELECT vendor_id, market_date, product_id, original_price, 
	NTILE (10) OVER (ORDER BY original_price DESC) AS price_ntil
FROM vendor_inventory
ORDER BY original_price DESC;

SELECT* FROM(	
    SELECT vendor_id, market_date, product_id, original_price,
		AVG(original_price) OVER (PARTITION BY market_date ORDER BY market_date) AS Average_Cost_Product_by_Market_Date
	 FROM vendor_inventory) X
WHERE X.vendor_id=7
	AND X.original_price > x.average_cost_product_by_market_date
ORDER BY x.market_date, x.original_price DESC;


SELECT * FROM
(
 SELECT 
 vendor_id, 
 market_date,
 product_id, 
 original_price,
 ROUND(AVG(original_price) OVER (PARTITION BY market_date ORDER BY 
market_date), 2) 
 AS average_cost_product_by_market_date
 FROM farmers_market.vendor_inventory
) x
WHERE x.vendor_id = 7
 AND x.original_price > x.average_cost_product_by_market_date
ORDER BY x.market_date, x.original_price DESC;

SELECT 
 vendor_id, 
 market_date,
 product_id, 
 original_price,
 COUNT(product_id) OVER (PARTITION BY market_date, vendor_id) 
vendor_product_count_per_market_date
 FROM farmers_market.vendor_inventory 
ORDER BY vendor_id, market_date, original_price DESC;

SELECT customer_id, market_date, vendor_id, product_id,
	quantity * cost_to_customer_per_qty AS Price,
    SUM(quantity * cost_to_customer_per_qty) OVER (ORDER BY market_date, transaction_time, 
    customer_id, product_id) AS running_total_purchases
FROM customer_purchases;

SELECT customer_id, market_date, vendor_id,
	product_id, quantity * cost_to_customer_per_qty AS price, 
    SUM(quantity * cost_to_customer_per_qty) OVER (PARTITION BY customer_id ORDER BY market_date,
    transaction_time, product_id) AS customer_spending_running_total	
FROM customer_purchases;

SELECT market_date, vendor_id, booth_number, LAG(booth_number,1) 
	OVER (PARTITION BY vendor_id ORDER BY market_date, vendor_id) AS Previous_booth_number
FROM vendor_booth_assignments
ORDER BY market_date, vendor_id, booth_number;

SELECT * FROM (
SELECT market_date, vendor_id, booth_number, LAG(booth_number,1) 
	OVER (PARTITION BY vendor_id ORDER BY market_date, vendor_id) AS Previous_booth_number
FROM vendor_booth_assignments
ORDER BY market_date, vendor_id, booth_number) X	
WHERE X.market_date = '2019-04-10'
	AND (x.booth_number <> x.previous_booth_number OR x.previous);
    
SELECT market_date,
	SUM(quantity * cost_to_customer_per_qty) AS market_date_total_sales,
    LAG(SUM(quantity * cost_to_customer_per_qty), 1) OVER (ORDER BY 
market_date) AS previous_market_date_total_sales
 FROM customer_purchases
 GROUP BY market_date
 ORDER BY market_date