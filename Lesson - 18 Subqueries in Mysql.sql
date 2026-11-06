use sample;


select * from orders;
select * from products;
select * from payments;
select * from employees;

select * from orders;

SELECT empName, (SELECT MAX(salary) FROM employees where) AS max_salary FROM employees;

SELECT department, AVG(salary) AS avg_salary 
      FROM employees 
      GROUP BY department;
      

SELECT dept_name, avg_salary 
FROM (SELECT department, AVG(salary) AS avg_salary 
      FROM employees 
      GROUP BY department) AS dept_avg 
JOIN departments ON dept_avg.department = departments.dept_id;




-- Order Id 10100


SELECT e1.empName, e1.salary , e1.department,d.dept_name
FROM employees e1 
join departments d on d.dept_id = e1.department
WHERE e1.salary = (SELECT MAX(e2.salary) FROM employees e2 WHERE e1.department = e2.department);
















-- Find products bought in orders by customers with Gmail addresses.



SELECT
    productCode
FROM
    orderdetails
WHERE
    orderNumber IN (
        SELECT
            orderNumber
        FROM
            orders
        WHERE
            custId IN (
                SELECT
                    custId
                FROM
                    customers
                WHERE
                    custEmail LIKE '%@gmail.com'
            )
    );








-- Find orders with same product and quantity as order #10100.

SELECT * FROM orderDetails
WHERE (productCode, quantityOrdered) IN
(SELECT productCode, quantityOrdered FROM orderDetails WHERE orderNumber = 10100);



  

  
-- List students who scored more than the average score in their class
  
  SELECT s.student_id, s.name, s.class_id, s.score
FROM students s
WHERE s.score > (
  SELECT AVG(s2.score)
  FROM students s2
  WHERE s2.class_id = s.class_id
);




-- Find employees who have the highest salary in their department


SELECT e1.employee_id, e1.name, e1.salary, e1.department_id
FROM employees e1
WHERE e1.salary = (
  SELECT MAX(e2.salary)
  FROM employees e2
  WHERE e2.department_id = e1.department_id
);








