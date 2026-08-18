-- =============================================================================
-- Question: What is total revenue by month?
-- 
-- Business context:
-- Establishes the baseline revenue trend over time. Filters to
-- 'delivered' orders only, since cancelled/unfulfilled orders
-- shouldn't count as realized revenue.
--
-- Result Takeaway:
-- Revenue grew steadily from September 2016 - August 2018.
-- =============================================================================

SELECT 
    DATE_TRUNC('month', o.order_purchase_timestamp) AS month,
    ROUND(SUM(oi.price)::numeric, 2) AS revenue
FROM olist_orders AS o
JOIN olist_order_items AS oi ON o.order_id = oi.order_id
WHERE o.order_status = 'delivered'
GROUP BY MONTH
ORDER BY MONTH
;