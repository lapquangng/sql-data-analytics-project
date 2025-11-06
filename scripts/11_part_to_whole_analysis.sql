/*
===============================================================================
Part-to-Whole Analysis
===============================================================================
Purpose:
	- To compare performance or metrics across dimensions or time periods.
	- To evaluate differences between categories.
	- Useful for A/B testing or regional comparisons.

SQL Functions Used:
	- SUM(), AVG(): Aggregates values for comparison.
	- Window Functions: SUM() OVER() for total calculations.
	===============================================================================
	*/
	-- Which categories contribute the most to overall sales?
	SELECT DISTINCT
		p.category,
		SUM(f.sales_amount) OVER(PARTITION BY category) AS total_sales,
		SUM(f.sales_amount) OVER() AS overall_sales,
		ROUND(CAST(SUM(f.sales_amount) OVER(PARTITION BY category) AS FLOAT) / CAST(SUM(f.sales_amount) OVER() AS FLOAT) * 100, 2) AS percentage_of_total
	FROM gold.fact_sales AS f
	LEFT JOIN gold.dim_products AS p
	ON p.product_key = f.product_key
	ORDER BY percentage_of_total DESC