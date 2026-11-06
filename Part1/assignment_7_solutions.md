# 📘 Assignment #7 - Functions, UD Functions & Types of Func

**Topics:** User Defined Functions & Types of functions scaler, table, multi rows

---

### 🧩 Section 1: Scalar Functions

* **Use a function to display customer names in uppercase.**
  ```sql
  SELECT UPPER(customerName) FROM customers;
  ```

* **Use a function to get the current date and time of the system.**
  ```sql
  SELECT NOW(); -- Or CURRENT_TIMESTAMP
  ```

---

### 🏛 Section 2: Aggregate Functions

* **Find the total number of orders placed by all customers.**
  ```sql
  SELECT COUNT(orderID) FROM orders;
  ```

* **Calculate the average salary of employees in the company.**
  ```sql
  SELECT AVG(salary) FROM employees;
  ```

---

### 📦 Section 3: String Functions (Scalar)

* **Extract the first 3 letters of each product name.**
  ```sql
  SELECT SUBSTRING(productName, 1, 3) FROM products; -- Or LEFT(productName, 3)
  ```

* **Find the length of each customer’s full name.**
  ```sql
  SELECT LENGTH(customerName) FROM customers;
  ```

---

### 📏 Section 4: Date Functions (Scalar)

* **Get the current year and subtract it from the year of joining to get years of service.**
  ```sql
  SELECT YEAR(CURRENT_DATE) - YEAR(joiningDate) AS years_of_service FROM employees;
  ```

* **Display all customers who registered in the current month.**
  ```sql
  SELECT * FROM customers WHERE MONTH(registrationDate) = MONTH(CURRENT_DATE) AND YEAR(registrationDate) = YEAR(CURRENT_DATE);
  ```

---

### 🔁 Section 5: Numeric Functions (Scalar)

* **Round off the product price to 2 decimal places.**
  ```sql
  SELECT ROUND(price, 2) FROM products;
  ```

* **Display the absolute difference between order quantity and stock.**
  ```sql
  SELECT ABS(orderQuantity - stockQuantity) FROM orders JOIN products USING(productCode);
  ```

---

### 🧠 Section 6: User Defined Function (UDF) - Business Logic

* **Create a UDF to calculate total price = price * quantity.**
  ```sql
  CREATE FUNCTION CalculateTotalPrice(price DECIMAL(10,2), quantity INT)
  RETURNS DECIMAL(10,2)
  DETERMINISTIC
  BEGIN
      RETURN price * quantity;
  END;
  ```

* **Use this function to get the total amount for all orders.**
  ```sql
  SELECT orderID, CalculateTotalPrice(priceEach, quantityOrdered) AS total_amount FROM orderdetails;
  ```

---

### 🧠 Section 7: User Defined Function (UDF) - Category Label

* **Create a UDF that returns 'Adult' or 'Minor' based on date of birth.**
  ```sql
  CREATE FUNCTION GetAgeCategory(dob DATE)
  RETURNS VARCHAR(10)
  DETERMINISTIC
  BEGIN
      DECLARE age INT;
      SET age = YEAR(CURRENT_DATE) - YEAR(dob);
      IF age >= 18 THEN
          RETURN 'Adult';
      ELSE
          RETURN 'Minor';
      END IF;
  END;
  ```

* **Use it to label all customers in a report.**
  ```sql
  SELECT customerName, dob, GetAgeCategory(dob) AS age_group FROM customers;
  ```

---

### 🧠 Section 8: Combining Functions

* **Concatenate first name and last name, and display it in uppercase.**
  ```sql
  SELECT UPPER(CONCAT(firstName, ' ', lastName)) AS full_name FROM employees;
  ```

* **Display the number of days between order date and delivery date.**
  ```sql
  SELECT DATEDIFF(deliveryDate, orderDate) AS days_to_deliver FROM orders;
  ```
