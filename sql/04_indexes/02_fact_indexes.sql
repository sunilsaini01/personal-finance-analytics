-- ============================================
-- Fact Table Performance Indexes
-- ============================================

CREATE INDEX IF NOT EXISTS idx_fact_txn_date
ON fact_transactions(txn_date);

CREATE INDEX IF NOT EXISTS idx_fact_user
ON fact_transactions(user_id);

CREATE INDEX IF NOT EXISTS idx_fact_card
ON fact_transactions(card_id);

CREATE INDEX IF NOT EXISTS idx_fact_merchant
ON fact_transactions(merchant_key);

CREATE INDEX IF NOT EXISTS idx_fact_mcc
ON fact_transactions(mcc);

CREATE INDEX IF NOT EXISTS idx_fact_amount
ON fact_transactions(amount);