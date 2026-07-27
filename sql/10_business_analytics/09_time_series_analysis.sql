/*
09. TIME SERIES ANALYSIS
Business Objective:
Analyze transaction trends over time to identify
seasonality, business growth, monthly patterns,
and long-term revenue movement.

Source: fact_transactions (governed warehouse table), not
stg_transactions — amount is already typed NUMERIC.
==============================================================*/


/*
1. Monthly Revenue Trend
-*/

SELECT
    DATE_TRUNC('month', txn_date) AS month,
    ROUND(SUM(amount),2) AS revenue,
    COUNT(*) AS transactions
FROM fact_transactions
GROUP BY month
ORDER BY month;



/*
2. Monthly Revenue Growth
*/

WITH monthly_revenue AS
(
    SELECT
        DATE_TRUNC('month', txn_date) AS month,
        SUM(amount) AS revenue
    FROM fact_transactions
    GROUP BY month
)

SELECT
    month,
    ROUND(revenue,2) AS revenue,
    ROUND(
        LAG(revenue) OVER(ORDER BY month),2
    ) AS previous_month,
    ROUND(
        revenue -
        LAG(revenue) OVER(ORDER BY month),2
    ) AS revenue_change,
    ROUND(
        (
            revenue -
            LAG(revenue) OVER(ORDER BY month)
        )/
        NULLIF(ABS(LAG(revenue) OVER(ORDER BY month)),0)
        *100,
        2
    ) AS growth_percent
FROM monthly_revenue
ORDER BY month;



/*
3. Yearly Revenue Trend
*/

SELECT
    EXTRACT(YEAR FROM txn_date) AS year,
    ROUND(SUM(amount),2) AS revenue,
    COUNT(*) AS transactions
FROM fact_transactions
GROUP BY year
ORDER BY year;



/*
4. Running Revenue
*/

WITH monthly_revenue AS
(
    SELECT
        DATE_TRUNC('month', txn_date) AS month,
        SUM(amount) AS revenue
    FROM fact_transactions
    GROUP BY month
)

SELECT
    month,
    ROUND(revenue,2) AS revenue,
    ROUND(
        SUM(revenue)
        OVER(
            ORDER BY month
        ),
        2
    ) AS cumulative_revenue
FROM monthly_revenue
ORDER BY month;



/*
5. Rolling 3-Month Revenue
*/

WITH monthly_revenue AS
(
    SELECT
        DATE_TRUNC('month', txn_date) AS month,
        SUM(amount) AS revenue
    FROM fact_transactions
    GROUP BY month
)

SELECT
    month,
    ROUND(revenue,2) AS revenue,
    ROUND(
        AVG(revenue)
        OVER(
            ORDER BY month
            ROWS BETWEEN 2 PRECEDING
            AND CURRENT ROW
        ),
        2
    ) AS rolling_average
FROM monthly_revenue
ORDER BY month;



/*
6. Highest Revenue Months
*/

SELECT
    DATE_TRUNC('month', txn_date) AS month,
    ROUND(
        SUM(amount),
        2
    ) AS revenue
FROM fact_transactions
GROUP BY month
ORDER BY revenue DESC
LIMIT 10;



/*
7. Lowest Revenue Months
*/

SELECT
    DATE_TRUNC('month', txn_date) AS month,
    ROUND(
        SUM(amount),
        2
    ) AS revenue
FROM fact_transactions
GROUP BY month
ORDER BY revenue
LIMIT 10;



/*
8. Average Monthly Revenue Per Year
*/

WITH monthly_revenue AS
(
    SELECT
        EXTRACT(YEAR FROM txn_date) AS year,
        DATE_TRUNC('month', txn_date) AS month,
        SUM(amount) AS revenue
    FROM fact_transactions
    GROUP BY year, month
)

SELECT
    year,
    ROUND(AVG(revenue),2) AS average_monthly_revenue,
    ROUND(MIN(revenue),2) AS minimum_month,
    ROUND(MAX(revenue),2) AS maximum_month
FROM monthly_revenue
GROUP BY year
ORDER BY year;
