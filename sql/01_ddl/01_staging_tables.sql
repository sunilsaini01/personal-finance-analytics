-- ============================================
-- Staging Tables
-- Personal Finance Analytics
--
-- Raw load target for the source CSV files
-- (users_data.csv, cards_data.csv, transactions_data.csv).
-- Columns are kept as TEXT where the source has
-- formatting (e.g. "$1,234.56", "12/2022") that must
-- survive an unmodified COPY before Phase 6 cleaning
-- casts them into the typed star schema.
-- ============================================

DROP TABLE IF EXISTS stg_transactions;
DROP TABLE IF EXISTS stg_cards;
DROP TABLE IF EXISTS stg_users;

-- ============================================
-- Staging: Users
-- Source: users_data.csv
-- ============================================

CREATE TABLE stg_users (
    id                  INTEGER PRIMARY KEY,
    current_age         INTEGER,
    retirement_age      INTEGER,
    birth_year          INTEGER,
    birth_month         INTEGER,
    gender              TEXT,
    address             TEXT,
    latitude            NUMERIC(9,6),
    longitude           NUMERIC(9,6),
    per_capita_income   TEXT,
    yearly_income       TEXT,
    total_debt          TEXT,
    credit_score        INTEGER,
    num_credit_cards    INTEGER
);

-- ============================================
-- Staging: Cards
-- Source: cards_data.csv
-- ============================================

CREATE TABLE stg_cards (
    id                      INTEGER PRIMARY KEY,
    client_id               INTEGER NOT NULL,
    card_brand              TEXT,
    card_type               TEXT,
    card_number             TEXT,
    expires                 TEXT,
    cvv                     TEXT,
    has_chip                TEXT,
    num_cards_issued        INTEGER,
    credit_limit            TEXT,
    acct_open_date          TEXT,
    year_pin_last_changed   INTEGER,
    card_on_dark_web        TEXT
);

-- ============================================
-- Staging: Transactions
-- Source: transactions_data.csv
-- ============================================

CREATE TABLE stg_transactions (
    id              BIGINT PRIMARY KEY,
    date            TIMESTAMP NOT NULL,
    client_id       INTEGER NOT NULL,
    card_id         INTEGER NOT NULL,
    amount          TEXT NOT NULL,
    use_chip        TEXT,
    merchant_id     BIGINT NOT NULL,
    merchant_city   TEXT,
    merchant_state  TEXT,
    zip             TEXT,
    mcc             TEXT,
    errors          TEXT
);

-- ============================================
-- Load (run from psql, path relative to client)
-- ============================================

-- \copy stg_users FROM 'data/raw/users_data.csv' WITH (FORMAT csv, HEADER true);
-- \copy stg_cards FROM 'data/raw/cards_data.csv' WITH (FORMAT csv, HEADER true);
-- \copy stg_transactions FROM 'data/raw/transactions_data.csv' WITH (FORMAT csv, HEADER true);
