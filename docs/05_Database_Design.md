# Database Design

# Card Transaction & Merchant Analytics

---

> **Correction notice:** an earlier version of this document described `stg_transactions` as the fact table and omitted `dim_merchant` and `audit_log` entirely. Both are fixed below. The authoritative, most detailed version of this material — including the full ER diagram and every design decision's rationale — is [`14_ER_Diagram_Architecture.md`](14_ER_Diagram_Architecture.md); this document is the higher-level summary.

## Purpose

The database is designed to support high-performance analytical queries against 13.3M+ card transactions while maintaining referential integrity, auditability, and ease of reporting. A star-schema dimensional model was adopted specifically to optimize Power BI and SQL reporting performance.

## Database Technology

| Component | Technology |
|---|---|
| Database | PostgreSQL |
| Modeling Approach | Star Schema (Kimball) |
| Query Language | SQL |

## Database Architecture

```
Raw CSV/JSON Files
        │
        ▼
Staging Layer (untyped, 1:1 mirror of source)
        │
        ▼
Cleaning & Typing (currency/date casts, PAN masking)
        │
        ▼
Dimension Tables
        │
        ▼
Fact Table (fact_transactions)
        │
        ▼
Views, Functions, Procedures, Security Roles
        │
        ▼
SQL Business Analytics → Power BI Dashboard
```

## Staging Layer

Raw, minimally-transformed 1:1 mirror of the source files. No FKs are enforced here by design — staging must accept whatever the source produced; validation happens on promotion into the star schema.

**Tables:** `stg_users`, `stg_cards`, `stg_transactions`

**Purpose:** preserve raw imported data, guarantee the load never fails on formatting, and support reprocessing.

## Dimension Layer

| Table | Primary Key | Grain |
|---|---|---|
| `dim_users` | `user_id` | 1 row = 1 user |
| `dim_cards` | `card_id` | 1 row = 1 physical card |
| `dim_mcc` | `mcc` | 1 row = 1 Merchant Category Code |
| `dim_merchant` | `merchant_key` (surrogate) | 1 row = 1 distinct merchant location |

`dim_merchant` is the one dimension that required a manufactured surrogate key. Its natural key, `merchant_id`, is not unique on its own — the same merchant recurs across multiple physical locations in the source data. Joining on `merchant_id` directly would fan out `fact_transactions` and double-count spend, so `merchant_key` (one row per distinct `merchant_id` + city/state/zip combination) is what keeps the fact-to-dimension join 1:1 on the dimension side. Every other dimension reuses its source system's own id as the key, since those ids are already unique and no dimension history (SCD) is tracked.

## Fact Table

**The fact table is `fact_transactions`** — grain: 1 row = 1 card transaction (~13.3M rows).

**Foreign keys:** `user_id` → `dim_users`, `card_id` → `dim_cards`, `merchant_key` → `dim_merchant`, `mcc` → `dim_mcc`.
**Measure:** `amount` (signed; positive = spend, negative = refund).
**Degenerate dimensions kept on the fact row:** `use_chip` (payment channel), `errors` (failure reason) — both low-cardinality with no further descriptive attributes of their own, so a separate dimension table would add a join without benefit.

## Audit Layer

`audit_log` (grain: 1 row = 1 insert event on `fact_transactions`) is populated by the `trg_transaction_audit` trigger on every insert. Its `transaction_id` column is a **logical**, not currently DB-enforced, reference back to `fact_transactions` — flagged as a fix in [`14_ER_Diagram_Architecture.md §8`](14_ER_Diagram_Architecture.md#8-production-readiness-gaps--recommended-improvements).

## Primary Keys

| Table | Primary Key |
|---|---|
| dim_users | user_id |
| dim_cards | card_id |
| dim_mcc | mcc |
| dim_merchant | merchant_key |
| fact_transactions | transaction_id |
| audit_log | audit_id |

## Foreign Keys

| Table | Foreign Key | References |
|---|---|---|
| dim_cards | user_id | dim_users.user_id |
| fact_transactions | user_id | dim_users.user_id |
| fact_transactions | card_id | dim_cards.card_id |
| fact_transactions | merchant_key | dim_merchant.merchant_key |
| fact_transactions | mcc | dim_mcc.mcc |

## Normalization Strategy

Raw data remains in staging tables (denormalized-by-necessity, since it mirrors flat source files). Dimensions are deliberately denormalized relative to strict 3NF — this is standard Kimball practice: a star schema trades some normalization for join simplicity and query performance, which is the right trade-off for an analytical workload rather than a transactional one.

## Why Star Schema?

Compared with a fully normalized OLTP design, a star schema is better suited to this project's analytical workload because every business question (spend by user, by card brand, by merchant, by category) resolves to a single join from `fact_transactions` to exactly one dimension — no dimension joins to another dimension. This also makes Power BI's relationship model simpler and its aggregations faster.

## Design Considerations

- Grain agreed and documented before any SQL was written against `fact_transactions` — the single habit that prevents the most common star-schema bug: a fan-out join silently duplicating fact rows.
- Currency stored as `NUMERIC(12,2)`, never `FLOAT`, to avoid floating-point rounding error across millions of aggregated rows.
- Card PAN never promoted past staging in usable form; only a masked last-4 value reaches `dim_cards`.
- Referential integrity enforced with real FK constraints, plus explicit orphan-detection queries run at load time as a belt-and-suspenders check (see [`18_Technical_Validation.md`](18_Technical_Validation.md)).

## Future Enhancements

- A conformed `dim_date` to centralize month/quarter/weekend logic that's currently derived inline in every query.
- Table partitioning on `fact_transactions` by `txn_date`, given its current size (~13.3M rows).
- A `UNIQUE` constraint on `dim_merchant`'s natural key tuple, currently backed only by a non-unique lookup index.
- Type-2 history tracking on `dim_users`/`dim_cards` if the warehouse ever needs to track attribute changes across multiple load cycles.

Full prioritized list: [`14_ER_Diagram_Architecture.md §8`](14_ER_Diagram_Architecture.md#8-production-readiness-gaps--recommended-improvements).

## Conclusion

The database design provides a governed, auditable foundation for card-transaction analytics: a star schema at documented transaction grain, a surrogate key applied exactly where the natural key breaks down, and referential integrity enforced both structurally (FKs) and operationally (load-time validation queries).
