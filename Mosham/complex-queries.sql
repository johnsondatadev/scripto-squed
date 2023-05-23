-- Find products that are more expensive than Lettuce (id = 3)

USE sql_store;

SELECT 
	name,
    unit_price
FROM products 
WHERE unit_price > (
		SELECT
			unit_price
		FROM products
		WHERE product_id = 3
	)
ORDER BY unit_price DESC;


-- In sql_hr database, find employees who earn more than average

USE sql_hr;

SELECT * 
FROM employees 
WHERE salary > (
	SELECT
		AVG(salary)
	FROM employees
)
ORDER BY salary DESC;
 

-- Products that have never been ordered

USE sql_store;

SELECT * 
FROM products
WHERE product_id NOT IN (
	SELECT DISTINCT product_id
	FROM order_items
);

-- EXERCISE
-- Find the Clients without invoices

USE sql_invoicing;

SELECT *
FROM clients
WHERE client_id NOT IN (
	SELECT DISTINCT client_id
    FROM invoices
);

-- NOTE: JOIN can be used in place of Subqueries and vice-versa
-- Performance and Readability are two metrics to make the decision between these
-- two

SELECT *
FROM clients
LEFT JOIN invoices USING(client_id)
WHERE invoice_id IS NULL;

-- EXERCISE

-- Find customers who have ordered lettuce (id = 3)
-- Select customer_id, first_name, last_name

USE sql_store;

-- USING JOIN 

SELECT 
	DISTINCT c.customer_id,
    c.first_name,
    c.last_name
FROM customers c
JOIN orders o
	USING(customer_id)
JOIN order_items oi
	USING(order_id)
WHERE oi.product_id = 3;

-- USING SUBQUERY
SELECT 
	c.customer_id,
    c.first_name,
    c.last_name
FROM customers c
WHERE customer_id IN (
	SELECT o.customer_id
    FROM order_items oi
    JOIN orders o USING (order_id)
    WHERE product_id = 3
);

-- The ALL keyword

-- Select invoices larger than all invoices of client 3
USE sql_invoicing;


SELECT * 
FROM invoices
WHERE invoice_total > (
	SELECT MAX(invoice_total)
	FROM invoices
	WHERE client_id = 3
);

-- Doing the same thing above using the ALL keyword

SELECT *
FROM invoices
WHERE invoice_total > ALL (
	SELECT invoice_total
    FROM invoices
    WHERE client_id = 3
);

-- Using the ANY keyword

-- Select clients with at least two invoices
USE sql_invoicing;

SELECT * 
FROM clients
WHERE client_id IN (
	SELECT client_id
	FROM invoices
	GROUP BY client_id
	HAVING COUNT(*) >= 2
);

-- Alternatively, you can do the following:

SELECT * 
FROM clients
WHERE client_id = ANY (
	SELECT client_id
	FROM invoices
	GROUP BY client_id
	HAVING COUNT(*) >= 2
);

-- CORRELATEDD QUERIES
-- Select employees whose salary is above the average in their office

-- Pseudocode

-- for each employee
--   	calculate the average salary for employees in the office
-- 		return the employee if the salary is greater than the average salary

USE sql_hr;

SELECT * 
FROM employees e
WHERE salary > (
	SELECT AVG(salary)
    FROM employees
    WHERE office_id = e.office_id
);

-- SELECT office_id, AVG(SALARY)
-- FROM employees
-- GROUP BY office_id

-- EXERCISE

-- Get invoices that are larger than the client's average invoice amount

USE sql_invoicing;

SELECT *
FROM invoices i
WHERE invoice_total > (
	SELECT AVG(invoice_total)
    FROM invoices
    WHERE client_id = i.client_id
);

-- EXISTS OPERATOR

-- Select clients that have an invoice

SELECT *
FROM clients
WHERE client_id IN (
	SELECT DISTINCT client_id
    FROM invoices
);

-- USING EXISTS approach

SELECT *
FROM clients c
WHERE EXISTS (
	SELECT client_id
    FROM invoices
    WHERE client_id = c.client_id
);

-- Rule of thumb: If the subquery produces a large result, it is more efficient to
-- use the EXISTS keyword because the Subquery in an EXISTS keyword does not return
-- a result to the outer query

-- EXERCISE 
-- Find the products that have never been ordered

USE sql_store;

SELECT *
FROM products p
WHERE NOT EXISTS (
	SELECT product_id
    FROM order_items
    WHERE product_id = p.product_id
);

-- SUBQUERIES in SELECT clause

USE sql_invoicing;

SELECT 
	invoice_id,
    invoice_total,
    (SELECT AVG(invoice_total)
		FROM invoices) AS invoice_average,
	invoice_total - (SELECT invoice_average) AS difference
FROM invoices;

-- EXERCISE

USE sql_invoicing;

SELECT
	client_id,
    name,
    (
		SELECT SUM(invoice_total)
			FROM invoices
			WHERE client_id = c.client_id
	) AS total_sales,
	(SELECT AVG(invoice_total)
		FROM invoices) AS average,
	(SELECT total_sales - average) AS difference
FROM clients c
;

-- SUBQUERY in the FROM Clause
-- NOTE: when using Subqueries in the FROM clause, it is REQUIRED to give it an alias
-- If you don't, you'll get an error: Every derived table must have its own alias


SELECT *
FROM (
	SELECT
		client_id,
		name,
		(
			SELECT SUM(invoice_total)
				FROM invoices
				WHERE client_id = c.client_id
		) AS total_sales,
		(SELECT AVG(invoice_total)
			FROM invoices) AS average,
		(SELECT total_sales - average) AS difference
	FROM clients c
) AS sales_summary
WHERE total_sales IS NOT NULL;

