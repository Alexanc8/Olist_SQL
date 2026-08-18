-- ============================================================
-- Q2: What are the top 10 product categories by revenue?
--
-- Business context:
-- Identifies which product categories drive the most revenue.
-- Joins through the product_category_name_translation lookup
-- table so results are in English rather than Portuguese codes.
--
-- Result takeaway:
-- health/beauty and watches are the top categories for revenue.
-- ============================================================

SELECT 
    t.product_category_name_english AS category,
    ROUND(SUM(oi.price)::numeric, 2) AS revenue,
    COUNT(*) AS items_sold
FROM olist_order_items AS oi
JOIN olist_products AS p ON oi.product_id = p.product_id
JOIN product_category_name_translation t ON p.product_category_name = t.product_category_name
GROUP BY 1
ORDER BY revenue DESC
LIMIT 10
;