-- View: Transaction Summary
-- Project: Personal Finance Analytics
-- ============================================

DROP VIEW IF EXISTS vw_transaction_summary;

CREATE VIEW vw_transaction_summary AS

SELECT

    ft.transaction_id,
    ft.txn_date,

    du.user_id,
    du.gender,
    du.current_age,

    dc.card_brand,
    dc.card_type,

    dm.merchant_id,
    dm.merchant_city,
    dm.merchant_state,

    mcc.description AS merchant_category,

    ft.amount,
    ft.use_chip,
    ft.errors

FROM fact_transactions ft

LEFT JOIN dim_users du
       ON ft.user_id = du.user_id

LEFT JOIN dim_cards dc
       ON ft.card_id = dc.card_id

LEFT JOIN dim_merchant dm
       ON ft.merchant_key = dm.merchant_key

LEFT JOIN dim_mcc mcc
       ON ft.mcc = mcc.mcc;