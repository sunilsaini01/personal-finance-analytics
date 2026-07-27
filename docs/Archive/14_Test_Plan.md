# Test Plan

**Project Name:** Personal Finance Analytics & Budget Intelligence System

---

# 1. Purpose

This document defines the testing strategy used to validate database objects, ETL processes, data quality, and reporting outputs.

---

# 2. Testing Objectives

Verify that:

* Tables are created successfully.
* Data loads correctly.
* Relationships are valid.
* KPIs are accurate.
* Reports return expected results.

---

# 3. ETL Test Cases

| Test Case           | Expected Result                |
| ------------------- | ------------------------------ |
| Load Users          | 2,000 records loaded           |
| Load Cards          | 6,146 records loaded           |
| Load Transactions   | All transaction records loaded |
| Load MCC            | All MCC codes imported         |
| Currency Conversion | No conversion errors           |

---

# 4. Data Quality Test Cases

| Validation      | SQL Check                                |
| --------------- | ---------------------------------------- |
| Duplicate Users | COUNT(*) = COUNT(DISTINCT user_id)       |
| Duplicate Cards | COUNT(*) = COUNT(DISTINCT card_id)       |
| Foreign Keys    | No orphan records                        |
| Null Values     | Mandatory columns contain no NULL values |

---

# 5. Functional Test Cases

* Verify customer analytics queries.
* Verify merchant reports.
* Verify fraud analysis.
* Verify reporting views.
* Verify dashboard datasets.

---

# 6. Performance Tests

* ETL completes within batch window.
* Analytical queries return acceptable response times.
* Views execute successfully.

---

# 7. Security Tests

* Card numbers remain masked.
* CVV values are not stored.
* Sensitive reports are access controlled.

---

# 8. Acceptance Criteria

The solution is accepted when:

* All ETL jobs succeed.
* Validation queries pass.
* KPIs match expected values.
* Dashboards display accurate information.
* Documentation is complete.

---

# 9. Conclusion

Testing confirms that the data warehouse delivers reliable, accurate, and secure analytical information for business users.
