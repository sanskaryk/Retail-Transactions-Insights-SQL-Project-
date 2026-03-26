# Retail Transactions & Insights using SQL

## Project Overview

**Project Title**: Retail Transactions & Insights 
**Level**: Intermediate  
**Database**: `store_sales_db`

This project showcases practical SQL skills used in data analysis to examine retail transaction data. It includes database creation, data preprocessing, exploratory analysis, and solving business-related problems using SQL queries. It is well-suited for beginners aiming to strengthen their SQL fundamentals.

## Objectives

1. **Database Setup**: Build and populate a structured database using provided sales data.
2. **Data Cleaning**: Detect and handle missing or inconsistent records.
3. **Exploratory Analysis**: Understand data distribution, customers, and product categories.
4. **Business Insights**: Answer real-world business questions using SQL.

## Project Structure

### 1. Database Initialization

- Create a database named `store_sales_db`
- Define a table `sales_data` to store transaction records

```sql
CREATE DATABASE store_sales_db;

CREATE TABLE sales_data
(
    transaction_id INT PRIMARY KEY,
    sale_date DATE,
    sale_time TIME,
    customer_id INT,
    gender VARCHAR(10),
    age INT,
    category VARCHAR(35),
    quantity INT,
    unit_price FLOAT,
    cogs FLOAT,
    total_amount FLOAT
);
````

---

### 2. Data Exploration & Cleaning

* Count total records
* Identify unique customers
* List product categories
* Detect and remove null values

```sql
SELECT COUNT(*) FROM sales_data;
SELECT COUNT(DISTINCT customer_id) FROM sales_data;
SELECT DISTINCT category FROM sales_data;

SELECT * FROM sales_data
WHERE 
    sale_date IS NULL OR sale_time IS NULL OR customer_id IS NULL OR 
    gender IS NULL OR age IS NULL OR category IS NULL OR 
    quantity IS NULL OR unit_price IS NULL OR cogs IS NULL;

DELETE FROM sales_data
WHERE 
    sale_date IS NULL OR sale_time IS NULL OR customer_id IS NULL OR 
    gender IS NULL OR age IS NULL OR category IS NULL OR 
    quantity IS NULL OR unit_price IS NULL OR cogs IS NULL;
```

---

### 3. Data Analysis & Insights

Below are sample business queries:

1. Retrieve sales for a specific date:

```sql
SELECT *
FROM sales_data
WHERE sale_date = '2022-11-05';
```

2. Transactions with high quantity in a category:

```sql
SELECT *
FROM sales_data
WHERE 
    category = 'Clothing'
    AND TO_CHAR(sale_date, 'YYYY-MM') = '2022-11'
    AND quantity >= 4;
```

3. Total revenue by category:

```sql
SELECT 
    category,
    SUM(total_amount) AS total_revenue,
    COUNT(*) AS order_count
FROM sales_data
GROUP BY category;
```

4. Average customer age for a category:

```sql
SELECT 
    ROUND(AVG(age), 2) AS average_age
FROM sales_data
WHERE category = 'Beauty';
```

5. High-value transactions:

```sql
SELECT *
FROM sales_data
WHERE total_amount > 1000;
```

6. Transactions grouped by gender and category:

```sql
SELECT 
    category,
    gender,
    COUNT(*) AS transactions
FROM sales_data
GROUP BY category, gender
ORDER BY category;
```

7. Best-performing month each year:

```sql
SELECT *
FROM (
    SELECT 
        EXTRACT(YEAR FROM sale_date) AS year,
        EXTRACT(MONTH FROM sale_date) AS month,
        AVG(total_amount) AS avg_sales,
        RANK() OVER (
            PARTITION BY EXTRACT(YEAR FROM sale_date)
            ORDER BY AVG(total_amount) DESC
        ) AS rank
    FROM sales_data
    GROUP BY 1,2
) t
WHERE rank = 1;
```

8. Top 5 customers by spending:

```sql
SELECT 
    customer_id,
    SUM(total_amount) AS total_spent
FROM sales_data
GROUP BY customer_id
ORDER BY total_spent DESC
LIMIT 5;
```

9. Unique customers per category:

```sql
SELECT 
    category,
    COUNT(DISTINCT customer_id) AS unique_customers
FROM sales_data
GROUP BY category;
```

10. Orders by time of day:

```sql
WITH sales_shift AS (
    SELECT *,
        CASE
            WHEN EXTRACT(HOUR FROM sale_time) < 12 THEN 'Morning'
            WHEN EXTRACT(HOUR FROM sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
            ELSE 'Evening'
        END AS shift
    FROM sales_data
)
SELECT 
    shift,
    COUNT(*) AS total_orders
FROM sales_shift
GROUP BY shift;
```

---

## Key Insights

* Customer purchases span multiple age groups and categories.
* High-value transactions highlight premium buying patterns.
* Monthly trends reveal peak sales periods.
* Customer-level analysis identifies top buyers and engagement patterns.

---

## Reports Generated

* **Sales Overview**: Revenue, orders, and category performance.
* **Trend Analysis**: Monthly and time-based sales behavior.
* **Customer Analysis**: Spending patterns and customer segmentation.

---

## Conclusion

This project provides hands-on experience in SQL-based data analysis, covering database setup, cleaning, and extracting meaningful insights. It demonstrates how structured queries can support business decision-making and uncover patterns in sales data.

---

## How to Use

1. Clone this repository
2. Run SQL scripts to create and populate the database
3. Execute analysis queries
4. Modify queries to explore further insights

---

## Author

**Sanskar Gupta**

GitHub: https://github.com/sanskaryk
LinkedIn: https://www.linkedin.com/in/sanskargupta1/
Email: sanskargupta.codes@gmail.com

---

