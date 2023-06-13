DROP PROCEDURE get_invoices_by_client;

DROP PROCEDURE IF EXISTS get_invoices_by_client;

DELIMITER $$
CREATE PROCEDURE get_invoices_by_client
(
	name VARCHAR(50)
)
BEGIN
	SELECT 
		invoice_id,
		number,
		invoice_total,
		payment_total,
		(invoice_total - payment_total) AS balance,
		invoice_date,
		due_date,
		payment_date
	FROM clients c
	JOIN invoices 
		USING (client_id)
	WHERE c.name=name;
END$$

DELIMITER ;