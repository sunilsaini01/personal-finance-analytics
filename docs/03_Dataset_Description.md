# Dataset Description

# Card Transaction & Merchant Analytics

---

# 1. Dataset Overview

This project uses a synthetic financial transactions dataset that simulates real-world banking and payment card activity. The dataset contains customer information, card details, merchant information, merchant category codes (MCC), and millions of financial transactions collected over multiple years.

The dataset is suitable for Business Intelligence, SQL Analytics, Customer Analytics, Merchant Analytics, and Dashboard Development.

---

# 2. Dataset Components

The dataset consists of four primary entities:

| Dataset | Description |
|----------|-------------|
| Users | Customer demographic and account information |
| Cards | Customer card details |
| Transactions | Financial transaction records |
| MCC Codes | Merchant Category Code reference data |

---

# 3. Database Tables

After the ETL process, the following tables are available in PostgreSQL.

## Staging Tables

- stg_users
- stg_cards
- stg_transactions

## Dimension Tables

- dim_users
- dim_cards
- dim_mcc

---

# 4. Dataset Size

| Table | Approximate Records |
|--------|--------------------:|
| Customers | 2,000 |
| Cards | 6,146 |
| Transactions | 13.3 Million+ |
| Merchant Categories (MCC) | 109 |

The large transaction table enables realistic analytical workloads similar to enterprise financial systems.

---

# 5. Important Fields

## Customer

- Client ID
- Gender
- Current Age
- Credit Score
- Income
- Number of Credit Cards

---

## Card

- Card ID
- Client ID
- Card Brand
- Card Type
- Card Number
- Expiration Date

---

## Transaction

- Transaction ID
- Transaction Date
- Client ID
- Card ID
- Merchant ID
- Merchant City
- Merchant State
- MCC
- Transaction Amount
- Payment Method
- Transaction Errors

---

## Merchant Category

- MCC
- Merchant Category Description

---

# 6. Time Period

The dataset contains transaction records from:

**2010 – 2019**

This allows long-term trend analysis, seasonal analysis, and year-over-year comparisons.

---

# 7. Data Types

The dataset contains a mix of:

- Integer values
- Decimal values
- Dates and timestamps
- Text fields
- Categorical attributes

This combination supports descriptive, diagnostic, and trend analysis.

---

# 8. Data Quality

Before analysis, the dataset was cleaned using SQL.

Cleaning activities included:

- Removing currency symbols from monetary values
- Converting data to appropriate numeric types
- Handling missing values
- Standardizing categorical fields
- Validating primary and foreign keys
- Removing duplicate records where applicable

---

# 9. Analytical Capabilities

The dataset supports multiple business analyses, including:

- Customer Segmentation
- Merchant Performance Analysis
- Category Analysis
- Payment Method Analysis
- Net Spend / Cash-Flow-Shaped Trend Analysis (spend minus refunds — not income-based cash flow; see [`09_KPI_Definitions.md`](09_KPI_Definitions.md))
- Revenue Trend Analysis
- Time Series Analysis
- KPI Reporting

---

# 10. Limitations

Although comprehensive, the dataset has some limitations:

- Synthetic rather than real banking data
- No personally identifiable customer information
- No account balance history
- No loan or investment information
- Merchant names are represented by IDs

These limitations do not affect the project's ability to demonstrate Business Intelligence and SQL Analytics concepts.

---

# Conclusion

The dataset provides a realistic environment for building an end-to-end financial analytics solution. Its scale, structure, and diversity make it suitable for demonstrating SQL development, dimensional modeling, KPI generation, and executive dashboard design using PostgreSQL and Power BI.