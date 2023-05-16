use sql_store;

-- ------------ INNER JOIN ------------------
-- Joining across Tables in a single database
-- Note: By default, using JOIN is the same as using INNER JOIN

-- Select everything both orders and customers table
SELECT * 
FROM orders
JOIN customers 
     ON orders.customer_id = customers.customer_id;
  
-- Select specific columns from both tables
SELECT order_id, orders.customer_id, first_name, last_name
FROM orders
JOIN customers 
     ON orders.customer_id = customers.customer_id;
     
-- Exercise
-- Select order_id, product_id, the name of the product, quantity,
-- and the unit price of the product as at when it was sold.
SELECT order_id, oi.product_id, name, quantity, oi.unit_price
FROM order_items oi
JOIN products p
ON oi.product_id = p.product_id;

-- ------------------- JOINING ACROSS DATABASES -------------------------

SELECT *
FROM order_items oi
JOIN sql_inventory.products p
	ON oi.product_id = p.product_id;
    
-- JOINING A TABLE WITH ITSELF 
-- SELF JOIN

-- Select all fields employees and the managers they report to
USE sql_hr;

SELECT *
FROM employees e
JOIN employees m -- m short for managers.
	ON e.reports_to = m.employee_id;

-- Select particular fields
SELECT 
	e.employee_id,
    e.first_name,
    m.first_name AS manager
FROM employees e
JOIN employees m -- m short for managers.
	ON e.reports_to = m.employee_id;
    
-- JOINING MULTIPLE TABLES 
-- More than 2 tables

USE sql_store;

SELECT 
	o.order_id,
    o.order_date,
    c.first_name,
    c.last_name,
    os.name AS status
FROM orders o
JOIN customers c
	ON o.customer_id = c.customer_id
JOIN order_statuses os
	ON o.status = os.order_status_id;
    
-- Exercise
-- Using the sql_invoicing database
-- Join the invoice table with the payments table on invoice ids and payment methods
-- Produce a report that shows more details such as the name of the client
-- and the payment method they used.

USE sql_invoicing;

SELECT 
	i.invoice_id, 
	c.name,
    p.date,
    p.amount,
    pm.name
FROM invoices i
JOIN clients c 
	ON c.client_id = i.client_id
JOIN payments p
	ON p.client_id = i.client_id
JOIN payment_methods pm
	ON p.payment_method = pm.payment_method_id;
    

-- COMPOUND JOINS
-- Joining tables with composite keys

USE sql_store;

SELECT *
FROM order_items oi
JOIN order_item_notes oin
	ON oi.order_id = oin.order_id
    AND oi.product_id = oin.product_id;


-- IMPLICIT JOINS ***** NOT ADVISABLE ***** As it could lead to cross join
-- If you forget the WHERE clause.

-- This is the regular JOIN. That is, the INNER JOIN
SELECT *
FROM orders o
JOIN customers c
	ON o.customer_id = c.customer_id;
  
-- This is the equivalent IMPLICIT JOIN  
SELECT * 
FROM orders o, customers c
WHERE o.customer_id = c.customer_id;

-- Cross Join occurs when we omit the WHERE Clause
SELECT * 
FROM orders o, customers c;


-- OUTER JOIN
-- There are two types of OUTER JOIN {LEFT JOIN and RIGHT JOIN}
-- LEFT JOIN - All records from the left table are returned whether the condition is true
-- or not. The opposite is the case for the RIGHT JOIN


-- LEFT JOIN
SELECT 
	c.customer_id,
    c.first_name,
    o.order_id
FROM orders o
LEFT JOIN customers c
	ON o.customer_id = c.customer_id
ORDER BY c.customer_id;

SELECT 
	c.customer_id,
    c.first_name,
    o.order_id
FROM customers c
RIGHT JOIN orders o
	ON o.customer_id = c.customer_id
ORDER BY c.customer_id;

-- RIGHT JOIN using the same code
SELECT 
	c.customer_id,
    c.first_name,
    o.order_id
FROM orders o
RIGHT JOIN customers c
	ON o.customer_id = c.customer_id
ORDER BY c.customer_id;

-- Exercise (OUTER JOIN)
-- Get all the products that can be ordered whether they have been ordered or not
-- For instance, product no 7 has never been ordered.

USE sql_store;

SELECT 
	p.product_id,
    p.name,
    oi.quantity
FROM products p
LEFT JOIN order_items oi
	ON p.product_id = oi.product_id;

-- OUTER JOIN multiple Tables
-- Best practice: Avoid RIGHT JOINs, use LEFT JOIN instead

USE sql_store;

SELECT 
	c.customer_id,
    c.first_name,
    o.order_id,
    sh.name AS shipper
FROM customers c
LEFT JOIN orders o
	ON o.customer_id = c.customer_id
LEFT JOIN shippers sh
	ON o.shipper_id = sh.shipper_id
ORDER BY c.customer_id;

-- Exercise

USE sql_store;

SELECT 
	o.order_date,
    o.order_id,
    c.first_name AS customer,
    sh.name AS shipper,
    os.name AS order_status
FROM orders o
JOIN customers c
	ON o.customer_id = c.customer_id
LEFT JOIN shippers sh
	ON o.shipper_id = sh.shipper_id
JOIN order_statuses os
	ON os.order_status_id = o.status;
    
-- SELF OUTER JOIN
USE sql_hr;

SELECT 
	e.employee_id,
    e.first_name,
    m.first_name AS manager
FROM employees e
LEFT JOIN employees m
	ON e.reports_to = m.employee_id;
    
-- The USING Clause
USE sql_store;

SELECT 
	o.order_id,
    c.first_name,
    sh.name AS shipper
FROM orders o
JOIN customers c
	-- ON c.customer_id = o.customer_id
	USING (customer_id)
LEFT JOIN shippers sh
	USING (shipper_id);
  
USE sql_store;

SELECT *
FROM order_items oi
JOIN order_item_notes oin
	-- ON oi.order_id = oin.order_id AND
    -- oi.product_id = oin.product_id;
	USING (order_id, product_id); -- The two commented lines above produce exactly
									-- the same result as the USING statement here.


-- Customers who have made payments and their payment details

USE sql_invoicing;

SELECT
	p.date,
    c.name AS client,
    p.amount,
    pm.name AS payment_method
FROM payments p
JOIN clients c
	USING (client_id)
JOIN payment_methods pm
	ON p.payment_method = pm.payment_method_id;
    
-- Natural Joins (Not recommended)
USE sql_store;

SELECT 
	o.order_id,
    c.first_name
FROM orders o
NATURAL JOIN customers c;

-- CROSS JOIN 
-- To combine every record in one table with every record in another table
USE sql_store;

-- Using CROSS JOIN - Explicit Syntax
SELECT
	c.first_name AS customer,
    p.name AS product
FROM customers c
CROSS JOIN products p
ORDER BY c.first_name;

-- This implicit syntax also produces the same thing
SELECT
	c.first_name AS customer,
    p.name AS product
FROM customers c, products p
ORDER BY c.first_name;

-- Exercise

-- Do a cross join between shippers and products
-- using the implicit syntax
-- and then using the explicit syntax


-- IMPLICT CROSS JOIN
USE sql_store;

SELECT
	sh.name AS shipper,
    p.name AS product
FROM shippers sh, products p
ORDER BY sh.name;

-- EXPLICIT CROSS JOIN
USE sql_store;

SELECT 	
	sh.name AS shipper,
    p.name AS product
FROM shippers sh
CROSS JOIN products p
ORDER BY sh.name;

-- COMBINING ROWS FROM MULTIPLE TABLEES USING UNION
-- Note** The columns have to match between the two 
-- Whatever we have in the first select determines the name of the columns
USE sql_store;

SELECT 
	order_id,
    order_date,
    'Active' As status
FROM orders
WHERE order_date >= '2019-01-01'

UNION

SELECT 
	order_id,
    order_date,
    'Archived' As status
FROM orders
WHERE order_date < '2019-01-01';

SELECT first_name
FROM customers
UNION 
SELECT name
FROM shippers;

-- Exercise

-- Less than 2000 - Bronze
-- Between 2000 - 3000 Silver
-- Above 3000 - Gold

USE sql_store;

SELECT 
	customer_id,
    first_name,
    points,
    'Bronze' AS type
FROM customers
WHERE points < 2000

UNION

SELECT 
	customer_id,
    first_name,
    points,
    'Silver' AS type
FROM customers c
WHERE points BETWEEN 2000 AND 3000

UNION

SELECT 
	customer_id,
    first_name,
    points,
    'Gold' AS type
FROM customers
WHERE points > 3000

ORDER BY first_name;