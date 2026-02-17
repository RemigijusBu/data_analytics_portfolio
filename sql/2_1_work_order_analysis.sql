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
ORDER BY SUM(work_order_routing.ActualCost) DESC
