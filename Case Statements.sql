SELECT vendor_id, vendor_name, vendor_type,
	CASE 
		WHEN LOWER(vendor_type) LIKE '%fresh%'
			THEN 'Fresh Produce'
		ELSE 'Other'
	END AS vendor_type_condensed
FROM vendor;

SELECT market_date, market_season,
	CASE 
    
		WHEN LOWER(market_day) = 'Saturday'
			THEN 1
		ELSE 0
	END AS 'Weekend_Flag'
FROM market_date_info;


SELECT market_date, customer_id, vendor_id, 
	ROUND (quantity * cost_to_customer_per_qty, 2) AS price,
    CASE 
		WHEN quantity * cost_to_customer_per_qty < 5.00
			THEN 'Under $5'
		WHEN quantity * cost_to_customer_per_qty < 10.00
			THEN '$5 - $9.99'
		WHEN quantity * cost_to_customer_per_qty < 20.00
			THEN '$10 - $19.99'
		WHEN quantity * cost_to_customer_per_qty >= 20.00
			THEN '$20  and Up'
		END AS price_bin
FROM customer_purchases;

-- ONE HOT ENCODING
SELECT vendor_id, vendor_name, vendor_type,
	CASE WHEN vendor_type = 'Arts & Jewelry'
		THEN 1
        ELSE 0
	END AS Vendor_type_arts_jewelry,
    CASE WHEN vendor_type = 'Eggs & Meats' 
		 THEN 1
		 ELSE 0 
	 END AS vendor_type_eggs_meats,
	 CASE WHEN vendor_type = 'Fresh Focused' 
		 THEN 1
		 ELSE 0 
	 END AS vendor_type_fresh_focused, 
	 CASE WHEN vendor_type = 'Fresh Variety: Veggies & More' 
		 THEN 1
		 ELSE 0 
	 END AS vendor_type_fresh_variety,
	 CASE WHEN vendor_type = 'Prepared Foods' 
		 THEN 1
		 ELSE 0 
	 END AS vendor_type_prepared
FROM vendor