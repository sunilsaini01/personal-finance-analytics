# Project Documentation

## Card Transaction & Merchant Analytics

This folder contains the complete project documentation for Card Transaction & Merchant Analytics — a PostgreSQL data warehouse and Power BI project, originally scoped as "Personal Finance Analytics & Budget Intelligence System" and formally repositioned after confirming the sourced dataset has no income, budget, or savings data. Start with the Scope & Governance section below if you're new to this repo.

---

## Documentation Index

### Scope & Governance

- [00_PRD_Scope_Addendum.md](00_PRD_Scope_Addendum.md) — records the accepted pivot from the original budget-intelligence PRD to card-transaction analytics, and exactly what it supersedes
- [16_Portfolio_Positioning.md](16_Portfolio_Positioning.md) — why this project is valuable, target roles, and how to present it in interviews
- [17_Documentation_Audit.md](17_Documentation_Audit.md) — documentation quality review and prioritized action plan
- [19_GitHub_Repository_Audit.md](19_GitHub_Repository_Audit.md) — repository-wide pre-publish audit: folder structure, README review, GitHub assets/badges, release checklist, recruiter experience, resume copy, and final scoring

### Project Overview

- [01_Project_Overview.md](01_Project_Overview.md)

### Business Documentation

- [02_Business_Requirements.md](02_Business_Requirements.md) — scope, requirements, user stories, business rules

### Dataset

- [03_Dataset_Description.md](03_Dataset_Description.md)
- [04_Data_Dictionary.md](04_Data_Dictionary.md)

### Database

- [05_Database_Design.md](05_Database_Design.md)
- [11_Star_Schema.md](11_Star_Schema.md)
- [14_ER_Diagram_Architecture.md](14_ER_Diagram_Architecture.md) — authoritative ER diagram, DBML source, ETL flow, design decisions, and production-readiness gaps (supersedes the two docs above where they conflict)
- [erd/schema.dbml](erd/schema.dbml) — importable dbdiagram.io schema

### ETL

- [06_ETL_Process.md](06_ETL_Process.md)
- [18_Technical_Validation.md](18_Technical_Validation.md) — ETL validation, data quality, integrity checks

### SQL Analytics

- [07_SQL_Analysis.md](07_SQL_Analysis.md)

### Business Insights

- [08_Business_Insights.md](08_Business_Insights.md)

### KPI Reference

- [09_KPI_Definitions.md](09_KPI_Definitions.md)

### Architecture

- [10_Project_Architecture.md](10_Project_Architecture.md) — high-level summary; see `14_ER_Diagram_Architecture.md` for the deep dive

### Dashboard

- [15_Dashboard_Documentation.md](15_Dashboard_Documentation.md) — page-by-page Power BI review: business objective, visual-by-visual breakdown, insights, executive summary, recommendations, design scoring, and interview prep

### Performance

- [12_Query_Optimization.md](12_Query_Optimization.md)

### Conclusion

- [13_Conclusion.md](13_Conclusion.md)

---

## Archived Documents

The **Archive/** folder holds the original, pre-pivot PRD (`00_PRD_v2_Original.md`) and the documents it originally shipped with (functional specifications, user stories, dashboard design, test plans, deployment guide, individual SQL analysis reports, architecture decisions). Everything in `Archive/` is kept verbatim as a historical record — it is superseded by the numbered docs above and by [`00_PRD_Scope_Addendum.md`](00_PRD_Scope_Addendum.md), and should not be edited.

---

## Project Stack

- PostgreSQL
- SQL
- Power BI
- Git
- GitHub

---

## Status

See the phase-by-phase status table in the [root README](../README.md) — this is the single authoritative status tracker for the project; it isn't duplicated here to avoid the two drifting out of sync.
