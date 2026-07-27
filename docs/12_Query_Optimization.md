# Query Optimization

# Card Transaction & Merchant Analytics

---

> **Correction notice:** an earlier version of this document stated "indexes were not created in this project." That's no longer accurate — `sql/04_indexes/` contains real indexes, added specifically because the transaction table is large enough (~13.3M rows) that unindexed dimension joins and date-range scans would be materially slower. This document now describes what's actually implemented.

## Purpose

This document describes the SQL and indexing optimization techniques used to keep analytical queries efficient against a 13.3M+ row transaction table.

## Project Dataset

| Table | Approximate Records |
|---|---:|
| Users | 2,000 |
| Cards | 6,146 |
| Transactions | 13.3 Million+ |
| MCC Categories | 109 |

## Indexing Strategy

Implemented in `sql/04_indexes/01_indexes.sql` and `02_fact_indexes.sql`:

| Table | Indexed Column(s) | Reason |
|---|---|---|
| `dim_users` | `user_id` | Dimension join target |
| `dim_cards` | `card_id`, `user_id` | Dimension join target + FK lookup |
| `dim_merchant` | `merchant_id, merchant_city, merchant_state, zip` (composite) | Supports the fact-load join on the natural key tuple |
| `dim_mcc` | `mcc` | Dimension join target |
| `stg_transactions` | `merchant_id, merchant_city, merchant_state, zip` (composite) | Supports the `dim_merchant` de-duplication query at load time |
| `fact_transactions` | `txn_date` | Range scans for time-series/monthly analysis |
| `fact_transactions` | `user_id` | Customer-level joins and segmentation |
| `fact_transactions` | `card_id` | Card-brand/type analysis |
| `fact_transactions` | `merchant_key` | Merchant performance analysis |
| `fact_transactions` | `mcc` | Category analysis |
| `fact_transactions` | `amount` | Direct use in `WHERE`/`ORDER BY` across the business-analytics library |

Indexing follows the query shape actually used in `sql/10_business_analytics/`, not a blanket "index everything" policy — every indexed column is either a dimension-join FK or a column directly filtered/sorted on in the analytics library.

## SQL Optimization Techniques

**Filter early** — apply `WHERE amount > 0` (or similar) before aggregation wherever the business logic allows, reducing rows processed before the expensive aggregation step.

**Aggregate only required columns:**

```sql
SELECT mcc, SUM(amount)
FROM fact_transactions
GROUP BY mcc;
```

**Avoid `SELECT *`** in favor of explicit column lists — lower I/O, clearer intent.

**Window functions** for running totals, rolling averages, month-over-month growth, and customer ranking — avoiding self-joins:

```sql
SUM(revenue) OVER (ORDER BY month)
```

**Common Table Expressions (CTEs)** for multi-step analytical queries — improves readability and lets intermediate results be reused within one query instead of repeated as subqueries.

**Consistent, centralized cleaning** — monetary values cast once at load time (`REGEXP_REPLACE(amount, '[^0-9.-]', '', 'g')::NUMERIC`), not repeatedly at query time.

## Performance Best Practices

- Meaningful aliases and modular, readable SQL.
- Filter before grouping; aggregate only what's needed.
- Prefer window functions for trend analysis over self-joins.
- Use CTEs for multi-step logic instead of deeply nested subqueries.
- Index every dimension FK on the fact table, plus any column directly filtered/sorted on at scale.

## Power BI Considerations

Views in `sql/05_views` and `sql/11_dashboard_views` are designed so Power BI queries a small set of stable, pre-aggregated views rather than re-deriving business logic inside Power Query — reducing both transformation load and dashboard refresh time.

## Future Improvements

- **Table partitioning** on `fact_transactions` by `txn_date` (e.g., yearly range partitions) — the highest-leverage next step at this table's current size; see [`14_ER_Diagram_Architecture.md §8`](14_ER_Diagram_Architecture.md#8-production-readiness-gaps--recommended-improvements).
- **Materialized views** for the most expensive repeated aggregations, refreshed on the same cadence as the load.
- **A `UNIQUE` constraint** (not just a lookup index) on `dim_merchant`'s natural key tuple.
- **A `CHECK` constraint** on `fact_transactions.amount` as cheap insurance against absurd-magnitude data-entry errors.

## Conclusion

Query performance at this scale rests on two things working together: indexes placed on exactly the columns the analytics library actually filters/joins on, and SQL patterns (early filtering, window functions, CTEs) that keep the query planner's job simple. Both are implemented and verifiable directly in `sql/04_indexes/` and `sql/10_business_analytics/`.
