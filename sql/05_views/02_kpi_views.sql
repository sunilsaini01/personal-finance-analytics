-- =====================================================
-- KPI Views
-- Personal Finance Analytics & Budget Intelligence System
-- =====================================================

----------------------------------------------------------
-- Drop Existing Views
----------------------------------------------------------

DROP VIEW IF EXISTS vw_daily_transaction_summary;
DROP VIEW IF EXISTS vw_monthly_transaction_summary;
DROP VIEW IF EXISTS vw_merchant_performance;
DROP VIEW IF EXISTS vw_card_performance;
DROP VIEW IF EXISTS vw_transaction_errors;

----------------------------------------------------------
-- Daily Transaction Summary
----------------------------------------------------------

CREATE VIEW vw_daily_transaction_summary AS

SELECT

    DATE(txn_date) AS transaction_date,

    COUNT(*) AS total_transactions,

    SUM(amount) AS total_amount,

    AVG(amount) AS average_transaction,

    MIN(amount) AS minimum_transaction,

    MAX(amount) AS maximum_transaction

FROM fact_transactions

GROUP BY DATE(txn_date);

----------------------------------------------------------
-- Monthly Transaction Summary
----------------------------------------------------------

CREATE VIEW vw_monthly_transaction_summary AS

SELECT

    DATE_TRUNC('month', txn_date)::DATE AS month,

    COUNT(*) AS total_transactions,

    SUM(amount) AS total_amount,

    AVG(amount) AS average_transaction,

    MIN(amount) AS minimum_transaction,

    MAX(amount) AS maximum_transaction

FROM fact_transactions

GROUP BY DATE_TRUNC('month', txn_date);

----------------------------------------------------------
-- Merchant Performance
----------------------------------------------------------

CREATE VIEW vw_merchant_performance AS

SELECT

    dm.merchant_id,

    dm.merchant_city,

    dm.merchant_state,

    COUNT(*) AS total_transactions,

    SUM(ft.amount) AS total_sales,

    AVG(ft.amount) AS average_transaction

FROM fact_transactions ft

JOIN dim_merchant dm
ON ft.merchant_key = dm.merchant_key

GROUP BY

    dm.merchant_id,
    dm.merchant_city,
    dm.merchant_state;

----------------------------------------------------------
-- Card Performance
----------------------------------------------------------

CREATE VIEW vw_card_performance AS

SELECT

    dc.card_brand,

    dc.card_type,

    COUNT(*) AS total_transactions,

    SUM(ft.amount) AS total_amount,

    AVG(ft.amount) AS average_transaction

FROM fact_transactions ft

JOIN dim_cards dc
ON ft.card_id = dc.card_id

GROUP BY

    dc.card_brand,
    dc.card_type;

----------------------------------------------------------
-- Transaction Errors
----------------------------------------------------------

CREATE VIEW vw_transaction_errors AS

SELECT

    COALESCE(errors,'No Error') AS error_type,

    COUNT(*) AS total_transactions,

    ROUND(
        COUNT(*) * 100.0 /
        SUM(COUNT(*)) OVER (),
        2
    ) AS percentage

FROM fact_transactions

GROUP BY errors;