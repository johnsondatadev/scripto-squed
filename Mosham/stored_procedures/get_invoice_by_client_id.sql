DROP PROCEDURE IF EXISTS get_invoice_by_client_id;

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