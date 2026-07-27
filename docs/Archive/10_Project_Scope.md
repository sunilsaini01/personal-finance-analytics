# Project Scope

**Project Name:** Personal Finance Analytics & Budget Intelligence System

**Version:** 1.0

**Prepared By:** Sunil Kumar

**Date:** July 2026

---

# 1. Purpose

This document defines the boundaries of the Personal Finance Analytics & Budget Intelligence System. It specifies what is included in the project, what is excluded, the expected deliverables, project milestones, and acceptance criteria.

A clearly defined scope ensures that all stakeholders have a shared understanding of the project objectives and prevents uncontrolled changes during development.

---

# 2. Project Objective

To design and implement a SQL-based analytics platform that transforms raw financial transaction data into a dimensional data warehouse and provides meaningful reports, KPIs, and dashboards to support business decision-making.

---

# 3. In Scope

The following activities are included in this project:

## Data Collection

* Import customer data.
* Import card data.
* Import transaction data.
* Import Merchant Category Code (MCC) reference data.
* Import fraud label data.

---

## Data Warehouse Development

* Create staging tables.
* Design Star Schema.
* Create dimension tables.
* Create fact table.
* Define primary and foreign key relationships.

---

## ETL Development

* Load raw data into staging tables.
* Clean and transform data.
* Convert currency fields to numeric values.
* Mask card numbers.
* Exclude CVV values.
* Load warehouse tables.

---

## Data Quality

* Validate primary keys.
* Validate foreign keys.
* Check duplicate records.
* Verify mandatory fields.
* Validate numeric conversions.

---

## SQL Analytics

* Customer analytics.
* Merchant analytics.
* Card analytics.
* Fraud analytics.
* Financial KPI calculations.

---

## Reporting

* SQL reporting views.
* Business KPIs.
* Dashboard datasets.
* Analytical reports.

---

## Documentation

* Business Requirements Document (BRD)
* Stakeholder Analysis
* Business Rules
* KPI Catalog
* User Stories
* Functional Requirements Specification (FRS)
* Reporting Requirements
* Assumptions, Risks & Constraints
* Project Scope
* Success Metrics

---

# 4. Out of Scope

The following items are intentionally excluded from this project:

* Real-time transaction processing.
* Mobile application development.
* Internet banking functionality.
* Payment gateway integration.
* Customer authentication and login.
* Live API integrations.
* Machine learning fraud prediction models.
* Email or SMS notifications.
* Investment recommendation engine.
* Loan management functionality.

---

# 5. Project Deliverables

The project will produce the following deliverables:

| Deliverable            | Description                              |
| ---------------------- | ---------------------------------------- |
| PostgreSQL Database    | Analytical data warehouse                |
| Staging Tables         | Raw data storage                         |
| Dimension Tables       | Customer, Card, Merchant, MCC dimensions |
| Fact Table             | Transaction fact table                   |
| ETL SQL Scripts        | Data loading and transformation scripts  |
| SQL Analysis Scripts   | Business analysis queries                |
| Reporting Views        | Reusable SQL views                       |
| Business Documentation | Complete project documentation           |
| BI Dashboards          | Executive and analytical dashboards      |

---

# 6. Project Milestones

| Milestone | Deliverable                          |
| --------- | ------------------------------------ |
| Phase 1   | Requirement Analysis                 |
| Phase 2   | Data Profiling                       |
| Phase 3   | Database Design                      |
| Phase 4   | Star Schema Development              |
| Phase 5   | ETL Implementation                   |
| Phase 6   | Reporting Views                      |
| Phase 7   | SQL Analytics                        |
| Phase 8   | Dashboard Development                |
| Phase 9   | Testing & Validation                 |
| Phase 10  | Project Documentation & Final Review |

---

# 7. Acceptance Criteria

The project will be considered complete when:

* All source data is successfully loaded.
* Star Schema is implemented.
* ETL completes without errors.
* Data quality validation passes.
* Fact and dimension tables are populated correctly.
* SQL reports return accurate results.
* KPIs match business definitions.
* Dashboards display correct information.
* Documentation is complete and reviewed.

---

# 8. Project Success Factors

The project should achieve the following:

* Reliable data warehouse.
* Accurate business reporting.
* Standardized KPI calculations.
* Secure handling of sensitive financial data.
* Easy-to-maintain SQL scripts.
* Clear documentation for future enhancements.

---

# 9. Scope Change Management

Any proposed change to project scope should:

1. Be documented.
2. Be reviewed by the Business Analyst.
3. Be assessed for impact on schedule, cost, and quality.
4. Be approved before implementation.

This ensures controlled project delivery and minimizes scope creep.

---

# 10. Conclusion

The defined project scope establishes clear expectations for stakeholders by identifying the project's objectives, deliverables, boundaries, and acceptance criteria. Adhering to this scope helps ensure successful project execution while maintaining focus on delivering a high-quality analytics solution.
