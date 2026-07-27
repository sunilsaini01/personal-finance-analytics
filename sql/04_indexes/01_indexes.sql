-- ============================================
-- Performance Indexes
-- Personal Finance Analytics
-- ============================================

-- Users
CREATE INDEX IF NOT EXISTS idx_dim_users_user_id
ON dim_users(user_id);

-- Cards
CREATE INDEX IF NOT EXISTS idx_dim_cards_card_id
ON dim_cards(card_id);

CREATE INDEX IF NOT EXISTS idx_dim_cards_user_id
ON dim_cards(user_id);

-- Merchant Lookup
CREATE INDEX IF NOT EXISTS idx_dim_merchant_lookup
ON dim_merchant (
    merchant_id,
    merchant_city,
    merchant_state,
    zip
);

-- MCC
CREATE INDEX IF NOT EXISTS idx_dim_mcc
ON dim_mcc(mcc);

-- Staging Transaction Lookup

CREATE INDEX IF NOT EXISTS idx_stg_transactions_lookup
ON stg_transactions (
    merchant_id,
    merchant_city,
    merchant_state,
    zip
);