-- ============================================================
-- Q4: How many orders came from each state?
--
-- Business context:
-- Shows geographic distribution of demand. COUNT(DISTINCT ...)
-- matters here — without it, a multi-item order would be
-- counted once per item row after an order_items join.
--
-- Result takeaway:
-- Most customers are from the states SP, RJ,, and MG.
-- ============================================================

SELECT
    c.customer_state,
    COUNT(DISTINCT o.order_id) AS order_count
FROM olist_orders o
JOIN olist_customers c ON o.customer_id = c.customer_id
GROUP BY 1
ORDER BY order_count DESC;