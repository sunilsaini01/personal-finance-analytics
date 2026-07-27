/*
Monthly Spend & Refund Summary
=====================================================
Business Question:
How much was spent, how much was refunded, and what
was the net card spend every month?

Note on framing: this dataset is credit-card transaction
data with no salary/income stream. A positive amount is a
purchase (spend); a negative amount is a refund/reversal
(~5% of rows). There is no "income" here, so these queries
report spend vs. refunds rather than income vs. expense.
=====================================================
*/

SELECT
    DATE_TRUNC('month', txn_date) AS month,

    ROUND(
        SUM(
            CASE
                WHEN amount > 0 THEN amount
                ELSE 0
            END
        ),
        2
    ) AS total_spend,

    ROUND(
        SUM(
            CASE
                WHEN amount < 0 THEN ABS(amount)
                ELSE 0
            END
        ),
        2
    ) AS total_refunds,

    ROUND(
        SUM(amount),
        2
    ) AS net_spend

FROM fact_transactions

GROUP BY month

ORDER BY month;

/*
Month-over-Month Net Spend Growth
=====================================================
Business Question:
How did the monthly net spend change
compared to the previous month?
=====================================================
*/

WITH monthly_spend AS (

    SELECT
        DATE_TRUNC('month', txn_date) AS month,

        ROUND(SUM(amount), 2) AS net_spend

    FROM fact_transactions

    GROUP BY DATE_TRUNC('month', txn_date)

)

SELECT

    month,

    net_spend,

    LAG(net_spend) OVER (
        ORDER BY month
    ) AS previous_month,

    ROUND(
        net_spend
        -
        LAG(net_spend) OVER (
            ORDER BY month
        ),
        2
    ) AS spend_change,

    ROUND(
        (
            (
                net_spend
                -
                LAG(net_spend) OVER (
                    ORDER BY month
                )
            )
            /
            NULLIF(
                ABS(LAG(net_spend) OVER (
                    ORDER BY month
                )),
                0
            )
        ) * 100,
        2
    ) AS growth_percent

FROM monthly_spend

ORDER BY month;

/*
Analysis 3 : Top 10 Months with Highest Net Spend
=====================================================
Business Question:
Which months generated the highest
net spend?
=====================================================
*/

WITH monthly_spend AS (

    SELECT
        DATE_TRUNC('month', txn_date) AS month,

        ROUND(SUM(amount),2) AS net_spend

    FROM fact_transactions

    GROUP BY DATE_TRUNC('month', txn_date)

)

SELECT

    month,

    net_spend,

    RANK() OVER(
        ORDER BY net_spend DESC
    ) AS spend_rank

FROM monthly_spend

ORDER BY net_spend DESC

LIMIT 10;

/*
Analysis 4 : Bottom 10 Months with Lowest Net Spend
=====================================================
Business Question:
Which months generated the lowest
net spend?
=====================================================
*/

WITH monthly_spend AS (

    SELECT
        DATE_TRUNC('month', txn_date) AS month,

        ROUND(SUM(amount), 2) AS net_spend

    FROM fact_transactions

    GROUP BY DATE_TRUNC('month', txn_date)

)

SELECT

    month,

    net_spend,

    RANK() OVER (
        ORDER BY net_spend ASC
    ) AS spend_rank

FROM monthly_spend

ORDER BY net_spend ASC

LIMIT 10;

/*
Analysis 5 : Yearly Spend & Refund Summary
=====================================================
Business Question:
How much was spent, refunded, and net spent
each year?
=====================================================
*/

SELECT

    EXTRACT(YEAR FROM txn_date) AS year,

    ROUND(
        SUM(
            CASE
                WHEN amount > 0 THEN amount
                ELSE 0
            END
        ),
        2
    ) AS total_spend,

    ROUND(
        SUM(
            CASE
                WHEN amount < 0 THEN ABS(amount)
                ELSE 0
            END
        ),
        2
    ) AS total_refunds,

    ROUND(
        SUM(amount),
        2
    ) AS net_spend,

    ROUND(
        (
            SUM(
                CASE
                    WHEN amount < 0 THEN ABS(amount)
                    ELSE 0
                END
            )
        )
        /
        NULLIF(
            SUM(
                CASE
                    WHEN amount > 0 THEN amount
                    ELSE 0
                END
            ),
            0
        ) * 100,
        2
    ) AS refund_rate_percent

FROM fact_transactions

GROUP BY EXTRACT(YEAR FROM txn_date)

ORDER BY year;

/*
Year-over-Year Net Spend Growth
=====================================================
Business Question:
How did net spend change
compared to the previous year?
=====================================================
*/

WITH yearly_spend AS (

    SELECT

        EXTRACT(YEAR FROM txn_date) AS year,

        ROUND(SUM(amount), 2) AS net_spend

    FROM fact_transactions

    GROUP BY EXTRACT(YEAR FROM txn_date)

)

SELECT

    year,

    net_spend,

    LAG(net_spend) OVER (
        ORDER BY year
    ) AS previous_year,

    ROUND(
        net_spend
        -
        LAG(net_spend) OVER (
            ORDER BY year
        ),
        2
    ) AS yearly_change,

    ROUND(
        (
            (
                net_spend
                -
                LAG(net_spend) OVER (
                    ORDER BY year
                )
            )
            /
            NULLIF(
                ABS(LAG(net_spend) OVER (
                    ORDER BY year
                )),
                0
            )
        ) * 100,
        2
    ) AS growth_percent

FROM yearly_spend

ORDER BY year;

/*
Analysis 7 : Cumulative Net Spend
=====================================================
Business Question:
How has cumulative net spend
grown over time?
=====================================================
*/

WITH monthly_spend AS (

    SELECT

        DATE_TRUNC('month', txn_date) AS month,

        ROUND(SUM(amount), 2) AS net_spend

    FROM fact_transactions

    GROUP BY DATE_TRUNC('month', txn_date)

)

SELECT

    month,

    net_spend,

    ROUND(
        SUM(net_spend) OVER (
            ORDER BY month
        ),
        2
    ) AS cumulative_spend

FROM monthly_spend

ORDER BY month;

/*
Best & Worst Net Spend Months
=====================================================
Business Question:
Which months recorded the highest
and the lowest net spend?
=====================================================
*/

WITH monthly_spend AS (

    SELECT

        DATE_TRUNC('month', txn_date) AS month,

        ROUND(SUM(amount), 2) AS net_spend

    FROM fact_transactions

    GROUP BY DATE_TRUNC('month', txn_date)

)

(

SELECT

    'Highest Net Spend' AS category,

    month,

    net_spend

FROM monthly_spend

ORDER BY net_spend DESC

LIMIT 10

)

UNION ALL

(

SELECT

    'Lowest Net Spend' AS category,

    month,

    net_spend

FROM monthly_spend

ORDER BY net_spend ASC

LIMIT 10

)

ORDER BY category DESC, net_spend DESC;

/*
Rolling 3-Month Average Net Spend
=====================================================
Business Question:
How is net spend trending when
using a 3-month moving average?
=====================================================
*/

WITH monthly_spend AS (

    SELECT

        DATE_TRUNC('month', txn_date) AS month,

        ROUND(SUM(amount), 2) AS net_spend

    FROM fact_transactions

    GROUP BY DATE_TRUNC('month', txn_date)

)

SELECT

    month,

    net_spend,

    ROUND(

        AVG(net_spend) OVER (

            ORDER BY month

            ROWS BETWEEN 2 PRECEDING
            AND CURRENT ROW

        ),

        2

    ) AS rolling_3_month_average

FROM monthly_spend

ORDER BY month;

/*
Net Spend Volatility
=====================================================
Business Question:
Which months experienced the largest
increase or decrease in net spend?
=====================================================
*/

WITH monthly_spend AS (

    SELECT
        DATE_TRUNC('month', txn_date) AS month,
        ROUND(SUM(amount),2) AS net_spend

    FROM fact_transactions

    GROUP BY DATE_TRUNC('month', txn_date)

),

spend_change AS (

    SELECT

        month,

        net_spend,

        LAG(net_spend) OVER(
            ORDER BY month
        ) AS previous_spend

    FROM monthly_spend

)

SELECT

    month,

    net_spend,

    previous_spend,

    ROUND(
        net_spend - previous_spend,
        2
    ) AS change_amount,

    ROUND(
        ABS(net_spend - previous_spend),
        2
    ) AS volatility

FROM spend_change

WHERE previous_spend IS NOT NULL

ORDER BY volatility DESC

LIMIT 20;

/*
Average Monthly Net Spend
=====================================================
Business Question:
Average monthly net spend by year
=====================================================
*/

WITH monthly_spend AS (

    SELECT

        DATE_TRUNC('month', txn_date) AS month,

        ROUND(SUM(amount),2) AS net_spend

    FROM fact_transactions

    GROUP BY DATE_TRUNC('month', txn_date)

)

SELECT

    EXTRACT(YEAR FROM month) AS year,

    ROUND(
        AVG(net_spend),
        2
    ) AS average_monthly_spend,

    MIN(net_spend) AS minimum_month,

    MAX(net_spend) AS maximum_month

FROM monthly_spend

GROUP BY EXTRACT(YEAR FROM month)

ORDER BY year;

/*
Executive Spend KPI Summary
=====================================================
Business Question:
Overall business spend KPIs
=====================================================
*/

SELECT

    ROUND(SUM(amount),2) AS total_net_spend,

    ROUND(AVG(amount),2) AS average_transaction,

    ROUND(MAX(amount),2) AS highest_transaction,

    ROUND(MIN(amount),2) AS lowest_transaction,

    COUNT(*) AS total_transactions,

    ROUND(

        SUM(amount) / COUNT(*),

        2

    ) AS average_spend_per_transaction

FROM fact_transactions;
