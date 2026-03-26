-- =====================================================
-- RETAIL TRANSACTIONS & INSIGHTS PROJECT (SQL)
-- =====================================================

-- =========================
-- TABLE CREATION
-- =========================

CREATE TABLE retail_sales (
    transaction_id INT PRIMARY KEY,
    sale_date DATE,
    sale_time TIME,
    customer_id INT,
    gender VARCHAR(10),
    age INT,
    category VARCHAR(20),
    quantity INT,
    price_per_unit FLOAT,
    cogs FLOAT,
    total_sale FLOAT
);

-- =========================
-- DATA OVERVIEW
-- =========================

SELECT * FROM retail_sales LIMIT 10;

SELECT COUNT(*) AS total_records FROM retail_sales;

-- =========================
-- DATA CLEANING
-- =========================

-- Check for null values
SELECT *
FROM retail_sales
WHERE transaction_id IS NULL
   OR sale_date IS NULL
   OR sale_time IS NULL
   OR customer_id IS NULL
   OR gender IS NULL
   OR category IS NULL
   OR quantity IS NULL
   OR cogs IS NULL
   OR total_sale IS NULL;

-- Remove null records
DELETE FROM retail_sales
WHERE transaction_id IS NULL
   OR sale_date IS NULL
   OR sale_time IS NULL
   OR customer_id IS NULL
   OR gender IS NULL
   OR category IS NULL
   OR quantity IS NULL
   OR cogs IS NULL
   OR total_sale IS NULL;

-- =========================
-- EXPLORATORY DATA ANALYSIS
-- =========================

-- Total sales transactions
SELECT COUNT(*) AS total_sales FROM retail_sales;

-- Unique customers
SELECT COUNT(DISTINCT customer_id) AS total_customers FROM retail_sales;

-- Product categories
SELECT DISTINCT category FROM retail_sales;

-- =========================
-- BUSINESS ANALYSIS
-- =========================

-- 1. Sales on a specific date
SELECT *
FROM retail_sales
WHERE sale_date = '2022-11-05';

-- 2. Clothing transactions with quantity > 4 in Nov 2022
SELECT *
FROM retail_sales
WHERE category = 'Clothing'
  AND quantity >= 4
  AND TO_CHAR(sale_date, 'YYYY-MM') = '2022-11';

-- 3. Total sales by category
SELECT 
    category,
    SUM(total_sale) AS total_sales,
    COUNT(*) AS total_orders
FROM retail_sales
GROUP BY category
ORDER BY total_sales DESC;

-- 4. Average age of Beauty category customers
SELECT 
    ROUND(AVG(age), 2) AS avg_age
FROM retail_sales
WHERE category = 'Beauty';

-- 5. High-value transactions (>1000)
SELECT *
FROM retail_sales
WHERE total_sale > 1000;

-- 6. Transactions by gender and category
SELECT 
    category,
    gender,
    COUNT(transaction_id) AS total_transactions
FROM retail_sales
GROUP BY category, gender
ORDER BY category;

-- 7. Best-selling month (based on avg sales per year)
SELECT year, month, avg_sale
FROM (
    SELECT 
        EXTRACT(YEAR FROM sale_date) AS year,
        EXTRACT(MONTH FROM sale_date) AS month,
        AVG(total_sale) AS avg_sale,
        RANK() OVER (
            PARTITION BY EXTRACT(YEAR FROM sale_date)
            ORDER BY AVG(total_sale) DESC
        ) AS rank
    FROM retail_sales
    GROUP BY 1, 2
) t
WHERE rank = 1;

-- 8. Top 5 customers by total sales
SELECT 
    customer_id,
    SUM(total_sale) AS total_spent
FROM retail_sales
GROUP BY customer_id
ORDER BY total_spent DESC
LIMIT 5;

-- 9. Unique customers per category
SELECT 
    category,
    COUNT(DISTINCT customer_id) AS unique_customers
FROM retail_sales
GROUP BY category
ORDER BY unique_customers DESC;

-- 10. Sales by time of day (shift analysis)
WITH hourly_sales AS (
    SELECT *,
        CASE
            WHEN EXTRACT(HOUR FROM sale_time) < 12 THEN 'Morning'
            WHEN EXTRACT(HOUR FROM sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
            ELSE 'Evening'
        END AS shift
    FROM retail_sales
)
SELECT 
    shift,
    COUNT(*) AS total_orders
FROM hourly_sales
GROUP BY shift
ORDER BY total_orders DESC;

-- =====================================================
-- END OF PROJECT
-- =====================================================


