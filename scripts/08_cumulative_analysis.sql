/*
===============================================================================
Cumulative Analysis
===============================================================================
Purpose:
	- To calculate running totals or moving averages for key metrics.
	- To track performance over time cumulatively.
	- Useful for growth analysis or identifying long-term trends.

SQL Functions Used:
	- Window Functions: SUM() OVER(), AVG() OVER()
===============================================================================
*/

-- Calculate the total sales per month
-- and the running total of sales over time
SELECT
	order_date,
	total_sales,
	avg_price,
	SUM(total_sales) OVER(ORDER BY order_date) AS running_total_sales,
	AVG(total_sales) OVER(ORDER BY order_date) AS moving_avg_price
FROM (
SELECT
	DATETRUNC(MONTH, order_date) AS order_date,
	SUM(sales_amount) AS total_sales,
	AVG(sales_amount) AS avg_price
FROM gold.fact_sales
WHERE order_date IS NOT NULL
GROUP BY DATETRUNC(MONTH, order_date)
) AS t