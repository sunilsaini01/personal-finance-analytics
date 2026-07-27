/*
MERCHANT ANALYSIS
Business Analytics Module
===========================================================

Business Questions:
1. Which merchants generate the highest revenue?
2. Which merchant locations process the most transactions?
3. Which merchant categories (MCC) generate the highest spending?
4. Which merchants have the highest average transaction value?
5. Merchant performance by state.

Source: fact_transactions joined to dim_merchant (governed warehouse
tables), not stg_transactions — amount is already typed NUMERIC here,
so no REPLACE/CAST parsing is needed in every query.
===========================================================
*/

-- 1. Top 20 Merchants by Revenue

SELECT
    dm.merchant_id,
    COUNT(*) AS total_transactions,
    ROUND(SUM(ft.amount),2) AS total_revenue,
    ROUND(AVG(ft.amount),2) AS avg_transaction
FROM fact_transactions ft
JOIN dim_merchant dm
    ON ft.merchant_key = dm.merchant_key
WHERE ft.amount > 0
GROUP BY dm.merchant_id
ORDER BY total_revenue DESC
LIMIT 20;



-- 2. Top Merchant Cities

SELECT
    dm.merchant_city,
    dm.merchant_state,
    COUNT(*) AS total_transactions,
    ROUND(SUM(ft.amount),2) AS total_sales
FROM fact_transactions ft
JOIN dim_merchant dm
    ON ft.merchant_key = dm.merchant_key
WHERE ft.amount > 0
GROUP BY dm.merchant_city, dm.merchant_state
ORDER BY total_sales DESC
LIMIT 20;



-- 3. Top Merchant Categories (MCC)

SELECT
    ft.mcc,
    COUNT(*) AS transactions,
    ROUND(SUM(ft.amount),2) AS revenue,
    ROUND(AVG(ft.amount),2) AS avg_transaction
FROM fact_transactions ft
WHERE ft.amount > 0
GROUP BY ft.mcc
ORDER BY revenue DESC
LIMIT 20;



-- 4. Merchants with Highest Average Transaction Value

SELECT
    dm.merchant_id,
    COUNT(*) AS transactions,
    ROUND(AVG(ft.amount),2) AS avg_transaction_value
FROM fact_transactions ft
JOIN dim_merchant dm
    ON ft.merchant_key = dm.merchant_key
WHERE ft.amount > 0
GROUP BY dm.merchant_id
HAVING COUNT(*) >= 100
ORDER BY avg_transaction_value DESC
LIMIT 20;



-- 5. Merchant Performance by State

SELECT
    dm.merchant_state,
    COUNT(*) AS transactions,
    ROUND(SUM(ft.amount),2) AS revenue,
    ROUND(AVG(ft.amount),2) AS avg_transaction
FROM fact_transactions ft
JOIN dim_merchant dm
    ON ft.merchant_key = dm.merchant_key
WHERE ft.amount > 0
GROUP BY dm.merchant_state
ORDER BY revenue DESC;
