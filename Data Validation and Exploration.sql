--The following is meant to test the data returned from tableau in our visualizations against the database as well as general exploration of the Offuture data set.


--We noticed missing records depending on what table was being used, so to fuel our   visualization we created a view

CREATE VIEW student.customer_relations AS 
SELECT * 
FROM offuture."order" o 
LEFT JOIN offuture.customer c 
ON (o.customer_id = c.customer_id_long OR o.customer_id = c.customer_id_short);

--Data Vaidation

-- Total profit and units sold per quarter
SELECT 
    EXTRACT(YEAR FROM o.order_date) AS year,
    EXTRACT(QUARTER FROM o.order_date) AS quarter,
    SUM(oi.quantity) AS total_quantity,
    SUM(oi.profit) AS total_profit
FROM offuture."order" o 
INNER JOIN offuture.order_item oi 
ON o.order_id = oi.order_id
GROUP BY year, quarter
ORDER BY year, quarter;


-- Total profit and units sold per year
SELECT 
    EXTRACT(YEAR FROM o.order_date) AS year,
    SUM(oi.quantity) AS total_quantity,
    SUM(oi.profit) AS total_profit
FROM offuture."order" o 
INNER JOIN offuture.order_item oi 
ON o.order_id = oi.order_id
GROUP BY year
ORDER BY year;


-- Total sales per year
SELECT EXTRACT(YEAR FROM o.order_date) AS year,
       SUM(oi.sales) AS total_sales
FROM offuture."order" o 
INNER JOIN offuture.order_item oi 
ON o.order_id = oi.order_id
GROUP BY year
ORDER BY year;


-- Total sales per quarter across all years
SELECT 
    EXTRACT(QUARTER FROM o.order_date) AS quarter,
    SUM(oi.sales) AS total_sales
FROM offuture."order" o 
INNER JOIN offuture.order_item oi 
ON o.order_id = oi.order_id
GROUP BY quarter
ORDER BY quarter;


--Customer segment distribution
SELECT segment, 
       COUNT(*)
FROM student.customer_relations
GROUP BY segment
ORDER BY COUNT(*);


--Most popular products by units sold
SELECT p.product_id,
       p.product_name,
       SUM(oi.quantity) AS total_units_sold
FROM offuture.order_item oi
INNER JOIN offuture.product p ON oi.product_id = p.product_id
GROUP BY p.product_id, p.product_name
ORDER BY total_units_sold DESC
LIMIT 10;  


--Most profitable products 
SELECT p.product_id,
       p.product_name,
       SUM(oi.profit) AS total_profit
FROM offuture.order_item oi
INNER JOIN offuture.product p ON oi.product_id = p.product_id
GROUP BY p.product_id, p.product_name
ORDER BY total_profit DESC
LIMIT 10;  


--Least profitable products 
SELECT p.product_id,
       p.product_name,
       SUM(oi.profit) AS total_profit
FROM offuture.order_item oi
INNER JOIN offuture.product p ON oi.product_id = p.product_id
GROUP BY p.product_id, p.product_name
ORDER BY total_profit 
LIMIT 10; 


-- Total sales by country
SELECT a.country,
       SUM(oi.sales) AS total_sales
FROM offuture.order_item oi
INNER JOIN offuture."order" o ON oi.order_id = o.order_id
INNER JOIN offuture.address a ON o.address_id = a.address_id
GROUP BY a.country
ORDER BY total_sales DESC
LIMIT 10;


-- most profitable products in the US
SELECT oi.product_id,
       p.product_name,
       SUM(oi.profit) AS total_profit
FROM offuture.order_item oi
INNER JOIN offuture."order" o ON oi.order_id = o.order_id
INNER JOIN offuture.address a ON o.address_id = a.address_id
INNER JOIN offuture.product p ON oi.product_id = p.product_id
WHERE a.country = 'United States'
GROUP BY oi.product_id, p.product_name
ORDER BY total_profit DESC
LIMIT 10; 


--Total profit by state
SELECT a.state,
       SUM(oi.profit) AS total_profit
FROM offuture.order_item oi
INNER JOIN offuture."order" o ON oi.order_id = o.order_id
INNER JOIN offuture.address a ON o.address_id = a.address_id
WHERE a.country = 'United States'
GROUP BY a.state
ORDER BY total_profit DESC;


--Global Order Priority
SELECT a.country,  COUNT(o.order_priority)
FROM offuture.address a
INNER JOIN offuture."order" o ON a.address_id = o.address_id 
GROUP BY a.country
ORDER BY COUNT(o.order_priority) DESC


--Global shipping times
SELECT region,
       order_priority,
       AVG(ship_date - order_date)
FROM offuture.order
GROUP BY
    region,
    order_priority
ORDER BY 
	region,
    AVG(ship_date - order_date);


--There is a mystery customer, what's happening there
SELECT * 
FROM offuture."order" o
WHERE 
    o.customer_id NOT IN (SELECT c.customer_id_short FROM offuture.customer c) 
    AND 
    o.customer_id NOT IN (SELECT c2.customer_id_long FROM offuture.customer c2);


--Other Data Exploration


-- Most popular category by sales
SELECT p.category,
       SUM (oi.sales) AS salecount
FROM offuture.product p
INNER JOIN offuture.order_item oi ON p.product_id = oi.product_id
GROUP BY p.category
ORDER BY salecount DESC;

--Total sales per sub category 
SELECT p.sub_category, 
       COUNT(*) AS total_sales
FROM offuture.order_item oi
INNER JOIN offuture.product p ON oi.product_id = p.product_id
GROUP BY p.sub_category
ORDER BY total_sales DESC;


--Most profitable products by sub-category
SELECT p.sub_category, 
       SUM(oi.profit) AS total_profit
FROM offuture.order_item oi
INNER JOIN offuture.product p ON oi.product_id = p.product_id
GROUP BY p.sub_category
ORDER BY total_profit DESC;

-- How many times a specific discount was applied
SELECT discount, 
       COUNT(*) AS times_applied
FROM offuture.order_item
GROUP BY discount
ORDER BY times_applied DESC;