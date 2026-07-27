# Changelog

All notable changes to this project are documented in this file. Format loosely follows [Keep a Changelog](https://keepachangelog.com/); dates are commit dates from `git log`.

## [Unreleased]

### Changed

- **Full project repositioning:** renamed from "Personal Finance Analytics & Budget Intelligence System" to "Card Transaction & Merchant Analytics" after confirming the sourced dataset has no income, budget, savings, or account-balance data. See [`docs/00_PRD_Scope_Addendum.md`](docs/00_PRD_Scope_Addendum.md).
- Rewrote all active documentation (`docs/01`–`13`) for accuracy and consistent terminology; corrected several standing inaccuracies (wrong fact table referenced, `dim_merchant`/`audit_log` missing from data dictionary and design docs, a stale ETL folder-structure description, a false "no indexes were created" claim).
- Rewrote root `README.md` as a full recruiter-facing GitHub README.
- Removed the stray, unresolved merge-conflict marker (`>>>>>>> 5d35a32e...`) left in `.gitignore`; deduplicated repeated ignore entries.

### Added

- `docs/14_ER_Diagram_Architecture.md` + `docs/erd/schema.dbml` — full ER diagram, importable DBML, and design-decision rationale (completes the previously-outstanding ER Diagram project phase).
- `docs/15_Dashboard_Documentation.md` — page-by-page Power BI dashboard review, including self-identified defects (a mislabeled KPI card, a trend-chart data anomaly, a KPI display overflow).
- `docs/16_Portfolio_Positioning.md`, `docs/17_Documentation_Audit.md`, `docs/18_Technical_Validation.md`.
- `CONTRIBUTING.md`, `CODE_OF_CONDUCT.md`, `SECURITY.md`, this `CHANGELOG.md`, `RELEASE_NOTES.md`.
- `.github/ISSUE_TEMPLATE/` (bug report, feature request) and `.github/PULL_REQUEST_TEMPLATE.md`.
- `assets/banner.svg` repository banner.

## [2026-07-20] — a6bcaa6, 4061971

### Added

- Merchant, category, payment-method, time-series, and customer-segmentation SQL analytics modules (`sql/10_business_analytics/06`–`10`).

### Removed

- An advanced SQL showcase file no longer aligned with the project's direction.

## [2026-07-16] — fefb9d3

### Added

- Phase 6.3: expense business analytics (`sql/10_business_analytics/03_expense_analysis.sql`).

## [2026-07-15] — d64e69f, 1ea5e2d, 5d35a32

### Added

- Initial commit and Phase 5: PostgreSQL data warehouse implementation — staging tables, star schema DDL, dimension/fact load scripts.
- Remote repository merge.

---

*Older, pre-repositioning documentation history is preserved verbatim in [`docs/Archive/`](docs/Archive/) rather than summarized here — see [`docs/README.md`](docs/README.md).*
