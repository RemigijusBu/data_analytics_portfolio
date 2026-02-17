-- Task 2.2.
--Enhance the 2.1  query by adding country-level tax details. 
-- Aggregate sales data per month, region, and country
WITH monthly_sales AS (
    SELECT 
        LAST_DAY(DATE(sales_order.OrderDate)) AS order_month, -- Aggregate monthly sales performance by country and region
        territory.CountryRegionCode AS country_code,
        territory.Name AS region,
        COUNT(sales_order.SalesOrderID) AS no_orders,
        COUNT(DISTINCT(sales_order.CustomerID)) AS no_customers,
        COUNT(DISTINCT(sales_order.SalesPersonID)) AS no_salespersons,
        CAST(SUM(sales_order.TotalDue) AS INT64) AS total_w_tax -- Total amount earned in the period, including tax (rounded to integer)
    FROM `tc-da-1.adwentureworks_db.salesorderheader` sales_order
    JOIN `tc-da-1.adwentureworks_db.salesterritory` AS territory
        ON territory.TerritoryID = sales_order.TerritoryID
    GROUP BY order_month, country_code, region
)

--Adding a cumulative sum of the total amount (with tax) earned
--Adding a sales_rank column that ranks rows from highest to lowest total amount (with tax) earned per country and month.
SELECT *,
    RANK() OVER(PARTITION BY country_code, region ORDER BY total_w_tax DESC) AS country_sales_rank,
    SUM(total_w_tax) OVER (PARTITION BY country_code, region ORDER BY order_month) AS cumulative_sum
FROM monthly_sales
WHERE region = 'France'
ORDER BY country_sales_rank
