# Assumptions, Risks and Constraints

**Project Name:** Personal Finance Analytics & Budget Intelligence System

**Version:** 1.0

**Prepared By:** Sunil Kumar

**Date:** July 2026

---

# 1. Purpose

This document identifies the assumptions, risks, constraints, and dependencies associated with the Personal Finance Analytics & Budget Intelligence System.

Documenting these items helps project stakeholders understand potential challenges, manage expectations, and reduce implementation risks.

---

# 2. Project Assumptions

The following assumptions are made throughout the project lifecycle.

| ID    | Assumption                                               | Business Impact                       |
| ----- | -------------------------------------------------------- | ------------------------------------- |
| A-001 | Source datasets are available before ETL execution.      | Required for successful data loading. |
| A-002 | User IDs, Card IDs, and Transaction IDs are unique.      | Ensures data integrity.               |
| A-003 | PostgreSQL server is available during ETL execution.     | Required for warehouse operations.    |
| A-004 | Source files follow the expected schema.                 | Prevents ETL failures.                |
| A-005 | Merchant Category Code (MCC) reference file is complete. | Supports merchant analysis.           |
| A-006 | Fraud labels correctly identify fraudulent transactions. | Enables fraud reporting.              |
| A-007 | All currency fields can be converted to numeric values.  | Required for KPI calculations.        |
| A-008 | ETL jobs complete successfully before dashboard refresh. | Ensures consistent reporting.         |

---

# 3. Project Constraints

The following constraints limit the project scope or implementation.

| ID    | Constraint                                                                               | Impact                                                |
| ----- | ---------------------------------------------------------------------------------------- | ----------------------------------------------------- |
| C-001 | Project uses historical sample data only.                                                | Results do not represent live financial activity.     |
| C-002 | Merchant information is derived from transactions instead of a master merchant database. | Merchant data quality depends on transaction records. |
| C-003 | Dashboards rely on daily batch ETL rather than real-time streaming.                      | Reports are not real-time.                            |
| C-004 | PostgreSQL is the selected database platform.                                            | Design is optimized for PostgreSQL features.          |
| C-005 | Card numbers are masked and CVV values are excluded.                                     | Sensitive information is protected.                   |

---

# 4. Project Risks

| Risk ID | Risk Description                                               | Probability | Impact | Mitigation                                                  |
| ------- | -------------------------------------------------------------- | ----------- | ------ | ----------------------------------------------------------- |
| R-001   | Source file format changes.                                    | Medium      | High   | Validate schema before loading.                             |
| R-002   | Duplicate records in source files.                             | Medium      | High   | Perform duplicate checks during ETL.                        |
| R-003   | Missing mandatory values.                                      | Medium      | Medium | Apply data validation rules.                                |
| R-004   | Incorrect foreign key relationships.                           | Low         | High   | Validate keys before loading fact tables.                   |
| R-005   | Performance degradation with increasing transaction volume.    | Medium      | High   | Use indexing and query optimization.                        |
| R-006   | Incorrect KPI calculations due to inconsistent business logic. | Low         | High   | Standardize KPI definitions.                                |
| R-007   | Dashboard refresh failures after ETL.                          | Low         | Medium | Schedule dashboard refresh after successful ETL completion. |

---

# 5. Dependencies

The project depends on the following components.

| Dependency                 | Purpose                              |
| -------------------------- | ------------------------------------ |
| PostgreSQL                 | Data warehouse platform              |
| CSV Source Files           | Customer, Card, and Transaction data |
| MCC JSON File              | Merchant category reference data     |
| Fraud Label JSON File      | Fraud analysis                       |
| SQL Scripts                | ETL, warehouse creation, reporting   |
| BI Tool (Power BI/Tableau) | Dashboard visualization              |

---

# 6. Data Quality Risks

Potential data quality issues identified during analysis include:

* Duplicate source records.
* Invalid foreign key relationships.
* Missing mandatory values.
* Incorrect currency formatting.
* Merchant IDs associated with multiple cities.
* Invalid MCC values.

These issues should be monitored using validation queries during ETL.

---

# 7. Security Considerations

To protect sensitive financial information:

* Store only masked card numbers.
* Exclude CVV values from the warehouse.
* Restrict access to fraud-related reports.
* Use warehouse tables instead of raw staging data for reporting.

---

# 8. Business Continuity

The project should support:

* Repeatable ETL execution.
* Database backup and recovery.
* Reloading warehouse tables if ETL fails.
* Consistent KPI generation after recovery.

---

# 9. Conclusion

Understanding project assumptions, constraints, risks, and dependencies allows the team to proactively manage potential issues and deliver a reliable analytics solution. These considerations improve project planning, reduce implementation risk, and ensure that business users receive trustworthy analytical insights.
