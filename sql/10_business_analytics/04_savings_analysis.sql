/*
Spend & Refund Analysis
Project : Personal Finance Analytics & Budget Intelligence
Database: PostgreSQL
=========================================================

Business Objective:
Analyze net card spend behavior over time.

Note on framing: this dataset is credit-card transaction
data with no salary/income stream, so there is no "savings
rate" to compute (income = 0 for every user, which the
project's own business rule says must never be silently
coerced into a misleading percentage). Instead this module
reports total spend, total refunds, and the resulting net
spend/refund ratio, which is the analysis this dataset can
actually support.

Topics Covered:
1. Monthly Spend & Refunds
2. Refund Rate
3. Running Net Spend
4. Highest Spend Month
5. Lowest Spend Month
6. Surplus vs Deficit (Refund-Heavy) Months
7. Spend Trend
8. Moving Average
9. Executive Spend Summary

=========================================================
*/


/*
Monthly Spend & Refunds
Business Question:
How much is spent and refunded every month, net of returns?
*/

SELECT
    DATE_TRUNC('month', txn_date) AS month,

    SUM(
        CASE
            WHEN amount > 0 THEN amount
            ELSE 0
        END
    ) AS total_spend,

    ABS(
        SUM(
            CASE
                WHEN amount < 0 THEN amount
                ELSE 0
            END
        )
    ) AS total_refunds,

    SUM(
        CASE
            WHEN amount > 0 THEN amount
            ELSE 0
        END
    )
    -
    ABS(
        SUM(
            CASE
                WHEN amount < 0 THEN amount
                ELSE 0
            END
        )
    ) AS net_spend

FROM fact_transactions

GROUP BY DATE_TRUNC('month', txn_date)

ORDER BY month;

/*
Monthly Refund Rate
Business Question:
What percentage of monthly spend comes back as refunds?
*/

WITH monthly_financials AS (

    SELECT
        DATE_TRUNC('month', txn_date) AS month,

        SUM(
            CASE
                WHEN amount > 0 THEN amount
                ELSE 0
            END
        ) AS total_spend,

        ABS(
            SUM(
                CASE
                    WHEN amount < 0 THEN amount
                    ELSE 0
                END
            )
        ) AS total_refunds

    FROM fact_transactions

    GROUP BY DATE_TRUNC('month', txn_date)

)

SELECT

    month,

    total_spend,

    total_refunds,

    total_spend - total_refunds AS net_spend,

    ROUND(
        (
            total_refunds
            / NULLIF(total_spend,0)
        ) * 100,
        2
    ) AS refund_rate_percent

FROM monthly_financials

ORDER BY month;
