# User Stories

**Project Name:** Personal Finance Analytics & Budget Intelligence System

**Version:** 1.0

**Prepared By:** Sunil Kumar

**Methodology:** Agile Scrum

---

# 1. Purpose

This document captures the functional requirements from the perspective of different stakeholders using Agile user stories. Each story includes acceptance criteria, priority, and the related business epic.

---

# Epic 1 – Customer Analytics

---

## US-001

**As a** Finance Analyst

**I want** to view the total number of transactions

**So that** I can monitor overall business activity.

**Priority:** High

### Acceptance Criteria

* Dashboard displays total transaction count.
* Value updates after warehouse refresh.
* Users can filter by date.

---

## US-002

**As a** Finance Analyst

**I want** to view total transaction amount

**So that** I can understand customer spending.

**Priority:** High

### Acceptance Criteria

* Amount is calculated from the fact table.
* Currency values are numeric.
* Date filters are supported.

---

## US-003

**As a** Product Manager

**I want** to view active customers

**So that** I can measure customer engagement.

**Priority:** High

---

## US-004

**As a** Product Manager

**I want** to identify top spending customers

**So that** marketing campaigns can target high-value users.

**Priority:** Medium

---

## US-005

**As a** Business Analyst

**I want** customer spending segmented by credit score

**So that** financial behavior can be analyzed.

**Priority:** Medium

---

# Epic 2 – Card Analytics

---

## US-006

**As a** Product Manager

**I want** to compare Visa, Mastercard, and other card brands

**So that** I can understand card usage trends.

**Priority:** Medium

---

## US-007

**As a** Product Manager

**I want** to compare Debit and Credit card transactions

**So that** I can understand customer payment preferences.

---

## US-008

**As a** Finance Analyst

**I want** to analyze chip versus swipe transactions

**So that** I can evaluate payment technology adoption.

---

## US-009

**As a** Business Analyst

**I want** average credit limits by customer segment

**So that** customer purchasing power can be analyzed.

---

# Epic 3 – Merchant Analytics

---

## US-010

**As a** Finance Manager

**I want** spending grouped by merchant category

**So that** I know where customers spend most.

---

## US-011

**As a** Product Manager

**I want** to identify top merchants

**So that** partnership opportunities can be evaluated.

---

## US-012

**As a** Executive

**I want** spending by state

**So that** regional performance can be monitored.

---

## US-013

**As a** Executive

**I want** spending by city

**So that** local business trends are visible.

---

# Epic 4 – Fraud Monitoring

---

## US-014

**As a** Risk Analyst

**I want** to monitor fraudulent transactions

**So that** suspicious activity can be investigated quickly.

---

## US-015

**As a** Risk Manager

**I want** to calculate fraud rate

**So that** overall financial risk is monitored.

---

## US-016

**As a** Risk Analyst

**I want** to identify high-value fraudulent transactions

**So that** critical cases receive immediate attention.

---

# Epic 5 – Reporting & Dashboards

---

## US-017

**As a** Executive

**I want** a monthly financial dashboard

**So that** I can monitor business performance.

---

## US-018

**As a** Finance Team Member

**I want** downloadable reports

**So that** I can share insights with stakeholders.

---

## US-019

**As a** Product Manager

**I want** dashboard filters by date, customer, merchant, and card type

**So that** I can analyze different business segments.

---

## US-020

**As a** Business User

**I want** KPI cards displayed at the top of dashboards

**So that** key metrics are immediately visible.

---

# 2. Story Prioritization

| Priority | Description                                     |
| -------- | ----------------------------------------------- |
| High     | Required for the first production release       |
| Medium   | Important but can be delivered in later sprints |
| Low      | Nice-to-have enhancement                        |

---

# 3. Definition of Done

A user story is considered complete when:

* Business requirements are implemented.
* SQL queries are validated.
* ETL process loads accurate data.
* KPIs match business definitions.
* Dashboard visualizations are verified.
* Documentation is updated.
* Stakeholder acceptance is received.

---

# 4. Sprint Planning Example

| Sprint   | User Stories     |
| -------- | ---------------- |
| Sprint 1 | US-001 to US-005 |
| Sprint 2 | US-006 to US-010 |
| Sprint 3 | US-011 to US-015 |
| Sprint 4 | US-016 to US-020 |

---

# 5. Conclusion

These user stories translate business requirements into implementable development tasks. They help the Scrum team understand stakeholder expectations, prioritize work, and deliver features incrementally while ensuring alignment with business objectives.
