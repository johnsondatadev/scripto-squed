-- INSERT A ROW INTO TABLE

USE sql_store;

INSERT INTO customers (
		first_name,
        last_name,
        birth_date,
        address,
        city,
        state
	)
VALUES (
    'John', 
    'Smith',
    '1990-01-01',
    'address',
    'city',
    'CA'
    );
    
-- INSERT MULTIPLE ROWS

USE sql_store;

INSERT INTO shippers (name)
VALUES ('Shipper1'),
		('Shipper2'),
        ('Shipper3');
        
-- Exercise

-- INSERT three rows in the products table

USE sql_store;

INSERT INTO products(
	name, quantity_in_stock, unit_price)
VALUES 
	('Pencil', 2, 1.80),
    ('Crayon', 1, 3.90),
    ('Nose Trimmer', 4, 4.80);

-- INSERT DATA INTO MULTIPLE TABLES (Hierarchical Rows)

USE sql_store;

INSERT INTO orders (customer_id, order_date, status)
VALUES (1, '2019-01-02', 1);

INSERT INTO order_items
VALUES 
	(LAST_INSERT_ID(), 1, 1, 2.95),
    (LAST_INSERT_ID(), 2, 1, 3.95);


-- COPY DATA FROM ONE TABLE TO ANOTHER

-- SUBQUERIES
USE sql_store;

CREATE TABLE orders_archived AS
SELECT * FROM orders;

SELECT * 
FROM orders
WHERE order_date < '2019-01-01';

-- INSERTING INTO A TABLE USING SUBQUERY
INSERT INTO orders_archived
SELECT * 
FROM orders
WHERE order_date < '2019-01-01';

-- EXERCISE
-- Create a table that copies over the details in the invoice table
-- Select only cases where order payment was made and ensure the client name 
-- is displayed

USE sql_invoicing;

CREATE TABLE invoices_archived AS
SELECT 
	i.invoice_id,
    i.number,
    c.name AS client_name,
    i.invoice_total,
    i.payment_total,
    i.invoice_date,
    i.due_date,
    i.payment_date
FROM invoices i
JOIN CLIENTS c
	USING (client_id)
WHERE i.payment_date IS NOT NULL;

SELECT * 
FROM invoices_archived;


-- UPDATE DATA

-- SINGLE ROW
USE sql_invoicing;

UPDATE invoices
SET 
	payment_total = 10, 
    payment_date = '2019-03-01'
WHERE invoice_id = 1;

-- REVERT TO PREVIOUS DATA
-- Using the previous detail

UPDATE invoices
SET
	payment_total = DEFAULT,  -- Use DEFAULT when the table 
    payment_date = NULL -- You can use NULLs where the table accepts it
WHERE invoice_id = 1;


UPDATE invoices
SET
	payment_total = invoice_total * 0.5,  -- Use DEFAULT when the table 
    payment_date = due_date -- You can use NULLs where the table accepts it
WHERE invoice_id = 3; -- WHERE invoice_id IN (3, 5)

-- UPDATE MULTIPLE ROWS

UPDATE invoices
SET
	payment_total = invoice_total * 0.5,  -- Use DEFAULT when the table 
    payment_date = due_date -- You can use NULLs where the table accepts it
WHERE client_id = 3;

-- EXERCISE
-- Write a SQL statemnt to give any customers born before 1990 50 extra points
USE sql_store;

UPDATE customers
SET points = 50 + points
WHERE birth_date < '1990-01-01';

SELECT * FROM customers
WHERE birth_date < '1990-01-01';

-- SUBQUERIES IN UPDATE

USE sql_invoicing;

SELECT * 
FROM invoices
WHERE client_id = (
	SELECT DISTINCT c.client_id
    FROM clients c
    JOIN invoices i 
		USING (client_id)
	WHERE c.name = 'Yadel'
		);
        

SELECT *
FROM invoices
WHERE client_id = (
					SELECT client_id
                    FROM clients
                    WHERE name = 'Yadel'
					);
                    
-- EXERCISE

-- Update comments for customers with more than 3000 points
-- Regard them as Gold customers
USE sql_store;

UPDATE orders
SET 
	comments = 'gold customer'
WHERE customer_id IN 
		(SELECT customer_id
		FROM customers
		WHERE points > 3000);


USE sql_invoicing;
        
DELETE FROM invoices
WHERE client_id = 
	(
		SELECT client_id FROM clients
		WHERE client_id = 2
    );
    
-- RESTORE the Database