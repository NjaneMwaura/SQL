SELECT * 
FROM product P
LEFT JOIN product_category PC
		USING (product_category_id);
        
SELECT * 
FROM product P
RIGHT JOIN product_category PC
		USING (product_category_id);
        
SELECT * 
FROM product P
JOIN product_category PC
		USING (product_category_id);
        
SELECT * 
FROM customer c 
LEFT JOIN customer_purchases cp
    USING (customer_id)
WHERE cp.customer_id IS NULL;
