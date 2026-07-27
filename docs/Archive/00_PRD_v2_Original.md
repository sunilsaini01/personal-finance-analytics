# Product Requirements Document (Original)

**Personal Finance Analytics & Budget Intelligence System**
SQL Data Warehouse, Business Intelligence & Analytics Portfolio Project

- Prepared for: Sunil (Data Analyst, Portfolio Track)
- Prepared by: Senior Data Analytics Manager (Mentor Persona)
- Document Version: 1.0 (PRD v2)
- Date: July 26, 2026
- Status: Draft — Approved for Build

> **Archival note:** This is the original PRD as approved before the dataset was finalized. It assumes a multi-account personal-finance dataset (bank, credit card, UPI, wallet, cash) with income and user-defined budgets. The dataset actually sourced for the build is credit-card-transaction-only data with no income stream, no budgets, and no linked-account balances. See [`../00_PRD_Scope_Addendum.md`](../00_PRD_Scope_Addendum.md) for the accepted scope change that supersedes the sections below wherever they conflict with what was actually built. This document is kept verbatim for audit-trail purposes — do not edit it; edit the addendum instead.

---

## 1. Executive Summary

This PRD defines the scope, requirements, architecture, and delivery plan for the Personal Finance Analytics & Budget Intelligence System — a portfolio-grade analytics project simulating a real FinTech engagement. The system ingests multi-account personal finance data (bank, credit card, UPI, wallets, cash) and delivers a governed SQL data warehouse plus an executive BI layer answering income, expense, savings, budget-adherence, cash-flow, and financial-health questions.

The project is structured as an end-to-end analytics engagement — business framing, data modeling, SQL development, analysis, dashboarding, documentation, and interview readiness — so the finished artifact functions simultaneously as (a) a working analytics product and (b) a recruiter-facing portfolio piece demonstrating SQL depth, dimensional modeling judgment, and business communication.

Primary audience for this document: the analyst building the project (you), reviewers/mentors evaluating the work, and — indirectly — any recruiter or hiring manager who reads the resulting GitHub repository. Every requirement below is written to be defensible in an interview, not just functionally correct.

## 2. Problem Statement & Background

### 2.1 Problem Statement

Individual users spread financial activity across five or more disconnected surfaces — savings accounts, credit cards, UPI apps, digital wallets, and cash — with no unified view of where money comes from, where it goes, or whether spending aligns with intent. Existing personal finance apps largely report raw transactions; they rarely answer the second-order business questions that actually drive behavior change: Is my savings rate improving or eroding? Which categories are silently overspending against budget? Is my cash flow structurally negative in any recurring month? What does my spending pattern say about my financial risk segment?

This is the same problem FinTech product-analytics teams solve for millions of users, at a scale small enough to model precisely and reason about end-to-end — which is exactly why it works as a portfolio project: it forces the same modeling, SQL, and communication skills used at Amex, Chase, or a banking-analytics function at Deloitte/EY, without requiring proprietary data.

### 2.2 Background

A FinTech personal finance management (PFM) application allows users to link multiple account types and auto-categorizes transactions. Management (the project stakeholder we are simulating) has asked the analytics function to move beyond transaction logging into decision-grade reporting: budget adherence, financial health scoring, and user segmentation that could plausibly feed retention or monetization strategy (e.g., targeting overspending users with a premium budgeting tier).

## 3. Business Objectives

The analytics solution must let the business:

1. Quantify income, expenses, savings, and savings rate at user, account, and time-period granularity.
2. Measure budget adherence — actual spend vs. planned budget — by category and by user.
3. Track cash flow and running balance to detect structurally negative months before they compound.
4. Score financial health per user using a composite, explainable metric (not a black box).
5. Segment users by spending behavior (e.g., saver, overspender, volatile, disciplined) to support targeted product/marketing decisions.
6. Surface merchant, category, and payment-method patterns that explain *why* metrics moved, not just *that* they moved.
7. Deliver the above through governed SQL (auditable, re-runnable) and an executive dashboard (Power BI/Tableau) suitable for a non-technical stakeholder.

## 4. Stakeholders

| Stakeholder | Role | Primary Interest | Interaction |
|---|---|---|---|
| VP of Product Analytics | Business Sponsor | Actionable KPIs; ROI narrative for premium-tier targeting | Weekly summary + dashboard |
| Finance/BI Director | Technical Reviewer | Data model correctness, query performance, auditability | Schema + query review |
| Product Managers (Budgeting feature) | Consumer | Budget-vs-actual accuracy; overspend alerts | Dashboard drill-downs |
| Marketing/Growth | Consumer | User segments for targeted campaigns | Segment table export |
| Data Engineering | Upstream partner | Clean, documented schema; ETL contract | Data dictionary, DDL |
| End User (indirect) | Beneficiary | Trustworthy financial-health feedback | In-app insight surfaced from same model |
| You (Analyst / Portfolio Owner) | Builder | Demonstrable, interview-defensible artifact | GitHub repo + report |

## 5. Business Questions the Model Must Answer

These are the questions every downstream SQL query and dashboard visual should trace back to. If a query in Phase 7/8 doesn't answer one of these (or a clearly derived sub-question), it doesn't belong in the portfolio — this is the discipline that separates a query dump from an analytics product.

- What is total income, total expenses, and net savings — overall, and by month/quarter/year?
- What is the savings rate, and is it trending up or down?
- How does actual spend compare to budget, by category and by user, and who is chronically overspending?
- What does cash flow and running balance look like per account, and are there structurally negative periods?
- Which categories and merchants drive the largest share of spend, and how concentrated is that spend (80/20)?
- Is spending different on weekends vs. weekdays, and does that vary by category?
- Which expenses are recurring (subscriptions, EMIs, bills) vs. discretionary, and what share of the budget do they consume?
- What is each user's financial health score, and what factors drive it up or down?
- How do users segment by behavior (saver / balanced / overspender / volatile), and how large is each segment?
- Which payment methods and accounts are used most, and does method correlate with overspending?
- What is month-over-month and year-over-year growth in income and expenses?
- Directionally, what would next month's spend look like if current trends continue (conceptual forecast, not production ML)?

## 6. Key Performance Indicators (KPIs)

| KPI | Formula | Why It Matters | Grain |
|---|---|---|---|
| Savings Rate | (Income − Expenses) / Income | Core financial-health signal; target >20% is a common industry benchmark | Monthly |
| Net Cash Flow | Income − Expenses (period) | Detects structurally negative months | Monthly |
| Budget Adherence % | Actual Spend / Budgeted Spend, by category | Flags overspending categories early | Monthly |
| Category Contribution % | Category Spend / Total Spend | Identifies concentration risk (80/20 spend) | Monthly |
| MoM / YoY Growth | % change in income or expense vs. prior period | Trend direction, seasonality detection | Monthly/Yearly |
| Financial Health Score | Weighted composite (savings rate, budget adherence, debt ratio, volatility) | Single explainable score for segmentation | Monthly |
| Recurring Expense Ratio | Recurring Spend / Total Spend | Fixed-cost burden vs. discretionary flexibility | Monthly |
| Overspend Incidence | # categories over budget / total budgeted categories | Early-warning operational metric | Monthly |
| Average Transaction Value | Total Spend / # Transactions | Behavior granularity by category/merchant | Monthly |
| Weekend Spend Share | Weekend Spend / Total Spend | Behavioral segmentation input | Monthly |

## 7. Scope

### 7.1 In Scope

- Relational data warehouse design (star-schema-oriented) covering users, accounts, transactions, categories, merchants, budgets, payment methods, and a date dimension.
- SQL development from foundational DDL/DML through advanced window functions, CTEs, views, and indexing/optimization.
- Business analytics covering income, expense, savings, budget adherence, cash flow, segmentation, and financial health scoring.
- Executive dashboard (Power BI or Tableau) with KPI cards, trend visuals, and interactive filters.
- Documentation: README, data dictionary, ER diagram, SQL documentation, insights report.
- GitHub portfolio packaging and interview-preparation Q&A.

### 7.2 Out of Scope

- Real bank connectivity (Plaid/UPI API integration) — data is sourced from a static Kaggle dataset, not live feeds.
- Production-grade ML forecasting — spending forecast is treated conceptually (e.g., moving average), not a deployed model.
- Multi-currency real-time FX conversion — handled as a simplifying assumption, documented explicitly.
- Regulatory compliance work (PCI-DSS, SOC 2, RBI/PSD2 guidelines) — acknowledged as a real-world requirement but not implemented.
- Mobile/web front-end application — deliverable is the data layer + BI layer only.

## 8. Functional Requirements

### 8.1 Functional Requirements (FR)

| ID | Requirement | Priority |
|---|---|---|
| FR-01 | System shall store multi-account transaction data per user across bank, credit card, UPI, wallet, and cash account types. | Must |
| FR-02 | System shall classify every transaction into a category and sub-category via a dimension table (not free text). | Must |
| FR-03 | System shall support user-defined monthly budgets per category, comparable against actuals. | Must |
| FR-04 | System shall compute income, expense, net savings, and savings rate at user/month grain. | Must |
| FR-05 | System shall compute a running account balance ordered by transaction date. | Must |
| FR-06 | System shall flag transactions as recurring based on merchant + amount + interval pattern. | Should |
| FR-07 | System shall compute a financial health score per user per month from a documented, explainable formula. | Should |
| FR-08 | System shall segment users into behavioral cohorts based on savings rate and budget adherence. | Should |
| FR-09 | System shall expose all metrics via reusable SQL views for BI-tool consumption. | Must |
| FR-10 | System shall support ranking and top-N queries (top merchants, top categories, top transactions). | Must |

### 8.2 Non-Functional Requirements (NFR)

| ID | Requirement | Rationale |
|---|---|---|
| NFR-01 | All core reporting queries should execute in reasonable time on the sample dataset size (target: sub-second on indexed dimensional queries). | Portfolio credibility — you should be able to explain and demonstrate query plans. |
| NFR-02 | Schema must be documented well enough that a new analyst can onboard from the data dictionary alone. | Mirrors real onboarding/handoff standards. |
| NFR-03 | All monetary values stored in a normalized base currency with an explicit conversion-assumption note. | Avoids silent aggregation errors across currencies. |
| NFR-04 | Naming conventions (snake_case, singular/plural rules, suffixes like `_id`, `_dt`, `_amt`) must be consistent across all objects. | Industry hygiene; reviewers notice inconsistency immediately. |
| NFR-05 | Every fact table must have documented grain (one row = ?) before any SQL is written against it. | Prevents the single most common analytics bug: silent fan-out joins. |
| NFR-06 | Design must be extensible to add new account types or category taxonomies without breaking existing queries. | Simulates production schema evolution. |

## 9. Data & Reporting Requirements

### 9.1 Data Requirements

- Source: Kaggle personal finance / transactions dataset (documented in Phase 3 EDA), supplemented with synthetically generated Users, Budgets, and Merchant dimension data where the raw dataset lacks them.
- Minimum required attributes per transaction: transaction id, user id, account id, date, amount, direction (debit/credit), category, merchant, payment method.
- Date dimension must support day/week/month/quarter/year rollups and weekend/weekday flags.
- Historical depth: minimum 12 months per user to support MoM/YoY comparisons meaningfully.

### 9.2 Reporting Requirements

- Executive summary view: income, expense, savings, savings rate, financial health score — single page.
- Trend views: monthly income/expense/savings line trends with YoY comparison.
- Budget view: budget vs. actual by category with variance and overspend flags.
- Behavioral view: category/merchant/payment-method breakdown, weekend vs. weekday split.
- Segmentation view: user distribution across behavioral cohorts.
- All dashboard visuals must be filterable by user, account type, date range, and category.

## 10. Business Rules

8. A transaction with a negative signed amount (or explicit debit flag) is an expense; positive/credit is income. Transfers between a user's own accounts are excluded from both income and expense totals to avoid double-counting.
9. Savings Rate is undefined (null, not zero) when Income = 0 for the period — never silently divide by zero or coerce to 0%.
10. A category is 'over budget' only if Actual > Budgeted AND Budgeted > 0 for that user-category-month (unbudgeted categories are reported separately, not flagged as overspend).
11. A transaction is 'recurring' if the same merchant + similar amount (±5%) appears in at least 3 of the last 4 months for that user.
12. Financial Health Score is a weighted composite (e.g., 40% savings rate, 30% budget adherence, 20% cash-flow stability, 10% recurring-expense ratio) — weights must be documented and justified, not arbitrary.
13. Currency values are stored in minor units (e.g., paise/cents) internally to avoid floating-point rounding errors in aggregation; display layer converts to major units.

## 11. Representative User Stories & Acceptance Criteria

**US-01: Monthly savings rate**
As a product manager, I want to see each user's monthly savings rate so that I can identify users trending toward financial risk.
- Given a user with recorded income and expenses in a month, the system returns savings rate = (income − expenses) / income.
- If income is 0, the metric returns NULL with a documented reason, not a divide-by-zero error or misleading 0%.

**US-02: Budget overspend detection**
As a budgeting feature PM, I want a list of user-categories that are over budget this month so that I can trigger an in-app nudge.
- Given a user has a budget set for a category, the system flags the category when actual spend exceeds budget.
- Categories with no budget set are excluded from the flagged list and shown separately as 'unbudgeted spend'.

**US-03: Financial health segmentation**
As a growth marketer, I want users segmented into behavioral cohorts so that I can target a premium budgeting tier at the right audience.
- Every user with ≥3 months of history receives exactly one cohort label per month.
- Cohort thresholds are documented in the data dictionary and reproducible from the SQL view definition.

## 12. Data Model Overview

The warehouse follows a star-schema pattern: two fact tables at transaction and budget grain, surrounded by conformed dimensions. This is deliberate — a star schema keeps joins shallow and predictable, which is exactly what a BI tool (and an interviewer asking 'why this design') expects. Full grain definitions, keys, cardinality, and normalization justification (1NF/2NF/3NF for source tables vs. deliberate denormalization in the star schema) are developed in Phase 4.

| Table | Type | Grain | Key Attributes |
|---|---|---|---|
| fact_transactions | Fact | 1 row = 1 transaction | user_id, account_id, category_id, merchant_id, payment_method_id, date_id, amount, direction |
| fact_budgets | Fact | 1 row = 1 user-category-month budget | user_id, category_id, month_id, budgeted_amount |
| dim_users | Dimension | 1 row = 1 user | user_id, signup_date, age_band, income_band, region |
| dim_accounts | Dimension | 1 row = 1 linked account | account_id, user_id, account_type, institution, opened_date |
| dim_categories | Dimension | 1 row = 1 category/subcategory | category_id, category_name, parent_category, is_discretionary |
| dim_merchants | Dimension | 1 row = 1 merchant | merchant_id, merchant_name, merchant_category |
| dim_payment_methods | Dimension | 1 row = 1 payment method | payment_method_id, method_name, method_type |
| dim_date | Dimension | 1 row = 1 calendar day | date_id, full_date, month, quarter, year, is_weekend |

Design rule enforced throughout: no query is written against fact_transactions until its grain is written down and agreed — this single habit prevents the most common analytics bug (accidental row duplication from a fan-out join).

## 13. Assumptions, Constraints, Risks & Success Metrics

### 13.1 Assumptions

- The Kaggle source dataset approximates real transaction behavior closely enough for realistic analysis; gaps (e.g., missing budgets, missing merchant dimension) are filled with clearly-labeled synthetic data.
- All amounts are normalized to a single base currency (e.g., INR or USD) for aggregation; FX conversion, if needed, uses a static documented rate, not live rates.
- A single analyst (you) executes all phases; timeline assumes part-time portfolio-project pacing, not a funded team sprint.

### 13.2 Constraints

- Data is static/historical — no real-time ingestion pipeline is in scope.
- BI tool licensing: Power BI Desktop (free) or Tableau Public — both have feature/data-size limits vs. enterprise licenses.
- No access to real users — all segmentation and health-score validation is internally consistent, not externally A/B tested.

### 13.3 Risks & Mitigations

| Risk | Impact | Mitigation |
|---|---|---|
| Source dataset lacks budgets/merchants dimension | Cannot demo budget-vs-actual or merchant analysis | Generate clearly-labeled synthetic dimension data with documented logic |
| Financial Health Score weights appear arbitrary to a reviewer | Undermines credibility of the flagship metric | Document weighting rationale explicitly; show sensitivity to weight changes |
| Star schema over-engineered for dataset size | Adds complexity without demonstrable benefit | Justify design choice in docs as simulating production scale, not solving this dataset's literal size |
| Scope creep across 14 phases | Project stalls before reaching GitHub/interview-prep phases | Timebox each phase; ship incrementally, commit after each phase |
| Currency/rounding errors in aggregation | Silently wrong KPI values | Store minor units internally; add reconciliation checks (sum of parts = total) |

### 13.4 Success Metrics (for this project)

- All Phase 8/9 business questions answered with working, documented SQL.
- Dashboard renders all KPIs with working interactive filters, no broken visuals.
- README + data dictionary + ER diagram allow a stranger to understand the project in under 10 minutes.
- You can defend every design decision (grain, normalization level, index choice, score weighting) unprompted in a mock interview.

## 14. Project Roadmap (14 Phases)

| Phase | Deliverable | Primary Output |
|---|---|---|
| 1. Business Understanding | Problem framing | Problem statement, KPIs, scope (this document) |
| 2. Requirement Analysis | Requirements | FR/NFR, user stories, acceptance criteria (this document) |
| 3. Dataset Understanding | EDA | Column dictionary, data-quality report, cleaning plan |
| 4. Database Design | Schema | Fact/dim tables, keys, normalization notes |
| 5. ER Diagram | Diagram | Visual entity-relationship model |
| 6. Data Preparation | Clean dataset | Standardized, validated load-ready tables |
| 7. SQL Development | Query library | Foundational → advanced SQL, documented |
| 8. Business Analytics | Answered questions | Income/expense/savings/budget/segmentation queries |
| 9. Advanced SQL | Window-function analysis | Rankings, running totals, moving averages |
| 10. Dashboard Design | BI dashboard | Power BI/Tableau executive dashboard |
| 11. Business Insights | Insight narrative | What/why/impact/recommendation per analysis |
| 12. Documentation | Docs set | README, data dictionary, reports |
| 13. GitHub Portfolio | Public repo | Recruiter-ready repository |
| 14. Interview Preparation | Mock interview | Q&A across SQL, modeling, KPIs, dashboards |

## 15. Technology Stack

| Layer | Tool | Justification |
|---|---|---|
| Database | PostgreSQL or MySQL | Free, industry-standard, strong window-function support (PostgreSQL preferred for advanced SQL) |
| SQL Development | DBeaver / pgAdmin / MySQL Workbench | Free GUI clients for query development and EDA |
| Data Prep | Python (pandas) or SQL staging scripts | Cleaning, standardization prior to load |
| BI / Dashboard | Power BI Desktop or Tableau Public | Industry-standard, free tiers, recruiter-recognized tools |
| Diagramming | dbdiagram.io / draw.io / Lucidchart | ER diagram generation |
| Version Control | Git + GitHub | Portfolio hosting, commit history as evidence of process |
| Documentation | Markdown | README, data dictionary, reports — GitHub-native rendering |

## 16. Final Deliverables

- Governed SQL data warehouse schema (DDL) with seed/load scripts.
- Documented SQL query library spanning foundational through advanced (window functions, CTEs, views).
- Executive Power BI/Tableau dashboard with interactive filters.
- Business insights report (What happened / Why / Impact / Recommendation) per analysis.
- Full documentation set: README, data dictionary, ER diagram, schema doc, SQL doc, dashboard doc.
- Public GitHub repository, structured and screenshot-illustrated for recruiter review.
- Interview-preparation Q&A bank with your answers and mentor feedback.

## 17. Governance & Next Step

This PRD is the reference contract for the build. Any phase output that contradicts a definition here (grain, business rule, KPI formula) should trigger an explicit PRD update, not a silent divergence — that discipline is itself part of what this portfolio project is meant to demonstrate.

Next step: Phase 3 — Dataset Understanding. Bring the actual Kaggle dataset (or its column list) and we do a full EDA pass — column-by-column typing, missingness, duplicates, outliers, and a gap analysis against the data requirements in Section 9 — before a single CREATE TABLE statement is written.
