DROP PROCEDURE IF EXISTS get_clients_by_state;

DELIMITER $$
CREATE PROCEDURE get_clients_by_state
(
	state CHAR(2) -- Use VARCHAR if length is variable
)
BEGIN
	SELECT * 
    FROM clients c
    WHERE c.state = state;
END$$

DELIMITER ;