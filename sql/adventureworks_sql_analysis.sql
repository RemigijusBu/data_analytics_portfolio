-- Exploration of adventureworks data, organized into two main modules: 
-- 1. Product Data Exploration 
-- 2. Operational & Cost Analysis

-- Task 1.1.
-- Retrieve product data from the Product table, focusing only on products that have an associated Product Subcategory, sorted by Subcategory name
SELECT 
  product.ProductID AS product_id,
  product.Name AS product_name,  
  product.ProductNumber AS product_number, 
  product.Size AS size,
  product.Color AS color,
  product.ProductSubcategoryID AS subcategory_id,  
  product_subcategory.Name AS subcategory_name
FROM `tc-da-1.adwentureworks_db.product` AS product
JOIN `tc-da-1.adwentureworks_db.productsubcategory` AS product_subcategory
  ON product.ProductSubcategoryID = product_subcategory.ProductSubcategoryID
ORDER BY subcategory_name


-- Task 1.2.
-- Retrieve products  with their subcategory and category names, ordered by category name.
SELECT 
  product.ProductID AS product_id,
  product.Name AS product_name,  
  product.ProductNumber AS product_number, 
  product.Size AS size,
  product.Color AS color,
  product.ProductSubcategoryID AS subcategory_id,  
  product_subcategory.Name AS subcategory_name,
  product_category.Name AS category_name
FROM `tc-da-1.adwentureworks_db.product` AS product
-- First join to get subcategory details
JOIN `tc-da-1.adwentureworks_db.productsubcategory` AS product_subcategory
  ON product.ProductSubcategoryID = product_subcategory.ProductSubcategoryID
-- Second join to get category details via the subcategory table
JOIN `tc-da-1.adwentureworks_db.productcategory` AS product_category
  ON product_category.ProductCategoryID = product_subcategory.ProductCategoryID
ORDER BY category_name;

-- Task 1.3.
-- Retrieve result, actively sold bikes (ListPrice ≥ 2000), with category and subcategory details, sorted by price
SELECT 
  product.ProductID AS product_id,
  product.Name AS product_name,  
  product.ProductNumber AS product_number, 
  product.Size AS size,
  product.Color AS color,
  product.ProductSubcategoryID AS subcategory_id,  
  product_subcategory.Name AS subcategory_name,
  product_category.Name AS category_name,
  product.ListPrice AS list_price
FROM `tc-da-1.adwentureworks_db.product` AS product
JOIN `tc-da-1.adwentureworks_db.productsubcategory` AS product_subcategory
  ON product.ProductSubcategoryID = product_subcategory.ProductSubcategoryID
JOIN `tc-da-1.adwentureworks_db.productcategory` AS product_category
  ON product_category.ProductcategoryID = product_subcategory.ProductCategoryID
WHERE product_category.Name = 'Bikes'
  AND product.ListPrice >= 2000
  AND product.SellEndDate IS NULL
ORDER BY list_price DESC;


-- Task 2.1.
-- Get locations by total actual cost for work orders started in January 2004
SELECT 
  work_order_routing.LocationID AS location_id,
  COUNT(work_order.OrderQty) AS no_work_orders,
  COUNT(DISTINCT work_order_routing.ProductID) AS no_unique_products,
  SUM(work_order_routing.ActualCost) AS actual_cost
FROM `tc-da-1.adwentureworks_db.workorderrouting` AS work_order_routing
JOIN `tc-da-1.adwentureworks_db.workorder` AS work_order
  ON work_order_routing.WorkOrderID = work_order.WorkOrderID
WHERE work_order_routing.ActualStartDate 
  BETWEEN DATE '2004-01-01'
  AND DATE '2004-01-31'
GROUP BY work_order_routing.LocationID
ORDER BY SUM(work_order_routing.ActualCost) DESC;


-- Task 2.2
-- Get production locations by total actual cost and for work orders started in January 2004.
SELECT 
  work_order_routing.LocationID AS location_id,
  location.Name AS location_name,
  COUNT(work_order.OrderQty) AS no_work_orders,
  COUNT(DISTINCT work_order_routing.ProductID) AS no_unique_products,
  SUM(work_order_routing.ActualCost) AS actual_cost,
  ROUND(AVG(DATE_DIFF(work_order_routing.ActualEndDate, work_order_routing.ActualStartDate, DAY)),2) AS avg_days_diff
FROM `tc-da-1.adwentureworks_db.workorderrouting` AS work_order_routing
JOIN `tc-da-1.adwentureworks_db.workorder` AS work_order
  ON work_order_routing.WorkOrderID = work_order.WorkOrderID
JOIN `tc-da-1.adwentureworks_db.location` AS location
  ON work_order_routing.LocationID = location.LocationID
WHERE work_order_routing.ActualStartDate 
  BETWEEN DATE '2004-01-01'
  AND DATE '2004-01-31'
GROUP BY work_order_routing.LocationID, location.Name
ORDER BY SUM(work_order_routing.ActualCost) DESC;


-- 2.3.
-- Retrieve Work Orders started after Jan 1, 2004 with total Actual Cost > 300

SELECT 
  work_order_routing.WorkOrderID AS work_order_id,
  SUM(work_order_routing.ActualCost) AS actual_cost,
FROM `tc-da-1.adwentureworks_db.workorderrouting` AS work_order_routing
JOIN `tc-da-1.adwentureworks_db.workorder` AS work_order
  ON work_order_routing.WorkOrderID = work_order.WorkOrderID
WHERE work_order_routing.ActualStartDate > DATE '2004-01-01'
GROUP BY work_order_routing.WorkOrderID, work_order_routing.ActualStartDate
HAVING SUM(work_order_routing.ActualCost) > 300;

