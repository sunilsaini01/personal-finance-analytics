# SQL Query Catalog

**Project:** Personal Finance Analytics & Budget Intelligence System

---

# Purpose

This document catalogs all SQL queries developed during the project. It explains the business purpose of each query, the tables involved, expected outputs, and how the results support business decisions.

---

# Query Categories

## 1. Data Validation

| Query                       | Purpose                    | Tables           |
| --------------------------- | -------------------------- | ---------------- |
| Count Users                 | Verify user records        | stg_users        |
| Count Cards                 | Verify card records        | stg_cards        |
| Count Transactions          | Verify transaction records | stg_transactions |
| Duplicate User Check        | Data Quality               | stg_users        |
| Duplicate Card Check        | Data Quality               | stg_cards        |
| Duplicate Transaction Check | Data Quality               | stg_transactions |

---

## 2. ETL Validation

| Query                            | Purpose |
| -------------------------------- | ------- |
| Validate dim_users count         |         |
| Validate dim_cards count         |         |
| Validate dim_mcc count           |         |
| Validate dim_merchant count      |         |
| Validate fact_transactions count |         |

---

## 3. Business Analytics

### Spending by Category

Business Question:

> Which merchant categories receive the highest customer spending?

Tables:

* fact_transactions
* dim_mcc

Expected Output

* MCC
* Category Name
* Total Spend

---

### Monthly Spending Trend

Business Question:

> How does customer spending change over time?

Expected Output

* Month
* Total Transactions
* Total Spend

---

### Top Merchants

Business Question

> Which merchants generate the highest transaction value?

---

### Customer Segmentation

Business Question

> Which customers spend the most?

Metrics

* Total Spend
* Average Spend
* Transaction Count

---

### Card Analytics

Business Question

> Which card brands and card types are used most frequently?

---

### Fraud Analytics

Business Question

> Which merchant categories experience the highest fraud activity?

---

# Views

| View                           | Purpose           |
| ------------------------------ | ----------------- |
| vw_monthly_spend_summary       | Monthly reporting |
| vw_customer_summary *(Future)* | Customer KPIs     |
| vw_merchant_summary *(Future)* | Merchant KPIs     |

---

# Query Performance

Recommended Indexes

* transaction_date
* user_id
* card_id
* merchant_key
* mcc

---

# Conclusion

The SQL Query Catalog provides a centralized reference for analytical SQL used throughout the project, improving maintainability, collaboration, and future enhancements.
