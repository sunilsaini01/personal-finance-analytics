-- Table Tests
-- Personal Finance Analytics
-- =====================================================

-- Row Counts

SELECT 'dim_users' AS table_name, COUNT(*) AS row_count
FROM dim_users

UNION ALL

SELECT 'dim_cards', COUNT(*)
FROM dim_cards

UNION ALL

SELECT 'dim_merchant', COUNT(*)
FROM dim_merchant

UNION ALL

SELECT 'dim_mcc', COUNT(*)
FROM dim_mcc

UNION ALL

SELECT 'fact_transactions', COUNT(*)
FROM fact_transactions;

-- Duplicate Primary Keys

SELECT user_id, COUNT(*)
FROM dim_users
GROUP BY user_id
HAVING COUNT(*) > 1;

SELECT card_id, COUNT(*)
FROM dim_cards
GROUP BY card_id
HAVING COUNT(*) > 1;

SELECT merchant_key, COUNT(*)
FROM dim_merchant
GROUP BY merchant_key
HAVING COUNT(*) > 1;

SELECT transaction_id, COUNT(*)
FROM fact_transactions
GROUP BY transaction_id
HAVING COUNT(*) > 1;


-- Orphan Records

SELECT COUNT(*) AS orphan_users
FROM fact_transactions ft
LEFT JOIN dim_users du
ON ft.user_id = du.user_id
WHERE du.user_id IS NULL;

SELECT COUNT(*) AS orphan_cards
FROM fact_transactions ft
LEFT JOIN dim_cards dc
ON ft.card_id = dc.card_id
WHERE dc.card_id IS NULL;

SELECT COUNT(*) AS orphan_merchants
FROM fact_transactions ft
LEFT JOIN dim_merchant dm
ON ft.merchant_key = dm.merchant_key
WHERE dm.merchant_key IS NULL;

SELECT COUNT(*) AS orphan_mcc
FROM fact_transactions ft
LEFT JOIN dim_mcc mc
ON ft.mcc = mc.mcc
WHERE mc.mcc IS NULL;