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
ORDER BY category_name
