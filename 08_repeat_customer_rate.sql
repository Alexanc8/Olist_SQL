-- ============================================================
-- Q8: What percentage of customers are repeat buyers?
-- 
-- Business context:
-- Core retention metric. Deliberately groups by
-- customer_unique_id, NOT customer_id — Olist generates a new
-- customer_id per order, so grouping by customer_id would make
-- every customer look like a one-time buyer.
--
-- Result takeaway:
-- The percentage of repeat buyers is 3.12%.
-- ============================================================

WITH customer_order_counts AS (
    SELECT
        c.customer_unique_id,
        COUNT(DISTINCT o.order_id) AS order_count
    FROM olist_orders o
    JOIN olist_customers c ON o.customer_id = c.customer_id
    GROUP BY c.customer_unique_id
)
SELECT
    ROUND(
        100.0 * COUNT(*) FILTER (WHERE order_count > 1) / COUNT(*),
        2
    ) AS pct_repeat_customers
FROM customer_order_counts;