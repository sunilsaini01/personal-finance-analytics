# Data Model Design

**Project Name:** Personal Finance Analytics & Budget Intelligence System

**Version:** 1.0

**Prepared By:** Sunil Kumar

**Date:** July 2026

---

# 1. Purpose

This document describes the logical and physical data model used in the Personal Finance Analytics & Budget Intelligence System. The objective is to design a dimensional model that supports analytical reporting while maintaining data quality, scalability, and performance.

---

# 2. Why a Star Schema?

A Star Schema was selected because it is optimized for analytical workloads (OLAP). Compared with a fully normalized model, it provides:

* Faster analytical queries
* Simpler SQL joins
* Better compatibility with BI tools
* Easier KPI calculation
* Improved dashboard performance

---

# 3. Fact Table Grain

**Fact Table:** `fact_transactions`

**Grain:** One row represents one financial transaction.

Each record contains:

* Transaction ID
* Transaction Date
* User
* Card
* Merchant
* Merchant Category (MCC)
* Transaction Amount
* Payment Method
* Fraud Status

Choosing the lowest level of detail preserves flexibility for future analysis.

---

# 4. Dimension Tables

## dim_users

**Business Purpose**

Stores relatively stable customer attributes.

**Primary Key**

`user_id`

### Attributes

* Age
* Gender
* Address
* Latitude
* Longitude
* Income
* Debt
* Credit Score
* Number of Credit Cards

---

## dim_cards

**Business Purpose**

Stores payment card information independently from users.

**Primary Key**

`card_id`

**Foreign Key**

`user_id`

### Attributes

* Card Brand
* Card Type
* Masked Card Number
* Expiry Date
* Credit Limit
* Chip Availability
* Account Open Date
* PIN Change Year

### Design Decision

Each customer may own multiple cards. Card information depends on `card_id`, not `user_id`, so it is modeled as a separate dimension to avoid redundancy and update anomalies.

---

## dim_mcc

**Business Purpose**

Stores Merchant Category Codes (MCC) and their descriptions.

**Primary Key**

`mcc`

---

## dim_merchant

**Business Purpose**

Stores merchant location information derived from transaction data.

**Primary Key**

`merchant_key` (surrogate key)

### Attributes

* Merchant ID
* Merchant City
* Merchant State
* ZIP Code

### Design Decision

During data profiling, several merchant IDs were associated with multiple cities. Therefore, a surrogate key is used to uniquely identify merchant-location combinations while preserving historical consistency.

---

# 5. Fact Table Relationships

| Fact Column  | Dimension    |
| ------------ | ------------ |
| user_id      | dim_users    |
| card_id      | dim_cards    |
| merchant_key | dim_merchant |
| mcc          | dim_mcc      |

---

# 6. Data Model Diagram

```
             dim_users
                 |
                 |
            dim_cards
                 |
                 |
fact_transactions -------- dim_mcc
        |
        |
  dim_merchant
```

---

# 7. Data Types

| Attribute   | Data Type        |
| ----------- | ---------------- |
| IDs         | INTEGER / BIGINT |
| Currency    | NUMERIC(12,2)    |
| Dates       | DATE / TIMESTAMP |
| Text        | TEXT             |
| Coordinates | NUMERIC(9,6)     |
| Boolean     | BOOLEAN          |

---

# 8. Design Principles

* Separate facts from dimensions.
* Keep dimensions descriptive.
* Preserve transaction-level detail.
* Avoid duplicate business information.
* Mask sensitive payment data.
* Maintain referential integrity using foreign keys.

---

# 9. Conclusion

The dimensional model provides a scalable foundation for analytical reporting, KPI calculation, and dashboard development while supporting future enhancements.
