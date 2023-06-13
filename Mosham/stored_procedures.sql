-- A Stored Procedure is a database object that contains a block of SQL Code
-- Used to store and organize SQL. Also used to optimize the execution of the SQL
-- Code. It also enables data security.

USE sql_invoicing;

DELIMITER $$
CREATE PROCEDURE get_invoices_with_balance()
BEGIN
	SELECT * 
    FROM invoices
    WHERE (invoice_total - payment_total) > 0;
END$$

DELIMITER ;

-- Note that we can use our created views inside the stored procedure
SELECT *
FROM invoices_with_balance
WHERE balance > 0;

-- Now to put that in a stored procedure, we can do the following

DELIMITER $$
CREATE PROCEDURE get_invoices_with_balance_from_view()
BEGIN
	SELECT *
	FROM invoices_with_balance
	WHERE balance > 0;
END$$

DELIMITER ;

-- DROPPING STORED PROCEDURES

DROP PROCEDURE get_invoices_with_balance;

-- To check if the Procedure exists before dropping it, you can do the following:

DROP PROCEDURE IF EXISTS get_invoice_by_client_id;

-- CREATING PROCEDURES WITH PARAMETERS

DELIMITER $$
CREATE PROCEDURE get_invoice_by_client_id
(
	client_id INT
)
BEGIN
	SELECT *
    FROM invoices i
    WHERE i.client_id=client_id;
END$$

DELIMITER ;


-- CREATING PROCEDURES WITH DEFAULT PARAMETERS
DROP PROCEDURE IF EXISTS get_clients_by_state;

DELIMITER $$
CREATE PROCEDURE get_clients_by_state
(
	state CHAR(2) -- Use VARCHAR if length is variable
)
BEGIN
	IF state IS NULL THEN
		SET state = 'CA';
	END IF;

	SELECT * 
    FROM clients c
    WHERE c.state = state;
END$$

DELIMITER ;

-- Note that because default values are set does not mean that the parameters will
-- not be supplied. We can however pass in NULL as the parameter
-- This will not work! You can uncomment the line to test it out.
-- CALL get_clients_by_state(); 

CALL get_clients_by_state(NULL);

-- We can also set the state to all the states, rather than choosing a specific 
-- state out of the box

DROP PROCEDURE IF EXISTS get_clients_by_state;

DELIMITER $$
CREATE PROCEDURE get_clients_by_state
(
	state CHAR(2) -- Use VARCHAR if length is variable
)
BEGIN
	IF state IS NULL THEN
		SELECT * FROM clients;
	ELSE
		SELECT * 
		FROM clients c
		WHERE c.state = state;
	END IF;
END$$

DELIMITER ;

-- We can even optimize the code above in a more professional way as below

DROP PROCEDURE IF EXISTS get_clients_by_state;

DELIMITER $$
CREATE PROCEDURE get_clients_by_state
(
	state CHAR(2) -- Use VARCHAR if length is variable
)
BEGIN
	SELECT * 
	FROM clients c
	WHERE c.state = IFNULL(state, c.state);
END$$

DELIMITER ;



-- EXERCISE
-- Write a stored procedure called get_payments with two parameters
--
-- client_id => INT
-- payment_method_id => TINYINT

DROP PROCEDURE IF EXISTS get_payments;

DELIMITER $$
CREATE PROCEDURE get_payments
(
	client_id INT,
    payment_method_id TINYINT
)
BEGIN
	SELECT *
    FROM payments p
    WHERE (p.client_id = IFNULL(client_id, p.client_id))
		AND (p.payment_method = IFNULL(payment_method_id, p.payment_method)); 
END$$

DELIMITER ;

CALL get_payments(NULL, NULL);
CALL get_payments(5, 2);


-- PARAMETER VALIDATION
DROP PROCEDURE IF EXISTS make_payment;

DELIMITER $$
CREATE PROCEDURE make_payment
(
	invoice_id INT,
    payment_amount DECIMAL(9, 2),
    payment_date DATE
)
BEGIN
	IF payment_amount <= 0 THEN
		SIGNAL SQLSTATE '22003'
        SET MESSAGE_TEXT = 'Invalid payment amount!';
	END IF;
    
	UPDATE invoices i
    SET 
		i.payment_total = payment_amount,
        i.payment_date = payment_date
	WHERE i.invoice_id = invoice_id;
END$$


--  OUTPUT PARAMETERS

CREATE DEFINER=`root`@`localhost` PROCEDURE `get_unpaid_invoices_for_client`(
	client_id INT,
    OUT invoices_count INT,
    OUT invoices_total DECIMAL(9, 2)
)
BEGIN
	SELECT COUNT(*), SUM(invoice_total)
    INTO invoices_count, invoices_total
    FROM invoices i
    WHERE i.client_id = client_id
		AND payment_total = 0;
END;


-- User or Session variables: Defined in memory and only available for as long
-- as the particular statement executes, once done with execution, it is freed up
-- from the memory



-- Local variables: Defined inside a function or a stored procedure. They do not stay
-- in memory
DROP PROCEDURE IF EXISTS get_risk_factor;

DELIMITER $$
CREATE PROCEDURE get_risk_factor()
BEGIN
	DECLARE risk_factor DECIMAL(9, 2) DEFAULT 0;
    DECLARE invoices_total DECIMAL(9, 2);
    DECLARE invoices_count INT;
    
    SELECT COUNT(*), SUM(invoice_total)
    INTO invoices_count, invoices_total
    FROM invoices;
    
    SET risk_factor = invoices_total / invoices_count * 5;
    
    SELECT risk_factor;
END$$

DELIMITER ;



-- FUNCTIONS: Unlike stored procedures, functions can only return a single values
USE sql_invoicing;

DROP function IF EXISTS get_risk_factor_for_client;

DELIMITER $$
CREATE FUNCTION get_risk_factor_for_client
(
	client_id INT
)
RETURNS INTEGER
-- ATTRIBUTES
-- DETERMINISTIC: Returns same output for the same inputs
-- READS SQL DATA: Read Sql data
-- MODIFIES SQL DATA
READS SQL DATA
BEGIN
	DECLARE risk_factor DECIMAL(9, 2) DEFAULT 0;
    DECLARE invoices_total DECIMAL(9, 2);
    DECLARE invoices_count INT;
    
    SELECT COUNT(*), SUM(invoice_total)
    INTO invoices_count, invoices_total
    FROM invoices i
    WHERE i.client_id = client_id;
    
    SET risk_factor = invoices_total / invoices_count * 5;
	RETURN IFNULL(risk_factor, 0);
END$$

DELIMITER ;






USE sql_store;

WITH result AS
(
	SELECT points, DENSE_RANK() OVER (ORDER BY points DESC) AS denserank
	FROM customers
)
SELECT * 
FROM result
WHERE denserank = 4;