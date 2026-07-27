# Data Profile: `users_data.csv`

# Card Transaction & Merchant Analytics

---

Computed directly against `data/raw/users_data.csv` (not estimated) via `pandas`. See [`docs/04_Data_Dictionary.md`](../docs/04_Data_Dictionary.md) for how these columns map to `stg_users` / `dim_users`.

## Overview

- **Rows:** 2,000
- **Columns:** 14
- **Grain:** 1 row = 1 user
- **Missing values:** none, in any column
- **Duplicate `id` values:** 0

## Column Profile

| Column | Type | Missing | Unique | Notes |
|---|---|---:|---:|---|
| `id` | int | 0 | 2,000 | Unique per row — safe as `dim_users.user_id` with no dedup needed |
| `current_age` | int | 0 | 80 | Range 18–101 |
| `retirement_age` | int | 0 | 29 | Range 50–79 |
| `birth_year` | int | 0 | 80 | Range 1918–2002 |
| `birth_month` | int | 0 | 12 | 1–12, as expected |
| `gender` | text | 0 | 2 | `Female` (1,016 / 50.8%), `Male` (984 / 49.2%) — no other values, no missing |
| `address` | text | 0 | 1,999 | **1 duplicate address across 2 different user rows** — flagged below |
| `latitude` | float | 0 | 989 | Range 20.88–61.20 |
| `longitude` | float | 0 | 1,224 | Range -159.41–-68.67 (the low end corresponds to Hawaii/Alaska-range longitudes, consistent with a US-wide user base) |
| `per_capita_income` | text (`"$…"`) | 0 | 1,754 | Range $0–$163,145; mean $23,141.93 |
| `yearly_income` | text (`"$…"`) | 0 | 1,948 | Range $1–$307,018; mean $45,715.88 |
| `total_debt` | text (`"$…"`) | 0 | 1,880 | Range $0–$516,263; mean $63,709.69 |
| `credit_score` | int | 0 | 321 | Range 480–850; mean 709.73 |
| `num_credit_cards` | int | 0 | 9 | Range 1–9; mean 3.07 |

## Categorical Distributions

**`num_credit_cards`:**

| Cards | Users |
|---:|---:|
| 1 | 416 |
| 2 | 388 |
| 3 | 449 |
| 4 | 376 |
| 5 | 206 |
| 6 | 105 |
| 7 | 40 |
| 8 | 17 |
| 9 | 3 |

## Data Quality Findings

- **No missing values anywhere.** This is a clean synthetic source file — no null-handling was required for `stg_users` beyond the intentional TEXT-typed currency columns (see [`06_ETL_Process.md`](../docs/06_ETL_Process.md)).
- **`per_capita_income` minimum is $0 and `yearly_income` minimum is $1.** Both are plausible edge cases in a synthetic dataset (a user with effectively no recorded income) rather than obvious errors, but worth knowing if a query ever divides by these fields — neither is currently used as a divisor anywhere in `sql/`.
- **One duplicate address across two distinct `id` values.** Not a referential-integrity problem (each row still has a unique `id`), but worth knowing this exists if `address` is ever used as a join or grouping key — it currently isn't.
- **`credit_score` mean (709.73) matches the value shown on the Customer Analytics dashboard page** (`docs/15_Dashboard_Documentation.md`), confirming the pipeline preserves this figure unchanged from source through to the dashboard.

## Cross-Reference

This profile is the upstream source for [`docs/03_Dataset_Description.md`](../docs/03_Dataset_Description.md) and the `dim_users` design in [`docs/04_Data_Dictionary.md`](../docs/04_Data_Dictionary.md).
