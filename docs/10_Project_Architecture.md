# Project Architecture

# Card Transaction & Merchant Analytics

---

> This is the high-level architecture summary. For the full layer-by-layer explanation, the ER diagram, and every design decision's rationale, see [`14_ER_Diagram_Architecture.md`](14_ER_Diagram_Architecture.md) — that document is authoritative where the two overlap.

## Purpose

This document describes how raw card-transaction data flows through the system: from source files, through a governed PostgreSQL warehouse, to the SQL analytics layer and Power BI dashboard.

## High-Level Architecture

```
                +----------------------+
                |  Source Files        |
                |----------------------|
                | Users (CSV)          |
                | Cards (CSV)          |
                | Transactions (CSV)   |
                | MCC Codes (JSON)     |
                +----------+-----------+
                           │
                           ▼
                +----------------------+
                | PostgreSQL Database  |
                |----------------------|
                | Staging Tables       |
                | Dimension Tables     |
                | Fact Table           |
                | Audit Log + Trigger  |
                +----------+-----------+
                           │
                           ▼
                +----------------------+
                | Operational Layer    |
                |----------------------|
                | Indexes              |
                | Views & Functions    |
                | Procedures           |
                | Security Roles       |
                +----------+-----------+
                           │
                           ▼
                +----------------------+
                | SQL Analytics Layer  |
                |----------------------|
                | Customer Analysis    |
                | Merchant Analysis    |
                | Category Analysis    |
                | Payment Analysis     |
                | Net Spend / Time     |
                |   Series Analysis    |
                +----------+-----------+
                           │
                           ▼
                +----------------------+
                | Power BI Dashboard   |
                |----------------------|
                | Executive Overview   |
                | Customer Analytics   |
                | Transaction Analytics|
                +----------------------+
```

## Architecture Components

### 1. Source Layer

Flat CSV/JSON files under `data/raw/`: users, cards, transactions, and MCC reference data. Static and historical — no live connectivity, by design.

### 2. Staging Layer

`stg_users`, `stg_cards`, `stg_transactions` — an unconstrained, mostly-`TEXT` 1:1 mirror of the source files. No FKs are enforced here; the only job of this layer is to guarantee the raw load never fails on formatting.

### 3. Warehouse Core (Star Schema)

- **Dimensions:** `dim_users`, `dim_cards`, `dim_mcc`, `dim_merchant`
- **Fact:** `fact_transactions` (grain: 1 row = 1 transaction)

### 4. Operational Layer

Cross-cutting concerns sitting alongside the core tables: performance indexes (`sql/04_indexes`), an insert-triggered audit log (`sql/08_triggers`), maintenance procedures (`sql/07_procedures`), and role-based access control (`sql/10_security`).

### 5. Semantic / SQL Analytics Layer

Reusable views (`sql/05_views`, `sql/11_dashboard_views`) and a 12-module business-analytics query library (`sql/10_business_analytics`) covering customer segmentation, merchant/category/payment analysis, net-spend trend analysis, and transaction-error analysis. Power BI and any other BI tool query these views rather than the raw fact table directly.

### 6. Reporting Layer

Power BI connects to PostgreSQL and renders three audience-specific dashboard pages — see [`15_Dashboard_Documentation.md`](15_Dashboard_Documentation.md).

## Technology Stack

| Component | Technology |
|---|---|
| Database | PostgreSQL |
| Query Language | SQL |
| ETL | SQL scripts + Python (`scripts/load_mcc.py`) |
| Data Source | CSV / JSON files |
| Dashboard | Power BI Desktop |
| Version Control | Git & GitHub |

## Benefits of This Architecture

- Clear separation of raw, staged, and analytical data.
- Efficient querying via a star schema with shallow joins.
- Auditability via the insert-triggered audit log and load-time validation queries.
- Easy Power BI integration through a stable semantic (views) layer.

## Future Enhancements

See the prioritized list in [`14_ER_Diagram_Architecture.md §8`](14_ER_Diagram_Architecture.md#8-production-readiness-gaps--recommended-improvements): a conformed `dim_date`, fact-table partitioning by `txn_date`, an enforced FK from `audit_log` to `fact_transactions`, and column-scoped (rather than table-broad) security grants.

## Conclusion

The architecture follows a layered Business Intelligence workflow — source, staging, warehouse core, operational layer, semantic layer, reporting — that keeps raw and analytical data cleanly separated while remaining auditable and Power BI-ready end to end.
