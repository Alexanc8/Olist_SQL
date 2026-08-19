-- ============================================================
-- Q7: Which sellers have the highest revenue but the worst
--     average review scores?
--
-- Business context:
-- Surfaces a "volume vs. quality" tension — high-revenue sellers
-- who may be hurting the platform's reputation. Minimum order
-- threshold excludes low-volume sellers whose average could hit
-- 1.0 or 5.0 purely by chance on a handful of orders.
--
-- Result takeaway:
-- Overall, top sellers perform well with good reviews ranging from 3.35-4.34.
-- ============================================================
SELECT
    oi.seller_id,
    ROUND(SUM(oi.price)::numeric, 2) AS total_revenue,
    ROUND(AVG(r.review_score)::numeric, 2) AS avg_review_score,
    COUNT(DISTINCT oi.order_id) AS order_count
FROM olist_order_items oi 
JOIN olist_order_reviews r ON oi.order_id = r.order_id
GROUP BY oi.seller_id
HAVING COUNT(DISTINCT oi.order_id) >= 20
ORDER BY total_revenue DESC, avg_review_score ASC
LIMIT 15;