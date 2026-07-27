-- Stored Procedures
-- Personal Finance Analytics
-- =====================================================

-- Procedure 1 : Refresh Statistics

CREATE OR REPLACE PROCEDURE sp_refresh_statistics()
LANGUAGE SQL
AS $$
    ANALYZE dim_users;
    ANALYZE dim_cards;
    ANALYZE dim_merchant;
    ANALYZE dim_mcc;
    ANALYZE fact_transactions;
$$;

-- Procedure 2 : Truncate Fact Table

CREATE OR REPLACE PROCEDURE sp_truncate_fact_transactions()
LANGUAGE SQL
AS $$
    TRUNCATE TABLE fact_transactions RESTART IDENTITY;
$$;

-- Procedure 3 : Show Database Summary

CREATE OR REPLACE PROCEDURE sp_database_summary()
LANGUAGE plpgsql
AS $$
DECLARE
    total_users BIGINT;
    total_cards BIGINT;
    total_merchants BIGINT;
    total_transactions BIGINT;
BEGIN

    SELECT COUNT(*) INTO total_users
    FROM dim_users;

    SELECT COUNT(*) INTO total_cards
    FROM dim_cards;

    SELECT COUNT(*) INTO total_merchants
    FROM dim_merchant;

    SELECT COUNT(*) INTO total_transactions
    FROM fact_transactions;

    RAISE NOTICE 'Users           : %', total_users;
    RAISE NOTICE 'Cards           : %', total_cards;
    RAISE NOTICE 'Merchants       : %', total_merchants;
    RAISE NOTICE 'Transactions    : %', total_transactions;

END;
$$;