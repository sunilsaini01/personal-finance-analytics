-- Security Roles
-- Personal Finance Analytics
-- ============================================

-- Remove Roles (if they exist)

DROP ROLE IF EXISTS analyst_role;
DROP ROLE IF EXISTS readonly_role;
DROP ROLE IF EXISTS admin_role;

-- Create Roles

CREATE ROLE admin_role;

CREATE ROLE analyst_role;

CREATE ROLE readonly_role;

-- Admin Permissions

GRANT ALL PRIVILEGES
ON ALL TABLES IN SCHEMA public
TO admin_role;

GRANT ALL PRIVILEGES
ON ALL SEQUENCES IN SCHEMA public
TO admin_role;

-- Analyst Permissions

GRANT SELECT, INSERT, UPDATE

ON ALL TABLES IN SCHEMA public

TO analyst_role;

-- Read Only

GRANT SELECT

ON ALL TABLES IN SCHEMA public

TO readonly_role;