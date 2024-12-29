CREATE VIEW student.customer_relations AS 
(
SELECT 
	* 
FROM
	offuture.ORDER o 
LEFT JOIN 
	offuture.customer c
ON 
	o.customer_id = c.customer_id_long OR
	o.customer_id = c.customer_id_short
)


GRANT SELECT ON student.customer_relations 
TO da11_tosc, de11_dekn, da11_olaj


DROP VIEW IF EXISTS student.customer_relations;




SELECT * FROM student.customer_relations

SELECT COUNT(*) FROM student.customer_relations


SELECT * FROM student.customer_relations
WHERE customer_id_long IS NULL

SELECT * FROM offuture.address;

SELECT COUNT(*) FROM student.customer_relations;



SELECT oi.product_id, SUM(oi.profit) FROM offuture.address a
JOIN offuture.ORDER o 
ON
	a.address_id = o.address_id
JOIN offuture.order_item oi 
ON
	o.order_id = oi.order_id
WHERE 
	a.country = 'United States'
GROUP BY 
	oi.product_id 
ORDER BY 
	SUM(oi.profit) DESC

SELECT * FROM offuture.order

   
SELECT
    DISTINCT(customer_id)
FROM
    offuture.order o
LEFT JOIN offuture.customer c
ON o.customer_id = c.customer_id_short OR
   o.customer_id = c.customer_id_long
WHERE customer_id_long IS NULL;  


SELECT * FROM offuture.product p 
JOIN offuture.order_item oi 
ON
	p.product_id = oi.product_id
WHERE p.sub_category = 'Phones'

