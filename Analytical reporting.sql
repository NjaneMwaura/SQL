SELECT 
market_date, vendor_id, 
ROUND(SUM(quantity * cost_to_customer_per_qty),2) AS Sales
FROM customer_purchases
GROUP BY market_date, vendor_id
ORDER BY market_date, vendor_id;

WITH sales_by_vendor AS (
SELECT 
	cp.market_date, md.market_day, md.market_week, md.market_year,
    cp.vendor_id, v.vendor_name, v.vendor_type,
    ROUND(SUM(cp.quantity * cp.cost_to_customer_per_qty), 2) AS Sales
FROM customer_purchases cp
	LEFT JOIN market_date_info md USING (market_date)
    LEFT JOIN vendor v USING (vendor_id)
GROUP BY cp.market_date, cp.vendor_id
ORDER BY cp.market_date, cp.vendor_id)

SELECT
	s.market_year,
    s.market_week,
    SUM(s.sales) AS weekly_sales
FROM  sales_by_vendor s
GROUP BY s.market_year, s.market_week;

CREATE VIEW farmers_market.vw_sales_per_date_vendor_product AS
SELECT 
 vi.market_date, 
 vi.vendor_id, 
 v.vendor_name, 
 vi.product_id, 
 -- p.product_name,
 vi.quantity AS quantity_available,
 sales.quantity_sold,
 ROUND((sales.quantity_sold / vi.quantity) * 100, 2) AS percent_of_available_sold,
 vi.original_price, 
 (vi.original_price * sales.quantity_sold) - sales.total_sales AS 
discount_amount,
 sales.total_sales
FROM farmers_market.vendor_inventory AS vi
 LEFT JOIN
 (
 SELECT market_date, 
 vendor_id, 
 product_id, 
 SUM(quantity) quantity_sold, 
 SUM(quantity * cost_to_customer_per_qty) AS total_sales
 FROM farmers_market.customer_purchases
 GROUP BY market_date, vendor_id, product_id
 ) AS sales
 ON vi.market_date = sales.market_date 
 AND vi.vendor_id = sales.vendor_id
 AND vi.product_id = sales.product_id
 LEFT JOIN farmers_market.vendor v 
 ON vi.vendor_id = v.vendor_id
