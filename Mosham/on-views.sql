-- VIEWS are used to simplify queries.
-- They also reduce the impact of changes to your database designs.
-- They can also be used to restrict access to the underlying table.



USE sql_invoicing;

CREATE VIEW sales_by_client AS
SELECT
	c.client_id,
    c.name,
    SUM(invoice_total) AS total_sales
FROM clients c
JOIN invoices i
	USING (client_id)
GROUP BY client_id, name;

-- EXERCISE

-- Create a view to see the balance
-- for each client.

-- clients_balance

-- client_id
-- name
-- balance (invoice_total - payment_total)
USE sql_invoicing;

CREATE VIEW clients_balance AS

SELECT 
	client_id,
    name,
    SUM(invoice_total - payment_total) AS balance
FROM invoices
JOIN clients
	USING (client_id)
GROUP BY client_id, name;

-- ALTERING  or DROPPING VIEWS

DROP VIEW client_balance;


-- Another way
CREATE OR REPLACE VIEW clients_balance AS

SELECT 
	client_id,
    name,
    SUM(invoice_total - payment_total) AS balance
FROM invoices
JOIN clients
	USING (client_id)
GROUP BY client_id, name;


-- UPDATABLE VIEWS

-- If the VIEW does not have DISTINCT, Aggregate Functions (MIN, MAX), GROUP BY
-- UNION, then such VIEW is updateable 

CREATE OR REPLACE VIEW invoices_with_balance AS
SELECT 
	invoice_id,
    number,
    client_id,
    invoice_total,
    payment_total,
    invoice_total - payment_total AS balance,
    invoice_date,
    due_date,
    payment_date
FROM invoices
WHERE (invoice_total - payment_total) > 0;

-- This view can be updated. Record can be deleted from this view just as we would
-- a table.

DELETE FROM invoices_with_balance
WHERE invoice_id = 1;

UPDATE invoices_with_balance
SET due_date = DATE_ADD(due_date, INTERVAL 2 DAY)
WHERE invoice_id = 2;

-- Good practice to use the WITH CHECK OPTION when working with views.

CREATE OR REPLACE VIEW invoices_with_balance AS
SELECT 
	invoice_id,
    number,
    client_id,
    invoice_total,
    payment_total,
    invoice_total - payment_total AS balance,
    invoice_date,
    due_date,
    payment_date
FROM invoices
WHERE (invoice_total - payment_total) > 0
WITH CHECK OPTION;


-- Using the WITH CHECK OPTION mitigates against the disappearing behaviour of VIEWS

UPDATE invoices_with_balance
SET payment_total = invoice_total
WHERE invoice_id = 3

