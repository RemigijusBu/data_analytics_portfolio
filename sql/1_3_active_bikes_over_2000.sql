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
ORDER BY list_price DESC
