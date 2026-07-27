# Release Notes

> **Relationship to `CHANGELOG.md`:** [`CHANGELOG.md`](CHANGELOG.md) is the running, entry-by-entry log of changes. This file is a snapshot per tagged release — narrative, recruiter/reviewer-facing, and only updated when a release is actually tagged. For a solo portfolio project with no formal release cadence yet, maintaining both is optional; keeping just `CHANGELOG.md` up to date is enough day to day. This file exists so the project has a clean "v1.0" story once one is tagged.

## v1.0.0 (Unreleased)

**Card Transaction & Merchant Analytics** — first complete release.

### Highlights

- End-to-end PostgreSQL data warehouse: staging → cleaned dimensions → transaction-grain fact table, covering ~2,000 users, ~6,146 cards, 13.3M+ transactions, and 109 merchant category codes.
- 12-module SQL business-analytics library covering customer segmentation, merchant/category/payment analysis, transaction reliability, and time-series trends.
- Reusable views, scalar functions, stored procedures, an insert-triggered audit log, and role-based security.
- A three-page, audience-specific Power BI dashboard (Executive Overview, Customer Analytics, Transaction Analytics).
- A full, internally consistent documentation set (19 numbered docs) including a full ER diagram with importable DBML, a page-by-page dashboard review, and a documentation quality audit.

### Notable Engineering Decisions

- A surrogate key (`merchant_key`) was introduced specifically for `dim_merchant`, because its natural key (`merchant_id`) is not unique across physical locations — every other dimension reuses its source system's own id.
- A real ETL bug was found and fixed: the fact-load join to `dim_merchant` originally used `=` on nullable location columns, silently dropping every online transaction; switched to `IS NOT DISTINCT FROM`, with a row-count reconciliation check added to guard against regression.

### Scope Correction

Partway through the build, the sourced dataset was confirmed to have no income, budget, savings, or account-balance data. Rather than fabricate that data to match the original "Personal Finance Analytics & Budget Intelligence System" pitch, the project was formally repositioned as "Card Transaction & Merchant Analytics." Full rationale: [`docs/00_PRD_Scope_Addendum.md`](docs/00_PRD_Scope_Addendum.md).

### Known Issues at Release

- Dashboard: a data-model anomaly in two trend charts, one mislabeled KPI card, and a KPI display overflow — see [`docs/15_Dashboard_Documentation.md`](docs/15_Dashboard_Documentation.md).
- No `dim_date`, no fact-table partitioning, and `audit_log.transaction_id` is not yet an enforced foreign key — see [`docs/14_ER_Diagram_Architecture.md §8`](docs/14_ER_Diagram_Architecture.md#8-production-readiness-gaps--recommended-improvements).

Full prioritized list: [`docs/17_Documentation_Audit.md`](docs/17_Documentation_Audit.md).
