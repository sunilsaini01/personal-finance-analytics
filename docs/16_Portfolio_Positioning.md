# Portfolio Positioning

# Card Transaction & Merchant Analytics

---

## Why This Project Is Valuable

Most portfolio SQL/BI projects demonstrate technique against a dataset that conveniently fits the pitch. This one doesn't, and that's the point: partway through the build, it became clear the sourced dataset had no income, budget, savings, or account-balance data — the exact fields the original "Personal Finance Analytics & Budget Intelligence System" pitch depended on. The project's response was to formally repose the scope around what the data actually supports (see [`00_PRD_Scope_Addendum.md`](00_PRD_Scope_Addendum.md)), rather than fabricate business data to keep the original pitch intact. That decision — documented, not hidden — is itself evidence of the judgment a real analytics role requires: recognizing when a plan and the data have diverged, and correcting the plan.

Beyond that, the project demonstrates a complete, governed analytics workflow: dimensional modeling with a defensible grain, a documented ETL pipeline with a real bug found and fixed (`IS NOT DISTINCT FROM` vs. `=` on nullable join columns), a 12-module SQL analytics library, and a three-page Power BI dashboard reviewed critically enough to catch its own mislabeled KPI card and data-quality anomaly (see [`15_Dashboard_Documentation.md`](15_Dashboard_Documentation.md)).

## Technical Skills Demonstrated

- **Dimensional modeling:** star schema design, grain-first discipline, and a specific, defensible surrogate-key decision (`dim_merchant`) rather than a blanket "always use surrogate keys" rule.
- **SQL depth:** joins, aggregations, window functions, CTEs, CASE-based segmentation, ranking, and running totals — organized into a 12-module business-analytics library.
- **PostgreSQL engineering:** staging/dimension/fact separation, functions, stored procedures, triggers (insert-level audit logging), indexing strategy tied to actual query patterns, and role-based security.
- **ETL & data quality:** currency/date/boolean casting, PII masking (card PAN, CVV), row-count reconciliation, orphan-key validation, and root-causing a real join-logic bug.
- **BI/dashboard design:** three audience-specific Power BI pages, plus the discipline to critically review your own dashboard and document what's actually wrong with it rather than only what works.
- **Technical writing & judgment:** a documentation set that stays internally consistent, corrects its own prior inaccuracies, and is honest about limitations.

## Job Roles This Project Targets

- **Data Analyst / BI Analyst** — SQL analytics library, KPI design, dashboard storytelling.
- **Analytics Engineer** — star-schema modeling, ETL pipeline design, data-quality validation.
- **SQL Developer** — the breadth of SQL features used (window functions, CTEs, procedures, triggers) across `sql/`.
- **Junior Data Engineer** — staging → dimension → fact pipeline design, indexing, and role-based security.

## What Recruiters Should Notice First

1. **The scope-pivot addendum** ([`00_PRD_Scope_Addendum.md`](00_PRD_Scope_Addendum.md)) — a candidate who documents "I was wrong about the data and here's what I did about it" is a stronger signal than a portfolio project with no visible mistakes at all.
2. **The `dim_merchant` surrogate-key decision** — a concrete, correctly-reasoned modeling call, not a copy-pasted "always use surrogate keys" rule.
3. **The dashboard's self-identified defects** ([`15_Dashboard_Documentation.md`](15_Dashboard_Documentation.md)) — most portfolio dashboards are presented as finished; this one is presented with its actual, current flaws named.
4. **The business-question traceability file** ([`sql/10_business_analytics/12_business_questions.sql`](../sql/10_business_analytics/12_business_questions.sql)) — every query traces to a business question, and every question the dataset can't answer is marked as such instead of silently dropped.

## How to Present This Project in Interviews

Lead with the pivot, not as an apology but as the strongest data point in the project: *"I built this against a dataset I assumed had income and budget data. It didn't. Instead of manufacturing that data, I re-scoped the whole project and documented why."* That single sentence does more to demonstrate judgment than any KPI count.

Then walk the architecture top-down: source → staging → star schema → SQL analytics → dashboard, using the `dim_merchant` surrogate-key story as your one deep technical example (it has a clear problem, a clear reason, and a clear fix — the ideal shape for a spoken technical answer).

Close with the dashboard review: naming the mislabeled KPI card and the trend-chart anomaly unprompted signals the kind of self-review discipline a hiring manager wants before this kind of work reaches a real stakeholder.

A ready-to-use 2-minute spoken script for the architecture specifically is in [`14_ER_Diagram_Architecture.md §9`](14_ER_Diagram_Architecture.md#9-interview-explanation-under-3-minutes); a dashboard-specific one is in [`15_Dashboard_Documentation.md`](15_Dashboard_Documentation.md#2-minute-presentation-script).

## Common Mistakes to Avoid When Presenting This Project

- Don't call it a "Personal Finance" or "Budget Intelligence" project without immediately explaining the pivot — the repo's own name and README will otherwise look inconsistent with what you say out loud.
- Don't claim the dashboard is finished/bug-free — the mislabeled KPI card and trend-chart anomaly are documented in the repo itself; an interviewer who looks will find them, so get there first.
- Don't describe every dimension as using a "generated surrogate key" — only `dim_merchant` does, for a specific reason; the others reuse the source system's own id, which is itself a design decision worth explaining.
