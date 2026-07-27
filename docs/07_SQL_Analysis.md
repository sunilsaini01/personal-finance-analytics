# SQL Analysis

# Card Transaction & Merchant Analytics

---

## Purpose

This document summarizes the SQL-based business analyses performed against the star schema in `sql/10_business_analytics/`. The objective is to transform 13.3M+ raw transactions into merchant, customer, payment, and time-based insight using PostgreSQL.

## SQL Analysis Modules

| Module | Script | Objective |
|---|---|---|
| Income → Spend Reframing | `02_income_analysis.sql` | Reframes the original "income" question as total card spend, since no income stream exists in this dataset |
| Expense Analysis | `03_expense_analysis.sql` | Spend patterns, including weekend vs. weekday |
| Savings → Net Spend Reframing | `04_savings_analysis.sql` | Reframes "savings" as net spend (spend minus refunds), since no income exists to compute savings against |
| Cash Flow (as Net Spend) | `05_cashflow_analysis.sql` | Monthly net-spend trend and rolling average |
| Merchant Analysis | `06_merchant_analysis.sql` | Merchant-level performance |
| Category Analysis | `07_category_analysis.sql` | MCC-level spend and contribution |
| Payment Analysis | `08_payment_analysis.sql` | Payment-channel comparison |
| Time Series Analysis | `09_time_series_analysis.sql` | Monthly/yearly trend, growth, running totals |
| Customer Segmentation | `10_customer_segmentation.sql` | Spend-tier segmentation |
| Exception Analysis | `11_exception_analysis.sql` | Transaction failure/error analysis |
| Business Questions Traceability | `12_business_questions.sql` | Maps every PRD business question to its answering script, or marks it not answerable |

> **Naming note:** modules 02 and 04 keep their original "income"/"savings" filenames for traceability back to the original PRD's business questions, but their content and this document both frame them correctly as spend/net-spend analysis — see [`09_KPI_Definitions.md §11`](09_KPI_Definitions.md#11-net-spend) and [`00_PRD_Scope_Addendum.md`](00_PRD_Scope_Addendum.md).

## 1. Customer Segmentation Analysis

**Objective:** Identify valuable customers based on total spend.

**KPIs:** Total Spend, Total Transactions, Average Transaction Value, Customer Segment, Monthly Spend.

**Business questions answered:** Who are the highest-spending customers? How many Premium-tier customers exist? Which customers have the highest average transaction value?

**Business value:** loyalty-program targeting, personalized offers, customer retention.

## 2. Merchant Analysis

**Objective:** Evaluate merchant performance across the network.

**KPIs:** Revenue by Merchant, Transactions by Merchant, Average Transaction Value, Merchant State/City Performance.

**Business questions answered:** Which merchants generate the highest revenue? Which cities/states have the highest transaction volume?

**Business value:** merchant-partnership strategy, revenue concentration monitoring.

## 3. Category Analysis

**Objective:** Understand spend across Merchant Category Codes (MCC).

**KPIs:** Revenue by Category, Transaction Count, Category Contribution %, Average Transaction, Monthly Category Revenue.

**Business questions answered:** Which spending categories dominate? How concentrated is spend (80/20)?

**Business value:** category-partnership prioritization, targeted promotions.

## 4. Payment Method Analysis

**Objective:** Analyze payment-channel preference and usage trends.

**KPIs:** Transactions by Payment Method, Revenue by Payment Method, Average Transaction, Revenue Contribution %.

**Payment channels:** Swipe Transaction, Chip Transaction, Online Transaction.

**Business questions answered:** Which channel is most used? Which generates the highest revenue? How has channel mix shifted over time (e.g., chip adoption)?

**Business value:** payment-infrastructure investment prioritization, channel-adoption tracking.

## 5. Net Spend Analysis (formerly "Cash Flow")

**Objective:** Monitor net card spend (spend minus refunds) over time.

**KPIs:** Monthly Total Spend, Monthly Refunds, Net Spend, Rolling Average.

**Business questions answered:** How does net spend change month to month? Are there unusually high-refund or high-spend months?

**Business value:** operational spend monitoring, anomaly detection. **Not** a financial-planning or budgeting capability — this dataset has no income stream to plan a budget against.

## 6. Time Series Analysis

**Objective:** Analyze long-term spend trends.

**KPIs:** Monthly Revenue, Yearly Revenue, Revenue Growth, Running Total, Moving Average.

**Business questions answered:** How has revenue changed over time? Which months/years perform best?

**Business value:** trend visibility for executive reporting and category/merchant planning.

## SQL Features Used

- **Aggregate functions:** `SUM`, `AVG`, `COUNT`, `MIN`, `MAX`
- **Window functions:** `ROW_NUMBER`, `RANK`, `LAG`, `LEAD`, `SUM() OVER()`, `AVG() OVER()`
- **Date functions:** `DATE_TRUNC`, `EXTRACT`
- **Conditional logic:** `CASE`, `COALESCE`
- **Joins:** `INNER JOIN`, `LEFT JOIN`
- **CTEs:** used throughout to simplify multi-step analytical queries

## Business Outcomes

The SQL analyses provide insight into customer spend behavior, merchant performance, category-wise spend, payment-channel preference, transaction reliability, and time-based trends — the foundation for the Power BI dashboards described in [`15_Dashboard_Documentation.md`](15_Dashboard_Documentation.md).

## Conclusion

The SQL analysis phase turns 13.3M+ transaction records into actionable business insight using PostgreSQL's analytical features — window functions, CTEs, and CASE-based segmentation — scoped strictly to what a card-transaction dataset can actually support.
