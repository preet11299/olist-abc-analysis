-- ============================================================
-- QUERY A: Full Product-Level ABC Classification
--
-- Returns all 32,951 products with:
--   - Total revenue and sales count
--   - Cumulative revenue percentage
--   - ABC class (A/B/C)
--   - English category name
-- ============================================================

WITH revenue_by_product AS (
    SELECT 
        product_id,
        SUM(price) AS total_revenue,
        COUNT(*) AS times_sold
    FROM order_items
    GROUP BY product_id
),
classified AS (
    SELECT 
        product_id,
        total_revenue,
        times_sold,
        ROUND(
            SUM(total_revenue) OVER (ORDER BY total_revenue DESC) * 100.0 
            / SUM(total_revenue) OVER (), 
        2) AS cumulative_pct,
        CASE 
            WHEN ROUND(SUM(total_revenue) OVER (ORDER BY total_revenue DESC) * 100.0 
                 / SUM(total_revenue) OVER (), 2) <= 80 THEN 'A'
            WHEN ROUND(SUM(total_revenue) OVER (ORDER BY total_revenue DESC) * 100.0 
                 / SUM(total_revenue) OVER (), 2) <= 95 THEN 'B'
            ELSE 'C'
        END AS abc_class
    FROM revenue_by_product
)
SELECT 
    c.product_id,
    COALESCE(ct.product_category_name_english, p.product_category_name, 'Unknown') AS category,
    c.total_revenue,
    c.times_sold,
    c.cumulative_pct,
    c.abc_class
FROM classified c
LEFT JOIN products p ON c.product_id = p.product_id
LEFT JOIN category_translation ct ON p.product_category_name = ct.product_category_name
ORDER BY c.total_revenue DESC;
