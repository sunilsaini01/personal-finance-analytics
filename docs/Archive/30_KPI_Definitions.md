# Personal Finance Analytics & Budget Intelligence System

# KPI Definitions Document

---

# Purpose

This document defines every Key Performance Indicator (KPI) used throughout the Personal Finance Analytics & Budget Intelligence System.

The objective is to establish a single source of truth for business metrics used by:

- Executive Leadership
- Finance Team
- Business Analysts
- Product Managers
- Data Analysts
- Dashboard Developers

Each KPI includes its business definition, calculation logic, SQL implementation reference, interpretation, and business importance.

---

# KPI Classification

The KPIs are categorized into the following groups:

- Executive KPIs
- Financial KPIs
- Customer KPIs
- Merchant KPIs
- Card KPIs
- Time-based KPIs
- Operational KPIs

---

# 1. Total Transactions

## Business Definition

The total number of successfully recorded financial transactions in the system.

---

## Business Purpose

Measures platform activity.

Higher transaction counts generally indicate greater customer engagement.

---

## Formula

Total Transactions = COUNT(Transaction ID)

---

## SQL Logic

Count every record in the Fact Transactions table.

---

## SQL File

01_executive_kpi_analysis.sql

---

## Business Interpretation

High Value

- Increased customer activity
- Higher platform utilization

Low Value

- Lower engagement
- Possible system issues
- Reduced customer spending

---

## Executive Action

Monitor transaction growth month-over-month.

---

## Dashboard Usage

Executive KPI Card

---

# 2. Total Transaction Amount

## Business Definition

The total monetary value processed through the platform.

---

## Formula

SUM(Transaction Amount)

---

## Business Importance

Measures business volume rather than transaction count.

Two months may have equal transactions but very different transaction values.

---

## SQL File

01_executive_kpi_analysis.sql

---

## Interpretation

Increasing trend

- Higher customer spending

Decreasing trend

- Reduced purchasing activity

---

## Dashboard Usage

Executive Dashboard

Financial Dashboard

---

# 3. Average Transaction Value

## Business Definition

Average amount spent per transaction.

---

## Formula

Average Transaction =

Total Transaction Amount

/

Total Transactions

---

## SQL Logic

AVG(amount)

---

## Business Importance

Measures customer purchasing behavior.

Useful for detecting:

- Inflation
- Spending behavior
- Product pricing impact

---

## Dashboard Usage

Executive KPI

---

# 4. Active Users

## Business Definition

Unique users who performed at least one transaction.

---

## Formula

COUNT(DISTINCT user_id)

---

## Business Importance

Measures customer engagement.

---

## Executive Action

If Active Users decline while total users remain stable:

Investigate customer churn.

---

# 5. Total Cards

## Business Definition

Number of cards registered in the platform.

---

## SQL Logic

COUNT(card_id)

---

## Business Importance

Represents customer banking penetration.

---

# 6. Total Merchants

## Business Definition

Number of merchants accepting payments.

---

## Formula

COUNT(DISTINCT merchant_key)

---

## Business Importance

Measures ecosystem size.

---

# 7. Merchant Categories

## Business Definition

Unique merchant categories available.

---

## Formula

COUNT(DISTINCT mcc)

---

## Business Importance

Shows diversity of spending.

---

# 8. Monthly Transaction Growth

## Business Definition

Percentage increase in transaction volume compared to previous month.

---

## Formula

(Current Month - Previous Month)

/

Previous Month

×100

---

## SQL Concepts

Window Function

LAG()

---

## Business Importance

Growth indicator for executives.

---

# 9. Total Income

## Business Definition

Total incoming cash.

---

## Formula

SUM(Income Transactions)

---

## Business Importance

Measures earning capacity.

---

# 10. Total Expense

## Business Definition

Total outgoing cash.

---

## Formula

SUM(Expense Transactions)

---

## Business Importance

Measures customer spending.

---

# 11. Net Savings

## Formula

Income − Expenses

---

## Business Importance

Primary financial health metric.

---

# 12. Savings Rate

## Formula

(Net Savings / Income) × 100

---

## Business Importance

Shows how efficiently customers save money.

---

# 13. Cash Flow

## Formula

Cash In − Cash Out

---

## Importance

Tracks liquidity.

---

# 14. Average Spend Per User

## Formula

Total Expense

/

Active Users

---

## Business Importance

Customer value metric.

---

# 15. Merchant Sales

## Formula

SUM(amount)

GROUP BY merchant

---

## Business Importance

Measures merchant contribution.

---

# 16. Merchant Contribution %

## Formula

Merchant Sales

/

Total Sales

×100

---

## Business Importance

Identifies key merchants.

---

# 17. Card Utilization

## Formula

Transactions

per Card

---

## Business Importance

Measures card usage.

---

# 18. Credit vs Debit Usage

## Business Definition

Distribution of transactions by card type.

---

## Business Importance

Customer payment preference.

---

# 19. Daily Transactions

Tracks day-level activity.

---

# 20. Monthly Transactions

Tracks month-level trends.

---

# 21. Quarterly Transactions

Executive reporting KPI.

---

# 22. Yearly Transactions

Long-term business growth.

---

# KPI Relationships

Executive Dashboard

├── Total Transactions

├── Total Amount

├── Avg Transaction

├── Active Users

├── Merchant Sales

├── Savings Rate

├── Cash Flow

└── Monthly Growth

---

# Dashboard KPI Priority

Priority 1

- Total Transactions
- Total Amount
- Active Users

Priority 2

- Merchant Sales
- Savings Rate
- Cash Flow

Priority 3

- Card Utilization
- Merchant Categories
- Average Spend

---

# KPI Validation Rules

Before using any KPI in reports:

✔ Validate against Fact Table

✔ Check NULL values

✔ Verify duplicate transactions

✔ Confirm date filters

✔ Validate joins

✔ Verify aggregation logic

---

# Best Practices

- Always define KPIs consistently.
- Avoid duplicate KPI definitions across reports.
- Validate business logic before dashboard publication.
- Use SQL views to standardize KPI calculations.
- Refresh statistics regularly for optimal performance.

---

# Summary

This KPI catalog serves as the official business metric reference for the Personal Finance Analytics & Budget Intelligence System. It ensures that executives, analysts, and dashboard developers interpret and calculate every KPI consistently, supporting accurate reporting and data-driven decision-making across the organization.