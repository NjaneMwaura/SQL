SELECT product_id, count(*)
from product
Group by product_id
HAVING count(*) > 1;

SElECT count(*) FROM product;

SELECT  pc.product_category_name, pc.product_category_id, count(product_id) AS count_of_products
FROM product p
JOIN product_category pc using(product_category_id)
GROUP BY pc.product_category_id;

SELECT MIN(market_date), MAX(market_date)
FROM vendor_inventory;

SELECT vendor_id, MIN(market_date), MAX(market_date)
FROM vendor_inventory
GROUP BY vendor_id
ORDER BY MIN(market_date), MAX(market_date);

SELECT
EXTRACT(YEAR FROM market_date) AS market_year,
EXTRACT(MONTH FROM market_date) AS market_month,
COUNT(DISTINCT vendor_id) AS vendors_with_inventory
FROM vendor_inventory
GROUP BY EXTRACT(YEAR FROM market_date), EXTRACT(MONTH FROM market_date)
ORDER BY  EXTRACT(YEAR FROM market_date), EXTRACT(MONTH FROM market_date);

SELECT * FROM vendor_inventory
WHERE vendor_id=7
ORDER BY market_date, product_id