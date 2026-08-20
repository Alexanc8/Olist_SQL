# Olist_SQL
# Olist E-Commerce SQL Analysis
 
SQL portfolio project analyzing the [Olist Brazilian E-Commerce dataset](https://www.kaggle.com/olistbr/brazilian-ecommerce) using PostgreSQL (Supabase).
 
## What's here
- `schema/` — table definitions, keys, indexes
- 01 through 04 — joins, aggregation, filtering
- 05 through 08 — CTEs, subqueries, HAVING
- 09 through 12 — window functions, RFM segmentation, cohort retention
## Highlights
- **Cohort retention** query using `customer_unique_id` to correctly track repeat customers (Olist regenerates `customer_id` per order — a common trap in this dataset)
- **RFM segmentation** using `NTILE()` window functions
- Handled real data quality issues: missing rows in the category translation table
## Run it
```bash
psql "$DATABASE_URL" -f 12_cohort_retention.sql
```
