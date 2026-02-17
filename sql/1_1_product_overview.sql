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
