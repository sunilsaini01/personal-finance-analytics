-- Function Tests
-- Personal Finance Analytics
-- =====================================================

-- Total Transactions

SELECT fn_total_transactions() AS total_transactions;

-- Total Transaction Amount

SELECT fn_total_transaction_amount() AS total_transaction_amount;

-- Average Transaction

SELECT fn_average_transaction() AS average_transaction;

-- User Spending

SELECT
    100 AS sample_user,
    fn_user_spending(100) AS total_spending;

SELECT
    500 AS sample_user,
    fn_user_spending(500) AS total_spending;

SELECT
    1000 AS sample_user,
    fn_user_spending(1000) AS total_spending;

-- Merchant Sales

SELECT
    27092 AS merchant_id,
    fn_merchant_sales(27092) AS merchant_sales;

SELECT
    3558 AS merchant_id,
    fn_merchant_sales(3558) AS merchant_sales;

-- Invalid Inputs

SELECT fn_user_spending(-1);

SELECT fn_merchant_sales(-1);