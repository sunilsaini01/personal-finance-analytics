# PRD Scope Addendum — Card-Transaction Analytics Pivot

**Status:** Accepted
**Supersedes:** [`Archive/00_PRD_v2_Original.md`](Archive/00_PRD_v2_Original.md) §3, §5, §6, §7, §8, §9, §10, §11, §12 — wherever they assume income, budgets, multi-account data, or account-level balances.
**Date:** 2026-07-26

---

## 1. Why this addendum exists

PRD v2 (archived at [`Archive/00_PRD_v2_Original.md`](Archive/00_PRD_v2_Original.md)) was written as a "Budget Intelligence System" against an assumed dataset: multi-account personal finance data (bank, credit card, UPI, wallet, cash) with an income stream and user-defined budgets. §17 of that PRD requires that any divergence between the plan and the actual build "trigger an explicit PRD update, not a silent divergence." This document is that update.

The dataset actually sourced and loaded (`data/raw/users_data.csv`, `cards_data.csv`, `transactions_data.csv`, `mcc_codes.json`) is **credit-card transaction data only**:

- No income or salary stream at any grain.
- No user-defined budgets.
- No account types beyond cards (no bank, UPI, wallet, or cash).
- No inter-account transfers, and no account-level running balance.
- Categories exist only as Merchant Category Codes (MCC), not a curated category/subcategory taxonomy.

This is not a data-quality gap that synthetic data can responsibly patch — income and budget figures invented wholesale would be fabricated business data, not "clearly-labeled synthetic dimension data" filling a structural hole (the PRD's own §13.1 assumption). The decision made here is to **narrow scope to what the real data supports**, and demonstrate the same SQL/modeling/BI depth through merchant, category, payment, and time-series analytics instead.

## 2. What is accepted as in scope (replacing PRD v2 §3, §7.1)

- Card-transaction-grain analytics: spend, refunds, net spend, transaction volume.
- Merchant and MCC-category performance analysis, including 80/20 concentration.
- Payment-channel analysis (swipe / chip / online, via `use_chip`).
- Customer segmentation by spend tier (Premium/Gold/Silver/Standard) — a proxy for the PRD's behavioral segmentation, built on total spend rather than savings rate or budget adherence.
- Time-series analysis: monthly/yearly revenue trends, MoM/YoY growth, rolling averages as a conceptual forecast proxy.
- Cash-flow-shaped reporting built from **net spend** (spend − refunds), not income − expenses.
- Star schema: `dim_users`, `dim_cards`, `dim_mcc`, `dim_merchant`, `fact_transactions` (see [`11_Star_Schema.md`](11_Star_Schema.md)).

## 3. What is explicitly out of scope (replacing PRD v2 §7.1 items, §8.1 FR-01/03/04/06/07, §10 rules 8-12)

These PRD v2 requirements are **descoped**, not deferred — they require data this project does not have:

| PRD v2 item | Reason descoped |
|---|---|
| FR-01 — multi-account data (bank/UPI/wallet/cash) | Dataset has cards only |
| FR-03 — user-defined budgets | No budget data exists |
| FR-04 — income, net savings, savings rate | No income stream exists |
| FR-05 — running account balance | No account/balance concept in this dataset |
| FR-06 — recurring-transaction flag | Not built (would require merchant + amount ±5% + 3-of-4-months rule; deferred, see §5) |
| FR-07 — financial health score | No inputs exist (savings rate, budget adherence, debt ratio all require income/budget) |
| FR-08 — segmentation by savings rate / budget adherence | Replaced by spend-tier segmentation (§2) |
| Business Rule 8 — income/expense direction, transfer exclusion | No income or transfers in this dataset |
| Business Rules 9-12 — savings-rate-null handling, over-budget flag, recurring rule, health-score weights | All depend on income or budget data that doesn't exist |
| §9.1 — "Minimum required attributes: ... direction (debit/credit) ... payment method" as originally scoped | `use_chip` substitutes for payment method; there is no explicit debit/credit direction field — sign of `amount` is used instead |
| §12 — `fact_budgets`, `dim_accounts`, `dim_categories`, `dim_payment_methods`, `dim_date` | Not built; MCC stands in for category, `use_chip` stands in for payment method, no date dimension table exists (date parts are derived inline from `txn_date`) |

## 4. Business questions — traceability decision (replacing PRD v2 §5)

The full per-question triage already lives in [`sql/10_business_analytics/12_business_questions.sql`](../sql/10_business_analytics/12_business_questions.sql) and is treated as authoritative — this addendum does not duplicate it. Summary: of PRD v2's twelve business questions, four are answered as originally scoped, four are answered against a substitute metric (net spend instead of income − expenses, spend-tier instead of behavior-tier segmentation), and four are marked not answerable (savings rate, budget adherence, financial health score, recurring-expense detection).

## 5. KPI catalog decision (replacing PRD v2 §6)

The accepted KPI catalog is [`09_KPI_Definitions.md`](09_KPI_Definitions.md) in full. It replaces Savings Rate, Budget Adherence %, Financial Health Score, Recurring Expense Ratio, Overspend Incidence, and Weekend Spend Share with Total/Monthly/Yearly Revenue, Revenue Growth, Customer/Merchant/Category/Payment-Method Revenue, Net Spend, and Rolling Average. Average Transaction Value and a weekend-vs-weekday spend comparison (in [`03_expense_analysis.sql`](../sql/10_business_analytics/03_expense_analysis.sql)) are the only PRD v2 KPIs carried forward unchanged.

## 6. What still applies unchanged from PRD v2

- §4 Stakeholders, §13.2 Constraints, §14 Roadmap phase structure, §15 Technology Stack, §16 Final Deliverables format, and §17's governance principle (this very addendum is that principle in action) all still hold and are not modified by this pivot.
- NFR-02, NFR-04, NFR-05 (documentation, naming, grain-first discipline) still apply and were followed in the actual build.
- FR-02 (category classification), FR-09 (SQL views), FR-10 (ranking/top-N) are met, using MCC as the category dimension.

## 7. Deferred, not descoped

Recurring-transaction detection (FR-06) is the one item that could plausibly still be built on this dataset (merchant + amount + interval is derivable from `fact_transactions` alone, no missing dimension required). It's listed as deferred rather than descoped in [`12_business_questions.sql`](../sql/10_business_analytics/12_business_questions.sql) — pick it up if there's appetite before Phase 13 (GitHub Portfolio Packaging).
