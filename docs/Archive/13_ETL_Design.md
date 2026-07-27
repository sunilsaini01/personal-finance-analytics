# ETL Design

**Project Name:** Personal Finance Analytics & Budget Intelligence System

---

# 1. Purpose

This document explains the Extract, Transform, and Load (ETL) process used to populate the analytical data warehouse.

---

# 2. ETL Overview

```
Raw CSV / JSON Files
        │
        ▼
Staging Tables (stg_*)
        │
        ▼
Data Cleaning
        │
        ▼
Data Validation
        │
        ▼
Dimension Tables
        │
        ▼
Fact Table
        │
        ▼
Reporting Views
        │
        ▼
Power BI / Tableau
```

---

# 3. Extract Phase

Source files:

* users_data.csv
* cards_data.csv
* transactions_data.csv
* mcc_codes.json
* train_fraud_labels.json

All files are first loaded into staging tables without modification.

---

# 4. Transform Phase

Transformations include:

* Remove currency symbols.
* Convert currency fields to NUMERIC.
* Convert YES/NO to BOOLEAN.
* Convert dates to PostgreSQL DATE/TIMESTAMP.
* Mask card numbers.
* Remove CVV.
* Validate primary keys.
* Validate foreign keys.
* Standardize merchant information.

---

# 5. Load Phase

Loading order:

1. dim_users
2. dim_cards
3. dim_mcc
4. dim_merchant
5. fact_transactions

This order preserves referential integrity.

---

# 6. Data Validation

Validation checks include:

* Duplicate detection
* Null checks
* Foreign key validation
* Data type validation
* Currency conversion validation
* Record count verification

---

# 7. Error Handling

* Invalid records logged.
* ETL stops on critical failures.
* Transactions rolled back on errors.
* Validation reports generated after loading.

---

# 8. Incremental Load Strategy

Future versions may support incremental loading using transaction timestamps instead of full reloads.

---

# 9. Conclusion

The ETL pipeline ensures that source data is transformed into a clean, reliable, and analytics-ready warehouse suitable for reporting and decision-making.
