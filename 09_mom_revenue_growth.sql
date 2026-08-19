-- ============================================================
-- Q9: What's the month-over-month revenue growth rate?
--
-- Business context:
-- "How did this period compare to last period" is one of the
-- most commonly requested analyses in real analyst work.
--
-- Result takeaway:
-- Overall, monthly revenue grew steadily except for the first year and beginning of 2017.
-- ============================================================
WITH monthly_revenue AS (
    SELECT 
        DATE_TRUNC('month', o.order_purchase_timestamp) AS month,
        SUM(oi.price) AS revenue
    FROM olist_order_items oi
    JOIN olist_orders o ON oi.order_id = o.order_id
    WHERE o.order_status = 'delivered'
    GROUP BY month
)
SELECT
    month,
    ROUND(revenue::numeric, 2) AS revenue,
    ROUND(
        100.0 * (revenue - LAG(revenue) OVER (ORDER BY month)) / LAG(revenue) OVER (ORDER BY month),
        1
    ) AS mom_growth_pct
FROM monthly_revenue
ORDER BY month;
