-- Windows Function -- ADV LESSON 28


-- Revision Aggregate Window Function

SUM(): Sums values within a window.
AVG(): Calculates the average value within a window.
COUNT(): Counts the rows within a window.
MAX(): Returns the maximum value in the window.
MIN(): Returns the minimum value in the window.

use sample;

select * from sales;

SELECT 
    id,
    region,
    employee,
    amount,
    SUM(amount) OVER (PARTITION BY region) AS region_total
FROM sales;

-- Without windows function 

SELECT s.*
FROM sales s
JOIN (
  SELECT region, MAX(amount) AS max_amount
  FROM sales
  GROUP BY region
) t ON s.region = t.region AND s.amount = t.max_amount;




# OVER 

-- Defines the window (or "scope") for the function to operate on.
-- Without OVER: ROW_NUMBER() cannot work because it needs to know how to group and order rows.
  
# PARTITION BY column

-- Splits the rows into groups (partitions) based on column value.


# ORDER BY column ASC/DESC

-- Same work but with windows partition by OVER keyword










top salaries of employees by particular department

-- WITH CTE

SELECT  * from employees;
WITH ranked AS (
  SELECT 
    department,
    empName,
    salary,
    ROW_NUMBER() OVER (PARTITION BY department ORDER BY salary DESC) AS rowNum
  FROM employees
)

SELECT department FROM ranked WHERE rowNum = 1;



   


#Find latest order of each customer

SELECT order_id, customer_id, order_date,
ROW_NUMBER() OVER (PARTITION BY customer_id ORDER BY order_date DESC) AS row_num
FROM orders;



SELECT customer_id, SUM(amount) AS total_sales,
RANK() OVER (ORDER BY SUM(amount) DESC) AS sales_rank
FROM orders
GROUP BY customer_id;



-- ROW_NUMBER()

#Use: Assigns a unique sequential number to each row in the result set.

-- Top 1 Order per Customer (e.g., finding latest purchase of each customer).

SELECT 
    orderId,
    custId,
    orderDate,
    ROW_NUMBER() OVER (PARTITION BY custId ORDER BY orderDate DESC) AS row_num
FROM orders;



-- RANK()



#Use: Assigns rank to rows. Ties get the same rank, and the next rank is skipped.

-- Find Top-Selling Products where ties should have same rank.
select * from order_items;

SELECT 
    productCode,
    SUM(priceEach * qty) AS total_sales,
    RANK() OVER (ORDER BY SUM(priceEach * qty) DESC) AS `rank`
FROM order_items
GROUP BY productCode;


select * from sales;


SELECT 
    employee,
    SUM(amount) AS total_sales,
    DENSE_RANK() OVER (ORDER BY SUM(amount) DESC) AS `rank`
FROM sales
GROUP BY employee;


-- DENSE_RANK()

#Use: Similar to RANK(), but no ranks are skipped.

-- Sales Competition where products with equal sales get same rank without skipping.

SELECT 
    product_id,
    SUM(sales) AS total_sales,
    DENSE_RANK() OVER (ORDER BY SUM(sales) DESC) AS dense_rank
FROM order_details
GROUP BY product_id;


-- PERCENT_RANK()

#Use: Computes the relative rank of a row (0 to 1 scale).

-- Find Performance Percentiles of employees or students.


0 to 1 

0% 10% 30% 50%
0  0.1  0.3 0.5 1

select * from employees;
SELECT 
    eId,
    salary,
    PERCENT_RANK() OVER (ORDER BY salary asc) AS salary_percent_rank
FROM employees;









-- NTILE(n)

#Use: Distributes rows into n buckets as evenly as possible.

-- Divide Employees into Salary Quartiles for HR analytics.

SELECT 
    eId,
    salary,
    NTILE(4) OVER (ORDER BY salary DESC) AS salary_quartile
FROM employees;


-- LAG() 

#Use: Accesses data from the previous row within the same result set.

select * from sales;

SELECT  
    id,
    region,
    amount,
    LAG(amount, 1) OVER (ORDER BY id) AS previous_amount
FROM sales;



-- LEAD()

#Use: Accesses data from the next row within the same result set.

SELECT  
    id,
    region,
    amount,
    LAG(amount, 1) OVER (ORDER BY id) AS previous_amount,
    LEAD(amount, 1) OVER (ORDER BY id) AS next_amount
FROM sales;






-- FIRST_VALUE()

#Use: Returns the first value in an ordered set.

-- Identify First Purchase Date of a customer.


SELECT 
    orderId,
    orderDate,
    status,
    custId,
    FIRST_VALUE(orderDate) OVER (PARTITION BY custId ORDER BY orderDate) AS first_order_date
FROM orders;

SELECT  * from orders where custId = 103 order by orderDate asc;


-- LAST_VALUE()

#Use: Returns the last value in an ordered set.

-- Find Most Recent Transaction per customer.

SELECT 
    orderId,
    orderDate,
    status,
    custId,
    LAST_VALUE(orderDate) OVER 
    (PARTITION BY custId ORDER BY orderDate ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING
 )
       AS last_order_date
FROM orders;


SELECT  * from orders where custId = 103 order by orderDate desc;


-- NTH_VALUE()

#Use: Fetches the nth value from the window.

-- Find Second Purchase Date (or any nth event).
SELECT 
    custId,
    NTH_VALUE(orderDate, 4) OVER (PARTITION BY custId ORDER BY orderDate) AS second_order_date
FROM orders;









890 - 1000  = 89%
890 - 1000  = 48%
 

-- CUME_DIST() 

#Use: Relative standing of a row within a group.
 
-- Salary Percentile Analysis (e.g., find employees in the top 10% salary range).

SELECT 
    eId,
    salary,
    CUME_DIST() OVER (ORDER BY salary asc) AS salary_distribution
FROM employees;



-- Common Uses in Real Scenarios

Ranking Data (RANK, DENSE_RANK, ROW_NUMBER)

-- Find top 3 highest-paid employees in each department.

SELECT 
    department,
    employee_name,
    salary,
    RANK() OVER (PARTITION BY department ORDER BY salary DESC) AS rank
FROM employees;


-- Running Totals & Cumulative Sums

#Example: Calculate cumulative sales by date.
SELECT 
    order_date,
    SUM(amount) OVER (ORDER BY order_date) AS cumulative_sales
FROM orders;



#Example: Calculate a 7-day rolling average.

SELECT 
    order_date,
    AVG(amount) OVER (ORDER BY order_date ROWS BETWEEN 6 PRECEDING AND CURRENT ROW) AS moving_avg
FROM orders;


#Example: Find each student's percentile based on scores.   

SELECT 
    student_id,
    score,
    PERCENT_RANK() OVER (ORDER BY score DESC) AS percentile
FROM students;








