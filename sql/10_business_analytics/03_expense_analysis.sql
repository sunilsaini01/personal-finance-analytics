/*
Expense Analysis
Project : Personal Finance Analytics & Budget Intelligence
Database: PostgreSQL
==========================================================

Business Goal
-------------
Understand customer spending behavior,
expense distribution,
merchant dependence,
category trends,
and overall spending patterns.

Note on framing: in this credit-card dataset a positive
amount is a purchase (expense/spend) and a negative amount
is a refund/reversal (~5% of rows). Every query below
filters on amount > 0 for that reason — filtering on
amount < 0 would analyze refunds, not spend.

Author : Sunil Kumar
==========================================================
*/

-- Monthly Expense Trend

SELECT
    DATE_TRUNC('month', txn_date) AS month,
    COUNT(*) AS expense_transactions,
    SUM(amount) AS total_expense,
    ROUND(AVG(amount),2) AS average_expense
FROM fact_transactions
WHERE amount > 0
GROUP BY month
ORDER BY month;

-- Category Wise Spending

SELECT
    m.description AS category,
    COUNT(*) AS transactions,
    SUM(f.amount) AS total_expense
FROM fact_transactions f
JOIN dim_mcc m
ON f.mcc = m.mcc
WHERE f.amount > 0
GROUP BY m.description
ORDER BY total_expense DESC;

-- Merchant Wise Spending

SELECT
    merchant_city,
    merchant_state,
    COUNT(*) AS transactions,
    SUM(amount) AS total_expense
FROM fact_transactions f
JOIN dim_merchant m
ON f.merchant_key = m.merchant_key
WHERE amount > 0
GROUP BY
merchant_city,
merchant_state
ORDER BY total_expense DESC
LIMIT 20;

-- Daily Spending Trend

SELECT
DATE(txn_date) AS day,
SUM(amount) AS expense
FROM fact_transactions
WHERE amount>0
GROUP BY day
ORDER BY day;

-- Weekly Spending Trend

SELECT
DATE_TRUNC('week',txn_date) AS week,
SUM(amount) AS expense
FROM fact_transactions
WHERE amount>0
GROUP BY week
ORDER BY week;

-- Weekend vs Weekday Spending

SELECT

CASE

WHEN EXTRACT(DOW FROM txn_date) IN (0,6)

THEN 'Weekend'

ELSE 'Weekday'

END AS day_type,

COUNT(*) transactions,

SUM(amount) expense

FROM fact_transactions

WHERE amount>0

GROUP BY day_type;


-- Highest Expense Transactions

SELECT

transaction_id,

txn_date,

user_id,

amount AS expense

FROM fact_transactions

WHERE amount>0

ORDER BY amount DESC

LIMIT 20;


-- Top Expense Categories

SELECT

m.description,

SUM(f.amount) expense

FROM fact_transactions f

JOIN dim_mcc m

ON f.mcc=m.mcc

WHERE amount>0

GROUP BY m.description

ORDER BY expense DESC

LIMIT 10;
