-- TRIGGERS
-- A block of SQL Code that automatically gets executed before or after an insert,
-- update, or delete statement.
USE sql_invoicing;

DELIMITER $$

DROP TRIGGER IF EXISTS payments_after_insert;

CREATE TRIGGER payments_after_insert
	AFTER INSERT ON payments
    FOR EACH ROW
BEGIN
	UPDATE invoices
    SET payment_total = payment_total + NEW.amount
    WHERE invoice_id = NEW.invoice_id;
    
    INSERT INTO payments_audit
    VALUES (NEW.client_id, NEW.date, NEW.amount, 'Insert', NOW());
END$$

DELIMITER ;

-- EXERCISE

-- Create a trigger that gets fired when a payment is deleted
-- The payment amount should be deducted from the payment total on the invoice table
DELIMITER $$

DROP TRIGGER IF EXISTS payments_after_delete;

CREATE TRIGGER payments_after_delete
	AFTER DELETE ON payments
    FOR EACH ROW
BEGIN
	UPDATE invoices
    SET payment_total = payment_total - OLD.amount
    WHERE invoice_id = OLD.invoice_id;
    
    INSERT INTO payments_audit
    VALUES (OLD.client_id, OLD.date, OLD.amount, 'Delete', NOW());
END$$

DELIMITER ;

-- A good use case for Triggers is also for logging
USE sql_invoicing;

CREATE TABLE payments_audit
(
	client_id 		INT 			NOT NULL, 
    date 			DATE 			NOT NULL,
    amount 			DECIMAL(9, 2) 	NOT NULL,
    action_type 	VARCHAR(50) 	NOT NULL,
    action_date 	DATETIME 		NOT NULL
);

SHOW TRIGGERS;

-- EVENTS

-- A task (or block of SQL code) that gets executed according to a schedule
-- Verify if the event scheduler is ON

SHOW VARIABLES LIKE 'event%';

-- Turn OFF/ON event_scheduler. You may wish to turn off the event scheduler to save
-- system resources.

SET GLOBAL event_scheduler = ON;

-- CREATING an event scheduler
DROP EVENT IF EXISTS yearly_delete_stale_audit_rows;

DELIMITER $$

CREATE EVENT yearly_delete_stale_audit_rows
ON SCHEDULE
	-- AT '2023-09-09' -- Use this if the event is only once
    EVERY 1 YEAR STARTS '2023-01-01' ENDS '2030-12-31' -- The STARTS and ENDS are optional
DO BEGIN
	DELETE FROM payments_audit
    WHERE action_date < NOW() - INTERVAL 1 YEAR;
    
    -- DATEADD(NOW(), INTERVAL -1 YEAR);
    -- DATESUB(NOW() INTERVAL 1 YEAR);
    -- Both are equivalent to what was used above.
END$$

DELIMITER ;

SHOW EVENTS;

-- ALTER an event scheduler

-- Altering an event scheduler can be used to reset certain parameters either by 
-- using it as in the CREATE event or by using it to disable/enable an event

DELIMITER $$

CREATE EVENT yearly_delete_stale_audit_rows
ON SCHEDULE
	-- AT '2023-09-09' -- Use this if the event is only once
    EVERY 1 YEAR STARTS '2023-01-01' ENDS '2030-12-31' -- The STARTS and ENDS are optional
DO BEGIN
	DELETE FROM payments_audit
    WHERE action_date < NOW() - INTERVAL 1 YEAR;
    
    -- DATEADD(NOW(), INTERVAL -1 YEAR);
    -- DATESUB(NOW() INTERVAL 1 YEAR);
    -- Both are equivalent to what was used above.
END$$

DELIMITER ;

ALTER EVENT yearly_delete_stale_audit_rows DISABLE;