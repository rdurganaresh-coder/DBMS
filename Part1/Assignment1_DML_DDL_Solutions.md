# DML / DDL Practice Assignment with Solutions

This document contains a structured set of practice questions and their corresponding SQL solutions, divided into Data Manipulation Language (DML) and Data Definition Language (DDL) sections.

---

## DML Section (Data Manipulation Language)

Data Manipulation Language commands are used to manage data within existing schema objects. This includes inserting, updating, and deleting rows.

### 1. Insert a New Employee
* **Task:** Insert a new employee into the `employees` table.
```sql
INSERT INTO employees (employeeID, firstName, lastName, department, salary) 
VALUES (201, 'John', 'Doe', 'IT', 45000);
```

### 2. Update Employee Salary by ID
* **Task:** Update the salary of an employee whose ID is 105 to 50,000.
```sql
UPDATE employees 
SET salary = 50000 
WHERE employeeID = 105;
```

### 3. Conditional Row Deletion
* **Task:** Delete all employees from the `employees` table who have a salary less than 10,000.
```sql
DELETE FROM employees 
WHERE salary < 10000;
```

### 4. Bulk Salary Increase
* **Task:** Increase salary by 15% for all employees in the 'Marketing' department.
```sql
UPDATE employees 
SET salary = salary * 1.15 
WHERE department = 'Marketing';
```

### 5. Table Copying / Backup
* **Task:** Copy all rows from `products` to a new table called `products_backup`.
```sql
CREATE TABLE products_backup AS 
SELECT * FROM products;
```

### 6. Handle NULL Dates
* **Task:** Set all `shippedDate` values to today's date for orders that are not yet shipped.
```sql
UPDATE orders 
SET shippedDate = CURRENT_DATE 
WHERE shippedDate IS NULL;
```

### 7. Rename Department Values
* **Task:** Change the department name from 'Sale' to 'Sales' in the `employees` table.
```sql
UPDATE employees 
SET department = 'Sales' 
WHERE department = 'Sale';
```

### 8. Insert Dummy Product Data
* **Task:** Insert a new product into the `products` table with appropriate dummy data.
```sql
INSERT INTO products (productCode, productName, productLine, buyPrice) 
VALUES ('P101', 'Test Product', 'Classic Cars', 55.00);
```

### 9. Delete Unspecified Order Dates
* **Task:** Delete all orders with NULL as `orderDate`.
```sql
DELETE FROM orders 
WHERE orderDate IS NULL;
```

### 10. Standardize String Casing
* **Task:** Update all `customerNames` to uppercase in the `customers` table.
```sql
UPDATE customers 
SET customerName = UPPER(customerName);
```

---

## DDL Section (Data Definition Language)

Data Definition Language commands are used to define, modify, or destroy the structure of database objects like tables, views, and indexes.

### 1. Create a New Table
* **Task:** Create a new table called `departments` with fields: `dept_id`, `dept_name`, and `location`.
```sql
CREATE TABLE departments (
    dept_id INT PRIMARY KEY, 
    dept_name VARCHAR(50), 
    location VARCHAR(100)
);
```

### 2. Add a Column to an Existing Table
* **Task:** Add a new column `bonus` of type `DECIMAL(10,2)` to the `employees` table.
```sql
ALTER TABLE employees 
ADD bonus DECIMAL(10,2);
```

### 3. Rename a Table
* **Task:** Rename the `products_backup` table to `archived_products`.
```sql
RENAME TABLE products_backup TO archived_products;
```

### 4. Conditionally Drop a Table
* **Task:** Drop the `temp_sales` table if it exists.
```sql
DROP TABLE IF EXISTS temp_sales;
```

### 5. Modify Column Constraints
* **Task:** Modify the `salary` column in the `employees` table to allow NULL values.
```sql
ALTER TABLE employees 
MODIFY salary DECIMAL(10,2) NULL;
```

### 6. Add Primary Key Constraint Separately
* **Task:** Add a primary key constraint to the `departments` table on `dept_id`.
```sql
ALTER TABLE departments 
ADD CONSTRAINT pk_dept PRIMARY KEY (dept_id);
```

### 7. Create a Database View
* **Task:** Create a view called `high_earners` that shows employees with salary above 60,000.
```sql
CREATE VIEW high_earners AS 
SELECT * FROM employees 
WHERE salary > 60000;
```

### 8. Create a Database Index
* **Task:** Create a new index on the `lastName` column in the `employees` table.
```sql
CREATE INDEX idx_lastname 
ON employees(lastName);
```

### 9. Add a Unique Constraint
* **Task:** Add a unique constraint to the `email` column in the `employees` table.
```sql
ALTER TABLE employees 
ADD CONSTRAINT unique_email UNIQUE (email);
```

### 10. Create an Audit Table
* **Task:** Create a new table `audit_log` with columns: `action_id`, `action_type`, `timestamp`.
```sql
CREATE TABLE audit_log (
    action_id INT PRIMARY KEY, 
    action_type VARCHAR(50), 
    timestamp DATETIME
);
```
