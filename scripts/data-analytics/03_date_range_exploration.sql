/*
===============================================================================
Date Range Exploration 
===============================================================================
Purpose:
    - To determine the temporal boundaries of key data points.
    - To understand the range of historical data.

SQL Functions Used:
    - MIN(), MAX(), DATEDIFF()
===============================================================================
*/

--Find the date of the first and last order
-- KNow how much years of data we have

SELECT 
MIN(order_date) AS first_order_date,
MAX(order_date) AS last_order_date,
EXTRACT(YEAR FROM AGE(MAX(order_date), MIN(order_date))) AS order_range_years
FROM gold.fact_sales;


--Find the youngest and the oldest customer

SELECT 
    MAX(birthdate) AS youngest_customer,
    AGE(CURRENT_DATE, MAX(birthdate)) AS youngest_age,
    MIN(birthdate) AS oldest_customer,
    AGE(CURRENT_DATE, MIN(birthdate)) AS oldest_age
FROM gold.dim_customers;

