SELECT market_start_datetime, EXTRACT( DAY FROM market_start_datetime) AS mrkts_day,
EXTRACT(MONTH FROM market_start_datetime) AS mrkt_Month,
EXTRACT(YEAR FROM market_start_datetime) AS mrkt_year,
EXTRACT(HOUR FROM market_start_datetime) AS mrkt_hour,
EXTRACT(MINUTE FROM market_start_datetime) AS mrkt_minute
FROM datetime_demo
WHERE market_start_datetime = '2019-03-02 08:00:00';

SELECT market_start_datetime,
	DATE(market_start_datetime) AS mkt_date,
    TIME(market_start_datetime) as mkt_time
FROM datetime_demo
WHERE market_start_datetime= '2019-03-02 08:00:00';

SELECT market_start_datetime,
	DATE_ADD(market_start_datetime, INTERVAL 30 MINUTE) AS MKRT_plus_30min
FROM datetime_demo
WHERE market_start_datetime = '2019-03-02 08:00:00';

SELECT market_start_datetime,
	DATE_ADD(market_start_datetime, INTERVAL 30 DAY) AS MKRT_plus_30days
FROM datetime_demo
WHERE market_start_datetime = '2019-03-02 08:00:00';

SELECT y.first_market,
	y.last_market,
    DATEDIFF(Y.last_market, y.first_market) days_first_to_last
    FROM
	(
    SELECT
		MIN(market_start_datetime) first_market, 
		MAX(market_start_datetime) last_market
	FROM datetime_demo
) y;

SELECT market_start_datetime, market_end_datetime,
	TIMESTAMPDIFF (HOUR, market_start_datetime, market_end_datetime)
		AS market_duration_hours,
	TIMESTAMPDIFF(MINUTE, market_start_datetime, market_end_datetime)
		AS market_duration_mins
	FROM datetime_demo;
    
    SELECT customer_id,
		MIN(market_date) AS first_purchase,
        MAX(market_date) AS last_purchase,
        COUNT(DISTINCT market_date) AS count_of_purchase_dates
    FROM customer_purchases
    WHERE customer_id=1
    GROUP BY customer_id;
    
  SELECT customer_id,
		MIN(market_date) AS first_purchase,
        MAX(market_date) AS last_purchase,
        COUNT(DISTINCT market_date) AS count_of_purchase_dates,
        DATEDIFF(MAX(market_date), MIN(market_date)) AS days_btwn_first_AND_Last_Purchase
    FROM customer_purchases
    GROUP BY customer_id  ;
    
    SELECT customer_id,
		MIN(market_date) AS first_purchase,
        MAX(market_date) AS last_purchase,
        COUNT(DISTINCT market_date) AS count_of_purchase_dates,
        DATEDIFF(MAX(market_date), MIN(market_date)) AS days_btwn_first_AND_Last_Purchase,
        DATEDIFF(CURDATE(), MAX(market_date)) AS days_since_Last_Purchase
    FROM customer_purchases
    GROUP BY customer_id;
    
    SELECT customer_id, market_date,
		RANK () OVER (PARTITION BY customer_id ORDER BY market_date) AS purchase_number,
        LEAD(market_date,1) OVER(PARTITION BY customer_id ORDER BY market_date) AS next_purchase
     FROM customer_purchases
     WHERE customer_id=1;
     
     SELECT 
 x.customer_id, 
 x.market_date,
 RANK() OVER (PARTITION BY x.customer_id ORDER BY x.market_date) AS 
purchase_number,
 LEAD(x.market_date,1) OVER (PARTITION BY x.customer_id ORDER BY 
x.market_date) AS next_purchase
 FROM
( 
 SELECT DISTINCT customer_id, market_date
 FROM farmers_market.customer_purchases
 WHERE customer_id = 1
) x   ;

SELECT x.customer_id, x.market_date,
	RANK () OVER(PARTITION BY x.customer_id ORDER BY x.market_date) AS Purchase_number,
    LEAD(X.market_date,1) OVER(PARTITION BY x.customer_id ORDER BY x.market_date) AS Next_Purchase_Number,
    DATEDIFF(LEAD (x.market_date,1) OVER(PARTITION BY x.customer_id ORDER BY x.market_date), 
		x.market_date) AS days_btwn_purchaases
	FROM
(
SELECT DISTINCT customer_id, market_date
FROM customer_purchases
WHERE customer_id = 1 ) X;

SELECT
a.customer_id, a.market_date AS first_purchase,
	a.next_purchase AS second_purchase,
    DATEDIFF(a.next_purchase, a.market_date) AS time_between_1st_2nd_purchase
FROM
(SELECT x.customer_id, x.market_date,
RANK() OVER (PARTITION BY x.customer_id ORDER BY x.market_date) AS purchase_number,
LEAD(x.market_date,1) OVER (PARTITION BY x.customer_id, x.market_date) AS next_purchase
FROM
(SELECT DISTINCT customer_id, market_date
FROM customer_purchases) x)a
WHERE a.purchase_number=1;

SELECT x.customer_id, 
 COUNT(DISTINCT x.market_date) AS market_count
FROM
(
 SELECT DISTINCT customer_id, market_date 
FROM farmers_market.customer_purchases
WHERE DATEDIFF('2019-03-31', market_date) <= 31)x
GROUP BY x.customer_id
HAVING COUNT(DISTINCT market_date) = 1;
 
 SELECT * 
 FROM customer_purchases
 WHERE vendor_id = 7 and product_id =4 AND customer_id=12
 ORDER BY market_date, transaction_time;
 
 SELECT market_date, vendor_id, product_id, 
	SUM(quantity) quantity_solld,
    SUM(quantity * cost_to_customer_per_qty) total_sales
FROM customer_purchases
WHERE vendor_id=7 and product_id=4
GROUP BY market_date, vendor_id, product_id
ORDER BY market_date, vendor_id, product_id;

SELECT* FROM vendor_inventory AS vi
LEFT JOIN(
	SELECT market_date, vendor_id, product_id, 
	SUM(quantity) quantity_solld,
    SUM(quantity * cost_to_customer_per_qty) total_sales
	FROM customer_purchases
	WHERE vendor_id=7 and product_id=4
	GROUP BY market_date, vendor_id, product_id) AS sales
ON vi.market_date = sales.market_date
	AND vi.vendor_id = sales.vendor_id 
 AND vi.product_id = sales.product_id
ORDER BY vi.market_date, vi.vendor_id, vi.product_id
LIMIT 10;

SELECT vi.market_date, 
 vi.vendor_id, 
 v.vendor_name, 
 vi.product_id, 
 p.product_name,
 vi.quantity AS quantity_available,
 sales.quantity_sold, 
 vi.original_price, 
 sales.total_sales
FROM farmers_market.vendor_inventory AS vi
 LEFT JOIN
 (
 SELECT market_date, 
 vendor_id, 
 product_id, 
 SUM(quantity) AS quantity_sold, 
 SUM(quantity * cost_to_customer_per_qty) AS total_sales
 FROM farmers_market.customer_purchases
 GROUP BY market_date, vendor_id, product_id
 ) AS sales
 ON vi.market_date = sales.market_date 
 AND vi.vendor_id = sales.vendor_id
 AND vi.product_id = sales.product_id
 LEFT JOIN farmers_market.vendor v 
 ON vi.vendor_id = v.vendor_id
 LEFT JOIN farmers_market.product p
 ON vi.product_id = p.product_id
WHERE vi.vendor_id = 7 
 AND vi.product_id = 4
ORDER BY vi.market_date, vi.vendor_id, vi.product_id