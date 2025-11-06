/*
===============================================================================
Data Segmentation Analysis
===============================================================================
Purpose:
	- To group data into meaningful categories for targeted insights.
	- For customer segmentation, product categorization, or regional analysis.

SQL Functions Used:
	- CASE: Defines custom segmentation logic.
	- GROUP BY: Groups data into segments.
===============================================================================
*/

/*Segment products into cost ranges and count how many products fall into each segment*/
WITH product_segments AS (
	SELECT
		product_name,
		CASE
			WHEN cost < 100 THEN 'Below 100'
			WHEN cost >= 100 AND cost < 500 THEN '100-500'
			WHEN cost >= 500 AND cost < 1000 THEN '500-1000'
			ELSE 'Above 1000'
		END AS cost_range
	FROM gold.dim_products
)
SELECT
	cost_range,
	COUNT(product_name) AS total_products
FROM product_segments
GROUP BY cost_range
ORDER BY CASE cost_range
	WHEN 'Below 100' THEN 1
	WHEN '100-500' THEN 2
	WHEN '500-1000' THEN 3
	ELSE 4
END

/*Group customers into three segments based on their spending behavior:
	- VIP: Customers with at least 12 months of history and spending more than 5,000.
	- Regular: Customers with at least 12 months of history but spending 5,000 or less.
	- New: Customers with a lifespan less than 12 months.
And find the total number of customers by each group
*/
WITH customer_summary AS (
	SELECT
		customer_key,
		MIN(order_date) AS first_order,
		MAX(order_date) AS last_order,
		SUM(sales_amount) AS total_spending,
		DATEDIFF(MONTH, MIN(order_date), MAX(order_date)) AS lifespan
	FROM gold.fact_sales
	GROUP BY customer_key
)
SELECT
	customer_segment,
	COUNT(customer_key) AS total_customer
FROM (
	SELECT
		customer_key,
		CASE
			WHEN lifespan >= 12 AND total_spending > 5000 THEN 'VIP'
			WHEN lifespan >= 12 AND total_spending <= 5000 THEN 'Regular'
			ELSE 'New'
		END AS customer_segment
	FROM customer_summary
) AS t
GROUP BY customer_segment
ORDER BY CASE customer_segment
		WHEN 'VIP' THEN 1
		WHEN 'Regular' THEN 2
		ELSE 3
END