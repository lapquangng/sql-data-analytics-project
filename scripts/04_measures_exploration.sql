/*
===============================================================================
Measures Exploration (Key Metrics)
===============================================================================
Purpose:
	- To calculate aggregated metrics(e.g., totals, averages) for quick insights.
	- To identify overall trends trends or spot anomalies.

SQL Functions Used:
	- COUNT(), SUM(), AVG()
===============================================================================
*/

-- Find the Total Sales
SELECT SUM(sales_amount) AS total_sales FROM gold.fact_sales;

-- Find how many items are sold
SELECT COUNT(quantity) AS total_quantity FROM gold.fact_sales;

-- Find the Average Selling Price
SELECT AVG(price) AS avg_price FROM gold.fact_sales;

-- Find the Total number of Orders
SELECT COUNT(DISTINCT order_number) AS total_orders FROM gold.fact_sales;

-- Find the Total number of Products
SELECT COUNT(product_key) AS total_products FROM gold.dim_products;

-- Find the Total number of Customers
SELECT COUNT(DISTINCT customer_key) AS total_customers FROM gold.dim_customers;

-- Find the total number of Customers that has placed  an order
SELECT COUNT(DISTINCT customer_key) AS total_customers FROM gold.fact_sales;

-- Denerate a report that shows all key metrics of the business
SELECT 'Total Sales' AS measure_name, SUM(sales_amount) AS measure_value FROM gold.fact_sales
UNION ALL
SELECT 'Total Quantity', COUNT(quantity) FROM gold.fact_sales
UNION ALL
SELECT 'Avg Price', AVG(price) FROM gold.fact_sales
UNION ALL
SELECT 'Total Orders', COUNT(DISTINCT order_number) FROM gold.fact_sales
UNION ALL
SELECT 'Total Products', COUNT(product_key) FROM gold.dim_products
UNION ALL
SELECT 'Total Customers', COUNT(DISTINCT customer_key) FROM gold.dim_customers
UNION ALL
SELECT 'Total Customers Ordered', COUNT(DISTINCT customer_key) FROM gold.fact_sales;