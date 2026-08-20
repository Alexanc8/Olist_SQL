-- ============================================================
-- Q10: What's the running (cumulative) revenue total over time?
--
-- Business context:
-- Standard running-total pattern, useful for cumulative growth
-- charts and tracking progress toward revenue targets.
--
-- Result takeaway:
-- Revenue grew steadily with each day.
-- ============================================================

WITH daily_revenue AS (
    SELECT
        o.order_purchase_timestamp::date AS order_date,
        ROUND(SUM(oi.price)::numeric, 2) AS revenue
    FROM olist_orders o
    JOIN olist_order_items oi ON o.order_id = oi.order_id
    WHERE o.order_status = 'delivered'
    GROUP BY order_date
)
SELECT
    order_date,
    revenue,
    SUM(revenue) OVER (ORDER BY order_date) AS running_revenue
FROM daily_revenue
ORDER BY order_date;

