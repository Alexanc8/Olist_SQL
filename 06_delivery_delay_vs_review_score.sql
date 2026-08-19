-- ============================================================
-- Q6: Is there a relationship between delivery delay and review score?
--
-- Business context:
-- Tests whether late deliveries actually hurt customer
-- satisfaction (measured via review score) — a classic
-- "does X affect Y" business question.
--
-- Result takeaway:
-- Yes, when the order arrives later than expected, the average review score goes down.
-- Most orders do come on time or early, however.
-- ============================================================

WITH delivery_stats AS (
    SELECT 
        o.order_id, 
        r.review_score, 
        (o.order_delivered_customer_date::date - o.order_estimated_delivery_date::date) AS days_late
    FROM olist_orders o
    JOIN olist_order_reviews r ON o.order_id = r.order_id
    WHERE o.order_delivered_customer_date IS NOT NULL
)
SELECT
    CASE
        WHEN days_late <= 0 THEN 'On time or early'
        WHEN days_late BETWEEN 1 AND 3 THEN '1-3 days late'
        ELSE '4+ days late'
    END AS delivery_bucket,
    AVG(review_score) AS avg_review_score,
    COUNT(*)
FROM delivery_stats
GROUP BY delivery_bucket
ORDER BY avg_review_score;