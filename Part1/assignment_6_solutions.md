# Assignment #6 - Views Practice Questions
**Topics:** Views, Updatable Views, Materialized Views

---

## 🧩 Section 1: Simple Views

### 1️⃣ Create a view to show employee names and their salaries.
```sql
CREATE VIEW view_employee_salaries AS
SELECT first_name, last_name, salary
FROM employees;
```

### 2️⃣ Create a view to display department names with total employees in each.
```sql
CREATE VIEW view_department_employee_count AS
SELECT department_name, COUNT(employee_id) AS total_employees
FROM departments d
LEFT JOIN employees e ON d.department_id = e.department_id
GROUP BY department_name;
```

---

## 🏛 Section 2: Complex Views

### 3️⃣ Create a view to show employee names, department names, and salary.
```sql
CREATE VIEW view_employee_department_details AS
SELECT e.first_name, e.last_name, d.department_name, e.salary
FROM employees e
INNER JOIN departments d ON e.department_id = d.department_id;
```

### 4️⃣ Create a view to show departments having an average salary greater than 50,000.
```sql
CREATE VIEW view_high_salary_departments AS
SELECT d.department_name, AVG(e.salary) AS average_salary
FROM departments d
INNER JOIN employees e ON d.department_id = e.department_id
GROUP BY d.department_name
HAVING AVG(e.salary) > 50000;
```

---

## 🖊 Section 3: Updatable Views

### 5️⃣ Create an updatable view for employee name and salary only.
```sql
-- For a view to be updatable, it must map directly to a single base table without aggregations
CREATE VIEW view_updatable_employee_salary AS
SELECT employee_id, first_name, last_name, salary
FROM employees;
```

### 6️⃣ Update salary through the updatable view.
```sql
UPDATE view_updatable_employee_salary
SET salary = 55000
WHERE employee_id = 101;
```

---

## 📌 Section 4: Materialized Views

### 7️⃣ Create a materialized view to store the total salary per department.
```sql
-- Note: Syntax varies by engine (e.g., PostgreSQL / Oracle). MySQL does not natively support materialized views.
CREATE MATERIALIZED VIEW mv_department_total_salary AS
SELECT department_id, SUM(salary) AS total_salary
FROM employees
GROUP BY department_id;
```

### 8️⃣ Refresh the materialized view.
```sql
-- PostgreSQL syntax
REFRESH MATERIALIZED VIEW mv_department_total_salary;

-- Oracle syntax alternative:
-- EXECUTE DBMS_MVIEW.REFRESH('mv_department_total_salary');
```

---
**Submit it after complete ❗❗**
