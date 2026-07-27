-- Triggers
-- Personal Finance Analytics
-- =====================================================

-- Audit Table

DROP TABLE IF EXISTS audit_log;

CREATE TABLE audit_log (

    audit_id BIGSERIAL PRIMARY KEY,

    transaction_id BIGINT,

    action_type TEXT,

    action_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP

);

-- Trigger Function

CREATE OR REPLACE FUNCTION fn_transaction_audit()
RETURNS TRIGGER
LANGUAGE plpgsql
AS
$$
BEGIN

    INSERT INTO audit_log (
        transaction_id,
        action_type
    )
    VALUES (
        NEW.transaction_id,
        TG_OP
    );

    RETURN NEW;

END;
$$;

-- Trigger

DROP TRIGGER IF EXISTS trg_transaction_audit
ON fact_transactions;

CREATE TRIGGER trg_transaction_audit

AFTER INSERT

ON fact_transactions

FOR EACH ROW

EXECUTE FUNCTION fn_transaction_audit();