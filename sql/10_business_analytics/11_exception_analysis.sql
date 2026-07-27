/*
Exception Analysis
Project : Personal Finance Analytics & Budget Intelligence
Database: PostgreSQL
==========================================================

Business Goal
-------------
Identify transactions that failed or were flagged with an
error (e.g. insufficient balance, bad PIN, technical glitch),
how often they occur, and whether they cluster around
particular merchants, payment channels, or time periods.

Author : Sunil Kumar
==========================================================
*/

-- 1. Overall Error Rate

SELECT
    COUNT(*) FILTER (WHERE errors IS NOT NULL) AS error_transactions,
    COUNT(*) AS total_transactions,
    ROUND(
        COUNT(*) FILTER (WHERE errors IS NOT NULL) * 100.0
        / NULLIF(COUNT(*), 0),
        2
    ) AS error_rate_percent
FROM fact_transactions;

-- 2. Error Type Breakdown

SELECT
    errors AS error_type,
    COUNT(*) AS total_transactions,
    ROUND(
        COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (),
        2
    ) AS percent_of_all_transactions
FROM fact_transactions
WHERE errors IS NOT NULL
GROUP BY errors
ORDER BY total_transactions DESC;

-- 3. Monthly Error Trend

SELECT
    DATE_TRUNC('month', txn_date) AS month,
    COUNT(*) FILTER (WHERE errors IS NOT NULL) AS error_transactions,
    COUNT(*) AS total_transactions,
    ROUND(
        COUNT(*) FILTER (WHERE errors IS NOT NULL) * 100.0
        / NULLIF(COUNT(*), 0),
        2
    ) AS error_rate_percent
FROM fact_transactions
GROUP BY month
ORDER BY month;

-- 4. Error Rate by Payment Channel

SELECT
    use_chip AS payment_channel,
    COUNT(*) FILTER (WHERE errors IS NOT NULL) AS error_transactions,
    COUNT(*) AS total_transactions,
    ROUND(
        COUNT(*) FILTER (WHERE errors IS NOT NULL) * 100.0
        / NULLIF(COUNT(*), 0),
        2
    ) AS error_rate_percent
FROM fact_transactions
GROUP BY use_chip
ORDER BY error_rate_percent DESC;

-- 5. Merchant Categories with the Highest Error Rate
-- (restricted to categories with meaningful volume)

SELECT
    m.description AS category,
    COUNT(*) FILTER (WHERE ft.errors IS NOT NULL) AS error_transactions,
    COUNT(*) AS total_transactions,
    ROUND(
        COUNT(*) FILTER (WHERE ft.errors IS NOT NULL) * 100.0
        / NULLIF(COUNT(*), 0),
        2
    ) AS error_rate_percent
FROM fact_transactions ft
JOIN dim_mcc m
    ON ft.mcc = m.mcc
GROUP BY m.description
HAVING COUNT(*) >= 500
ORDER BY error_rate_percent DESC
LIMIT 20;

-- 6. Users with the Most Failed Transactions

SELECT
    user_id,
    COUNT(*) AS error_transactions
FROM fact_transactions
WHERE errors IS NOT NULL
GROUP BY user_id
ORDER BY error_transactions DESC
LIMIT 20;
