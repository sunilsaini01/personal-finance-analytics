/*
Customer Segmentation Analysis
Business Goal:
Analyze customer spending behaviour and classify customers into business-friendly
segments using SQL aggregations.

Dataset:
- fact_transactions (governed warehouse table, not stg_transactions —
  amount is already typed NUMERIC, so no REPLACE/CAST parsing is needed)
- dim_users

Author: Sunil Kumar
===============================================================================
*/

SET search_path TO public;

-- 1. Customer Spending Summary

SELECT
    ft.user_id,
    COUNT(*) AS total_transactions,
    ROUND(SUM(ft.amount),2) AS total_spending,
    ROUND(AVG(ft.amount),2) AS average_transaction
FROM fact_transactions ft
WHERE ft.amount > 0
GROUP BY ft.user_id
ORDER BY total_spending DESC
LIMIT 20;

-- 2. Top 20 Highest Spending Customers

SELECT
    user_id,
    ROUND(SUM(amount),2) AS spending
FROM fact_transactions
WHERE amount > 0
GROUP BY user_id
ORDER BY spending DESC
LIMIT 20;

-- 3. Most Active Customers

SELECT
    user_id,
    COUNT(*) AS total_transactions
FROM fact_transactions
GROUP BY user_id
ORDER BY total_transactions DESC
LIMIT 20;

-- 4. Customer Segment based on Total Spending

WITH customer_spending AS
(
SELECT
    user_id,
    SUM(amount) AS spending
FROM fact_transactions
WHERE amount > 0
GROUP BY user_id
)

SELECT
    user_id,
    ROUND(spending,2) AS spending,

    CASE
        WHEN spending >= 400000 THEN 'Premium'
        WHEN spending >= 250000 THEN 'Gold'
        WHEN spending >= 150000 THEN 'Silver'
        ELSE 'Standard'
    END AS customer_segment

FROM customer_spending
ORDER BY spending DESC;

-- 5. Segment Distribution

WITH customer_spending AS
(
SELECT
    user_id,
    SUM(amount) AS spending
FROM fact_transactions
WHERE amount > 0
GROUP BY user_id
)

SELECT

CASE
    WHEN spending >= 400000 THEN 'Premium'
    WHEN spending >= 250000 THEN 'Gold'
    WHEN spending >= 150000 THEN 'Silver'
    ELSE 'Standard'
END AS customer_segment,

COUNT(*) AS customers

FROM customer_spending
GROUP BY customer_segment
ORDER BY customers DESC;

-- 6. Average Spending by Segment

WITH customer_spending AS
(
SELECT
    user_id,
    SUM(amount) AS spending
FROM fact_transactions
WHERE amount > 0
GROUP BY user_id
),

segments AS
(
SELECT
    user_id,
    spending,

    CASE
        WHEN spending >= 400000 THEN 'Premium'
        WHEN spending >= 250000 THEN 'Gold'
        WHEN spending >= 150000 THEN 'Silver'
        ELSE 'Standard'
    END AS segment

FROM customer_spending
)

SELECT

segment,

COUNT(*) AS customers,

ROUND(AVG(spending),2) AS average_spending,

ROUND(MAX(spending),2) AS highest_spending,

ROUND(MIN(spending),2) AS lowest_spending

FROM segments

GROUP BY segment

ORDER BY average_spending DESC;

-- 7. Monthly Spending of Top Customers

SELECT

DATE_TRUNC('month', txn_date)::DATE AS month,

user_id,

ROUND(SUM(amount),2) AS spending

FROM fact_transactions

WHERE amount > 0

GROUP BY month, user_id

ORDER BY spending DESC

LIMIT 50;

-- 8. Customers with Highest Average Transaction

SELECT

user_id,

COUNT(*) AS transactions,

ROUND(AVG(amount),2) AS average_transaction

FROM fact_transactions

WHERE amount > 0

GROUP BY user_id

HAVING COUNT(*) > 50

ORDER BY average_transaction DESC

LIMIT 20;
