# Data Profile: `cards_data.csv`

# Card Transaction & Merchant Analytics

---

Computed directly against `data/raw/cards_data.csv` via `pandas`. See [`docs/04_Data_Dictionary.md`](../docs/04_Data_Dictionary.md) for how these columns map to `stg_cards` / `dim_cards`.

## Overview

- **Rows:** 6,146
- **Columns:** 13
- **Grain:** 1 row = 1 physical card
- **Missing values:** none, in any column
- **Duplicate `id` values:** 0
- **Orphan `client_id`** (referencing a user that doesn't exist in `users_data.csv`): **0** — referential integrity holds at the source-file level, before any database constraint is applied

## Column Profile

| Column | Type | Missing | Unique | Notes |
|---|---|---:|---:|---|
| `id` | int | 0 | 6,146 | Unique per row — maps to `dim_cards.card_id` |
| `client_id` | int | 0 | 2,000 | Every value resolves to a real `users_data.csv` row (0 orphans) — 2,000 of 2,000 users own at least one card |
| `card_brand` | text | 0 | 4 | `Amex`, `Discover`, `Mastercard`, `Visa` |
| `card_type` | text | 0 | 3 | `Credit`, `Debit`, `Debit (Prepaid)` |
| `card_number` | int | 0 | 6,146 | Unique per row — **staging-only**, never promoted into `dim_cards` (masked to last-4 instead) |
| `expires` | text | 0 | 259 | `MM/YYYY`-style expiry strings |
| `cvv` | int | 0 | 998 | Range 0–999 — **staging-only**, dropped entirely before promotion (never enters `dim_cards`) |
| `has_chip` | text | 0 | 2 | `YES` / `NO` — cast to `BOOLEAN` on promotion |
| `num_cards_issued` | int | 0 | 3 | Range 1–3; mean 1.50 |
| `credit_limit` | text (`"$…"`) | 0 | 3,654 | Range $0–$151,223; mean $14,347.49 |
| `acct_open_date` | text | 0 | 303 | `MM/YYYY` strings — parsed to `DATE` on promotion |
| `year_pin_last_changed` | int | 0 | 19 | Range 2002–2020; mean 2013.44 |
| `card_on_dark_web` | text | 0 | **1** | Every row is `No` — a zero-variance column in this dataset |

## Categorical Distributions

**`card_brand`** and **`card_type`** cross-tab is available on request; both are low-cardinality and used directly in [`docs/15_Dashboard_Documentation.md`](../docs/15_Dashboard_Documentation.md)'s "Total Revenue by card_brand" visual, where Mastercard and Visa dominate over Amex and Discover.

## Data Quality Findings

- **No missing values anywhere**, same as `users_data.csv`.
- **`card_on_dark_web` has exactly one distinct value (`No`) across all 6,146 rows** — a zero-variance column with no analytical use in this dataset. This confirms, rather than contradicts, the decision already made in `sql/03_load/01_load_dimensions.sql`: the column is intentionally **not** selected into `dim_cards` at all. If a future data refresh ever introduces `Yes` values, this column would need to be re-evaluated and explicitly added back.
- **`credit_limit` minimum is $0.** A card with a $0 credit limit is a plausible synthetic edge case (e.g., a closed or restricted account) rather than a load error — worth knowing before writing any query that divides by `credit_limit`.
- **`cvv` ranges 0–999 with 998 distinct values** — consistent with a real 3-digit CVV space (000–999, 1,000 possible values), and correctly treated as sensitive: staging-only, dropped before promotion (see [`docs/14_ER_Diagram_Architecture.md §7`](../docs/14_ER_Diagram_Architecture.md#7-data-warehouse-design-decisions)).
- **Every `client_id` resolves to a real user, and every one of the 2,000 users owns at least one card** — the cards table has full coverage of the user base, unlike the transactions table (see `transactions_profile.md`), where only a subset of users and cards actually appear.

## Cross-Reference

This profile is the upstream source for the `dim_cards` design in [`docs/04_Data_Dictionary.md`](../docs/04_Data_Dictionary.md) and the PII-handling decisions documented in [`docs/14_ER_Diagram_Architecture.md`](../docs/14_ER_Diagram_Architecture.md).
