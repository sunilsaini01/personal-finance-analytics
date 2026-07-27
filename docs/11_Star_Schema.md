# Star Schema

# Card Transaction & Merchant Analytics

---

> **Correction notice:** an earlier version of this document described `stg_transactions` as the fact table, omitted `dim_merchant` and `audit_log`, and listed foreign keys as `client_id` (the staging column name) rather than the star schema's actual `user_id`. Corrected below. See [`14_ER_Diagram_Architecture.md`](14_ER_Diagram_Architecture.md) for the full ER diagram and importable DBML.

## What Is a Star Schema?

A star schema is a dimensional modeling technique: one central fact table storing measurable business events, surrounded by dimension tables providing descriptive attributes for filtering, grouping, and analysis.

## Star Schema Overview

```
                          dim_users
                              │
                              │ 1:N (a user issues many cards)
                              │
  dim_merchant  ── N:1 ──  fact_transactions  ── N:1 ──  dim_cards
                              │
                              │ N:1
                              │
                          dim_mcc
```

## Fact Table

### `fact_transactions`

Grain: **1 row = 1 card transaction** (~13.3M rows). This grain was written down and agreed before any analytical SQL was built against the table — the discipline that prevents a fan-out join from silently duplicating rows.

- **Primary Key:** `transaction_id`
- **Foreign Keys:** `user_id`, `card_id`, `merchant_key`, `mcc`
- **Measure:** `amount` (signed — positive = spend, negative = refund)
- **Degenerate dimensions:** `use_chip` (payment channel), `errors` (failure reason)

## Dimension Tables

### `dim_users`

Customer demographic and financial-profile attributes (age, gender, income, credit score, debt). Supports customer segmentation and demographic analysis. Primary key: `user_id`.

### `dim_cards`

Payment card attributes (brand, type, masked card number, credit limit, account open date). Supports card-brand and payment-behavior analysis. Primary key: `card_id`; foreign key `user_id` → `dim_users`.

### `dim_mcc`

Merchant Category Code reference data (~109 rows). Supports spending-category analysis. Primary key: `mcc`.

### `dim_merchant`

Merchant location attributes (merchant id, city, state, zip). Supports merchant and geographic analysis. Primary key: `merchant_key` — a **surrogate** key, because the natural `merchant_id` repeats across multiple physical locations in the source data. Without the surrogate, joining `fact_transactions` to merchant location would fan out one transaction into multiple rows.

## Relationships

| From | To | Relationship |
|---|---|---|
| fact_transactions.user_id | dim_users.user_id | Many-to-One |
| fact_transactions.card_id | dim_cards.card_id | Many-to-One |
| fact_transactions.merchant_key | dim_merchant.merchant_key | Many-to-One |
| fact_transactions.mcc | dim_mcc.mcc | Many-to-One |
| dim_users.user_id | dim_cards.user_id | One-to-Many |

## Why Star Schema?

- **Simpler queries** — every business question is a single join from the fact table to one dimension.
- **Faster reporting** — dimension tables are small relative to the fact table, keeping aggregations fast.
- **Better Power BI performance** — a star-shaped relationship model is exactly what Power BI's engine is optimized for.
- **Scalability** — new dimensions (e.g., a future `dim_date`) can be added without redesigning the existing model.

## Design Principles

- Separate facts (what happened, the measure) from descriptive attributes (who/where/what category).
- Keep dimension joins shallow — no dimension joins to another dimension.
- Maintain referential integrity with real FK constraints, not just documentation.
- Use a surrogate key only where the natural key genuinely breaks down (`dim_merchant`), not as a blanket default.

## Business Analysis Supported

- Customer segmentation and demographic analysis
- Merchant and merchant-category performance analysis
- Payment-channel analysis
- Time-series / net-spend trend analysis
- Transaction reliability (success/failure) analysis

## Limitations

A star schema optimizes for read-heavy analytical queries, not transactional (OLTP) write patterns — appropriate here since this warehouse is loaded in batch from a static historical dataset, not written to by a live transactional system.

The current model has two known gaps, tracked in [`14_ER_Diagram_Architecture.md §8`](14_ER_Diagram_Architecture.md#8-production-readiness-gaps--recommended-improvements): there is no conformed `dim_date` (date parts are derived inline per query), and `dim_mcc` is a flat two-column lookup rather than a hierarchical category/subcategory dimension.

## Conclusion

The star schema centers on `fact_transactions` at transaction grain, surrounded by four conformed dimensions — users, cards, merchants, and merchant category codes — plus an audit table capturing insert-level lineage. The one dimension requiring a surrogate key (`dim_merchant`) needed it for a specific, documented reason: its natural key isn't actually unique. This design keeps every reporting join shallow and predictable while remaining auditable end to end.
