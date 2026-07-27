-- Load Fact Table
-- Personal Finance Analytics
-- ============================================

-- Load fact_transactions

INSERT INTO fact_transactions (
    transaction_id,
    txn_date,
    user_id,
    card_id,
    merchant_key,
    mcc,
    amount,
    use_chip,
    errors
)
SELECT
    t.id,
    t.date,
    t.client_id,
    t.card_id,
    dm.merchant_key,
    t.mcc,
    t.amount,
    t.use_chip,
    t.errors
FROM vw_stg_transactions_clean t
JOIN dim_merchant dm
    ON t.merchant_id = dm.merchant_id
   AND t.merchant_city IS NOT DISTINCT FROM dm.merchant_city
   AND t.merchant_state IS NOT DISTINCT FROM dm.merchant_state
   AND t.zip IS NOT DISTINCT FROM dm.zip;

-- ============================================
-- Validation
-- ============================================

SELECT COUNT(*) AS fact_transaction_count
FROM fact_transactions;

-- Row-count reconciliation: fact load must not silently drop staging rows
-- (a plain equality join on merchant_city/state/zip previously dropped every
-- online transaction, where state/zip are NULL, because NULL = NULL is not TRUE)
SELECT
    (SELECT COUNT(*) FROM stg_transactions)  AS staging_row_count,
    (SELECT COUNT(*) FROM fact_transactions) AS fact_row_count,
    (SELECT COUNT(*) FROM stg_transactions) - (SELECT COUNT(*) FROM fact_transactions) AS dropped_rows;

SELECT
    MIN(amount) AS minimum_amount,
    MAX(amount) AS maximum_amount
FROM fact_transactions;

SELECT
    COUNT(*) AS orphan_users
FROM fact_transactions ft
LEFT JOIN dim_users du
ON ft.user_id = du.user_id
WHERE du.user_id IS NULL;

SELECT
    COUNT(*) AS orphan_cards
FROM fact_transactions ft
LEFT JOIN dim_cards dc
ON ft.card_id = dc.card_id
WHERE dc.card_id IS NULL;

SELECT
    COUNT(*) AS orphan_merchants
FROM fact_transactions ft
LEFT JOIN dim_merchant dm
ON ft.merchant_key = dm.merchant_key
WHERE dm.merchant_key IS NULL;

SELECT
    COUNT(*) AS orphan_mcc
FROM fact_transactions ft
LEFT JOIN dim_mcc m
ON ft.mcc = m.mcc
WHERE m.mcc IS NULL;