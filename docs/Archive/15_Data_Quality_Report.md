# Data Quality Report

**Project Name:** Personal Finance Analytics & Budget Intelligence System

**Version:** 1.0

**Prepared By:** Sunil Kumar

**Date:** July 2026

---

# 1. Purpose

The purpose of this report is to summarize the results of data profiling and quality assessment performed on the source datasets before designing the analytical data warehouse.

High-quality data is essential for accurate reporting, reliable KPIs, and trustworthy business decisions.

---

# 2. Source Datasets

| Dataset      |        Records |
| ------------ | -------------: |
| Users        |          2,000 |
| Cards        |          6,146 |
| Transactions |     13,305,915 |
| MCC Codes    | Reference Data |
| Fraud Labels |           JSON |

---

# 3. Profiling Summary

## Users Dataset

### Findings

* User IDs are unique.
* No duplicate customer records were identified.
* Income and debt fields contain currency symbols.
* Geographic coordinates are available for all users.

### Data Quality Actions

* Remove "$" symbols.
* Convert currency fields to NUMERIC.
* Preserve user IDs as business keys.

---

## Cards Dataset

### Findings

* Card IDs are unique.
* One customer may own multiple cards.
* Maximum cards owned by a single customer: **9**.
* CVV values exist in the source.
* Card numbers are stored in full.
* `card_on_dark_web` contains only the value **"No"**.

### Data Quality Actions

* Model cards as a separate dimension.
* Mask card numbers before loading.
* Exclude CVV from the warehouse.
* Exclude `card_on_dark_web` because it contains no analytical value.

---

## Transactions Dataset

### Findings

* Transaction IDs are unique.
* Merchant information is embedded within transactions.
* Merchant IDs may appear with multiple cities.
* Transaction amounts contain currency symbols.

### Data Quality Actions

* Convert amounts to NUMERIC.
* Validate merchant information before creating a merchant dimension.
* Build the fact table at transaction level.

---

## MCC Dataset

### Findings

* Provides descriptions for Merchant Category Codes.
* Used as reference data.

### Data Quality Actions

* Load into a lookup dimension.
* Validate that all transaction MCC codes exist in the reference table.

---

# 4. Data Quality Checks

| Check                  | Status |
| ---------------------- | ------ |
| Duplicate Users        | Passed |
| Duplicate Cards        | Passed |
| Duplicate Transactions | Passed |
| Currency Conversion    | Passed |
| Primary Key Validation | Passed |
| Foreign Key Validation | Passed |
| MCC Lookup Validation  | Passed |

---

# 5. Data Cleansing Rules

* Remove currency symbols.
* Convert monetary values to NUMERIC.
* Convert YES/NO values to BOOLEAN.
* Convert dates to PostgreSQL DATE or TIMESTAMP.
* Mask card numbers.
* Remove CVV.
* Remove columns containing no analytical value.

---

# 6. Known Data Limitations

| Issue                                        | Impact                                                               |
| -------------------------------------------- | -------------------------------------------------------------------- |
| Merchant IDs associated with multiple cities | Merchant dimension requires a surrogate key or composite uniqueness. |
| Historical sample data                       | Results do not represent live financial activity.                    |
| Batch data refresh                           | Reports are not real-time.                                           |

---

# 7. Recommendations

* Perform data validation during every ETL run.
* Monitor duplicate records.
* Validate foreign key relationships.
* Review merchant data periodically.
* Expand data quality rules as new data sources are introduced.

---

# 8. Conclusion

The source datasets were determined to be suitable for analytical reporting after applying the defined data cleansing and validation rules. Maintaining these quality controls ensures reliable KPIs and trustworthy business insights.
