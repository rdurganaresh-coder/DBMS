# Lesson 11: Practice / Assignment
**Topics Covered:** Basic Queries, Aggregations, Filtering, Conditional logic (`CASE`, `COALESCE`, `NULLIF`), and String manipulation.

This document compiles the practice questions along with their optimized and completed SQL solutions.

---

## 📋 Query Tasks & Solutions

### 1. Fetch all columns for all employees
* **Question:** Write a query to fetch all columns for all employees.
```sql
SELECT * 
FROM employees;
```

### 2. Fetch unique products from orders
* **Question:** Fetch the unique product from the orders table.
```sql
SELECT DISTINCT productCode 
FROM orderdetails;
```

### 3. Filter employees by department
* **Question:** Fetch all details of employees who belong to the 'Sales' department.
```sql
SELECT * 
FROM employees 
WHERE UPPER(department) = 'SALES';
```

### 4. Format names and handle zero salaries with aliases
* **Question:** Fetch the employee names and their salaries with column aliases "Name" and "Income". Show 'Intern' if income is 0.
```sql
SELECT 
    CONCAT(firstName, ' ', lastName) AS Name,
    COALESCE(NULLIF(CAST(salary AS CHAR), '0'), 'Intern') AS Income 
FROM employees;
```

### 5. Filter products by baseline price
* **Question:** Show all products buy price above 50 Dollar.
```sql
SELECT * 
FROM products 
WHERE buyPrice > 50.00;
```

### 6. Fetch top earners
* **Question:** Fetch the top 2 highest paid employees in our company.
```sql
SELECT * 
FROM employees 
ORDER BY salary DESC 
LIMIT 2;
```

### 7. Filter employees using OR logical operator
* **Question:** Get employees who are either in Sales or have a salary above 30,000.
```sql
SELECT * 
FROM employees 
WHERE department = 'Sales' OR salary > 30000;
```

### 8. Filter products within a range
* **Question:** Fetch products with a price between 20 and 100.
```sql
SELECT * 
FROM products 
WHERE buyPrice BETWEEN 20 AND 100;
```

### 9. Filter orders matching specific product categories
* **Question:** Retrieve orders where the product line matches 'Vintage Cars' or 'Motorcycles' (or specific products match 'Laptop' or 'Tablet').
```sql
SELECT * 
FROM products 
WHERE productLine IN ('Vintage Cars', 'Motorcycles');
```

### 10. Pattern matching for prefixes
* **Question:** Find employee names starting with 'J'.
```sql
SELECT * 
FROM employees 
WHERE firstName LIKE 'J%';
```

### 11. Case-insensitive substring matching
* **Question:** Case-insensitive search for employee names containing 'son'.
```sql
SELECT * 
FROM employees 
WHERE LOWER(firstName) LIKE '%son%' OR LOWER(lastName) LIKE '%son%';
```

### 12. Evaluate conditional logic thresholds
* **Question:** Display employee names along with their salary category as 'High' if above 35,000, else 'Low'.
```sql
SELECT 
    CONCAT(firstName, ' ', lastName) AS Name,
    salary,
    CASE 
        WHEN salary > 35000 THEN 'High'
        ELSE 'Low'
    END AS salary_category
FROM employees;
```

### 13. Handle missing delivery timestamps
* **Question:** Show the delivery date, but if it is NULL, display 'Pending'.
```sql
SELECT 
    orderNumber,
    COALESCE(CAST(shippedDate AS CHAR), 'Pending') AS status
FROM orders;
```

### 14. Identify matching columnar values
* **Question:** Compare two columns and return NULL if they are the same (or display custom flag).
```sql
SELECT 
    NULLIF(firstName, lastName) AS evaluated_mismatch
FROM employees;
```

### 15. Apply structural adjustments to numerical metrics
* **Question:** Display employee names and their salary incremented by 10% as "New Salary".
```sql
SELECT 
    CONCAT(firstName, ' ', lastName) AS Name,
    salary,
    salary * 1.10 AS `New Salary`
FROM employees;
```

### 16. Combine multi-clause grouping logic
* **Question:** Get the employees who are either in 'Sales' or 'Marketing' department and earn more than 30,000.
```sql
SELECT * 
FROM employees 
WHERE department IN ('Sales', 'Marketing') 
  AND salary > 30000;
```

### 17. Conditional stock evaluation
* **Question:** Show the product name and its availability status as 'In Stock' if the quantity is more than 0, else 'Out of Stock'.
```sql
SELECT 
    productName,
    CASE 
        WHEN quantityInStock > 0 THEN 'In Stock'
        ELSE 'Out of Stock'
    END AS availability_status
FROM products;
```

### 18. Substitute missing structural delivery entries
* **Question:** Display customer names and delivery dates, but if the delivery date is NULL, show 'Not Delivered'.
```sql
SELECT 
    customerName,
    COALESCE(CAST(shippedDate AS CHAR), 'Not Delivered') AS delivery_status
FROM customers c
LEFT JOIN orders o ON c.customerNumber = o.customerNumber;
```

### 19. Multi-criteria wildcards and ordering
* **Question:** Retrieve all products whose names contain the letter 'a' (case-insensitive) and are priced between 50 and 200, ordered by price in ascending order.
```sql
SELECT * 
FROM products 
WHERE LOWER(productName) LIKE '%a%' 
  AND buyPrice BETWEEN 50 AND 200 
ORDER BY buyPrice ASC;
```

### 20. Aggregate distinct instances
* **Question:** Count the number of different products sold.
```sql
SELECT COUNT(DISTINCT productCode) AS unique_products_sold 
FROM orderdetails;
```

### 21. Count instances against boundary parameters
* **Question:** Count how many employees have salaries above 70,000.
```sql
SELECT COUNT(*) AS high_earners_count 
FROM employees 
WHERE salary > 70000;
```
