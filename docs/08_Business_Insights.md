# Business Insights

# Card Transaction & Merchant Analytics

---

## Purpose

This document summarizes the key business insights discovered through SQL analysis, translating analytical results into recommendations grounded in what this credit-card transaction dataset actually contains — no income, budget, or savings insight is claimed, because none of that data exists here.

## Executive Summary

Analysis of 13.3M+ card transactions revealed insight into customer spend behavior, merchant performance, payment-channel preference, and long-term spend trends. These findings support merchant-partnership decisions, customer-segment targeting, and transaction-reliability monitoring.

## Customer Insights

### Premium Customers Drive Spend

A relatively small group of Premium-tier customers (per the spend-based segmentation in [`09_KPI_Definitions.md`](09_KPI_Definitions.md)) contributes a disproportionate share of total spend.

**Recommendation:** develop loyalty programs and exclusive offers targeted at the Premium tier; prioritize retention for this segment specifically.

### Customer Segmentation

Customers segment into Premium / Gold / Silver / Standard tiers by total spend. Different tiers warrant different marketing strategies rather than a one-size-fits-all approach.

## Merchant Insights

### Revenue Concentration

A limited number of merchant categories — Money Transfer consistently leading — generate a large share of total revenue (see [`15_Dashboard_Documentation.md`](15_Dashboard_Documentation.md) for the exact ranking observed on the dashboard).

**Recommendation:** prioritize merchant-partnership and fee-negotiation effort proportional to this concentration; monitor dependency risk on the top category/merchants.

### Geographic Concentration

Revenue is concentrated in North America, consistent with a US-issued card dataset (see the Revenue by State map in [`15_Dashboard_Documentation.md`](15_Dashboard_Documentation.md)).

**Recommendation:** treat this as a US-centric base for any geographic strategy; there isn't meaningful non-US volume in this dataset to expand analysis into.

## Category Insights

Several MCC categories — necessity-skewed ones (grocery, pharmacy, fuel, utilities) alongside Money Transfer — contribute a large share of revenue. Category-contribution analysis identifies where partnership and promotional effort would have the most leverage.

## Payment Method Insights

### Swipe Transactions Lead, but the Channel Mix Is Shifting

Swipe transactions account for the largest historical transaction share, with chip transactions essentially absent in the earliest years of the dataset and growing over time — consistent with the real-world EMV chip rollout timeline (see the dashboard's Jan-2010 vs. full-history payment-method comparison in [`15_Dashboard_Documentation.md`](15_Dashboard_Documentation.md)).

**Recommendation:** continue investing in swipe/chip terminal reliability given their combined dominant share, while tracking online-channel growth as the segment most likely to keep expanding.

## Net Spend Insights (formerly "Cash Flow")

Monthly net spend (spend minus refunds) can be tracked via `vw_monthly_spend_refund` and the rolling-average query in `05_cashflow_analysis.sql`. This supports operational spend monitoring and anomaly detection — **not** financial planning or budgeting, since no income data exists to plan a budget against.

**Recommendation:** use the rolling average to flag months with unusually high spend or refund volume for follow-up, rather than as a savings/budgeting signal.

## Time Series Insights

Revenue and transaction volume can be tracked month-over-month and year-over-year using the time-series module. Seasonal or period-specific patterns, where they exist in the data, are useful for staffing and promotional-timing decisions.

**Recommendation:** use MoM/YoY growth tracking for operational planning (staffing, promotional timing), not as a substitute for a true forecasting model — this project's forward-looking view is a conceptual moving average, not a deployed prediction.

## Risk Indicators

- Revenue concentration in a small number of top merchant categories.
- Geographic concentration in North America (a fact about this dataset, not necessarily a risk to a real business, but worth naming explicitly).
- A meaningful volume of failed transactions (see [`15_Dashboard_Documentation.md`](15_Dashboard_Documentation.md) — 98% success rate still means a non-trivial absolute failure count at 13M+ transactions), with Insufficient Balance and Bad PIN as the leading named causes.

## Opportunities

- Deepen the Premium-tier loyalty and retention program.
- Prioritize partnerships in the highest-concentration merchant categories.
- Build the deferred recurring-transaction flag (see [`00_PRD_Scope_Addendum.md §7`](00_PRD_Scope_Addendum.md#7-deferred-not-descoped)) to identify subscription/EMI-style spend.
- Reduce Insufficient-Balance and Bad-PIN failures through targeted, cause-specific fixes (see the dashboard recommendations in [`15_Dashboard_Documentation.md`](15_Dashboard_Documentation.md)).

## Recommended KPIs to Monitor

- Total Revenue, Total Transactions, Average Transaction Value
- Net Spend, Revenue Growth (MoM/YoY)
- Category/Merchant/Payment-Method Contribution %
- Transaction Success Rate and Failure-Reason Breakdown
- Customer Segment Distribution (Premium/Gold/Silver/Standard)

## Business Impact

Acting on these insights can improve customer retention (Premium-tier targeting), merchant-partnership ROI (concentration-aware prioritization), and transaction reliability (cause-specific failure fixes) — all grounded directly in what this dataset supports.

## Conclusion

These insights demonstrate how card-transaction data alone — without income, budget, or account-balance information — still supports meaningful customer, merchant, payment, and reliability analysis. The discipline throughout has been to frame every insight in terms the data can actually substantiate, rather than borrowing language (income, savings, budgeting) from the project's original, since-corrected scope.
