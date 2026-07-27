# Technical Validation

# Card Transaction & Merchant Analytics

---

## Purpose

This document consolidates the load-time and structural validation actually implemented in this project — what's checked, where the checks live, and what they'd catch. Every check described here is a real, runnable script in `sql/09_testing/` or embedded in `sql/03_load/`, not a description of a hypothetical test suite.

## ETL Validation Summary

| Stage | Validation | Script |
|---|---|---|
| Dimension load | Row count per dimension | `sql/03_load/01_load_dimensions.sql` |
| Fact load | Row count | `sql/03_load/02_load_transactions.sql` |
| Fact load | **Row-count reconciliation** — `staging_row_count − fact_row_count` must equal zero | `sql/03_load/02_load_transactions.sql` |
| Fact load | Min/max `amount` sanity range | `sql/03_load/02_load_transactions.sql` |
| Fact load | Orphan `user_id`, `card_id`, `merchant_key`, `mcc` detection | `sql/03_load/02_load_transactions.sql` |
| Post-load | Row counts across all tables | `sql/09_testing/01_table_tests.sql` |
| Post-load | Duplicate primary-key detection | `sql/09_testing/01_table_tests.sql` |
| Post-load | Orphan-record detection (repeated, independent of the load script) | `sql/09_testing/01_table_tests.sql` |
| Views | Row counts + sample rows for every view | `sql/09_testing/02_view_tests.sql` |
| Functions | Output smoke tests, including invalid-input cases | `sql/09_testing/03_function_tests.sql` |

## The Row-Count Reconciliation Check, Specifically

```sql
SELECT
    (SELECT COUNT(*) FROM stg_transactions)  AS staging_row_count,
    (SELECT COUNT(*) FROM fact_transactions) AS fact_row_count,
    (SELECT COUNT(*) FROM stg_transactions) - (SELECT COUNT(*) FROM fact_transactions) AS dropped_rows;
```

This exists because of a real bug: the fact-load join to `dim_merchant` originally used `=` on nullable `merchant_city`/`merchant_state`/`zip` columns, which silently dropped every online transaction (where those columns are `NULL`) because `NULL = NULL` is not `TRUE` in SQL. Switching the join to `IS NOT DISTINCT FROM` fixed it; this query is what would catch a regression of that exact class of bug — `dropped_rows` should always evaluate to `0`.

## Foreign Key Validation

Enforced structurally via `REFERENCES` constraints:

| Table | Column | References |
|---|---|---|
| `dim_cards` | `user_id` | `dim_users.user_id` |
| `fact_transactions` | `user_id` | `dim_users.user_id` |
| `fact_transactions` | `card_id` | `dim_cards.card_id` |
| `fact_transactions` | `merchant_key` | `dim_merchant.merchant_key` |
| `fact_transactions` | `mcc` | `dim_mcc.mcc` |

**Not currently enforced:** `audit_log.transaction_id` → `fact_transactions.transaction_id` is populated correctly by the audit trigger but has no `REFERENCES` clause — see [`14_ER_Diagram_Architecture.md §8`](14_ER_Diagram_Architecture.md#8-production-readiness-gaps--recommended-improvements).

Beyond the FK constraints themselves, `sql/09_testing/01_table_tests.sql` independently re-checks for orphans via `LEFT JOIN ... WHERE <fk_column> IS NULL` — belt-and-suspenders validation that doesn't rely solely on the constraint having been enforced correctly at load time.

## Data Integrity Checks

- **Duplicate primary keys:** explicit `GROUP BY <pk> HAVING COUNT(*) > 1` checks on `dim_users`, `dim_cards`, `dim_merchant`, and `fact_transactions`.
- **Currency precision:** all monetary columns are `NUMERIC(12,2)`, never `FLOAT`, eliminating binary floating-point rounding error across 13.3M+ aggregated rows.
- **PII hygiene:** card PAN reduced to a masked last-4 value at load time; CVV dropped entirely, never promoted past `stg_cards`.

## Known Limitations

- **No automated test framework** — validation queries in `sql/09_testing/` are run manually, not wired into CI. Acceptable for a static, single-load historical dataset; would need to change for a recurring pipeline.
- **`audit_log.transaction_id` has no enforced FK** (noted above).
- **`dim_merchant`'s natural key is protected only by a non-unique index**, not a `UNIQUE` constraint — a reload outside the current `SELECT DISTINCT` load path could theoretically insert duplicates.
- **No `CHECK` constraint on `fact_transactions.amount`** — `NOT NULL` is enforced, but no range sanity-check exists beyond the manual min/max query run at load time.
- **Full truncate-and-reload**, not incremental — every re-run replays the entire fact-load and validation sequence rather than upserting deltas.

## Performance Considerations

Indexing is scoped to the columns actually used across the 12-module analytics library — every dimension FK on `fact_transactions`, plus `txn_date` (range scans) and `amount` (direct filter/sort use). See [`12_Query_Optimization.md`](12_Query_Optimization.md) for the full indexing table and SQL-level optimization techniques (early filtering, window functions over self-joins, CTEs).

The highest-leverage next performance step, given the fact table's current size (~13.3M rows), is native PostgreSQL partitioning on `txn_date` — not yet implemented, tracked in [`14_ER_Diagram_Architecture.md §8`](14_ER_Diagram_Architecture.md#8-production-readiness-gaps--recommended-improvements).

## Conclusion

Validation in this project is real and load-integrated, not aspirational: every check described above is a script that runs today, and the row-count reconciliation check exists specifically because it once caught (and now guards against regressing) an actual data-loss bug in the fact load. The known limitations above are the honest next layer of validation this project doesn't yet have, not gaps being hidden.
