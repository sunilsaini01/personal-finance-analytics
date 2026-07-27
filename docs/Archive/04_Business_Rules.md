# Business Rules

**Project Name:** Personal Finance Analytics & Budget Intelligence System

**Version:** 1.0

**Prepared By:** Sunil Kumar

**Date:** July 2026

---

# 1. Purpose

This document defines the business rules that govern data collection, validation, transformation, storage, and reporting for the Personal Finance Analytics & Budget Intelligence System.

Business rules ensure that all analytical reports, KPIs, dashboards, and ETL processes follow consistent business logic.

---

# 2. User Rules

## BR-001 – Unique Customer

Every customer shall be uniquely identified by **User ID**.

**Reason:** Prevent duplicate customer records and ensure reliable reporting.

---

## BR-002 – One User Record

Each row in the User Dimension shall represent exactly one customer.

**Reason:** Maintains the correct grain of the dimension.

---

## BR-003 – Credit Score Integrity

Credit score values shall be loaded without modification.

**Reason:** Credit score is used for customer segmentation and financial analysis.

---

## BR-004 – Financial Attributes

Income and debt values shall be converted into numeric data types during ETL.

**Reason:** Enables mathematical calculations and KPI generation.

---

# 3. Card Rules

## BR-005 – Unique Card

Every payment card shall have a unique Card ID.

---

## BR-006 – Card Ownership

Each card must belong to one and only one customer.

---

## BR-007 – Multiple Cards

A customer may own multiple payment cards.

**Reason:** One-to-many relationship between User and Card.

---

## BR-008 – Card Number Security

Only the last four digits of the card number shall be stored.

**Reason:** Protects sensitive financial information.

---

## BR-009 – CVV Exclusion

CVV values shall never be stored in the analytical warehouse.

**Reason:** CVV has no analytical value and should not be retained.

---

## BR-010 – Dark Web Flag

The `card_on_dark_web` attribute shall not be included in the warehouse because every record contains the same value.

**Reason:** Columns with no variation do not provide analytical insight.

---

# 4. Transaction Rules

## BR-011 – Fact Table Grain

One row in the Fact Table represents one completed transaction.

---

## BR-012 – Unique Transaction

Every transaction must have a unique Transaction ID.

---

## BR-013 – User Relationship

Every transaction must reference a valid customer.

---

## BR-014 – Card Relationship

Every transaction must reference a valid payment card.

---

## BR-015 – MCC Relationship

Every transaction must reference a valid Merchant Category Code.

---

## BR-016 – Transaction Amount

Currency values shall be stored as numeric values after removing formatting symbols.

---

## BR-017 – Transaction Timestamp

Original transaction timestamps shall be preserved.

---

## BR-018 – Fraud Label

Fraud labels shall be associated using Transaction ID.

---

# 5. Merchant Rules

## BR-019 – Merchant Category

Every merchant transaction should contain a valid MCC.

---

## BR-020 – Merchant Information

Merchant city, state, and ZIP code shall be captured from transaction data.

---

## BR-021 – Merchant Consistency

Where possible, merchant attributes should remain consistent for the same merchant identifier.

**Reason:** In the provided dataset, some merchant IDs appear in multiple cities. This should be monitored as a data quality issue.

---

# 6. ETL Rules

## BR-022 – Staging First

All raw files shall be loaded into staging tables before transformation.

---

## BR-023 – Repeatable ETL

The ETL process shall support safe re-execution.

---

## BR-024 – Validation Before Load

Primary keys and foreign keys shall be validated before warehouse loading.

---

## BR-025 – Load Order

Warehouse loading shall follow this sequence:

1. Staging Tables
2. Dimension Tables
3. Fact Table
4. Reporting Views

---

## BR-026 – Error Handling

Failed ETL operations shall be logged and corrected before reporting.

---

# 7. Data Quality Rules

## BR-027 – Primary Key Integrity

Primary keys must be unique.

---

## BR-028 – Foreign Key Integrity

All foreign keys must reference existing dimension records.

---

## BR-029 – Mandatory Fields

Mandatory fields shall not contain NULL values.

---

## BR-030 – Numeric Validation

Currency fields must be successfully converted into numeric values.

---

## BR-031 – Duplicate Prevention

Duplicate records shall not be inserted into warehouse tables.

---

# 8. Reporting Rules

## BR-032 – Single Source of Truth

Reports shall use warehouse tables rather than staging tables.

---

## BR-033 – KPI Consistency

All dashboards shall calculate KPIs using standardized SQL logic.

---

## BR-034 – Historical Reporting

Historical transactions shall remain available for trend analysis.

---

## BR-035 – Reproducibility

Running the same report on the same dataset should always produce identical results.

---

# 9. KPI Rules

## BR-036 – Spending Calculations

Total spending shall be calculated using transaction amounts after currency conversion.

---

## BR-037 – Merchant Analysis

Merchant reports shall aggregate transactions by Merchant Category Code.

---

## BR-038 – Customer Analysis

Customer reports shall aggregate transactions at the User level.

---

## BR-039 – Fraud Analysis

Fraud reports shall use the fraud labels linked through Transaction ID.

---

## BR-040 – Dashboard Refresh

Dashboards shall only use successfully validated warehouse data.

---

# 10. Summary

These business rules define the standard behavior of the analytics platform. They guide ETL development, warehouse design, SQL reporting, dashboard implementation, and data quality validation. Following these rules ensures that business users receive accurate, secure, and consistent analytical information for decision-making.
