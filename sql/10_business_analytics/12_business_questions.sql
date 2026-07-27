/*
Business Questions Traceability
Project : Personal Finance Analytics & Budget Intelligence
==========================================================

The PRD requires every query in this project to trace back to
one of its Section 5 business questions — otherwise it's a
query dump, not an analytics product. This file is that
traceability map: each business question below either points
to the script that answers it, or is marked NOT ANSWERABLE
with the reason (this dataset is credit-card transaction data
only — no income, budgets, or linked-account balances exist to
answer the budgeting-specific questions the PRD originally
scoped for).

==========================================================
*/

-- Q: What is total income, total expenses, and net savings —
--    overall, and by month/quarter/year?
-- NOT ANSWERABLE — no income stream in this dataset.
-- Nearest equivalent: total spend / total refunds / net spend,
-- overall and by month/year -> 04_savings_analysis.sql,
-- 05_cashflow_analysis.sql

-- Q: What is the savings rate, and is it trending up or down?
-- NOT ANSWERABLE — savings rate requires income; see above.

-- Q: How does actual spend compare to budget, by category and
--    by user, and who is chronically overspending?
-- NOT ANSWERABLE — no fact_budgets / budget dimension exists yet.

-- Q: What does cash flow and running balance look like per
--    account, and are there structurally negative periods?
-- PARTIAL — net spend trend and structurally high-spend months:
-- 05_cashflow_analysis.sql. Per-account running balance is
-- NOT ANSWERABLE — no dim_accounts / account-level balance exists.

-- Q: Which categories and merchants drive the largest share of
--    spend, and how concentrated is that spend (80/20)?
-- ANSWERED -> 06_merchant_analysis.sql, 07_category_analysis.sql
-- (see the revenue_percent / contribution queries)

WITH category_spend AS (
    SELECT
        mcc,
        SUM(amount) AS total_spend
    FROM fact_transactions
    WHERE amount > 0
    GROUP BY mcc
)

SELECT
    mcc,
    ROUND(total_spend,2) AS total_spend,
    ROUND(
        SUM(total_spend) OVER (ORDER BY total_spend DESC)
        * 100.0 / NULLIF(SUM(total_spend) OVER (), 0),
        2
    ) AS cumulative_spend_percent
FROM category_spend
ORDER BY total_spend DESC
LIMIT 20;

-- Q: Is spending different on weekends vs. weekdays, and does
--    that vary by category?
-- ANSWERED -> 03_expense_analysis.sql ("Weekend vs Weekday Spending")

-- Q: Which expenses are recurring (subscriptions, EMIs, bills)
--    vs. discretionary, and what share of the budget do they consume?
-- NOT ANSWERABLE — no recurring-transaction flag has been built
-- (would require a merchant + amount(+/-5%) + 3-of-4-months rule),
-- and no budget to compute a "share of budget" against.

-- Q: What is each user's financial health score, and what
--    factors drive it up or down?
-- NOT ANSWERABLE — no financial health score has been built.

-- Q: How do users segment by behavior (saver / balanced /
--    overspender / volatile), and how large is each segment?
-- PARTIAL — 10_customer_segmentation.sql segments users by total
-- spend tier (Premium/Gold/Silver/Standard), not by savings-rate
-- or budget-adherence behavior, since neither exists in this dataset.

-- Q: Which payment methods and accounts are used most, and does
--    method correlate with overspending?
-- PARTIAL — payment-channel usage is answered in
-- 08_payment_analysis.sql. "Overspending" correlation is
-- NOT ANSWERABLE without a budget.

-- Q: What is month-over-month and year-over-year growth in
--    income and expenses?
-- ANSWERED (as spend, not income) -> 05_cashflow_analysis.sql,
-- 09_time_series_analysis.sql

-- Q: Directionally, what would next month's spend look like if
--    current trends continue (conceptual forecast, not
--    production ML)?
-- ANSWERED (moving average as the conceptual forecast proxy) ->
-- 05_cashflow_analysis.sql ("Rolling 3-Month Average Net Spend"),
-- 09_time_series_analysis.sql ("Rolling 3-Month Revenue")
