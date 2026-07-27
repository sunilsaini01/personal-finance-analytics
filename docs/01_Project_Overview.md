# Project Overview

# Card Transaction & Merchant Analytics

---

> **Formerly:** "Personal Finance Analytics & Budget Intelligence System." Repositioned after confirming the sourced dataset has no income, budget, savings, or bank-balance data — see [`00_PRD_Scope_Addendum.md`](00_PRD_Scope_Addendum.md) for the full decision record. This document reflects the corrected, implemented scope.

## Elevator Pitch

A production-style PostgreSQL data warehouse and Power BI analytics platform that transforms 13.3 million raw credit-card transactions into merchant, customer, payment-channel, and transaction-reliability intelligence — built end-to-end with a documented star schema, a 12-module SQL analytics library, and a three-page executive dashboard.

## Executive Summary

Card Transaction & Merchant Analytics is a Business Intelligence and data-warehousing project built on a large-scale credit-card transaction dataset (~2,000 users, ~6,146 cards, 13.3M+ transactions, 109 merchant category codes). Raw CSV/JSON source data is cleaned and loaded into a governed PostgreSQL star schema, analyzed through a documented SQL library, and surfaced through a three-page Power BI dashboard covering executive KPIs, customer segmentation, and transaction reliability.

The project exists to demonstrate the same skills a merchant-analytics, card-operations, or BI-engineering team uses in production: dimensional modeling with a defensible grain, an auditable ETL pipeline, SQL from foundational joins through window functions, and dashboards built for a specific audience rather than a generic "everything on one page" dump.

## Problem Statement

A card issuer or merchant-analytics team generates millions of transaction records but, without structured modeling, cannot easily answer the questions that actually drive decisions: Which merchant categories and merchants concentrate the most spend? Which customers are most valuable, and what do they look like demographically? Is the transaction pipeline reliable, and when it isn't, why not? Raw transaction logs answer none of these directly — they require a governed data model and a purpose-built analytics layer.

## Business Context

This project simulates the analytics function inside a card-network or PFM (personal finance management) company that has transaction, cardholder, and merchant data but needs to convert it into decision-grade reporting: revenue and volume trends, customer value segmentation, payment-channel adoption, and operational reliability (success/failure rates and failure-reason attribution). It intentionally does **not** simulate a lending, budgeting, or income-tracking function, because the underlying data doesn't support that framing — see [`00_PRD_Scope_Addendum.md`](00_PRD_Scope_Addendum.md) for exactly what was descoped and why.

## Project Objectives

1. Design and build a governed, star-schema PostgreSQL data warehouse at a documented transaction grain.
2. Implement a repeatable ETL pipeline from raw CSV/JSON through staging, cleaning, and load, with validation checks at each stage.
3. Build a SQL analytics library covering customer, merchant, category, payment-method, time-series, and transaction-error analysis.
4. Deliver a three-page Power BI dashboard tailored to three distinct audiences (executive, marketing/growth, operations/risk).
5. Produce documentation — data dictionary, ER diagram, ETL walkthrough, KPI catalog, business insights — accurate enough for a new analyst to onboard from the docs alone.
6. Package the result as an interview-defensible, recruiter-readable GitHub portfolio project.

## Business Value

- **For a merchant/category team:** identifies where spend concentrates (Money Transfer is consistently the top category) and how concentrated it is, informing partnership and negotiation priorities.
- **For a marketing/growth team:** segments customers by value and demographics, identifying the highest-value cohort (see [`docs/15_Dashboard_Documentation.md`](15_Dashboard_Documentation.md) — the 45-54 age band, not 65+, is the top-revenue segment in this dataset) for targeted retention work.
- **For an operations/risk team:** surfaces the transaction success rate and, critically, breaks down *why* transactions fail (Insufficient Balance and Bad PIN lead), which routes directly to two different fixes owned by two different teams.
- **For the business overall:** demonstrates that a governed, documented data model produces more trustworthy KPIs than ad-hoc querying against raw transaction logs — and that catching a scope/data mismatch honestly (as this project did) is itself a deliverable, not a failure.

## Success Criteria

- Every business question in [`02_Business_Requirements.md`](02_Business_Requirements.md) is answered by a working, documented SQL script, with any question the dataset cannot answer explicitly marked as such (not silently dropped).
- The Power BI dashboard renders all KPIs across all three pages with working interactive filters.
- The data dictionary, ER diagram, and README together let a stranger understand the project's scope and design in under 10 minutes.
- Every design decision (grain, surrogate-key choice, normalization level, index strategy) is defensible unprompted in a technical interview — see [`16_Portfolio_Positioning.md`](16_Portfolio_Positioning.md).
