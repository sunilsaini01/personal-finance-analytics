# Data Dictionary

# Card Transaction & Merchant Analytics

---

## Purpose

This document describes every table and column in the warehouse, across the staging, dimension, fact, and audit layers. It's the single source of truth for column-level meaning — if this document and a query disagree, this document (cross-checked against the DDL in `sql/01_ddl/`) wins.

For the entity-relationship diagram and design rationale, see [`14_ER_Diagram_Architecture.md`](14_ER_Diagram_Architecture.md).

## Database Overview

| Layer | Tables |
|---|---|
| Staging | `stg_users`, `stg_cards`, `stg_transactions` |
| Dimension | `dim_users`, `dim_cards`, `dim_mcc`, `dim_merchant` |
| Fact | `fact_transactions` |
| Audit | `audit_log` |

---

## Table: `stg_users`

Raw 1:1 landing zone for `users_data.csv`. Currency fields are kept as `TEXT` because a `COPY` into a typed column fails the whole batch on the first `"$45,000.00"`-style value.

| Column | Data Type | Description |
|---|---|---|
| id | INTEGER (PK) | Natural user identifier from the source file |
| current_age | INTEGER | User's current age |
| retirement_age | INTEGER | Expected retirement age |
| birth_year | INTEGER | Year of birth |
| birth_month | INTEGER | Month of birth |
| gender | TEXT | User gender |
| address | TEXT | Residential address |
| latitude | NUMERIC(9,6) | Geographic latitude |
| longitude | NUMERIC(9,6) | Geographic longitude |
| per_capita_income | TEXT | Raw currency string, e.g. `"$45,000.00"` |
| yearly_income | TEXT | Raw currency string |
| total_debt | TEXT | Raw currency string |
| credit_score | INTEGER | Credit score |
| num_credit_cards | INTEGER | Number of credit cards owned |

## Table: `stg_cards`

Raw 1:1 landing zone for `cards_data.csv`.

| Column | Data Type | Description |
|---|---|---|
| id | INTEGER (PK) | Natural card identifier |
| client_id | INTEGER, NOT NULL | Owning user's id |
| card_brand | TEXT | Card network (e.g. Mastercard, Visa) |
| card_type | TEXT | Card type |
| card_number | TEXT | Full card number — **staging only, never promoted** |
| expires | TEXT | Expiry date string |
| cvv | TEXT | Card verification value — **staging only, dropped before promotion** |
| has_chip | TEXT | `"YES"`/`"NO"` string, cast to `BOOLEAN` on promotion |
| num_cards_issued | INTEGER | Number of cards issued under this account |
| credit_limit | TEXT | Raw currency string |
| acct_open_date | TEXT | `"MM/YYYY"` string, parsed to `DATE` on promotion |
| year_pin_last_changed | INTEGER | Year the PIN was last changed |
| card_on_dark_web | TEXT | Sourced but not currently promoted to `dim_cards` |

## Table: `stg_transactions`

Raw 1:1 landing zone for `transactions_data.csv` (~13.3M rows).

| Column | Data Type | Description |
|---|---|---|
| id | BIGINT (PK) | Natural transaction identifier |
| date | TIMESTAMP, NOT NULL | Transaction date and time |
| client_id | INTEGER, NOT NULL | User id |
| card_id | INTEGER, NOT NULL | Card id |
| amount | TEXT, NOT NULL | Raw signed currency string; cast to `NUMERIC` on promotion |
| use_chip | TEXT | Payment channel: Swipe / Chip / Online Transaction |
| merchant_id | BIGINT, NOT NULL | Natural merchant identifier — **not unique alone**, see `dim_merchant` |
| merchant_city | TEXT | Merchant city; `NULL` for online transactions |
| merchant_state | TEXT | Merchant state; `NULL` for online transactions |
| zip | TEXT | Merchant zip; `NULL` for online transactions |
| mcc | TEXT | Merchant Category Code |
| errors | TEXT | Error/decline reason, if any (may be a compound multi-reason string) |

---

## Table: `dim_users`

Grain: 1 row = 1 user (~2,000 rows). Type-1 (overwrite) dimension — no history of income/credit-score changes is tracked.

**Primary Key:** `user_id`
**Referenced by:** `dim_cards.user_id`, `fact_transactions.user_id`

Same columns as `stg_users`, with `per_capita_income`, `yearly_income`, and `total_debt` cast to `NUMERIC(12,2)`.

## Table: `dim_cards`

Grain: 1 row = 1 physical card (~6,146 rows).

**Primary Key:** `card_id`
**Foreign Key:** `user_id` → `dim_users.user_id`
**Referenced by:** `fact_transactions.card_id`

| Column | Data Type | Description |
|---|---|---|
| card_id | INTEGER (PK) | |
| user_id | INTEGER (FK), NOT NULL | |
| card_brand | TEXT | |
| card_type | TEXT | |
| card_number_masked | TEXT | Derived as `XXXX-XXXX-XXXX-<last 4>` — full PAN never leaves staging |
| expires | TEXT | |
| has_chip | BOOLEAN | Cast from staging's `"YES"`/`"NO"` |
| num_cards_issued | INTEGER | |
| credit_limit | NUMERIC(12,2) | |
| acct_open_date | DATE | Parsed from staging's `"MM/YYYY"` |
| year_pin_last_changed | INTEGER | |

## Table: `dim_mcc`

Grain: 1 row = 1 Merchant Category Code (~109 rows). Loaded from `mcc_codes.json` via `scripts/load_mcc.py`.

**Primary Key:** `mcc`
**Referenced by:** `fact_transactions.mcc`

| Column | Data Type | Description |
|---|---|---|
| mcc | TEXT (PK) | Merchant Category Code |
| description | TEXT, NOT NULL | Category description (e.g. "Grocery Stores, Supermarkets") |

## Table: `dim_merchant`

Grain: 1 row = 1 distinct `(merchant_id, merchant_city, merchant_state, zip)` combination.

**Primary Key:** `merchant_key` (surrogate, `SERIAL`)
**Referenced by:** `fact_transactions.merchant_key`

| Column | Data Type | Description |
|---|---|---|
| merchant_key | INTEGER (PK, surrogate) | Required because `merchant_id` alone repeats across locations in the source data |
| merchant_id | BIGINT, NOT NULL | Natural merchant identifier |
| merchant_city | TEXT | `NULL` for online/card-not-present merchants |
| merchant_state | TEXT | `NULL` for online/card-not-present merchants |
| zip | TEXT | `NULL` for online/card-not-present merchants |

---

## Table: `fact_transactions`

**This is the fact table** — grain: 1 row = 1 card transaction (~13.3M rows).

**Primary Key:** `transaction_id`
**Foreign Keys:** `user_id` → `dim_users.user_id`, `card_id` → `dim_cards.card_id`, `merchant_key` → `dim_merchant.merchant_key`, `mcc` → `dim_mcc.mcc`

| Column | Data Type | Description |
|---|---|---|
| transaction_id | BIGINT (PK) | |
| txn_date | TIMESTAMP, NOT NULL | |
| user_id | INTEGER (FK), NOT NULL | |
| card_id | INTEGER (FK), NOT NULL | |
| merchant_key | INTEGER (FK) | |
| mcc | TEXT (FK) | |
| amount | NUMERIC(12,2), NOT NULL | Signed additive measure — positive = spend, negative = refund |
| use_chip | TEXT | Degenerate dimension: payment channel |
| errors | TEXT | Degenerate dimension: failure reason, if any |

## Table: `audit_log`

Grain: 1 row = 1 `INSERT` event on `fact_transactions`, written by the `trg_transaction_audit` trigger.

**Primary Key:** `audit_id`
**Logical reference (not DB-enforced):** `transaction_id` → `fact_transactions.transaction_id` — see [`14_ER_Diagram_Architecture.md §8`](14_ER_Diagram_Architecture.md#8-production-readiness-gaps--recommended-improvements) for why this should become a real FK.

| Column | Data Type | Description |
|---|---|---|
| audit_id | BIGINT (PK, `BIGSERIAL`) | |
| transaction_id | BIGINT | The inserted transaction's id |
| action_type | TEXT | Populated from `TG_OP` (e.g. `INSERT`) |
| action_time | TIMESTAMP | Defaults to `CURRENT_TIMESTAMP` |

---

## Primary Relationships

| Parent | Child | Relationship |
|---|---|---|
| dim_users | dim_cards | One-to-Many |
| dim_users | fact_transactions | One-to-Many |
| dim_cards | fact_transactions | One-to-Many |
| dim_merchant | fact_transactions | One-to-Many |
| dim_mcc | fact_transactions | One-to-Many |
| fact_transactions | audit_log | One-to-Many (logical only) |

## Business Keys

| Business Entity | Key |
|---|---|
| User | user_id |
| Card | card_id |
| Merchant (location) | merchant_key (surrogate); merchant_id is the natural but non-unique identifier |
| Transaction | transaction_id |
| Category | mcc |

## Frequently Used Analytical Columns

- `amount`, `txn_date`, `use_chip`, `errors` — from `fact_transactions`
- `merchant_key`, `merchant_city`, `merchant_state` — from `dim_merchant`
- `mcc`, `description` — from `dim_mcc`
- `user_id`, `gender`, `current_age`, `credit_score`, `yearly_income`, `total_debt` — from `dim_users`
- `card_brand`, `card_type` — from `dim_cards`

## Data Quality Notes

Preprocessing completed before analytical use (see [`06_ETL_Process.md`](06_ETL_Process.md) for the full walkthrough):

- Currency symbols stripped and monetary fields cast from `TEXT` to `NUMERIC(12,2)`.
- `has_chip` cast from `"YES"`/`"NO"` text to `BOOLEAN`.
- `acct_open_date` parsed from `"MM/YYYY"` text to `DATE`.
- Card PAN masked to last four digits; CVV dropped entirely.
- Primary/foreign key relationships validated at load time (row-count reconciliation, orphan-key checks) — see [`18_Technical_Validation.md`](18_Technical_Validation.md).

## Conclusion

This data dictionary is the centralized reference for every table and column used in the warehouse. It replaces an earlier version that omitted `dim_merchant` and `audit_log` entirely and incorrectly implied `stg_transactions` was the fact table — corrected here to match the actual DDL in `sql/01_ddl/`.
