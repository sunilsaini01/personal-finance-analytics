-- View Tests
-- Personal Finance Analytics
-- =====================================================

-- Transaction Summary View

SELECT COUNT(*) AS transaction_summary_rows
FROM vw_transaction_summary;

-- Daily Summary View

SELECT COUNT(*) AS daily_summary_rows
FROM vw_daily_transaction_summary;

-- Monthly Summary View

SELECT COUNT(*) AS monthly_summary_rows
FROM vw_monthly_transaction_summary;

-- Merchant Performance View

SELECT COUNT(*) AS merchant_performance_rows
FROM vw_merchant_performance;

-- Card Performance View

SELECT COUNT(*) AS card_performance_rows
FROM vw_card_performance;

-- Transaction Errors View

SELECT COUNT(*) AS transaction_error_rows
FROM vw_transaction_errors;

-- Sample Data Validation

SELECT *
FROM vw_transaction_summary
LIMIT 5;

SELECT *
FROM vw_daily_transaction_summary
LIMIT 5;

SELECT *
FROM vw_monthly_transaction_summary
LIMIT 5;

SELECT *
FROM vw_merchant_performance
ORDER BY total_sales DESC
LIMIT 5;

SELECT *
FROM vw_card_performance;

SELECT *
FROM vw_transaction_errors
ORDER BY total_transactions DESC;