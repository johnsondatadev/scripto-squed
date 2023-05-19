USE sql_invoicing;

-- NOTE: These aggregate functions work with non-null values and ignore the null ones
-- This can especially be a bit problematic when you use COUNT()
-- Use COUNT(*) to get total count
SELECT 
	MAX(invoice_total) AS highest,
	MIN(invoice_total) AS lowest,
    AVG(invoice_total) AS average,
    MAX(payment_date) AS latest_payment,
    SUM(invoice_total) AS total,
    COUNT(invoice_total) AS number_of_invoices,
    COUNT(payment_date) AS count_of_payments
FROM invoices;

-- NOTE: These also work with duplicate records. That is, it doesn't care if the 
-- records have duplicates or not, it uses a single value out of the duplicates.
-- For instance, counting the client_id that has duplicates treats each client_id as
-- a single entity, rather than counting all the client_ids that exist.
--  If unique values are needed, then you will have to use the DISTINCT keyword.
SELECT 
	MAX(invoice_total) AS highest,
	MIN(invoice_total) AS lowest,
    AVG(invoice_total) AS average,
    MAX(payment_date) AS latest_payment,
    SUM(invoice_total * 1.1) AS total,
    COUNT(invoice_total) AS number_of_invoices,
    COUNT(payment_date) AS count_of_payments,
    COUNT(client_id) AS total_clients,
    COUNT(DISTINCT client_id) AS total_distinct_clients,
    COUNT(*) As total_records
FROM invoices
WHERE invoice_date > '2019-07-01';

-- EXERCISE

-- A query that generates the date_range, total_sales, total_payments, what_we_expect
SELECT
	'First half of 2019' AS date_range,
    SUM(invoice_total) AS total_sales,
    SUM(payment_total) AS total_payments,
    SUM(invoice_total - payment_total) AS what_we_expect
FROM invoices
WHERE invoice_date
	BETWEEN '2019-01-01' AND '2019-06-30'
UNION
SELECT
	'Second half of 2019' AS date_range,
    SUM(invoice_total) AS total_sales,
    SUM(payment_total) AS total_payments,
    SUM(invoice_total - payment_total) AS what_we_expect
FROM invoices
WHERE invoice_date
	BETWEEN '2019-07-01' AND '2019-12-31'
UNION
SELECT
	'Total' AS date_range,
    SUM(invoice_total) AS total_sales,
    SUM(payment_total) AS total_payments,
    SUM(invoice_total - payment_total) AS what_we_expect
FROM invoices
WHERE invoice_date
	BETWEEN '2019-01-01' AND '2019-12-31';


-- GROUP BY

SELECT 
	client_id,
	SUM(invoice_total) AS total_sales
FROM invoices
-- WHERE invoice_date >= '2019-01-01'
GROUP BY client_id
ORDER BY total_sales DESC;

SELECT 
	state,
    city,
	SUM(invoice_total) AS total_sales
FROM invoices i
JOIN clients
	USING (client_id)
GROUP BY state, city;
-- ORDER BY total_sales DESC

-- EXERCISE
USE sql_invoicing;

SELECT
	date,
    pm.name AS payment_method,
    SUM(amount) AS total_payments
FROM payments p
JOIN payment_methods pm
	ON p.payment_method = pm.payment_method_id
GROUP BY date, payment_method
ORDER BY date;


-- HAVING CLAUSE - Used for filtering data after it is grouped.
-- In contrast, WHERE is used for filtering the data before it is grouped.
-- The column used for reference in HAVING clause should be in the SELECT clause
-- In contrast, the column does not have to be in the SELECT clause before it can be
-- used in the WHERE.

USE sql_invoicing;
SELECT 
	client_id,
    SUM(invoice_total) AS total_sales
FROM invoices
GROUP BY client_id
HAVING total_sales > 500;

USE sql_invoicing;
SELECT 
	client_id,
    SUM(invoice_total) AS total_sales,
    COUNT(*) AS number_of_invoices
FROM invoices
GROUP BY client_id
HAVING total_sales > 500 AND number_of_invoices > 5;

-- EXERCISE

-- Get customers located in Virginia who have spent more than $100

USE sql_store;

SELECT 
	c.customer_id,
    c.first_name,
    c.last_name,
    SUM(oi.quantity * oi.unit_price) AS total_sales
FROM customers c
JOIN orders o
	USING (customer_id)
JOIN order_items oi
	USING (order_id)
WHERE state = 'VA'
GROUP BY 
	c.customer_id,
    c.first_name,
    c.last_name
HAVING total_sales > 100;

-- ROLLUP Operator: Used to generate the total of an aggregate function
-- Not part of the standard SQL language, it's only available in MySql
USE sql_invoicing;

SELECT
	client_id,
    SUM(invoice_total) AS total_sales,
    AVG(invoice_total) AS average_sales
FROM invoices
GROUP BY client_id WITH ROLLUP;


USE sql_invoicing;

SELECT 
	state,
    city,
    SUM(invoice_total) AS total_sales
FROM invoices i
JOIN clients c USING (client_id)
GROUP BY state, city WITH ROLLUP;


-- EXERCISE

USE sql_invoicing;

SELECT 
	pm.name AS payment_method,
    SUM(amount) AS total
FROM payments p
JOIN payment_methods pm
	ON p.payment_method = pm.payment_method_id
GROUP BY pm.name WITH ROLLUP
