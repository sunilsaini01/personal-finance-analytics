# Security Policy

## Scope

This is a portfolio data-warehouse and BI project (PostgreSQL + Power BI), not a deployed production service — there is no live, internet-facing instance of this application to attack. "Security" here mainly concerns:

- Whether the repository itself leaks secrets or sensitive data.
- Whether the SQL and dashboard handle sensitive-looking fields (card numbers, PII) responsibly, since the source dataset simulates real financial data even though it's synthetic.

## What's Already Handled

- **No credentials are committed.** Database connection details are configured locally (Power BI data-source settings, `psql` connection args) and are not stored in this repo. `.gitignore` excludes `.env`, `.envrc`, and `*.pgpass`.
- **No raw data is committed.** `data/raw/*.csv` and `*.json` are gitignored — the ~13.3M-row transaction file and other source data never enter git history.
- **Card PAN is never stored in usable form past staging.** `dim_cards.card_number_masked` retains only the last four digits; the full card number and CVV from `stg_cards` are never promoted into the star schema. See [`docs/14_ER_Diagram_Architecture.md §7`](docs/14_ER_Diagram_Architecture.md#7-data-warehouse-design-decisions).
- **Role-based access is modeled** (`admin_role`, `analyst_role`, `readonly_role` in `sql/10_security/01_roles.sql`), though scoped at the table level, not column level — see the next section.

## Known Limitations (Not Vulnerabilities, But Worth Knowing)

- Security roles grant table-level access, including to PII-bearing columns in `dim_users` (address, lat/long, income, debt, credit score). Column-level or view-based restriction of those fields is a documented improvement, not yet implemented — see [`docs/14_ER_Diagram_Architecture.md §8`](docs/14_ER_Diagram_Architecture.md#8-production-readiness-gaps--recommended-improvements).
- This project has not undergone formal PCI-DSS or SOC 2 review, and doesn't claim compliance — see [`docs/00_PRD_Scope_Addendum.md`](docs/00_PRD_Scope_Addendum.md) (explicitly out of scope).
- The underlying dataset is synthetic. No real individuals' financial data is processed by this project.

## Reporting a Vulnerability

If you find committed credentials, an accidental data leak, or a real security issue in this repository (as opposed to a data-modeling limitation, which belongs in a regular issue), please **do not open a public issue**. Instead, report it privately via GitHub's "Report a vulnerability" feature on this repository (Security tab), or contact the maintainer directly through their GitHub profile.

Expect an acknowledgment within a few days — this is a portfolio project maintained part-time, not a funded team with an SLA.

## Supported Versions

This project doesn't currently maintain multiple release branches; security fixes, if any are needed, go to the latest version on `main`.
