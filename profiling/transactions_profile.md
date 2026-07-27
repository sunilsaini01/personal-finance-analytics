# Data Profile: `transactions_data.csv`

# Card Transaction & Merchant Analytics

---

Computed directly against `data/raw/transactions_data.csv` (1.25 GB, 13,305,915 rows) via chunked `pandas` processing (1M-row chunks). See [`docs/04_Data_Dictionary.md`](../docs/04_Data_Dictionary.md) for how these columns map to `stg_transactions` / `fact_transactions`.

## Overview

- **Rows:** 13,305,915
- **Columns:** 12
- **Grain:** 1 row = 1 card transaction
- **Duplicate `id` values:** 0 — every transaction id is unique
- **Date range:** 2010-01-01 00:01:00 to 2019-10-31 23:59:00

## Column Profile

| Column | Missing | Missing % | Notes |
|---|---:|---:|---|
| `id` | 0 | 0% | Unique per row |
| `date` | 0 | 0% | Full timestamp range 2010–2019 |
| `client_id` | 0 | 0% | **1,219 distinct values** — see finding below |
| `card_id` | 0 | 0% | **4,071 distinct values** — see finding below |
| `amount` | 0 | 0% | Range -$500.00 to $6,820.20; mean $42.9760; sum $571,835,522.28 |
| `use_chip` | 0 | 0% | 3 values — see distribution below |
| `merchant_id` | 0 | 0% | 74,831 distinct values |
| `merchant_city` | 0 | 0% | No missing — always populated, even for online transactions |
| `merchant_state` | 1,563,700 | 11.75% | Null for online / card-not-present transactions |
| `zip` | 1,652,706 | 12.42% | Null for online / card-not-present transactions (slightly more null than `merchant_state` — the two aren't perfectly co-null) |
| `mcc` | 0 | 0% | Every transaction has a Merchant Category Code |
| `errors` | 13,094,522 | 98.41% | Null = no error; see failure breakdown below |

## Key Statistics

**Amount:**
- Min: -$500.00 (a refund) · Max: $6,820.20 · Mean: $42.98 · Sum: $571,835,522.28
- Negative-amount (refund) rows: 660,049 (4.96% of all transactions)
- **This mean and sum match the Executive Overview dashboard exactly** (Average Transaction `$42.9760...`, Total Revenue `571.84M`) — confirms the pipeline preserves these figures unchanged from raw source through `fact_transactions` to the dashboard.

**Payment channel (`use_chip`):**

| Channel | Count | % |
|---|---:|---:|
| Swipe Transaction | 6,967,185 | 52.36% |
| Chip Transaction | 4,780,818 | 35.93% |
| Online Transaction | 1,557,912 | 11.71% |

These percentages match the dashboard's Payment Method Distribution donut exactly (see [`docs/15_Dashboard_Documentation.md`](../docs/15_Dashboard_Documentation.md)).

**Transaction failures (`errors`):**

| Error Type | Count |
|---|---:|
| *(no error)* | 13,094,522 (98.41%) |
| Insufficient Balance | 130,902 |
| Bad PIN | 32,119 |
| Technical Glitch | 26,271 |
| Bad Card Number | 7,767 |
| Bad Expiration | 6,161 |
| Bad CVV | 6,106 |
| Bad Zipcode | 1,126 |
| Bad PIN, Insufficient Balance (compound) | 293 |
| Insufficient Balance, Technical Glitch (compound) | 243 |
| *(additional smaller compound combinations)* | remainder of 211,393 total failed rows |

This is the raw-file source of the 98% success rate / 211K failed transactions shown on the Transaction Analytics dashboard page, and confirms Insufficient Balance and Bad PIN are the two leading failure causes at the source-file level, not an artifact introduced anywhere downstream.

## Data Quality Findings

- **Only 1,219 of the 2,000 users in `users_data.csv` (61.0%) appear in the transactions file at all.** 781 users (39.0%) have zero recorded transactions. This is a real, worth-knowing characteristic of the dataset: any "average revenue per customer" figure that divides by the *full* 2,000-user base (as the Executive Overview dashboard's "Avg Revenue / Customer" KPI does) is implicitly averaging over users with zero activity, not just active ones. A "per **active** customer" variant would be a meaningfully different, and arguably more useful, number — worth considering as a KPI addition.
- **Only 4,071 of the 6,146 cards (66.2%) appear in the transactions file.** Consistent with the users finding above — roughly a third of issued cards have no transaction activity in this dataset's time window.
- **`merchant_state` and `zip` are null at slightly different rates** (11.75% vs. 12.42%) — they're not perfectly co-null, meaning a small number of transactions have one populated without the other. Both are consistent with online/card-not-present transactions lacking a physical location, which is exactly the condition the `IS NOT DISTINCT FROM` fix in the fact-load join (see [`docs/06_ETL_Process.md`](../docs/06_ETL_Process.md)) was written to handle correctly.
- **`merchant_city` is never null, even when `merchant_state`/`zip` are** — worth knowing if `merchant_city` is ever used as a proxy for "has a physical location," since it isn't a reliable one on its own.
- **No duplicate transaction ids** across all 13,305,915 rows — the source file itself has no row-level duplication to guard against beyond what `sql/09_testing/01_table_tests.sql` already checks post-load.

## Cross-Reference

This profile is the upstream source for the `fact_transactions` design in [`docs/04_Data_Dictionary.md`](../docs/04_Data_Dictionary.md), the ETL join-fix rationale in [`docs/06_ETL_Process.md`](../docs/06_ETL_Process.md), and directly validates the KPI figures reported in [`docs/15_Dashboard_Documentation.md`](../docs/15_Dashboard_Documentation.md).
