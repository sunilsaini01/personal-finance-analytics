-- ============================================
-- Star Schema
-- Personal Finance Analytics
-- ============================================

DROP TABLE IF EXISTS fact_transactions CASCADE;
DROP TABLE IF EXISTS dim_merchant CASCADE;
DROP TABLE IF EXISTS dim_mcc CASCADE;
DROP TABLE IF EXISTS dim_cards CASCADE;
DROP TABLE IF EXISTS dim_users CASCADE;

-- ============================================
-- Dimension: Users
-- One row = One User
-- ============================================

CREATE TABLE dim_users (
    user_id             INTEGER PRIMARY KEY,
    current_age         INTEGER,
    retirement_age      INTEGER,
    birth_year          INTEGER,
    birth_month         INTEGER,
    gender              TEXT,
    address             TEXT,
    latitude            NUMERIC(9,6),
    longitude           NUMERIC(9,6),
    per_capita_income   NUMERIC(12,2),
    yearly_income       NUMERIC(12,2),
    total_debt          NUMERIC(12,2),
    credit_score        INTEGER,
    num_credit_cards    INTEGER
);

-- ============================================
-- Dimension: Cards
-- One row = One Card
-- ============================================

DROP TABLE IF EXISTS dim_cards CASCADE;

CREATE TABLE dim_cards (
    card_id                 INTEGER PRIMARY KEY,
    user_id                 INTEGER NOT NULL REFERENCES dim_users(user_id),
    card_brand              TEXT,
    card_type               TEXT,
    card_number_masked      TEXT,
    expires                 TEXT,
    has_chip                BOOLEAN,
    num_cards_issued        INTEGER,
    credit_limit            NUMERIC(12,2),
    acct_open_date          DATE,
    year_pin_last_changed   INTEGER
);



-- ============================================
-- Dimension: MCC Codes
-- One row = One Merchant Category Code
-- ============================================

DROP TABLE IF EXISTS dim_mcc CASCADE;

CREATE TABLE dim_mcc (
    mcc         TEXT PRIMARY KEY,
    description TEXT NOT NULL
);

-- ============================================
-- Dimension: Merchant
-- One row = One Merchant Location
-- ============================================

DROP TABLE IF EXISTS dim_merchant CASCADE;

CREATE TABLE dim_merchant (

    merchant_key SERIAL PRIMARY KEY,

    merchant_id BIGINT NOT NULL,

    merchant_city TEXT,

    merchant_state TEXT,

    zip TEXT

);


-- ============================================
-- FACT TABLE: Transactions
-- One row = One Transaction
-- ============================================

DROP TABLE IF EXISTS fact_transactions CASCADE;
CREATE TABLE fact_transactions (

    transaction_id BIGINT PRIMARY KEY,

    txn_date TIMESTAMP NOT NULL,

    user_id INTEGER NOT NULL
        REFERENCES dim_users(user_id),

    card_id INTEGER NOT NULL
        REFERENCES dim_cards(card_id),

    merchant_key INTEGER
        REFERENCES dim_merchant(merchant_key),

    mcc TEXT
        REFERENCES dim_mcc(mcc),

    amount NUMERIC(12,2) NOT NULL,

    use_chip TEXT,

    errors TEXT

);

