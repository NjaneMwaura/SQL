SELECT market_date, customer_id, 
COUNT(*) AS items_purchased -- counts the number of purchases by a customer per market date
FROM customer_purchases
GROUP BY market_date, customer_id
ORDER BY market_date, customer_id;

SELECT market_date, customer_id, 
SUM(quantity) AS items_purchased
FROM customer_purchases
GROUP BY market_date, customer_id
ORDER BY market_date, customer_id;

SELECT market_date, customer_id, 
COUNT(DISTINCT product_id) AS different_products_purchased,
SUM(quantity) AS items_purchased
FROM customer_purchases
GROUP BY market_date, customer_id
ORDER BY market_date, customer_id;

SELECT market_date, customer_id, 
SUM(quantity * cost_to_customer_per_qty) AS Total_Spent
FROM customer_purchases
WHERE customer_id=3
GROUP BY  market_date
ORDER BY market_date;

SELECT vendor_id, customer_id, 
SUM(quantity * cost_to_customer_per_qty) AS Total_Spent
FROM customer_purchases
WHERE customer_id=3
GROUP BY  vendor_id, customer_id
ORDER BY vendor_id, customer_id;

SELECT v.vendor_name, c.customer_first_name, c.customer_last_name, cp.vendor_id, cp.customer_id, SUM(quantity*cost_to_customer_per_qty) AS Price
FROM customer_purchases CP
JOIN customer C USING (customer_id)
JOIN vendor V ON 
CP.vendor_id=V.vendor_id
WHERE c.customer_id = 3
GROUP BY 
 c.customer_first_name,
 c.customer_last_name,
 cp.customer_id,
 v.vendor_name,
 cp.vendor_id
ORDER BY vendor_id, customer_id;

SELECT MIN(original_price) AS Minimum_Price, MAX(original_price) AS Maxmimum_Price, pc.product_category_id, pc.product_category_name
FROM vendor_inventory vi
JOIN product p USING (product_id)
JOIN product_category pc USING (product_category_id)
GROUP BY pc.product_category_id, pc.product_category_name ;
-- ORDER BY original_price  

SELECT market_date, COUNT(product_id) AS Total_Products
FROM vendor_inventory
GROUP BY market_date
ORDER BY market_date;

SELECT vendor_id, COUNT(DISTINCT(product_id)) AS Different_Products_Offered
FROM vendor_inventory
-- WHERE market_date BETWEEN '2019-01-01' AND '2019-03-16'
GROUP BY vendor_id ;

SELECT vendor_id, COUNT(DISTINCT(product_id)) AS Different_Products_Offered,
AVG(original_price) AS Average_Product_Price, SUM(quantity * original_price) AS value_of_inventory,
 SUM(quantity) AS inventory_item_count,
 ROUND(SUM(quantity * original_price) / SUM(quantity), 2) AS
average_item_price
FROM vendor_inventory
-- WHERE market_date BETWEEN '2019-01-01' AND '2019-03-16'
GROUP BY vendor_id 
ORDER BY vendor_id;

SELECT 
 vendor_id, 
 COUNT(DISTINCT product_id) AS different_products_offered,
 SUM(quantity * original_price) AS value_of_inventory,
 SUM(quantity) AS inventory_item_count,
 SUM(quantity * original_price) / SUM(quantity) AS average_item_price
FROM farmers_market.vendor_inventory
-- WHERE market_date BETWEEN '2019-03-02' AND '2019-03-16'
GROUP BY vendor_id
HAVING inventory_item_count >= 100
ORDER BY vendor_id
