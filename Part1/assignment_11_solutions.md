# Assignment #11 - Stored Procedures
**Topics:** Stored Procedures, Cursor, Loop, Repeat

---

## Section 1: Advance Level Index

### 1. Create a stored procedure that takes a department name as input and returns the count of employees in that department.
```sql
DELIMITER //

CREATE PROCEDURE GetEmployeeCountByDept(
    IN p_dept_name VARCHAR(100),
    OUT p_emp_count INT
)
BEGIN
    SELECT COUNT(*) INTO p_emp_count
    FROM employees
    WHERE department = p_dept_name;
END //

DELIMITER ;
```

### 2. Create a stored procedure that accepts two numbers and returns their sum, difference, product, and quotient.
```sql
DELIMITER //

CREATE PROCEDURE CalculateNumbers(
    IN p_num1 DECIMAL(10,2),
    IN p_num2 DECIMAL(10,2),
    OUT p_sum DECIMAL(10,2),
    OUT p_diff DECIMAL(10,2),
    OUT p_prod DECIMAL(10,2),
    OUT p_quot DECIMAL(10,2)
)
BEGIN
    SET p_sum = p_num1 + p_num2;
    SET p_diff = p_num1 - p_num2;
    SET p_prod = p_num1 * p_num2;
    
    IF p_num2 <> 0 THEN
        SET p_quot = p_num1 / p_num2;
    ELSE
        SET p_quot = NULL;
    END IF;
END //

DELIMITER ;
```

### 3. Create a non-clustered index on the product_name column of a products table. Show a query that benefits from this index.
```sql
-- Creating the index
CREATE INDEX idx_product_name ON products(product_name);

-- Query that benefits from the index
SELECT product_id, product_name, price 
FROM products 
WHERE product_name = 'Laptop';
```

### 4. Create a stored procedure that inserts a new user into the users table using name and email as input parameters.
```sql
DELIMITER //

CREATE PROCEDURE InsertUser(
    IN p_name VARCHAR(100),
    IN p_email VARCHAR(150)
)
BEGIN
    INSERT INTO users (name, email) 
    VALUES (p_name, p_email);
END //

DELIMITER ;
```

### 5. Create a stored procedure using a WHILE loop to insert numbers from 1 to 10 into a table called number_series.
```sql
DELIMITER //

CREATE PROCEDURE PopulateNumberSeries()
BEGIN
    DECLARE i INT DEFAULT 1;
    
    WHILE i <= 10 DO
        INSERT INTO number_series (number_value) VALUES (i);
        SET i = i + 1;
    END WHILE;
END //

DELIMITER ;
```

---

## Section 2: Hard Level Events

### 1. Create a stored procedure using a cursor to fetch all user emails from the users table and print them using SELECT statements.
```sql
DELIMITER //

CREATE PROCEDURE FetchAndPrintEmails()
BEGIN
    DECLARE done INT DEFAULT FALSE;
    DECLARE v_email VARCHAR(150);
    
    -- Declare the cursor
    DECLARE email_cursor CURSOR FOR 
        SELECT email FROM users;
        
    -- Declare continue handler
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;
    
    OPEN email_cursor;
    
    read_loop: LOOP
        FETCH email_cursor INTO v_email;
        IF done THEN
            LEAVE read_loop;
        END IF;
        
        -- Print the email using a SELECT statement
        SELECT v_email AS user_email;
    END LOOP;
    
    CLOSE email_cursor;
END //

DELIMITER ;
```

### 2. Create a stored procedure that uses a cursor and loop to increase salary by 10% for all employees in the "Sales" department.
```sql
DELIMITER //

CREATE PROCEDURE IncreaseSalesSalary()
BEGIN
    DECLARE done INT DEFAULT FALSE;
    DECLARE v_emp_id INT;
    
    DECLARE sales_cursor CURSOR FOR 
        SELECT employee_id FROM employees WHERE department = 'Sales';
        
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;
    
    OPEN sales_cursor;
    
    update_loop: LOOP
        FETCH sales_cursor INTO v_emp_id;
        IF done THEN
            LEAVE update_loop;
        END IF;
        
        UPDATE employees 
        SET salary = salary * 1.10 
        WHERE employee_id = v_emp_id;
    END LOOP;
    
    CLOSE sales_cursor;
END //

DELIMITER ;
```

### 3. Create a stored procedure that calculates the factorial of a given number using a REPEAT loop and returns the result.
```sql
DELIMITER //

CREATE PROCEDURE CalculateFactorial(
    IN p_num INT,
    OUT p_result BIGINT
)
BEGIN
    DECLARE i INT DEFAULT 1;
    SET p_result = 1;
    
    IF p_num < 0 THEN
        SET p_result = NULL;
    ELSEIF p_num > 0 THEN
        REPEAT
            SET p_result = p_result * i;
            SET i = i + 1;
        UNTIL i > p_num
        END REPEAT;
    END IF;
END //

DELIMITER ;
```

### 4. Create a stored procedure that deletes all records from a logs table older than 30 days, using a LOOP to delete in batches of 100.
```sql
DELIMITER //

CREATE PROCEDURE DeleteOldLogsInBatches()
BEGIN
    DECLARE affected_rows INT DEFAULT 1;
    
    batch_loop: LOOP
        -- Delete records in batches of 100
        DELETE FROM logs 
        WHERE log_date < NOW() - INTERVAL 30 DAY
        LIMIT 100;
        
        SET affected_rows = ROW_COUNT();
        
        -- Leave loop when no more rows match the criteria
        IF affected_rows = 0 THEN
            LEAVE batch_loop;
        END IF;
    END LOOP;
END //

DELIMITER ;
```

### 5. Write a stored procedure to update the salary of employees in a given department by 10%, using a cursor and loop.
```sql
DELIMITER //

CREATE PROCEDURE UpdateDeptSalary(
    IN p_dept_name VARCHAR(100)
)
BEGIN
    DECLARE done INT DEFAULT FALSE;
    DECLARE v_emp_id INT;
    
    DECLARE dept_cursor CURSOR FOR 
        SELECT employee_id FROM employees WHERE department = p_dept_name;
        
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;
    
    OPEN dept_cursor;
    
    dept_loop: LOOP
        FETCH dept_cursor INTO v_emp_id;
        IF done THEN
            LEAVE dept_loop;
        END IF;
        
        UPDATE employees 
        SET salary = salary * 1.10 
        WHERE employee_id = v_emp_id;
    END LOOP;
    
    CLOSE dept_cursor;
END //

DELIMITER ;
```
