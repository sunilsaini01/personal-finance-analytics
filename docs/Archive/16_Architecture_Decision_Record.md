# Architecture Decision Record (ADR)

**Project Name:** Personal Finance Analytics & Budget Intelligence System

**Version:** 1.0

**Prepared By:** Sunil Kumar

**Date:** July 2026

---

# Purpose

This document records significant architectural and design decisions made during the development of the Personal Finance Analytics & Budget Intelligence System.

Recording these decisions provides context for future maintenance and explains the rationale behind the selected design.

---

# ADR-001: Adopt a Star Schema

## Decision

Use a Star Schema for the analytical data warehouse.

## Rationale

* Optimized for OLAP workloads.
* Simpler SQL queries.
* Better performance for reporting.
* Well supported by BI tools.

## Alternatives Considered

* Fully normalized schema (3NF)

## Reason Not Selected

Although normalized databases reduce redundancy, they require more joins and are less efficient for analytical reporting.

---

# ADR-002: Separate Cards into a Dedicated Dimension

## Decision

Create `dim_cards` instead of storing card attributes in `dim_users`.

## Rationale

* One customer may own multiple cards.
* Card attributes depend on `card_id`, not `user_id`.
* Prevents update anomalies.
* Maintains Second and Third Normal Form.

---

# ADR-003: Mask Card Numbers

## Decision

Store only masked card numbers.

## Rationale

* Protect sensitive financial information.
* Demonstrate secure data handling.
* Reduce exposure of payment information.

---

# ADR-004: Exclude CVV

## Decision

Do not load CVV into the warehouse.

## Rationale

* No analytical value.
* Sensitive payment information.
* Follows secure data handling practices.

---

# ADR-005: Remove card_on_dark_web

## Decision

Exclude the `card_on_dark_web` column.

## Rationale

Data profiling showed every record contained the value **"No"**, making the column constant and unsuitable for analysis.

---

# ADR-006: Merchant Dimension Design

## Decision

Use a surrogate key for the merchant dimension.

## Rationale

Data profiling showed that the same merchant ID may appear with multiple cities. A surrogate key uniquely identifies each merchant-location combination and avoids ambiguity.

---

# ADR-007: Preserve Transaction-Level Grain

## Decision

The fact table stores one row per transaction.

## Rationale

Maintaining the lowest level of detail supports flexible aggregations, future reporting requirements, and advanced analytical use cases.

---

# ADR-008: Use Staging Tables

## Decision

Load raw files into staging tables before transformation.

## Rationale

* Preserve raw data.
* Simplify debugging.
* Improve ETL reliability.
* Separate extraction from transformation.

---

# ADR-009: Daily Batch Processing

## Decision

Use scheduled batch ETL instead of real-time streaming.

## Rationale

The project uses historical datasets intended for analytical reporting rather than operational transaction processing.

---

# ADR-010: Use PostgreSQL

## Decision

Implement the analytical warehouse using PostgreSQL.

## Rationale

* Open-source.
* Strong SQL support.
* ACID compliance.
* Well suited for data warehousing and analytical workloads.

---

# Lessons Learned

During development, several important design considerations emerged:

* Profiling data before modeling prevents poor schema decisions.
* Business rules should drive schema design.
* Security should be considered even when working with sample data.
* Data quality validation is essential before reporting.
* Clear documentation improves maintainability and knowledge transfer.

---

# Conclusion

The architectural decisions documented here provide a transparent record of the reasoning behind the data warehouse design. They serve as a reference for future enhancements and help ensure consistency as the project evolves.
