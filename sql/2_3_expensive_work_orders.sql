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
