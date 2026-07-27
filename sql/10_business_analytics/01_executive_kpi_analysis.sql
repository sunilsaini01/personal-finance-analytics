/*
Executive KPI Analysis
Project : Personal Finance Analytics & Budget Intelligence
Business Analytics
Author  : Sunil Kumar
===========================================================

Business Goal:
Provide top-level KPIs required by executives for dashboard reporting.
*/

-- KPI 1 : Total Transactions

SELECT
    COUNT(*) AS total_transactions
FROM fact_transactions;


-- KPI 2 : Total Transaction Amount

SELECT
    ROUND(SUM(amount),2) AS total_transaction_amount
FROM fact_transactions;


-- KPI 3 : Average Transaction Value

SELECT
    ROUND(AVG(amount),2) AS average_transaction_value
FROM fact_transactions;


-- KPI 4 : Active Users

SELECT
    COUNT(DISTINCT user_id) AS active_users
FROM fact_transactions;


-- KPI 5 : Total Users

SELECT
    COUNT(*) AS total_users
FROM dim_users;


-- KPI 6 : Total Cards

SELECT
    COUNT(*) AS total_cards
FROM dim_cards;


-- KPI 7 : Total Merchants

SELECT
    COUNT(*) AS total_merchants
FROM dim_merchant;


-- KPI 8 : Total Merchant Categories

SELECT
    COUNT(*) AS total_categories
FROM dim_mcc;


-- KPI 9 : Minimum Transaction

SELECT
    MIN(amount) AS minimum_transaction
FROM fact_transactions;


-- KPI 10 : Maximum Transaction

SELECT
    MAX(amount) AS maximum_transaction
FROM fact_transactions;