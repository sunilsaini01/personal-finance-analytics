-- ============================================
-- Cleaning: Currency Fields
-- Personal Finance Analytics
--
-- Staging tables keep monetary columns as TEXT
-- (e.g. "$29278", "$-77.00") so the raw COPY never
-- fails on formatting. These views cast those columns
-- to NUMERIC(12,2) ahead of the dimension/fact load,
-- so sql/03_load/*.sql selects already-typed amounts
-- instead of repeating the cast inline.
-- ============================================

DROP VIEW IF EXISTS vw_stg_transactions_clean;
DROP VIEW IF EXISTS vw_stg_cards_clean;
DROP VIEW IF EXISTS vw_stg_users_clean;

-- ============================================
-- Clean: Users
-- per_capita_income, yearly_income, total_debt: "$29278" -> 29278.00
-- ============================================

CREATE VIEW vw_stg_users_clean AS
SELECT
    id,
    current_age,
    retirement_age,
    birth_year,
    birth_month,
    gender,
    address,
    latitude,
    longitude,
    REPLACE(per_capita_income, '$', '')::NUMERIC(12,2) AS per_capita_income,
    REPLACE(yearly_income, '$', '')::NUMERIC(12,2)      AS yearly_income,
    REPLACE(total_debt, '$', '')::NUMERIC(12,2)         AS total_debt,
    credit_score,
    num_credit_cards
FROM stg_users;

-- ============================================
-- Clean: Cards
-- credit_limit: "$24295" -> 24295.00
-- ============================================

CREATE VIEW vw_stg_cards_clean AS
SELECT
    id,
    client_id,
    card_brand,
    card_type,
    card_number,
    expires,
    cvv,
    has_chip,
    num_cards_issued,
    REPLACE(credit_limit, '$', '')::NUMERIC(12,2) AS credit_limit,
    acct_open_date,
    year_pin_last_changed,
    card_on_dark_web
FROM stg_cards;

-- ============================================
-- Clean: Transactions
-- amount: "$-77.00" -> -77.00 (signed, so '$' alone isn't enough --
-- strip everything but digits, '.', and '-')
-- ============================================

CREATE VIEW vw_stg_transactions_clean AS
SELECT
    id,
    date,
    client_id,
    card_id,
    REGEXP_REPLACE(amount, '[^0-9.-]', '', 'g')::NUMERIC(12,2) AS amount,
    use_chip,
    merchant_id,
    merchant_city,
    merchant_state,
    zip,
    mcc,
    errors
FROM stg_transactions;
