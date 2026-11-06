
use sample;

-- Lets Start with VIEWS 

select * from orders;
select * from products;
select * from payments;
select * from employees;


select MinorOrAdult(19);


SELECT 
    customerName,
    age,
    MinorOrAdult(age) as status
FROM customers;


DELIMITER $$

CREATE FUNCTION MinorOrAdult (person_age INT)
RETURNS VARCHAR(10)
DETERMINISTIC
BEGIN
    RETURN CASE
        WHEN person_age < 18 THEN 'Minor'
        ELSE 'Adult'
    END;
END $$

DELIMITER ;








DELIMITER $$:
-- This sets the delimiter to "$$" instead of the default ";".

CREATE FUNCTION
-- This creates a new function called "addition" that takes two integer parameters (a and b).

BEGIN
-- This is the start of block of code that defines what the function does.

RETURN a + b;
-- This is the actual logic of the function. It adds the two parameters (a and b) together and returns the result.

END$$
-- This marks the end of the function definition block.

DELIMITER ; 
-- This resets the delimiter to ";".



-- EXAMPLE 


DELIMITER $$
-- Creating a function to add two parameters a and b
CREATE FUNCTION ADD_NUM(a INT, b INT) 
	RETURNS INT
		BEGIN
		 RETURN a + b;
		END$$

DELIMITER ;

-- call the addition function
SELECT ADD_NUM(10, 112);


-- TABLE Functions 

-- Creating a Function for getting average as return value from the table

DELIMITER $$

CREATE FUNCTION Demoavg()
RETURNS INT
DETERMINISTIC
BEGIN
    DECLARE result INT;
    -- Use SELECT INTO to assign value to variable
    SELECT AVG(`salary`) INTO result 
    FROM sample.employess;

    RETURN result;
END $$

DELIMITER ;



















ALTER FUNCTION func_name [characteristic ...]

characteristic: {
    COMMENT 'string'
  | LANGUAGE SQL
  | { CONTAINS SQL | NO SQL | READS SQL DATA | MODIFIES SQL DATA }
  | SQL SECURITY { DEFINER | INVOKER }
}






SHOW FUNCTION STATUS WHERE Db = 'sample';

SHOW CREATE FUNCTION CalculateAgeFromDOB;

-- Step 1: Remove old version
DROP FUNCTION IF EXISTS MinorOrAdult;

-- Step 2: Create new version
DELIMITER $$

CREATE FUNCTION MinorOrAdult(person_age INT)
RETURNS VARCHAR(10)
DETERMINISTIC
BEGIN
    RETURN CASE
        WHEN person_age IS NULL THEN 'Unknown'
        WHEN person_age < 18 THEN 'Minor'
        ELSE 'Adult'
    END;
END $$

DELIMITER ;

CREATE TABLE birthdays (
    emp_id bigint,
    birthday date,
    constraint foreign key (emp_id) references employees(id)
);


DELIMITER $$
	CREATE FUNCTION Demoavg()
	  RETURNS DECIMAL
	  DETERMINISTIC
      READS SQL DATA
		BEGIN
			DECLARE result DECIMAL;
			SELECT AVG(`salary`) INTO result 
			FROM sample.employees;
			RETURN result;
		END $$
DELIMITER ;

-- call the addition function
SELECT ADD_NUM(10, 12);


drop function demoavg;
select sample.demoavg() as avg;


DELIMITER $$

-- Creating a function to add two parameters a and b
CREATE FUNCTION ADD_NUM(a INT, b INT) RETURNS INT
BEGIN
RETURN a + b;
END$$
customers
DELIMITER ;




-- IsValidEmail — simple email check

DELIMITER $$

CREATE FUNCTION IsValidEmail(email VARCHAR(255))
RETURNS bool
DETERMINISTIC
BEGIN
    RETURN CASE
        WHEN email LIKE '%@%.%' THEN TRUE
        ELSE FALSE
    END;
END $$

DELIMITER ;


-- GetDiscount — discount by age

DELIMITER $$

CREATE FUNCTION GetDiscount(person_age INT)
RETURNS INT
DETERMINISTIC
BEGIN
    RETURN CASE
        WHEN person_age < 18 THEN 20   -- 20% discount for minors
        WHEN person_age >= 60 THEN 30  -- 30% for senior citizens
        ELSE 0                         -- No discount
    END;
END $$

DELIMITER ;

-- CalculateAgeFromDOB

DELIMITER $$

CREATE FUNCTION CalculateAgeFromDOB(dob DATE)
RETURNS INT
DETERMINISTIC
BEGIN
    RETURN TIMESTAMPDIFF(YEAR, dob, CURDATE());
END $$

DELIMITER ;

select * from customers;

SELECT customerName, dob, CalculateAgeFromDOB(dob) AS age FROM customers;


select custId,customerName,MaskEmail(custEmail),IsValidEmail(custEmail) as valid from customers;


-- MaskEmail

DELIMITER $$

CREATE FUNCTION MaskEmail(email VARCHAR(255))
RETURNS VARCHAR(255)
DETERMINISTIC
BEGIN
    DECLARE at_pos INT;
    DECLARE name_part VARCHAR(255);
    DECLARE domain_part VARCHAR(255);
    DECLARE masked_name VARCHAR(255);
    
    SET at_pos = LOCATE('@', email);
    SET name_part = LEFT(email, at_pos - 1);
    SET domain_part = SUBSTRING(email, at_pos);
    
    IF LENGTH(name_part) <= 2 THEN
        SET masked_name = CONCAT(LEFT(name_part, 2), '*');
    ELSE
        SET masked_name = CONCAT(LEFT(name_part, 3), REPEAT('*', LENGTH(name_part) - 2), RIGHT(name_part, 1));
    END IF;
    
    RETURN CONCAT(masked_name, domain_part);
END $$

DELIMITER ;



-- NormalizePhone

DELIMITER $$

CREATE FUNCTION NormalizePhone(phone VARCHAR(20))
RETURNS VARCHAR(20)
DETERMINISTIC
BEGIN
    DECLARE i INT DEFAULT 1;
    DECLARE len INT;
    DECLARE cleaned VARCHAR(20) DEFAULT '';
    SET len = CHAR_LENGTH(phone);
    
    WHILE i <= len DO
        IF SUBSTRING(phone, i, 1) REGEXP '[0-9]' THEN
            SET cleaned = CONCAT(cleaned, SUBSTRING(phone, i, 1));
        END IF;
        SET i = i + 1;
    END WHILE;
    
    RETURN cleaned;
END $$

DELIMITER ;


-- MonthlyInstallment

DELIMITER $$

CREATE FUNCTION MonthlyInstallment(principal DECIMAL(10,2), annual_rate DECIMAL(5,2), months INT)
RETURNS DECIMAL(10,2)
DETERMINISTIC
BEGIN
    DECLARE r DECIMAL(10,8);
    DECLARE emi DECIMAL(10,2);
    SET r = annual_rate / (12 * 100);
    SET emi = principal * r * POW(1 + r, months) / (POW(1 + r, months) - 1);
    RETURN emi;
END $$

DELIMITER ;

SELECT MonthlyInstallment(100000, 7.5, 60) AS emi;


-- DaysBetweenDates

DELIMITER $$

CREATE FUNCTION DaysBetweenDates(start_date DATE, end_date DATE)
RETURNS INT
DETERMINISTIC
BEGIN
    RETURN DATEDIFF(end_date, start_date);
END $$

DELIMITER ;

SELECT DaysBetweenDates('2024-01-01', '2024-12-31') AS days_diff;


