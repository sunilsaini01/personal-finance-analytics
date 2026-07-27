# Deployment Guide

---

# Purpose

This document explains how to set up and execute the Personal Finance Analytics project.

---

# Prerequisites

* PostgreSQL 18+
* Python 3.11+
* VS Code
* Git

---

# Project Structure

```text
personal-finance-analytics/

data/
docs/
scripts/
sql/
dashboard/
```

---

# Setup Steps

## 1. Clone Repository

```bash
git clone <repository-url>
```

---

## 2. Create Database

```sql
CREATE DATABASE finance_analytics;
```

---

## 3. Create Staging Tables

Run

```
sql/01_ddl/01_staging_tables.sql
```

---

## 4. Load Raw Data

Import

* Users
* Cards
* Transactions

---

## 5. Execute ETL

Run

```
sql/01_ddl/02_star_schema.sql
```

Followed by

```
scripts/load_mcc.py
```

---

## 6. Create Reporting Views

Execute

```
sql/05_views
```

---

## 7. Build Dashboard

Connect Power BI to PostgreSQL and use warehouse tables and reporting views.

---

# Validation

Verify

* Record Counts
* Foreign Keys
* KPIs

---

# Troubleshooting

Common Issues

* Database connection failure
* Missing files
* Duplicate keys
* Invalid data types

---

# Conclusion

Following these steps results in a fully operational analytics warehouse ready for reporting and dashboard development.
