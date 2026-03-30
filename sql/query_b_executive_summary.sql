-- ============================================================
-- QUERY B: Executive Summary by ABC Class
--
-- Returns 3 rows — one per class — showing:
--   - Number of products and % of total
--   - Total revenue and % of total
--   - Average revenue and sales per product
--
-- KEY FINDINGS:
--   Class A: 25.9% of products → 80% of revenue (R$10.87M)
--   Class B: 34.2% of products → 15% of revenue (R$2.03M)
--   Class C: 39.9% of products →  5% of revenue (R$684K)
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
    abc_class,
    COUNT(*) AS num_products,
    ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (), 1) AS pct_of_products,
    ROUND(SUM(total_revenue), 2) AS total_revenue,
    ROUND(SUM(total_revenue) * 100.0 / SUM(SUM(total_revenue)) OVER (), 1) AS pct_of_revenue,
    ROUND(AVG(total_revenue), 2) AS avg_revenue_per_product,
    ROUND(AVG(times_sold), 1) AS avg_times_sold
FROM classified
GROUP BY abc_class
ORDER BY abc_class;
