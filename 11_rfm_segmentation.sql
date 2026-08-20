-- ============================================================
-- Q11: Segment customers into RFM tiers (Recency, Frequency,
--      Monetary) using NTILE
--
-- Business context:
-- RFM segmentation is a standard real-world marketing/growth
-- analytics technique for identifying best vs. at-risk customers.
-- NTILE(4) splits customers into quartiles on each dimension.
-- Uses customer_unique_id.
--
-- Result takeaway:
-- Top 20 customers by FRM score have the best rfm score of 12.
-- ============================================================
WITH customer_rfm AS (
    SELECT
        c.customer_unique_id,
        MAX(o.order_purchase_timestamp) AS last_order_date,
        COUNT(DISTINCT o.order_id) AS frequency,
        SUM(oi.price) AS monetary
    FROM olist_orders o
    JOIN olist_customers c ON o.customer_id = c.customer_id
    JOIN olist_order_items oi ON o.order_id = oi.order_id
    WHERE o.order_status = 'delivered'
    GROUP BY c.customer_unique_id
),
rfm_scored AS (
    SELECT 
        *,
        NTILE(4) OVER (ORDER BY last_order_date) AS recency_tile,
        NTILE(4) OVER (ORDER BY frequency) AS frequency_tile,
        NTILE(4) OVER (ORDER BY monetary) AS monetary_tile
    FROM customer_rfm
)
SELECT 
    customer_unique_id,
    recency_tile,
    frequency_tile,
    monetary_tile,
    (recency_tile + frequency_tile + monetary_tile) AS rfm_score
FROM rfm_scored
ORDER BY rfm_score DESC
LIMIT 20;