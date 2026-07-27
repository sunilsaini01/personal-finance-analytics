-- Financial Functions
-- Personal Finance Analytics
-- =====================================================

-- Average Transaction Amount

CREATE OR REPLACE FUNCTION fn_average_transaction()

RETURNS NUMERIC(12,2)

LANGUAGE SQL

AS
$$

SELECT ROUND(AVG(amount),2)

FROM fact_transactions;

$$;

-- Total Transaction Amount

CREATE OR REPLACE FUNCTION fn_total_transaction_amount()

RETURNS NUMERIC(15,2)

LANGUAGE SQL

AS
$$

SELECT ROUND(SUM(amount),2)

FROM fact_transactions;

$$;

-- Total Transactions

CREATE OR REPLACE FUNCTION fn_total_transactions()

RETURNS BIGINT

LANGUAGE SQL

AS
$$

SELECT COUNT(*)

FROM fact_transactions;

$$;

-- Merchant Sales

CREATE OR REPLACE FUNCTION fn_merchant_sales(
    p_merchant INTEGER
)

RETURNS NUMERIC(15,2)

LANGUAGE SQL

AS
$$

SELECT ROUND(SUM(ft.amount),2)

FROM fact_transactions ft

JOIN dim_merchant dm

ON ft.merchant_key = dm.merchant_key

WHERE dm.merchant_id = p_merchant;

$$;

-- User Spending

CREATE OR REPLACE FUNCTION fn_user_spending(
    p_user INTEGER
)

RETURNS NUMERIC(15,2)

LANGUAGE SQL

AS
$$

SELECT ROUND(SUM(amount),2)

FROM fact_transactions

WHERE user_id = p_user;

$$;