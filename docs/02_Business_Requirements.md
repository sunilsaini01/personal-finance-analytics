# Business Requirements

# Card Transaction & Merchant Analytics

---

## 1. Business Problem

Card issuers and merchant-analytics teams generate millions of transactions every day. Raw transactional data alone cannot answer the second-order questions that drive decisions: where spend concentrates, which customers are most valuable, how payment behavior is shifting, and whether the transaction pipeline itself is reliable. This project transforms raw card-transaction data into governed, decision-grade business intelligence using PostgreSQL and Power BI.

## 2. Business Objectives

- Monitor overall transaction volume and revenue performance.
- Identify high-value customers and describe them demographically.
- Analyze merchant and merchant-category performance.
- Understand customer spending behavior (channel, timing, category mix).
- Track payment-method adoption over time.
- Monitor transaction success/failure rates and attribute failure reasons.
- Build executive dashboards tailored to distinct stakeholder audiences.

## 3. Stakeholders

| Stakeholder | Business Need |
|---|---|
| Executives / VP of Product Analytics | Actionable KPIs, revenue and volume trend visibility |
| Finance/BI Director | Data model correctness, query performance, auditability |
| Marketing/Growth | Customer segments and demographic value drivers for targeted campaigns |
| Operations / Risk Team | Transaction success rate, failure-reason attribution, geographic distribution |
| Data Engineering | Clean, documented schema; ETL contract |
| You (Analyst / Portfolio Owner) | A demonstrable, interview-defensible artifact |

## 4. Scope

### 4.1 In Scope

- Relational data warehouse design (star-schema) covering users, cards, transactions, merchants, and merchant category codes.
- SQL development from foundational DDL/DML through window functions, CTEs, views, functions, procedures, triggers, and indexing.
- Business analytics covering transaction volume/revenue, customer segmentation, merchant and category performance, payment-method adoption, transaction reliability, and time-series trends.
- Executive Power BI dashboard (three pages, audience-specific) with KPI cards, trend visuals, and interactive filters.
- Documentation: README, data dictionary, ER diagram, ETL walkthrough, KPI catalog, business insights, dashboard review.
- GitHub portfolio packaging and interview-preparation material.

### 4.2 Out of Scope

Removed because the sourced dataset cannot support them without fabricating business data (see [`00_PRD_Scope_Addendum.md`](00_PRD_Scope_Addendum.md) for the full reasoning):

- **Budget tracking** — no user-defined budget data exists.
- **Savings goals / savings rate** — no income stream exists to compute savings against.
- **Financial health score** — its standard inputs (savings rate, budget adherence, debt-to-income trend) aren't available.
- **Cash-flow planning / forecasting as a financial-planning tool** — reframed as *net spend* (spend minus refunds) trend reporting, which the data does support; not presented as income-vs-expense planning.
- **Investment tracking** — no investment or portfolio data exists.
- Real bank/UPI/wallet connectivity (Plaid-style live feeds) — data is a static historical dataset.
- Production-grade ML forecasting — any forward-looking view is a conceptual moving average, not a deployed model.
- Multi-currency real-time FX conversion.
- Regulatory compliance work (PCI-DSS, SOC 2) — acknowledged as a real-world requirement, not implemented; card PAN masking is applied as a hygiene measure, not a compliance claim.
- Mobile/web front-end application — deliverable is the data layer + BI layer only.

### 4.3 Assumptions

- The sourced dataset (synthetic, card-transaction-only) approximates real transaction behavior closely enough for realistic analysis.
- A single analyst executes all phases; the project timeline assumes part-time portfolio pacing, not a funded team sprint.
- All monetary values are in a single base currency with no live FX conversion.

### 4.4 Constraints

- Data is static/historical — no real-time ingestion pipeline is in scope.
- Power BI Desktop (free tier) is the BI tool, with its associated feature/data-size limits versus an enterprise license.
- No access to real users — all segmentation is internally consistent, not externally validated.

### 4.5 Risks

| Risk | Impact | Mitigation |
|---|---|---|
| Dataset lacks income/budget data | Cannot demo budget-vs-actual or savings-rate analysis | Formally descoped rather than filled with fabricated data — see [`00_PRD_Scope_Addendum.md`](00_PRD_Scope_Addendum.md) |
| Reviewer assumes "Personal Finance" branding implies budgeting features | Confusion about project scope | Project renamed to "Card Transaction & Merchant Analytics"; scope-pivot addendum linked from the README |
| Star schema perceived as over-engineered for dataset size | Adds complexity without demonstrable benefit at this scale | Documented explicitly as simulating production scale, not solving this dataset's literal size |
| Currency/rounding errors in aggregation | Silently wrong KPI values | Monetary values stored as `NUMERIC`, not `FLOAT`; reconciliation checks included in load scripts |

### 4.6 Future Enhancements

- Recurring-transaction detection (merchant + amount ±5% + 3-of-4-months) — the one originally-scoped capability this dataset can still support; deferred, not descoped (see [`00_PRD_Scope_Addendum.md`](00_PRD_Scope_Addendum.md#7-deferred-not-descoped)).
- A conformed `dim_date` dimension, fact table partitioning by `txn_date`, and an enforced FK from `audit_log` to `fact_transactions` — see [`14_ER_Diagram_Architecture.md`](14_ER_Diagram_Architecture.md#8-production-readiness-gaps--recommended-improvements).
- A fraud-analytics extension using `data/raw/train_fraud_labels.json`, which exists in the source data but is not currently loaded anywhere in the pipeline.

## 5. Functional Requirements

The system shall:

- Store multi-card transaction data per user (`fact_transactions`, `dim_users`, `dim_cards`).
- Classify every transaction by Merchant Category Code via a dimension table, not free text (`dim_mcc`).
- Compute transaction volume, revenue, and net spend (spend minus refunds) at user/card/merchant/month grain.
- Support ranking and top-N queries (top merchants, top categories, top customers).
- Segment customers into value tiers (Premium/Gold/Silver/Standard) based on total spend.
- Track transaction success/failure and attribute failure reasons.
- Expose all metrics via reusable SQL views for BI-tool consumption (`sql/05_views`, `sql/11_dashboard_views`).
- Log every fact-table insert to an audit trail (`audit_log` + `trg_transaction_audit`).

## 6. Non-Functional Requirements

- Core reporting queries should execute efficiently on the ~13.3M-row transaction table (indexed on every dimension FK plus `txn_date` and `amount`).
- Schema documented well enough that a new analyst can onboard from the data dictionary alone.
- Naming conventions (`snake_case`, `_id`/`_key` suffixes) consistent across all objects.
- Every fact table has a documented grain before any SQL is written against it.
- Design extensible to new dimensions (e.g., a future `dim_date`) without breaking existing queries.

## 7. Key Business Questions

- Which merchants and merchant categories generate the highest revenue, and how concentrated is that revenue (80/20)?
- Who are the highest-spending customers, and how should they be segmented?
- Which payment methods are used most, and how has that mix shifted over time?
- What is month-over-month and year-over-year growth in transaction volume and revenue?
- What share of transactions fail, and for what reasons?
- How is revenue distributed geographically?
- Is spending different on weekends vs. weekdays?

The full traceability of these questions to specific SQL scripts — including which ones the dataset cannot answer — is maintained in [`sql/10_business_analytics/12_business_questions.sql`](../sql/10_business_analytics/12_business_questions.sql).

## 8. Representative User Stories & Acceptance Criteria

**US-01: Merchant category concentration**
As a category manager, I want to see which merchant categories drive the most revenue so that I can prioritize partnership negotiations.
- Given transactions with a positive amount, the system ranks MCC categories by total revenue and shows cumulative contribution percentage.

**US-02: Customer value segmentation**
As a growth marketer, I want customers segmented by spend tier so that I can target retention offers at the right audience.
- Given a customer's total positive-amount spend, the system assigns exactly one segment label (Premium/Gold/Silver/Standard) per the thresholds documented in [`09_KPI_Definitions.md`](09_KPI_Definitions.md).

**US-03: Transaction failure attribution**
As an operations analyst, I want failed transactions broken down by reason so that I can route fixes to the right team.
- Given a transaction with a non-null `errors` value, the system attributes it to that reason and reports the percentage share of all transactions each reason represents.

## 9. Business Rules

1. A transaction with a positive `amount` is treated as spend; a negative `amount` is treated as a refund. `Net Spend = Total Spend − Total Refunds`.
2. A customer's spend segment (Premium ≥ 400,000 / Gold ≥ 250,000 / Silver ≥ 150,000 / Standard below) is computed only from positive-amount transactions — refunds do not reduce a customer out of their tier.
3. A transaction is "successful" if its `errors` field is null; any non-null `errors` value marks it as failed, and the specific string is retained (including compound multi-reason strings) for failure-mode analysis.
4. Currency values are stored as `NUMERIC(12,2)`, never `FLOAT`, to avoid floating-point rounding error in aggregation.
5. Card PAN is never stored in usable form outside staging; `dim_cards.card_number_masked` retains only the last four digits.

## 10. Reporting Requirements

- Executive summary view: total revenue, transactions, customers, cards, average transaction, monthly trend — single page.
- Customer view: demographic and value segmentation, top-20 customers, card-brand revenue mix.
- Transaction reliability view: success/failure rate, failure-reason breakdown, geographic revenue, monthly volume trend.
- All dashboard visuals filterable by date, and (where applicable) by state, payment channel, or demographic segment.

## 11. Success Criteria

- All business questions in §7 answered with working, documented SQL, or explicitly marked as not answerable given the dataset.
- Dashboard renders all KPIs with working interactive filters.
- Documentation set allows a new reader to understand the project's scope and design in under 10 minutes.

---

## Conclusion

This Business Requirements document defines the objectives, scope, stakeholders, functional expectations, and success criteria for Card Transaction & Merchant Analytics — scoped to what the sourced credit-card transaction dataset actually supports, with every descoped budget/income/financial-health capability documented rather than silently dropped.
