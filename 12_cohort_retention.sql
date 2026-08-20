-- ============================================================
-- Q12: Cohort retention — of customers who made their first
--      purchase in a given month, how many returned in later months?
--
-- Business context:
-- Cohort retention shows whether the business is retaining
-- customers over time, grouped by when they first purchased.
-- This is a standard growth/product analytics technique.
--
-- Result takeaway:
-- Retention rate ultimately varies, but overall, there's been a slight increase
-- across from 2016 to 2018. 
-- ============================================================
WITH first_purchase AS (
    SELECT 
        c.customer_unique_id,
        MIN(DATE_TRUNC('month', o.order_purchase_timestamp)) AS cohort_month
    FROM olist_orders o
    JOIN olist_customers c ON o.customer_id = c.customer_id
    GROUP BY c.customer_unique_id
),
orders_with_cohort AS (
    SELECT
        c.customer_unique_id,
        fp.cohort_month,
        DATE_TRUNC('month', o.order_purchase_timestamp) AS order_month
    FROM olist_orders o
    JOIN olist_customers c ON o.customer_id = c.customer_id
    JOIN first_purchase fp ON c.customer_unique_id = fp.customer_unique_id
),
cohort_activity AS (
    SELECT
        cohort_month,
        EXTRACT(YEAR FROM AGE(order_month, cohort_month)) * 12 +
        EXTRACT(MONTH FROM AGE(order_month, cohort_month)) AS months_since_first_purchase,
        COUNT(DISTINCT customer_unique_id) AS active_customers
    FROM orders_with_cohort
    GROUP BY cohort_month, 2
),
cohort_sizes AS (
    SELECT 
        cohort_month, 
        active_customers AS cohort_size
    FROM cohort_activity
    WHERE months_since_first_purchase = 0
)
SELECT
    ca.cohort_month,
    ca.months_since_first_purchase,
    ca.active_customers,
    cs.cohort_size,
    ROUND(100.0 * ca.active_customers / cs.cohort_size, 2) AS retention_rate_pct
FROM cohort_activity ca
JOIN cohort_sizes cs ON ca.cohort_month = cs.cohort_month
ORDER BY ca.cohort_month, ca.months_since_first_purchase;