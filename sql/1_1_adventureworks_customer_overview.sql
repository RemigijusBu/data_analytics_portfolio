-- Task 1.1.
-- Top 200 individual customers by total amount spent,
-- Select customers of type 'Individual' and retrieve core identifiers
WITH customer_info AS (
  SELECT 
    customer.CustomerID,
    customer.AccountNumber,
    customer.CustomerType,
    individual.ContactID
  FROM `tc-da-1.adwentureworks_db.customer` customer
  JOIN `tc-da-1.adwentureworks_db.individual` individual
    ON customer.CustomerID = individual.CustomerID
  WHERE customer.CustomerType = 'I' -- Only include individual (non-business) customers
),

-- Get contact details (name, title, email, phone) for each individual
contact_info AS (
  SELECT 
    ContactID,
    Firstname,
    LastName,
    Title,
    CONCAT(Firstname, ' ', LastName) AS full_name,
    IFNULL(CONCAT(Title, ' ', LastName), CONCAT('Dear ', LastName)) AS addressing_title,
    Emailaddress,
    Phone
  FROM `tc-da-1.adwentureworks_db.contact` 
),

-- Identify the latest address per customer based on highest AddressID
latest_address AS (
  SELECT
    CustomerID,
    MAX(AddressID) AS latest_address_id
  FROM `tc-da-1.adwentureworks_db.customeraddress`
  GROUP BY CustomerID
),

-- Retrieve the most recent address details for each customer
address_info AS (
  SELECT 
    customer_address.CustomerID,
    latest_address.latest_address_id,
    address.City,
    address.AddressLine1,
    IFNULL(address.AddressLine2, '') AS addressline2,
    state.Name AS state,
    country.Name AS country
  FROM `tc-da-1.adwentureworks_db.customeraddress` customer_address
  JOIN latest_address 
    ON customer_address.CustomerID = latest_address.CustomerID 
    AND customer_address.AddressID = latest_address.latest_address_id
  JOIN `tc-da-1.adwentureworks_db.address` address
    ON customer_address.AddressID = address.AddressID
  JOIN `tc-da-1.adwentureworks_db.stateprovince` state
    ON address.StateProvinceID = state.StateProvinceID
  JOIN `tc-da-1.adwentureworks_db.countryregion` country
    ON state.CountryRegionCode = country.CountryRegionCode
),

-- Aggregate order data per customer: total orders, total revenue, last order date
customer_orders AS (
  SELECT
    CustomerID,
    COUNT(*) AS number_orders,
    ROUND(SUM(TotalDue), 3) AS total_amount,
    MAX(OrderDate) AS date_last_order
  FROM `tc-da-1.adwentureworks_db.salesorderheader` 
  GROUP BY CustomerID
)

-- Final result: outputs top 200 individual customers by total amount spent,
SELECT 
  customer_info.CustomerID,
  contact_info.Firstname,
  contact_info.LastName,
  contact_info.full_name,
  contact_info.addressing_title,
  contact_info.Emailaddress,
  contact_info.Phone,
  customer_info.AccountNumber,
  customer_info.CustomerType,
  address_info.City,
  address_info.AddressLine1,
  address_info.AddressLine2,
  address_info.State,
  address_info.Country,
  customer_orders.number_orders,
  customer_orders.total_amount,
  customer_orders.date_last_order
FROM customer_info 
JOIN contact_info 
  ON customer_info.ContactID = contact_info.ContactID
JOIN address_info
  ON customer_info.CustomerID = address_info.CustomerID
JOIN customer_orders 
  ON customer_info.CustomerID = customer_orders.CustomerID
ORDER BY customer_orders.total_amount DESC
LIMIT 200;
