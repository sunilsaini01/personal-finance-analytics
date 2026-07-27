# KPI Catalog

**Project Name:** Personal Finance Analytics & Budget Intelligence System

**Version:** 1.0

**Prepared By:** Sunil Kumar

**Date:** July 2026

---

# 1. Purpose

The KPI Catalog defines the standardized business metrics used to measure financial performance, customer behavior, transaction activity, merchant performance, and fraud trends.

Each KPI includes its business purpose, calculation method, business owner, reporting frequency, and supported business decisions.

---

# 2. KPI Summary

| KPI ID  | KPI Name                   | Category    | Owner      | Frequency |
| ------- | -------------------------- | ----------- | ---------- | --------- |
| KPI-001 | Total Transactions         | Transaction | Finance    | Daily     |
| KPI-002 | Total Transaction Amount   | Financial   | Finance    | Daily     |
| KPI-003 | Average Transaction Value  | Financial   | Finance    | Daily     |
| KPI-004 | Active Customers           | Customer    | Product    | Weekly    |
| KPI-005 | Average Spend per Customer | Customer    | Finance    | Monthly   |
| KPI-006 | Top Spending Customers     | Customer    | Finance    | Monthly   |
| KPI-007 | Transactions by Card Brand | Card        | Product    | Weekly    |
| KPI-008 | Transactions by Card Type  | Card        | Product    | Weekly    |
| KPI-009 | Chip vs Swipe Usage        | Card        | Product    | Monthly   |
| KPI-010 | Merchant Category Spend    | Merchant    | Finance    | Monthly   |
| KPI-011 | Top Merchant Categories    | Merchant    | Finance    | Monthly   |
| KPI-012 | Transactions by State      | Geographic  | Management | Monthly   |
| KPI-013 | Transactions by City       | Geographic  | Management | Monthly   |
| KPI-014 | Monthly Transaction Trend  | Trend       | Executive  | Monthly   |
| KPI-015 | Average Credit Limit       | Customer    | Product    | Monthly   |
| KPI-016 | Credit Score Distribution  | Customer    | Risk       | Monthly   |
| KPI-017 | Customer Debt Distribution | Customer    | Risk       | Monthly   |
| KPI-018 | High Value Transactions    | Risk        | Risk Team  | Daily     |
| KPI-019 | Fraud Rate                 | Fraud       | Risk Team  | Daily     |
| KPI-020 | Fraud Count                | Fraud       | Risk Team  | Daily     |

---

# 3. KPI Details

## KPI-001 — Total Transactions

### Business Purpose

Measures overall transaction activity within the platform.

### Formula

Total number of transaction records.

### SQL Logic

COUNT(Transaction ID)

### Business Owner

Finance Team

### Reporting Frequency

Daily

### Business Decision

Tracks platform activity and growth.

---

## KPI-002 — Total Transaction Amount

### Business Purpose

Measures total customer spending.

### Formula

SUM(Transaction Amount)

### SQL Logic

SUM(amount)

### Business Owner

Finance Team

### Reporting Frequency

Daily

### Business Decision

Evaluates overall payment volume.

---

## KPI-003 — Average Transaction Value

### Business Purpose

Measures average customer spending per transaction.

### Formula

Total Transaction Amount ÷ Total Transactions

### Business Decision

Identifies changes in purchasing behavior.

---

## KPI-004 — Active Customers

### Business Purpose

Counts customers who performed at least one transaction during the reporting period.

### Formula

COUNT(DISTINCT user_id)

### Business Decision

Measures customer engagement.

---

## KPI-005 — Average Spend per Customer

### Formula

Total Spending ÷ Active Customers

### Business Decision

Supports customer segmentation.

---

## KPI-006 — Top Spending Customers

### Formula

Rank customers by total spending.

### Business Decision

Identify premium customer segments.

---

## KPI-007 — Transactions by Card Brand

### Business Purpose

Analyzes transaction distribution across Visa, Mastercard, and other brands.

### Business Decision

Supports card portfolio analysis.

---

## KPI-008 — Transactions by Card Type

### Business Purpose

Compares Debit, Credit, and Prepaid card usage.

### Business Decision

Understand customer payment preferences.

---

## KPI-009 — Chip vs Swipe Usage

### Business Purpose

Measures transaction method adoption.

### Business Decision

Supports payment technology analysis.

---

## KPI-010 — Merchant Category Spend

### Formula

SUM(amount) GROUP BY MCC

### Business Decision

Identifies high-spending merchant categories.

---

## KPI-011 — Top Merchant Categories

Ranks merchant categories based on transaction amount.

---

## KPI-012 — Transactions by State

Measures transaction volume by customer location.

---

## KPI-013 — Transactions by City

Measures city-level transaction distribution.

---

## KPI-014 — Monthly Transaction Trend

Tracks transaction growth month over month.

---

## KPI-015 — Average Credit Limit

Measures the average credit limit available across customer cards.

---

## KPI-016 — Credit Score Distribution

Analyzes customer credit score ranges.

---

## KPI-017 — Customer Debt Distribution

Analyzes debt across customer segments.

---

## KPI-018 — High Value Transactions

Counts transactions above a defined business threshold (for example, greater than $1,000).

---

## KPI-019 — Fraud Rate

### Formula

(Fraud Transactions ÷ Total Transactions) × 100

### Business Decision

Measures overall fraud exposure.

---

## KPI-020 — Fraud Count

Counts all transactions labeled as fraudulent.

---

# 4. KPI Ownership Matrix

| Department | KPIs                                        |
| ---------- | ------------------------------------------- |
| Executive  | KPI-002, KPI-014                            |
| Finance    | KPI-001, KPI-002, KPI-003, KPI-005, KPI-010 |
| Product    | KPI-004, KPI-007, KPI-008, KPI-009          |
| Risk       | KPI-016, KPI-017, KPI-018, KPI-019, KPI-020 |

---

# 5. Dashboard Mapping

| Dashboard           | KPIs Displayed                              |
| ------------------- | ------------------------------------------- |
| Executive Dashboard | KPI-001, KPI-002, KPI-003, KPI-014          |
| Customer Dashboard  | KPI-004, KPI-005, KPI-006, KPI-015, KPI-016 |
| Merchant Dashboard  | KPI-010, KPI-011, KPI-012, KPI-013          |
| Card Dashboard      | KPI-007, KPI-008, KPI-009                   |
| Fraud Dashboard     | KPI-018, KPI-019, KPI-020                   |

---

# 6. Conclusion

The KPI Catalog establishes a standardized definition for business metrics across the organization. By using consistent formulas and business rules, stakeholders can rely on dashboards and reports to make informed decisions without ambiguity.
