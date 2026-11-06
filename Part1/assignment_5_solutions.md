# Assignment #5 - Subquery & Correlated Subquery Types
**Topics:** Single-Row, Multi-Row, Multi-Column Subquery, Correlated, Nested, Scalar Subquery, Inline View

---

## 🧩 Section 1: Correlated Subquery

### 1. Find employees who earn more than the average salary in their department.
```sql
SELECT e1.* 
FROM employees e1
WHERE e1.salary > (
    SELECT AVG(e2.salary) 
    FROM employees e2 
    WHERE e2.department_id = e1.department_id
);
```

### 2. List customers who placed more orders than the average orders per customer.
```sql
SELECT c.customer_id, c.customer_name
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.customer_name
HAVING COUNT(o.order_id) > (
    SELECT AVG(order_count)
    FROM (
        SELECT COUNT(order_id) AS order_count
        FROM orders
        GROUP BY customer_id
    ) AS avg_orders
);
```

---

## 🏛 Section 2: Scalar Subquery

### 3. Show each employee and their department name.
```sql
SELECT e.employee_id, e.first_name, e.last_name,
       (SELECT d.department_name 
        FROM departments d 
        WHERE d.department_id = e.department_id) AS department_name
FROM employees e;
```

### 4. For each order, show order_id, amount, and the customer’s city.
```sql
SELECT o.order_id, o.amount,
       (SELECT c.city 
        FROM customers c 
        WHERE c.customer_id = o.customer_id) AS customer_city
FROM orders o;
```

---

## 📦 Section 3: Subquery with IN

### 5. Find employees who work in departments where average salary > 50,000.
```sql
SELECT * 
FROM employees 
WHERE department_id IN (
    SELECT department_id 
    FROM employees 
    GROUP BY department_id 
    HAVING AVG(salary) > 50000
);
```

### 6. Find customers who have orders over $1000.
```sql
SELECT * 
FROM customers 
WHERE customer_id IN (
    SELECT customer_id 
    FROM orders 
    WHERE amount > 1000
);
```

---

## 📏 Section 4: Subquery with EXISTS

### 7. Find customers who have placed at least one order.
```sql
SELECT * 
FROM customers c
WHERE EXISTS (
    SELECT 1 
    FROM orders o 
    WHERE o.customer_id = c.customer_id
);
```

### 8. Find employees who don’t have any co-workers earning more than 70,000 in their department.
```sql
SELECT e1.* 
FROM employees e1
WHERE NOT EXISTS (
    SELECT 1 
    FROM employees e2 
    WHERE e2.department_id = e1.department_id 
      AND e2.employee_id <> e1.employee_id 
      AND e2.salary > 70000
);
```

---

## 🔁 Section 5: Inline View (Derived Table)

### 9. List top 3 highest paid employees per department.
```sql
SELECT department_id, employee_id, first_name, last_name, salary
FROM (
    SELECT department_id, employee_id, first_name, last_name, salary,
           ROW_NUMBER() OVER(PARTITION BY department_id ORDER BY salary DESC) as rank_num
    FROM employees
) as ranked_employees
WHERE rank_num <= 3;
```

### 10. Show each customer and their total spend amount.
```sql
SELECT c.customer_name, spend_summary.total_spend
FROM customers c
JOIN (
    SELECT customer_id, SUM(amount) AS total_spend
    FROM orders
    GROUP BY customer_id
) AS spend_summary ON c.customer_id = spend_summary.customer_id;
```

---

## 🧠 Section 6: Nested Subquery

### 11. Find employees who earn more than the average salary of all employees.
```sql
SELECT * 
FROM employees 
WHERE salary > (
    SELECT AVG(salary) 
    FROM employees
);
```

### 12. Find customers whose total spend is above the average total spend.
```sql
SELECT customer_id, SUM(amount) AS total_spend
FROM orders
GROUP BY customer_id
HAVING SUM(amount) > (
    SELECT AVG(total_customer_spend)
    FROM (
        SELECT SUM(amount) AS total_customer_spend
        FROM orders
        GROUP BY customer_id
    ) AS overall_avg
);
```

---

## 🧠 Section 7: Subquery in SELECT

### 13. Show each employee and their salary difference from department average.
```sql
SELECT e1.employee_id, e1.first_name, e1.last_name, e1.salary,
       e1.salary - (
           SELECT AVG(e2.salary) 
           FROM employees e2 
           WHERE e2.department_id = e1.department_id
       ) AS salary_difference
FROM employees e1;
```

### 14. Show each customer, total orders and total spend.
```sql
SELECT c.customer_id, c.customer_name,
       (SELECT COUNT(*) FROM orders o WHERE o.customer_id = c.customer_id) AS total_orders,
       (SELECT COALESCE(SUM(amount), 0) FROM orders o WHERE o.customer_id = c.customer_id) AS total_spend
FROM customers c;
```

---
*❗❗ Completed Assignment #5 Submission Template*
