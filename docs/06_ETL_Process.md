# ETL Process

# Card Transaction & Merchant Analytics

---

> **Update notice:** an earlier version of this document referenced a folder structure (`02_cleaning/`, `03_dimension_loading/`, `04_validation/`) that didn't match the repository at the time, and was corrected to describe `sql/` as it actually existed. `sql/02_cleaning/` has since been added for real — see Step 3 below — so this notice is now historical, not a live discrepancy.

## Purpose

This document explains the Extract, Transform, and Load (ETL) pipeline that takes raw card-transaction data from flat files to an analysis-ready star schema.

## ETL Overview

```
Raw CSV/JSON Files (data/raw/)
      │
      ▼
Extract → Staging Tables (sql/01_ddl/01_staging_tables.sql)
      │
      ▼
Clean → Currency Casting (sql/02_cleaning/01_clean_currency_fields.sql)
      │
      ▼
Load → Dimension Tables (sql/03_load/01_load_dimensions.sql — date parsing, PAN masking)
      │
      ▼
Load → Fact Table (sql/03_load/02_load_transactions.sql)
      │
      ▼
Validate → Row counts, orphan-key checks (sql/09_testing/01_table_tests.sql)
      │
      ▼
Operationalize → Indexes, Views, Functions, Procedures, Triggers, Security
      │
      ▼
SQL Business Analytics → Power BI Dashboard
```

## Step 1 — Extract

Source files, imported without modification:

- `users_data.csv`
- `cards_data.csv`
- `transactions_data.csv`
- `mcc_codes.json` (loaded via `scripts/load_mcc.py`, not `\copy`, since it's JSON)

## Step 2 — Staging Layer

**Tables:** `stg_users`, `stg_cards`, `stg_transactions`

**Purpose:** preserve the original data untouched, guarantee the raw load never fails on formatting, and separate raw data from reporting tables. Columns that are numeric/date/boolean in the target schema are kept as `TEXT` in staging specifically because a `COPY` into a typed column fails the entire batch on the first malformed value (e.g., `"$1,234.56"` into `NUMERIC`).

## Step 3 — Data Cleaning (Currency Fields)

Performed in `sql/02_cleaning/01_clean_currency_fields.sql`, which sits between staging and load: three views (`vw_stg_users_clean`, `vw_stg_cards_clean`, `vw_stg_transactions_clean`) select every staging column unchanged except the monetary ones, which are cast from `TEXT` to `NUMERIC(12,2)`:

```sql
REPLACE(per_capita_income, '$', '')::NUMERIC(12,2)
```

Transaction amounts additionally use `REGEXP_REPLACE` to handle the signed (`-$12.34`-style) format:

```sql
REGEXP_REPLACE(amount, '[^0-9.-]', '', 'g')::NUMERIC(12,2)
```

`sql/03_load/*.sql` selects `FROM` these views instead of the raw `stg_*` tables, so the dimension/fact load reads already-typed amounts rather than repeating the cast inline. The other cleaning steps stay inline in the load scripts, next to the table they type:

**Boolean fields** — `has_chip` cast from `"YES"`/`"NO"` text to `BOOLEAN` (`sql/03_load/01_load_dimensions.sql`).

**Date fields** — `acct_open_date` parsed from `"MM/YYYY"` text via `TO_DATE(acct_open_date, 'MM/YYYY')` (`sql/03_load/01_load_dimensions.sql`).

**PII/security hygiene** — card PAN reduced to a masked last-4 value (`'XXXX-XXXX-XXXX-' || RIGHT(card_number, 4)`); CVV dropped entirely and never promoted past `stg_cards` (`sql/03_load/01_load_dimensions.sql`).

**Merchant de-duplication** — `dim_merchant` is populated via `SELECT DISTINCT merchant_id, merchant_city, merchant_state, zip FROM stg_transactions`, which is what establishes the surrogate `merchant_key` (`sql/03_load/01_load_dimensions.sql`).

## Step 4 — Dimension Load

`sql/03_load/01_load_dimensions.sql` populates `dim_users`, `dim_cards`, `dim_merchant` (in that order — `dim_cards` depends on `dim_users` existing for its FK, and the fact load depends on `dim_merchant` existing for its join), reading `dim_users`/`dim_cards` source rows from `vw_stg_users_clean`/`vw_stg_cards_clean` rather than the raw staging tables. `dim_mcc` is populated separately by `scripts/load_mcc.py` from `mcc_codes.json`.

## Step 5 — Fact Load

`sql/03_load/02_load_transactions.sql` populates `fact_transactions` by joining `vw_stg_transactions_clean` to `dim_merchant` on `merchant_id` plus city/state/zip.

**A specific, important detail:** this join uses `IS NOT DISTINCT FROM` rather than `=` on the nullable `merchant_city`/`merchant_state`/`zip` columns:

```sql
FROM vw_stg_transactions_clean t
JOIN dim_merchant dm
    ON t.merchant_id = dm.merchant_id
   AND t.merchant_city IS NOT DISTINCT FROM dm.merchant_city
   AND t.merchant_state IS NOT DISTINCT FROM dm.merchant_state
   AND t.zip IS NOT DISTINCT FROM dm.zip;
```

An earlier version used plain `=`, which silently dropped every online transaction from the fact table — `merchant_state`/`zip` are `NULL` for card-not-present transactions, and in SQL's three-valued logic, `NULL = NULL` evaluates to unknown, not true. The row-count reconciliation query at the bottom of the same script (`staging_row_count` vs. `fact_row_count`, expecting `dropped_rows = 0`) exists specifically to catch a regression of that bug.

## Step 6 — Load Validation

After loading, `sql/09_testing/01_table_tests.sql` runs:

- Row counts per table.
- Duplicate primary-key detection on every dimension and the fact table.
- Orphan-record detection (fact rows whose `user_id`/`card_id`/`merchant_key`/`mcc` don't match any dimension row).

Full detail in [`18_Technical_Validation.md`](18_Technical_Validation.md).

## Load Strategy

The current load is **full truncate-and-reload** (`sp_truncate_fact_transactions`, then re-run the load scripts) — appropriate for a static historical dataset loaded once, not an incremental/CDC pipeline. This is flagged as a gap to address before this design could support a recurring or live feed — see [`14_ER_Diagram_Architecture.md §8`](14_ER_Diagram_Architecture.md#8-production-readiness-gaps--recommended-improvements).

## ETL Best Practices Followed

- Raw data preserved untouched in staging.
- Transformations (casting, masking, de-duplication) kept separate from and downstream of the raw load.
- Validation queries run immediately after every load, not deferred.
- Consistent naming conventions across staging, dimension, and fact tables.

## Future Improvements

- Incremental/upsert loading keyed on `transaction_id`, instead of full truncate-and-reload.
- A conformed `dim_date` populated during ETL rather than derived inline per query.
- Load lineage tracking (`load_batch_id`/`load_timestamp`) on staging tables — useful the moment there's more than one historical load.
- Workflow orchestration (e.g., a scheduler) if this pipeline ever needs to run on a recurring cadence.

## Conclusion

The ETL pipeline converts raw, inconsistently-formatted card-transaction files into a validated, governed star schema, with an explicit, documented fix (the `IS NOT DISTINCT FROM` join) for a real bug the pipeline used to have — a more useful thing to document than a pipeline that's never had a bug worth learning from.
