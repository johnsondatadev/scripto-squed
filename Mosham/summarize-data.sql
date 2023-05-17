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
GROUP BY state, city
-- ORDER BY total_sales DESC

-- EXERCISE

