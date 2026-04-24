/*
===============================================================================
Change Over Time Analysis
===============================================================================
Purpose:
    - To track trends, growth, and changes in key metrics over time.
    - For time-series analysis and identifying seasonality.
    - To measure growth or decline over specific periods.

SQL Functions Used:
    - Date Functions: DATEPART(), DATETRUNC(), FORMAT()
    - Aggregate Functions: SUM(), COUNT(), AVG()
===============================================================================
*/

-- Analyse sales performance over time
-- Quick Date Functions
SELECT 
EXTRACT(YEAR FROM(order_date)) AS order_year,
SUM(sales_amount) AS total_sales,
SUM(DISTINCT customer_key) AS total_customers,
SUM(quantity) AS total_quantity
FROM gold.fact_sales
WHERE order_date IS NOT NULL
GROUP BY order_year
ORDER BY order_year
;


-- DATETRUNC()
SELECT
    DATE_TRUNC('month', order_date) AS month_date,
    TO_CHAR(DATE_TRUNC('month', order_date), 'YYYY-Mon') AS month_label,
    SUM(sales_amount) AS total_sales,
    COUNT(DISTINCT customer_key) AS total_customers,
    SUM(quantity) AS total_quantity
FROM gold.fact_sales
WHERE order_date IS NOT NULL
GROUP BY DATE_TRUNC('month', order_date)
ORDER BY month_date;

-- FORMAT()
SELECT
    TO_CHAR(order_date, 'YYYY-Mon') AS order_date,
    SUM(sales_amount) AS total_sales,
    COUNT(DISTINCT customer_key) AS total_customers,
    SUM(quantity) AS total_quantity
FROM gold.fact_sales
WHERE order_date IS NOT NULL
GROUP BY TO_CHAR(order_date, 'YYYY-Mon')
ORDER BY TO_CHAR(order_date, 'YYYY-Mon');