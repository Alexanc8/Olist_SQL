-- ============================================================
-- Q5: What's the average delivery time, and how does it vary by state?
--
-- Business context:
-- Surfaces regional logistics performance. Filters out orders
-- with no delivery date (e.g. cancelled orders), since including
-- them would skew or break the average.
--
-- Result takeaway:
-- Found that the average delivery time varies from 8.8 days from SP to 29.4 
-- days from RR.
-- ============================================================
SELECT
    c.customer_state,
    ROUND(
        AVG(EXTRACT(EPOCH FROM (o.order_delivered_customer_date - o.order_purchase_timestamp)) / 86400)::numeric, 1
    ) AS avg_delivery_days
FROM olist_orders o
JOIN olist_customers c ON o.customer_id = c.customer_id
WHERE o.order_delivered_customer_date IS NOT NULL
GROUP BY c.customer_state
ORDER BY avg_delivery_days DESC;