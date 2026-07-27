-- ============================================
-- Dashboard Views
-- Personal Finance Analytics
--
-- Reusable views for Power BI / Tableau consumption (FR-09).
-- These wrap the recurring aggregates from sql/10_business_analytics
-- so the BI tool queries a small set of stable views instead of
-- re-running ad-hoc analysis scripts against fact_transactions.
-- ============================================

DROP VIEW IF EXISTS vw_monthly_spend_refund;
DROP VIEW IF EXISTS vw_category_performance;
DROP VIEW IF EXISTS vw_customer_segment;
DROP VIEW IF EXISTS vw_error_summary;

----------------------------------------------------------
-- Monthly Spend, Refunds, Net Spend
----------------------------------------------------------

CREATE VIEW vw_monthly_spend_refund AS

SELECT
    DATE_TRUNC('month', txn_date)::DATE AS month,

    ROUND(
        SUM(CASE WHEN amount > 0 THEN amount ELSE 0 END),
        2
    ) AS total_spend,

    ROUND(
        SUM(CASE WHEN amount < 0 THEN ABS(amount) ELSE 0 END),
        2
    ) AS total_refunds,

    ROUND(SUM(amount), 2) AS net_spend,

    COUNT(*) AS total_transactions

FROM fact_transactions

GROUP BY DATE_TRUNC('month', txn_date);

----------------------------------------------------------
-- Category (MCC) Performance & Contribution
----------------------------------------------------------

CREATE VIEW vw_category_performance AS

WITH category_spend AS (
    SELECT
        f.mcc,
        m.description AS category,
        COUNT(*) AS total_transactions,
        SUM(f.amount) AS total_spend
    FROM fact_transactions f
    JOIN dim_mcc m
        ON f.mcc = m.mcc
    WHERE f.amount > 0
    GROUP BY f.mcc, m.description
)

SELECT
    mcc,
    category,
    total_transactions,
    ROUND(total_spend, 2) AS total_spend,
    ROUND(
        total_spend * 100.0 / NULLIF(SUM(total_spend) OVER (), 0),
        2
    ) AS spend_contribution_percent
FROM category_spend
ORDER BY total_spend DESC;

----------------------------------------------------------
-- Customer Spend Segment
----------------------------------------------------------

CREATE VIEW vw_customer_segment AS

WITH customer_spending AS (
    SELECT
        user_id,
        SUM(amount) AS total_spend
    FROM fact_transactions
    WHERE amount > 0
    GROUP BY user_id
)

SELECT
    user_id,
    ROUND(total_spend, 2) AS total_spend,
    CASE
        WHEN total_spend >= 400000 THEN 'Premium'
        WHEN total_spend >= 250000 THEN 'Gold'
        WHEN total_spend >= 150000 THEN 'Silver'
        ELSE 'Standard'
    END AS customer_segment
FROM customer_spending;

----------------------------------------------------------
-- Transaction Error Summary
----------------------------------------------------------

CREATE VIEW vw_error_summary AS

SELECT
    COALESCE(errors, 'No Error') AS error_type,
    COUNT(*) AS total_transactions,
    ROUND(
        COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (),
        2
    ) AS percent_of_all_transactions
FROM fact_transactions
GROUP BY errors;
