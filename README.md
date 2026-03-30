# Inventory Health & ABC Classification Analysis
### SQL Portfolio Project — Olist Brazilian E-Commerce Dataset

---

## Overview

This project applies **ABC inventory classification** (Pareto analysis) to a real-world e-commerce dataset to identify which products drive the most revenue — and which are dead weight. The analysis surfaces actionable insights for procurement prioritization, safety stock policy, and supplier relationship strategy.

**Key finding:** 26% of SKUs drive 80% of total revenue. Nearly 40% of the catalog contributes only 5%.

---

## Dataset

**Source:** [Olist Brazilian E-Commerce Public Dataset](https://www.kaggle.com/datasets/olistbr/brazilian-ecommerce) — Kaggle  
**Scope:** ~245,000 rows across 4 tables | Orders from 2016–2018

| Table | Rows | Description |
|---|---|---|
| `orders` | 99,441 | Order timestamps, status, delivery dates |
| `order_items` | 112,650 | Product ID, price, freight per line item |
| `products` | 32,951 | Category, weight, dimensions |
| `category_translation` | 71 | Portuguese → English category mapping |

> ⚠️ Raw CSVs are not included in this repo due to file size. Download from Kaggle and place in `data/raw/`.

---

## Repository Structure

```
olist-abc-analysis/
├── sql/
│   ├── create_tables.sql               # Schema DDL — run this first
│   ├── query_a_product_classification.sql  # Full product-level ABC output (32,951 rows)
│   └── query_b_executive_summary.sql   # 3-row executive summary by class
├── data/
│   └── raw/                            # Place Kaggle CSVs here (gitignored)
├── docs/
│   └── interview_prep.md               # Technical walkthrough & concept reference
├── assets/
│   └── results_summary.png             # (Optional) chart / screenshot placeholder
└── README.md
```

---

## SQL Concepts Demonstrated

| Concept | Where Used |
|---|---|
| `CREATE TABLE` with typed columns | `create_tables.sql` |
| Composite `PRIMARY KEY` | `order_items` table schema |
| `GROUP BY` + `SUM` aggregation | `revenue_by_product` CTE |
| Window functions (`SUM OVER ORDER BY`) | Cumulative revenue % in both queries |
| `CASE WHEN` classification logic | ABC tier assignment |
| Multi-table `LEFT JOIN` | Product → category enrichment |
| `COALESCE` for null handling | Category fallback logic |
| Nested aggregates (`SUM(SUM(...)) OVER ()`) | Executive summary percentage calc |
| CTEs (`WITH` clauses) | Both query files |

---

## Results

| ABC Class | # Products | % of Catalog | Total Revenue | % of Revenue |
|---|---|---|---|---|
| **A** | ~8,535 | 25.9% | R$ 10.87M | **80%** |
| **B** | ~11,269 | 34.2% | R$ 2.03M | 15% |
| **C** | ~13,147 | 39.9% | R$ 684K | 5% |

### Business Implications

- **Class A products** warrant tighter reorder point controls, preferred supplier terms, and dedicated safety stock buffers
- **Class B products** can use periodic review with moderate safety stock
- **Class C products** are candidates for SKU rationalization, consignment, or just-in-time replenishment with minimal carrying cost

---

## How to Run

### Prerequisites
- PostgreSQL 13+ (local install or Docker)
- DBeaver or any SQL client
- Olist CSVs downloaded from Kaggle

### Steps

1. **Create schema**
   ```sql
   -- Run in your PostgreSQL client
   \i sql/create_tables.sql
   ```

2. **Load data**  
   Use DBeaver's Import Wizard (right-click table → Import Data) or `psql \COPY`:
   ```bash
   \COPY orders FROM 'data/raw/01_olist_orders_dataset.csv' CSV HEADER;
   \COPY order_items FROM 'data/raw/02_olist_order_items_dataset.csv' CSV HEADER;
   \COPY products FROM 'data/raw/03_olist_products_dataset.csv' CSV HEADER;
   \COPY category_translation FROM 'data/raw/04_product_category_name_translation.csv' CSV HEADER;
   ```

3. **Verify row counts**
   ```sql
   SELECT 'orders', COUNT(*) FROM orders
   UNION ALL SELECT 'order_items', COUNT(*) FROM order_items
   UNION ALL SELECT 'products', COUNT(*) FROM products
   UNION ALL SELECT 'category_translation', COUNT(*) FROM category_translation;
   ```

4. **Run analysis**
   ```sql
   \i sql/query_b_executive_summary.sql    -- 3-row summary
   \i sql/query_a_product_classification.sql  -- Full 32,951-row output
   ```

---

## Skills Demonstrated

`PostgreSQL` · `SQL (DDL + DML)` · `Window Functions` · `CTEs` · `ABC Analysis` · `Inventory Management` · `Supply Chain Analytics` · `DBeaver`

---

## About

Built as a supply chain analytics portfolio project to demonstrate SQL proficiency on a realistic inventory dataset.  
**Author:** Preet | M.S. Engineering Management, USC Viterbi '26  
[LinkedIn](https://www.linkedin.com/in/preet) · [GitHub](https://github.com/preet)
