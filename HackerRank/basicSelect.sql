-- Query the Name of any student in STUDENTS who scored higher than 75 Marks. 
-- Order your output by the last three characters of each name. 
-- If two or more students both have names ending in the same last three characters 
-- (i.e.: Bobby, Robby, etc.), secondary sort them by ascending ID.
-- Table Structure ----

-- Column   |    Type
-- ID		|	Integer
-- Name		|	String
-- Marks	|	Integer

SELECT name
FROM students
WHERE marks > 75
ORDER BY SUBSTRING(name, LENGTH(name) - 2), ID ASC; 

-- The ORDER BY can also be written as

-- ORDER BY RIGHT(name, 3), ID ASC;


-- Exercise 2

-- Table Structure ----

-- Column   		|    Type
-- employee_id		|	Integer
-- name				|	String
-- months			|	Integer
-- salary			| 	Integer

-- Write a query that prints a list of employee names 
-- (i.e.: the name attribute) from the Employee table in alphabetical order.

SELECT name
FROM employee
ORDER BY name;

-- Exercise 3

-- Write a query that prints a list of employee names 
-- (i.e.: the name attribute) for employees in Employee having a salary greater than
-- $2000 per month who have been employees for less than 10 months. 
-- Sort your result by ascending employee_id.

SELECT name
FROM employee
WHERE salary > 2000
    AND months < 10
ORDER BY employee_id;




