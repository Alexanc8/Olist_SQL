-- ============================================================
-- Q3: What is the average order value (AOV)?
--
-- Business context:
-- A core e-commerce KPI. Must collapse to order-level totals
-- BEFORE averaging, or you'll average item-level prices instead
-- of order-level totals.
--
-- Result takeaway: 
-- The AOV turned out to be $137.75.
-- ============================================================

SELECT ROUND(AVG(order_total)::numeric, 2) AS avg_order_value
FROM (
    SELECT order_id, SUM(price) AS order_total
    FROM olist_order_items
    GROUP BY order_id
) sub;