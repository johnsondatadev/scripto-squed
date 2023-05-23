-- Numeric Functions

SELECT ROUND(5.73);

SELECT ROUND(5.73, 1); -- Keeps 1 digit after the decimal and rounds the number

SELECT ROUND(5.7355, 2); -- Keeps 2 digits after the decimal and rounds the number.

-- TRUNCATE

SELECT TRUNCATE(5.7355, 2); -- Produces 5.73 while ROUND produces 5.74

-- CEILING 
-- Produces the least (smallest) integer number more (greater) than or equal to 
-- the number passed in.

SELECT CEILING(5.734); -- Produces 6

SELECT CEILING(5.12); -- Also produces 6 because the next integer greater than 5.12 is 6

-- FLOOR
-- Produces the largest integer number less than the value

SELECT FLOOR(5.732); -- Produces 5

SELECT FLOOR(5.012); -- Also produces 5

-- ABS
-- Returns the absolute values of a number

SELECT ABS(-555); -- produces 555

-- RAND
-- Returns the random numbers between 0 and 1

SELECT ROUND(RAND(), 4);

-- More functions on google - mysql numeric functions

-- STRING FUNCTIONS

-- LENGTH
-- To get the length of a character
SELECT LENGTH('Johnson');


-- UPPER
-- Uppercase
SELECT UPPER('Johnson');

-- LOWER
-- Lowercase
SELECT LOWER('JOHNSON');

-- 


-- LTRIM, RTRIM, TRIM
-- Removes leading spaces from the left, right, and both respectively

SELECT LTRIM('       Johnson');
SELECT RTRIM('Johnson.       ');
SELECT TRIM('.        Johnson');

-- LEFT
-- Select leftmost n string characters

SELECT LEFT('Kindergaten', 4);

-- RIGHT 
-- Selects the rightmost n string characters

SELECT RIGHT('Kindergaten', 3);

-- SUBSTR or SUBSTRING
-- Selects a portion of strings based on the argmuments passed in starting at 
-- Index n and selecting m characters. Note than m is optional and when left out of
-- the expression, it select the entire characters starting at index n.

SELECT SUBSTR('Kindergaten', 4, 5); -- Produces derga, starting at index 4, 
								   -- select 5 characters

-- LOCATE
-- Returns the index of a character at a position n by looking at a search string
-- If search string does not exist, it returns 0 (specific to SQL, it returns -1 in
-- most programming languages)

SELECT LOCATE('ten', 'Kindergaten');

-- REPLACE
-- Replaces a string with another. Note that it is case sensitive, T is not the same 
-- as t

SELECT REPLACE('Johnson', 'son', ''); -- Returns John
SELECT REPLACE('Tow', 'T', 'L');

-- CONCAT
-- Used to combine two strings
SELECT CONCAT('firstname', ' ', 'lastname');

USE sql_store;
SELECT
	CONCAT(first_name, ' ', last_name)
FROM customers;

-- For more functions, google mysql string functions

-- DATE FUNCTIONS

-- NOW
-- To get the current date and time
SELECT NOW();

-- CURDATE
-- To get the current date
SELECT CURDATE();

-- CURTIME
-- To get the current time
SELECT CURTIME();

-- YEAR (returns integer)
-- To extract the year
SELECT YEAR(NOW());


-- MONTH (returns integer)
-- TO extract the month
SELECT MONTH(NOW());

-- SECOND (returns integer)
-- To extract the seconds
SELECT SECOND(NOW());

-- DAY
-- To extract the day (returns integer)
SELECT DAY(NOW());


-- DAYNAME (returns string)
-- To get the name of a day


-- MONTHNAME
-- To get the name of the month


-- EXTRACT
-- Use extract for portability

SELECT EXTRACT(YEAR FROM NOW());
SELECT EXTRACT(MONTH FROM NOW());

-- EXAMPLE
SELECT * 
FROM orders
WHERE EXTRACT(YEAR FROM order_date) = EXTRACT(YEAR From NOW());

-- FORMATTING DATES AND TIMES

-- DATE_FORMAT
-- Takes two argument, the date and the format
SELECT DATE_FORMAT(NOW(), '%Y'); -- Returned 2023
SELECT DATE_FORMAT(NOW(), '%y'); -- Lower case y returns 23

SELECT DATE_FORMAT(NOW(), '%M'); -- Returned the month name - May
SELECT DATE_FORMAT(NOW(), '%m'); -- Returned the month integer - 05

SELECT DATE_FORMAT(NOW(), '%d'); -- Returned 23
SELECT DATE_FORMAT(NOW(), '%D'); -- Returned 23rd

SELECT DATE_FORMAT(NOW(), '%M %d %Y'); -- Returned May 23 2023
SELECT DATE_FORMAT(NOW(), '%D %M %Y'); -- Returned 23rd May 2023

SELECT TIME_FORMAT(NOW(), '%h:%i %p'); -- Returned 5:23 PM
SELECT TIME_FORMAT(NOW(), '%H:%i'); -- Returned 17:27

-- CALCULATING DATES AND TIMES

-- DATE_ADD
-- To add date
SELECT DATE_ADD(NOW(), INTERVAL 1 DAY); -- Returns tomorrow's date at the current time
SELECT DATE_ADD(NOW(), INTERVAL 1 YEAR); -- Returned 2024-05-23 17:37:39

SELECT DATE_SUB(NOW(), INTERVAL 1 YEAR);

-- DATEDIFF
-- Returns the date difference.
-- The latter date is the first parameter to be passed in, followed by the lower one.
SELECT DATEDIFF('2019-02-01 10:00', '2019-01-01 09:00');

-- TIME_TO_SEC
SELECT TIME_TO_SEC('9:02') - TIME_TO_SEC('9:00');

-- IFNULL

USE sql_store;

SELECT 
	order_id,
    IFNULL(shipper_id, 'Not assigned') AS shipper
FROM orders;

-- COALESCE

USE sql_store;

SELECT
	order_id,
    COALESCE(shipper_id, comments, 'Not assigned')
FROM orders;

-- EXERCISE
USE sql_store;

SELECT 
	CONCAT(first_name, ' ', last_name) AS customer,
    COALESCE(phone, 'Unknown') AS phone
FROM customers;

-- IF STATEMENT

SELECT
	order_id,
    order_date,
    IF(YEAR(order_date) = YEAR(NOW()), 'Active', 'Archived') AS category
FROM orders;


-- EXERCISE

USE sql_store;

SELECT
	product_id,
    name,
    COUNT(*) AS orders,
    IF(COUNT(*) > 1, 'Many times', 'Once') As Frequency
FROM products
JOIN order_items
	USING(product_id)
GROUP BY product_id, name;

-- CASE

SELECT 
	order_id,
    CASE
		WHEN YEAR(order_date) = YEAR(NOW()) THEN 'Active'
        WHEN YEAR(order_date) = YEAR(NOW()) - 1 THEN 'Last Year'
        WHEN YEAR(order_date) < YEAR(NOW()) - 1 THEN 'Archived'
        ELSE 'Future'
	END AS category
FROM orders;


-- EXERCISE
USE sql_store;

SELECT 
	CONCAT(first_name, ' ', last_name) AS customer,
    points,
    CASE
		WHEN points > 3000 THEN 'Gold'
        WHEN points >= 2000 THEN 'Silver'
        ELSE 'Bronze'
	END AS category
FROM customers
ORDER BY points DESC;