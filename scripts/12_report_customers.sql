/*
===============================================================================
Customer Report
===============================================================================
Purpose:
	- This report consolidates key customer metrics and behaviors

Highlights:
	1. Gathers essential fields such as names, ages, and transaction details.
	2. Segments customers into categories (VIP, regular, New) and age groups.
	3. Aggregates customer-level metrics:
		- total orders
		- total sales
		- total quantity purchased
		- total products
		- lifespan (in months)
	4. Calculates valuable KPIs:
		- recency (months since last order)
		- average order value
		- average monthly spend
===============================================================================
*/
DROP VIEW IF EXISTS gold.report_customers
GO

CREATE VIEW gold.report_customers AS

WITH main_table AS (
	SELECT
		f.order_number,
		f.product_key,
		f.customer_key,
		f.order_date,
		f.sales_amount,
		f.quantity,
		c.customer_number,
		c.birthdate,
		CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
		DATEDIFF(YEAR, c.birthdate, GETDATE()) AS age
	FROM gold.fact_sales AS f
	LEFT JOIN gold.dim_customers AS c
	ON c.customer_key = f.customer_key
	WHERE order_date IS NOT NULL)
, aggregate_metric AS (
	SELECT
		customer_key,
		customer_number,
		customer_name,
		age,
		MAX(order_date) AS last_order_date,
		DATEDIFF(MONTH, MAX(order_date), GETDATE()) AS recency,
		COUNT(DISTINCT order_number) AS total_order,
		SUM(sales_amount) AS total_sales,
		SUM(quantity) AS total_quantity,
		DATEDIFF(MONTH, MIN(order_date), MAX(order_date)) AS lifespan,
		SUM(sales_amount) AS total_spending
	FROM main_table
	GROUP BY
		customer_key,
		customer_number,
		customer_name,
		age
)
SELECT
	customer_key,
	customer_number,
	customer_name,
	age,
	CASE
		WHEN age < 20 THEN 'Under 20'
		WHEN age BETWEEN 20 AND 29 THEN '20-29'
		WHEN age BETWEEN 30 AND 39 THEN '30-39'
		WHEN age BETWEEN 40 AND 49 THEN '40-49'
		ELSE '50 and above'
	END AS age_group,
	CASE
		WHEN lifespan >= 12 AND total_spending > 5000 THEN 'VIP'
		WHEN lifespan >= 12 AND total_spending <= 5000 THEN 'Regular'
		ELSE 'New'
	END AS customer_segment,
	last_order_date,
	recency,
	total_order,
	total_sales,
	total_quantity,
	lifespan,
	CASE
		WHEN total_sales = 0 THEN 0
		ELSE total_sales / total_order
	END AS avg_order_value,
	CASE
		WHEN lifespan = 0 THEN total_sales
		ELSE total_sales / lifespan
	END AS avg_monthly_spending
FROM aggregate_metric