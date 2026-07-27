/*
Business Analytics
Payment Analysis
=========================================================

Objective:
Analyze customer payment behavior by transaction type.

Source: fact_transactions (governed warehouse table), not
stg_transactions — amount is already typed NUMERIC.
=========================================================
*/

-- Query 1
-- Payment Method Summary

SELECT
    use_chip AS payment_method,
    COUNT(*) AS total_transactions,
    ROUND(SUM(amount),2) AS total_revenue,
    ROUND(AVG(amount),2) AS average_transaction
FROM fact_transactions
GROUP BY use_chip
ORDER BY total_revenue DESC;

-- Query 2
-- Payment Method Share

WITH payment_summary AS
(
    SELECT
        use_chip,
        COUNT(*) AS transactions
    FROM fact_transactions
    GROUP BY use_chip
)

SELECT
    use_chip,
    transactions,
    ROUND(
        transactions * 100.0 /
        NULLIF(SUM(transactions) OVER(), 0),
        2
    ) AS transaction_percent
FROM payment_summary
ORDER BY transactions DESC;

-- Query 3
-- Monthly Payment Trend

SELECT
    DATE_TRUNC('month', txn_date) AS month,
    use_chip,
    COUNT(*) AS transactions,
    ROUND(SUM(amount),2) AS revenue
FROM fact_transactions
GROUP BY month, use_chip
ORDER BY month, use_chip;

-- Query 4
-- Highest Average Transaction by Payment Method

SELECT
    use_chip,
    ROUND(AVG(amount),2) AS avg_transaction,
    ROUND(MAX(amount),2) AS highest_transaction,
    ROUND(MIN(amount),2) AS lowest_transaction
FROM fact_transactions
GROUP BY use_chip
ORDER BY avg_transaction DESC;

-- Query 5
-- Yearly Payment Performance

SELECT
    EXTRACT(YEAR FROM txn_date) AS year,
    use_chip,
    COUNT(*) AS transactions,
    ROUND(SUM(amount),2) AS revenue
FROM fact_transactions
GROUP BY year, use_chip
ORDER BY year, revenue DESC;

-- Query 6
-- Payment Method Revenue Contribution

WITH payment_revenue AS
(
    SELECT
        use_chip,
        SUM(amount) AS revenue
    FROM fact_transactions
    GROUP BY use_chip
)

SELECT
    use_chip,
    ROUND(revenue,2) AS revenue,
    ROUND(
        revenue * 100 /
        NULLIF(SUM(revenue) OVER(), 0),
        2
    ) AS revenue_percent
FROM payment_revenue
ORDER BY revenue DESC;

-- Query 7
-- Top 20 Highest Value Transactions

SELECT
    txn_date,
    user_id,
    card_id,
    use_chip,
    mcc,
    ROUND(amount,2) AS amount
FROM fact_transactions
ORDER BY amount DESC
LIMIT 20;
