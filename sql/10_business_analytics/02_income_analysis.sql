/*
TRANSACTION VOLUME ANALYSIS
(originally scoped as "Income Analysis" — renamed because this
dataset is credit-card transaction data with no salary/income
stream; SUM(amount) here is total net transaction value, i.e.
spend minus refunds, not income. See 03_expense_analysis.sql
and 04_savings_analysis.sql for the spend/refund breakdown.)

Business Questions

1. How much money flows through the system every month?
2. Which months generated the highest transaction value?
3. What is the month-over-month growth?
4. What is the running cumulative transaction amount?
5. Which year had the highest transaction value?
6. What is the average monthly transaction amount?

=========================================================
*/

/*
Monthly Transaction Amount
---------------------------------------------------------
Business Question:
How much transaction value occurs every month?
---------------------------------------------------------
*/

SELECT
    DATE_TRUNC('month', txn_date)::date AS month,
    COUNT(*) AS total_transactions,
    ROUND(SUM(amount),2) AS total_amount,
    ROUND(AVG(amount),2) AS average_transaction
FROM fact_transactions
GROUP BY month
ORDER BY month;

/*
Yearly Transaction Analysis
*/

SELECT
    EXTRACT(YEAR FROM txn_date) AS year,
    COUNT(*) AS total_transactions,
    ROUND(SUM(amount),2) AS total_amount,
    ROUND(AVG(amount),2) AS average_transaction
FROM fact_transactions
GROUP BY year
ORDER BY year;

/*
Highest Transaction Month
*/

SELECT
    DATE_TRUNC('month', txn_date)::date AS month,
    ROUND(SUM(amount),2) AS total_amount
FROM fact_transactions
GROUP BY month
ORDER BY total_amount DESC
LIMIT 10;

/*
Running Monthly Transaction Amount
*/

WITH monthly_income AS
(
    SELECT
        DATE_TRUNC('month', txn_date)::date AS month,
        SUM(amount) AS total_amount
    FROM fact_transactions
    GROUP BY month
)

SELECT
    month,
    ROUND(total_amount,2) AS monthly_amount,

    ROUND(
        SUM(total_amount)
        OVER(ORDER BY month),
    2) AS running_total

FROM monthly_income
ORDER BY month;

/*
Month-over-Month Growth
*/

WITH monthly_income AS
(
    SELECT
        DATE_TRUNC('month', txn_date)::date AS month,
        SUM(amount) AS total_amount
    FROM fact_transactions
    GROUP BY month
)

SELECT
    month,

    ROUND(total_amount,2) AS total_amount,

    ROUND(
        LAG(total_amount)
        OVER(ORDER BY month),
    2) AS previous_month,

    ROUND(
        total_amount
        -
        LAG(total_amount)
        OVER(ORDER BY month),
    2) AS growth_amount

FROM monthly_income
ORDER BY month;

/*
Average Monthly Transaction Value
*/

WITH monthly_income AS
(
    SELECT
        DATE_TRUNC('month', txn_date)::date AS month,
        SUM(amount) AS total_amount
    FROM fact_transactions
    GROUP BY month
)

SELECT
    ROUND(AVG(total_amount),2) AS average_monthly_amount
FROM monthly_income;