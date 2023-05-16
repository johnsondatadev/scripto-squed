-- Exercise 4

-- Table Structure ---- CITY

-- Field	   		|    Type
-- ID				|	Number
-- Name				|	Varchar
-- countrycode		|	varchar
-- district			| 	varchar
-- population		|	Number

-- Query the sum of the populations for all Japanese cities in CITY. The COUNTRYCODE
-- for Japan is JPN

SELECT SUM(population)
FROM city
WHERE countrycode='JPN';

-- Query the difference between the maximum and minimum populations in city
SELECT MAX(population) - MIN(population)
FROM city;

-- Table Structure ---- CITY

-- Column	   		|    Type
-- ID				|	Integer
-- Name				|	String
-- salalry			|	Integer

-- Samantha was tasked with calculating the average monthly salaries for all 
-- employees in the EMPLOYEES table, but did not realize her keyboard's 0 key was 
-- broken until after completing the calculation. She wants your help finding the 
-- difference between her miscalculation (using salaries with any zeros removed), and
--  the actual average salary.
-- Write a query calculating the amount of error (i.e.: actual - miscalculated 
-- average monthly salaries), and round it up to the next integer.







