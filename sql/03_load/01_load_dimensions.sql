-- Load Dimension Tables
-- Personal Finance Analytics

-- Load dim_users

INSERT INTO dim_users (
    user_id,
    current_age,
    retirement_age,
    birth_year,
    birth_month,
    gender,
    address,
    latitude,
    longitude,
    per_capita_income,
    yearly_income,
    total_debt,
    credit_score,
    num_credit_cards
)
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
    per_capita_income,
    yearly_income,
    total_debt,
    credit_score,
    num_credit_cards
FROM vw_stg_users_clean;

-- Validation
SELECT COUNT(*) AS dim_users_count
FROM dim_users;

-- Load dim_cards

INSERT INTO dim_cards (
    card_id,
    user_id,
    card_brand,
    card_type,
    card_number_masked,
    expires,
    has_chip,
    num_cards_issued,
    credit_limit,
    acct_open_date,
    year_pin_last_changed
)
SELECT
    id,
    client_id,
    card_brand,
    card_type,
    'XXXX-XXXX-XXXX-' || RIGHT(card_number, 4),
    expires,
    (has_chip = 'YES'),
    num_cards_issued,
    credit_limit,
    TO_DATE(acct_open_date, 'MM/YYYY'),
    year_pin_last_changed
FROM vw_stg_cards_clean;

-- Validation
SELECT COUNT(*) AS dim_cards_count
FROM dim_cards;

-- Load dim_merchant

INSERT INTO dim_merchant (
    merchant_id,
    merchant_city,
    merchant_state,
    zip
)
SELECT DISTINCT
    merchant_id,
    merchant_city,
    merchant_state,
    zip
FROM stg_transactions;

-- Validation
SELECT COUNT(*) AS dim_merchant_count
FROM dim_merchant;