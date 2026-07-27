/*
Business Analytics
Category Analysis
=========================================================

Objective:
Analyze customer spending by Merchant Category Code (MCC)

Source: fact_transactions (governed warehouse table), not
stg_transactions — amount is already typed NUMERIC.
=========================================================
*/

-- Query 1
-- Revenue by Category

SELECT
    mcc,
    COUNT(*) AS total_transactions,
    ROUND(SUM(amount),2) AS total_revenue,
    ROUND(AVG(amount),2) AS avg_transaction
FROM fact_transactions
WHERE amount > 0
GROUP BY mcc
ORDER BY total_revenue DESC
LIMIT 20;

-- Query 2
-- Categories with Highest Transaction Volume

SELECT
    mcc,
    COUNT(*) AS transactions
FROM fact_transactions
GROUP BY mcc
ORDER BY transactions DESC
LIMIT 20;

-- Query 3
-- Highest Average Transaction Categories

SELECT
    mcc,
    COUNT(*) AS transactions,
    ROUND(AVG(amount),2) AS average_transaction
FROM fact_transactions
WHERE amount > 0
GROUP BY mcc
HAVING COUNT(*) >= 100
ORDER BY average_transaction DESC
LIMIT 20;

-- Query 4
-- Monthly Category Revenue

WITH top_categories AS
(
    SELECT
        mcc
    FROM fact_transactions
    WHERE amount > 0
    GROUP BY mcc
    ORDER BY SUM(amount) DESC
    LIMIT 10
)

SELECT
    DATE_TRUNC('month', ft.txn_date) AS month,
    ft.mcc,
    ROUND(SUM(ft.amount),2) AS revenue
FROM fact_transactions ft
JOIN top_categories tc
    ON ft.mcc = tc.mcc
WHERE ft.amount > 0
GROUP BY month, ft.mcc
ORDER BY month, revenue DESC;

-- Query 5
-- Category Revenue Contribution

WITH category_sales AS
(
SELECT
    mcc,
    SUM(amount) AS revenue
FROM fact_transactions
WHERE amount > 0
GROUP BY mcc
)

SELECT
    mcc,
    ROUND(revenue,2) AS revenue,
    ROUND(
        revenue * 100 /
        NULLIF(SUM(revenue) OVER(), 0),
        2
    ) AS revenue_percent
FROM category_sales
ORDER BY revenue DESC;

-- Query 6
-- Yearly Category Performance

SELECT
    EXTRACT(YEAR FROM txn_date) AS year,
    mcc,
    ROUND(SUM(amount),2) AS revenue,
    COUNT(*) AS transactions
FROM fact_transactions
WHERE amount > 0
GROUP BY year, mcc
ORDER BY year, mcc;

-- Query 7
-- Top 10 Categories by Revenue

SELECT
    mcc,
    ROUND(SUM(amount),2) AS revenue
FROM fact_transactions
WHERE amount > 0
GROUP BY mcc
ORDER BY revenue DESC
LIMIT 10;
