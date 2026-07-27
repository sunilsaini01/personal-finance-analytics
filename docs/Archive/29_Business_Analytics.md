#  Business Analytics

## Overview

Business Analytics transforms raw transactional data into meaningful insights that support strategic and operational decision-making. Rather than simply storing financial transactions, this phase focuses on understanding customer behavior, spending patterns, income trends, savings performance, and financial health through SQL-based analytical queries.

The analytics layer is built on the dimensional warehouse created in previous phases, enabling efficient reporting using fact and dimension tables. All analyses are designed using PostgreSQL and follow real-world business reporting practices.

The primary objectives of this phase are to:

- Analyze income and expense trends
- Measure customer savings performance
- Identify major spending categories
- Detect high-value transactions
- Understand temporal spending behavior
- Produce KPIs suitable for executive dashboards
- Demonstrate advanced SQL analytical capabilities

---

# Business Analytics Roadmap

The business analytics phase consists of four major analyses:

| Analysis | Purpose |
|----------|---------|
| Income Analysis | Understand income trends over time |
| Expense Analysis | Analyze customer spending behavior |
| Savings Analysis | Measure savings and savings rate |
| Executive KPI Analysis | Generate dashboard-ready business metrics |

Each analysis is implemented using production-style SQL queries and includes business interpretation rather than only numerical outputs.

---

# Data Sources

The analytics queries use the dimensional warehouse created during previous phases.

### Fact Table

- `fact_transactions`

### Dimension Tables

- `dim_users`
- `dim_cards`
- `dim_merchant`
- `dim_mcc`

The star schema allows analytical queries to execute efficiently while keeping SQL readable and scalable.

---

# Business Metrics

Throughout this project, the following KPIs are calculated:

- Total Income
- Total Expenses
- Net Savings
- Savings Rate
- Monthly Income Trend
- Monthly Expense Trend
- Monthly Savings Trend
- Category-wise Spending
- Merchant-wise Spending
- Weekend vs Weekday Expenses
- Highest Expense Transactions
- Executive Dashboard KPIs

These KPIs represent common financial indicators used in banking, fintech, and personal finance applications.

---

# SQL Techniques Demonstrated

This section demonstrates a wide range of PostgreSQL analytical features.

### Aggregation Functions

- SUM()
- COUNT()
- AVG()
- MIN()
- MAX()

### Date Functions

- DATE_TRUNC()
- EXTRACT()

### Conditional Logic

- CASE
- CASE WHEN

### Mathematical Functions

- ROUND()
- ABS()

### Advanced SQL

- Common Table Expressions (CTEs)
- GROUP BY
- ORDER BY
- HAVING
- JOINs
- Conditional Aggregation
- NULLIF()

These SQL techniques are widely used in real-world analytical reporting systems.

---

# Income Analysis

## Business Objective

Income analysis measures how much money flows into the system over time. Understanding income trends enables financial organizations to monitor growth, identify seasonal changes, and evaluate long-term financial stability.

Rather than examining individual transactions, this analysis aggregates income monthly to reveal macro-level financial trends.

---

## Business Questions

The analysis answers several important questions:

- How much income is generated each month?
- Is income increasing over time?
- Are there seasonal variations?
- Which months generate the highest income?
- Is the income trend stable?

---

## Tables Used

- fact_transactions

Income transactions are identified using positive transaction amounts.

---

## Business Logic

Income is defined as every transaction where:

```sql
amount > 0
```

Monthly totals are generated using:

```sql
DATE_TRUNC('month', txn_date)
```

Income is aggregated using:

```sql
SUM(amount)
```

The result provides one row per month representing total monthly income.

---

## Business Interpretation

Monthly income provides an overall picture of financial inflows.

A consistent increase in monthly income generally indicates healthy customer activity and economic growth, while unexpected decreases may signal reduced transaction volume or changing customer behavior.

Monitoring income trends also enables budgeting, forecasting, and executive reporting.

---

## Business Value

Income analysis supports:

- Revenue monitoring
- Executive reporting
- Financial forecasting
- Budget planning
- Trend analysis
- Dashboard visualization

---

# Expense Analysis

## Business Objective

Expense analysis focuses on understanding how customers spend their money across different time periods, merchant locations, and spending categories. Unlike income analysis, which measures financial inflow, expense analysis identifies where money is being spent and highlights behavioral patterns that can support budgeting, financial planning, fraud detection, and customer segmentation.

The primary objective is to transform raw debit transactions into actionable business insights.

---

## Business Questions

This analysis answers several important business questions:

- How much money is spent each month?
- Which merchant categories receive the highest spending?
- Which merchant locations generate the highest expenses?
- How does spending change over time?
- Are weekends associated with higher spending?
- Which transactions represent unusually large expenses?
- What spending patterns can be observed across the dataset?

---

## Tables Used

### Fact Table

- `fact_transactions`

### Dimension Tables

- `dim_mcc`
- `dim_merchant`

---

## Business Logic

Expenses are defined as all transactions where the transaction amount is negative.

```sql
amount < 0
```

Since expense values are stored as negative numbers, the analysis uses the `ABS()` function to convert them into positive monetary values for reporting purposes.

Example:

```sql
ABS(amount)
```

This ensures that reports display actual spending amounts rather than negative values.

---

# Analysis 1 – Monthly Expense Trend

## Objective

Measure how customer expenses change over time by aggregating spending at the monthly level.

The analysis groups transactions using:

```sql
DATE_TRUNC('month', txn_date)
```

and computes:

- Expense transaction count
- Total monthly expense
- Average transaction amount

---

## Business Insight

The monthly expense trend reveals that customer spending remains remarkably stable throughout the observation period.

Example observations from the project:

- Monthly expenses generally range between **₹460K and ₹555K**.
- Average expense per transaction remains close to **₹95–102**.
- No abnormal spikes or sudden declines were observed.
- Spending follows a predictable long-term pattern, indicating stable customer behavior.

Such consistency is valuable for forecasting and budgeting models.

---

# Analysis 2 – Expense by Merchant Category

## Objective

Determine which merchant categories contribute the most to overall customer spending.

The analysis joins:

```text
fact_transactions
        ↓
dim_mcc
```

to retrieve human-readable merchant category descriptions.

The total expense is calculated using:

```sql
SUM(ABS(amount))
```

---

## Business Insight

The analysis shows that spending is concentrated within a relatively small number of merchant categories.

Top spending categories include:

| Category | Total Expense |
|-----------|--------------:|
| Miscellaneous Food Stores | ₹21.64 Million |
| Service Stations | ₹21.56 Million |
| Passenger Railways | ₹1.36 Million |
| Gardening Supplies | ₹1.35 Million |
| Ship Chandlers | ₹1.34 Million |

These categories dominate overall customer expenditure.

The results suggest that food-related purchases and transportation expenses represent the largest share of customer spending.

---

# Analysis 3 – Expense by Merchant Location

## Objective

Identify cities generating the highest transaction expenses.

This analysis joins:

```text
fact_transactions
        ↓
dim_merchant
```

allowing aggregation by:

- Merchant City
- Merchant State

---

## Business Insight

Several cities contribute significantly more spending than others.

Top merchant locations include:

| City | State | Total Expense |
|------|-------|--------------:|
| Las Vegas | NV | ₹1.52 Million |
| Oakland | CA | ₹1.45 Million |
| Waianae | HI | ₹1.36 Million |
| Lincoln Park | MI | ₹1.33 Million |
| Houston | TX | ₹0.90 Million |

These locations represent high customer activity and could be prioritized for regional marketing campaigns or merchant partnerships.

---

# Analysis 4 – Daily Expense Trend

## Objective

Measure daily spending to identify recurring spending behavior.

Daily aggregation is performed using:

```sql
DATE(txn_date)
```

This enables visualization of short-term fluctuations.

---

## Business Insight

Daily expenses fluctuate naturally while maintaining an overall stable trend.

The absence of extreme daily spikes indicates:

- Normal customer purchasing behavior
- Consistent transaction volume
- No evidence of major anomalous spending periods

Daily reporting is useful for operational monitoring and anomaly detection.

---

# Analysis 5 – Weekly Expense Trend

## Objective

Aggregate expenses on a weekly basis.

Weekly grouping uses:

```sql
DATE_TRUNC('week', txn_date)
```

---

## Business Insight

Weekly spending generally ranges between **₹105K and ₹130K**.

Weekly aggregation smooths out daily fluctuations and provides a clearer picture of customer spending cycles.

Such reports are commonly used in executive dashboards.

---

# Analysis 6 – Weekday vs Weekend Spending

## Objective

Compare customer spending between weekdays and weekends.

The analysis classifies each transaction using:

```sql
CASE
WHEN EXTRACT(DOW FROM txn_date) IN (0,6)
THEN 'Weekend'
ELSE 'Weekday'
END
```

---

## Business Insight

Project results show:

| Day Type | Transactions | Total Expense |
|-----------|-------------:|--------------:|
| Weekday | 459,502 | ₹45.04 Million |
| Weekend | 183,055 | ₹18.03 Million |

Approximately **72%** of expense transactions occur during weekdays.

This behavior is expected because most routine purchases—including groceries, fuel, transportation, and work-related expenses—occur during the working week.

---

# Analysis 7 – Highest Expense Transactions

## Objective

Identify unusually large expense transactions.

The analysis sorts transactions by:

```sql
ABS(amount)
```

in descending order.

---

## Business Insight

The largest expense transactions in the dataset are consistently **₹500**, indicating that this value likely represents the maximum permitted expense transaction in the source dataset.

These reports help analysts:

- detect unusually large purchases,
- investigate potential fraud,
- identify high-value customers,
- monitor transaction limits.

---

# Business Value Delivered

The Expense Analysis provides valuable business intelligence by:

- Measuring customer spending behavior over time.
- Identifying the largest spending categories.
- Highlighting high-revenue merchant locations.
- Comparing weekday and weekend purchasing patterns.
- Detecting high-value expense transactions.
- Producing dashboard-ready KPIs for business reporting.

These insights support budgeting, financial planning, customer segmentation, merchant analysis, and executive decision-making.

---

# Key SQL Concepts Demonstrated

| SQL Concept | Used |
|-------------|------|
| INNER JOIN | ✅ |
| GROUP BY | ✅ |
| ORDER BY | ✅ |
| SUM() | ✅ |
| AVG() | ✅ |
| COUNT() | ✅ |
| ABS() | ✅ |
| DATE_TRUNC() | ✅ |
| EXTRACT() | ✅ |
| CASE WHEN | ✅ |
| LIMIT | ✅ |
| Aggregation | ✅ |


---

# Income vs Expense Analysis

## Business Objective

Income and expense analysis provides a comprehensive view of overall financial performance by comparing money flowing into the system with money flowing out. Rather than analyzing income and expenses independently, this analysis combines both metrics to evaluate financial health and identify overall cash flow trends.

This type of analysis is commonly used in banking, personal finance applications, accounting systems, and executive financial dashboards.

---

## Business Questions

This analysis answers several important business questions:

- How much income is generated each month?
- How much money is spent each month?
- Is income consistently higher than expenses?
- Which months produce the highest net cash flow?
- Are there any months with negative financial performance?
- How stable is the overall financial trend?

---

## Tables Used

### Fact Table

- `fact_transactions`

No dimension tables are required because both income and expense values are stored within the transaction fact table.

---

## Business Logic

Income and expenses are separated using conditional aggregation.

Income is defined as:

```sql
amount > 0
```

Expense is defined as:

```sql
amount < 0
```

Monthly aggregation is performed using:

```sql
DATE_TRUNC('month', txn_date)
```

Income and expense are calculated separately using conditional `SUM()` expressions.

Example:

```sql
SUM(
    CASE
        WHEN amount > 0 THEN amount
        ELSE 0
    END
)
```

```sql
SUM(
    CASE
        WHEN amount < 0 THEN ABS(amount)
        ELSE 0
    END
)
```

Net financial performance is then calculated as:

```sql
Income − Expense
```

---

# Analysis

Each monthly record contains:

- Total Income
- Total Expense
- Net Financial Position

This provides a complete picture of monthly financial activity.

---

## Business Interpretation

Comparing income against expenses is one of the most important financial performance indicators.

A positive difference indicates that more money entered the system than was spent during that month.

A negative difference would indicate overspending or declining financial health.

This analysis enables financial analysts to monitor long-term profitability and identify periods requiring additional investigation.

---

## Expected Business Insights

Based on the project dataset:

- Monthly income consistently exceeds monthly expenses.
- No month records a negative financial balance.
- Financial inflow remains highly stable throughout the observation period.
- Customer spending represents only a relatively small portion of total income.
- Overall financial performance remains healthy across all analyzed months.

These observations indicate a financially stable customer population within the dataset.

---

# Business Applications

Income versus expense analysis supports numerous business functions, including:

- Financial health monitoring
- Budget planning
- Executive reporting
- Cash flow analysis
- Personal finance dashboards
- Revenue forecasting
- Business performance tracking

Financial institutions frequently use this analysis to assess customer behavior and identify unusual financial trends.

---

# Dashboard KPIs

Typical dashboard metrics generated from this analysis include:

| KPI | Description |
|------|-------------|
| Total Monthly Income | Total inflow during the month |
| Total Monthly Expense | Total spending during the month |
| Net Cash Flow | Income minus expense |
| Monthly Financial Position | Positive or Negative |
| Income Growth | Month-over-month income trend |
| Expense Growth | Month-over-month expense trend |

These KPIs are commonly displayed in executive dashboards and financial reporting systems.

---

# Performance Considerations

The analysis benefits from indexing on the transaction date column.

Recommended indexes include:

```sql
CREATE INDEX idx_fact_txn_date
ON fact_transactions(txn_date);
```

For very large datasets, monthly summary tables or materialized views can significantly improve reporting performance.

---

# Common Beginner Mistakes

Several common mistakes should be avoided when implementing this analysis:

### Using raw negative expense values

Expenses should be converted using:

```sql
ABS(amount)
```

before aggregation.

---

### Mixing income and expense together

Income and expense should always be calculated separately using conditional aggregation.

---

### Forgetting monthly grouping

Without:

```sql
DATE_TRUNC('month', txn_date)
```

the query produces overall totals rather than monthly trends.

---

### Ignoring NULL values

Always ensure aggregate calculations correctly handle missing values and avoid unintended NULL results.

---

# Business Value Delivered

This analysis provides a complete financial overview by combining income and expenses into a single report.

Business stakeholders can quickly determine:

- Financial stability
- Monthly cash flow
- Spending efficiency
- Revenue performance
- Budget effectiveness
- Long-term financial trends

It serves as the foundation for savings analysis, profitability analysis, and executive dashboard reporting.

---

# Key SQL Concepts Demonstrated

| SQL Concept | Used |
|-------------|------|
| CASE WHEN | ✅ |
| Conditional Aggregation | ✅ |
| SUM() | ✅ |
| ABS() | ✅ |
| DATE_TRUNC() | ✅ |
| GROUP BY | ✅ |
| ORDER BY | ✅ |
| Arithmetic Expressions | ✅ |
| Aggregate Functions | ✅ |
| Financial KPI Calculation | ✅ |

---

# Savings Analysis

## Business Objective

Savings analysis measures how much money remains after expenses are deducted from income. It is one of the most important financial performance indicators because it reflects overall financial health, spending efficiency, and long-term financial sustainability.

While income analysis measures earnings and expense analysis measures spending, savings analysis combines both to evaluate how effectively money is retained over time.

This type of analysis is widely used in personal finance applications, banking dashboards, investment platforms, and financial planning systems.

---

## Business Questions

This analysis answers several important questions:

- How much money is saved each month?
- How does the savings amount change over time?
- What percentage of monthly income is retained as savings?
- Is the savings rate stable?
- Which months have the highest savings?
- Does spending significantly affect savings performance?

---

## Tables Used

### Fact Table

- `fact_transactions`

No additional dimension tables are required because income and expenses are derived directly from transaction records.

---

## Business Logic

Monthly income is calculated using:

```sql
SUM(
    CASE
        WHEN amount > 0 THEN amount
        ELSE 0
    END
)
```

Monthly expense is calculated using:

```sql
SUM(
    CASE
        WHEN amount < 0 THEN ABS(amount)
        ELSE 0
    END
)
```

Monthly savings are calculated as:

```sql
Savings = Income − Expense
```

Savings rate is calculated using:

```sql
Savings Rate (%) =
(Savings / Income) × 100
```

Monthly aggregation is performed using:

```sql
DATE_TRUNC('month', txn_date)
```

---

# Analysis 1 – Monthly Savings

## Objective

Measure the total amount of money retained after deducting expenses from income each month.

The report includes:

- Total Income
- Total Expense
- Total Savings

---

## Business Insight

The project results show consistently strong savings across all months.

Example observations:

| Month | Savings |
|--------|---------:|
| Jan 2010 | ₹3.72 Million |
| Feb 2010 | ₹3.47 Million |
| Mar 2010 | ₹3.84 Million |
| Jul 2011 | ₹4.01 Million |
| Oct 2012 | ₹4.14 Million |
| Dec 2015 | ₹4.22 Million |

Monthly savings remain relatively stable throughout the dataset, indicating healthy financial behavior.

No month records negative savings.

---

# Analysis 2 – Savings Rate

## Objective

Evaluate savings efficiency by calculating the percentage of income retained after expenses.

Formula:

```text
Savings Rate (%) =
Savings ÷ Income × 100
```

---

## Business Insight

The calculated savings rate remains remarkably stable throughout the entire dataset.

Observed values range between approximately:

- **87.7%**
- **89.0%**

Example results:

| Month | Savings Rate |
|--------|-------------:|
| Jan 2010 | 88.10% |
| Dec 2010 | 88.90% |
| Aug 2012 | 88.18% |
| Jan 2013 | 88.96% |
| Dec 2014 | 88.94% |
| Jan 2016 | 88.65% |

The consistently high savings rate indicates that customer expenses represent only a small portion of total income.

This suggests strong financial stability across the analyzed population.

---

# Financial Interpretation

The relationship between income, expenses, and savings demonstrates a healthy financial profile.

Throughout the analysis:

- Income consistently exceeds expenses.
- Savings remain positive every month.
- Savings rate remains close to 88%.
- No evidence of overspending is observed.
- Monthly financial performance remains highly consistent.

These trends indicate predictable customer behavior and strong long-term financial stability.

---

# Business Applications

Savings analysis supports a wide range of financial use cases:

- Personal finance management
- Banking dashboards
- Wealth management
- Budget planning
- Financial health scoring
- Customer segmentation
- Investment planning
- Executive financial reporting

Financial institutions frequently use savings metrics to identify financially responsible customers and evaluate long-term customer value.

---

# Dashboard KPIs

Typical executive dashboard metrics include:

| KPI | Description |
|------|-------------|
| Monthly Income | Total income received |
| Monthly Expense | Total spending |
| Monthly Savings | Remaining amount after expenses |
| Savings Rate | Percentage of income retained |
| Highest Savings Month | Month with maximum savings |
| Lowest Savings Month | Month with minimum savings |

---

# Performance Considerations

The analysis performs efficiently because:

- Monthly aggregation uses indexed transaction dates.
- Conditional aggregation processes income and expenses in a single query.
- Only one scan of the transaction table is required.

For larger datasets, monthly summary tables or materialized views can further improve dashboard performance.

---

# Common Beginner Mistakes

### Forgetting ABS()

Expenses are stored as negative values.

Always use:

```sql
ABS(amount)
```

before calculating total expenses.

---

### Dividing by Expense Instead of Income

Savings rate should always be calculated as:

```text
Savings ÷ Income
```

not

```text
Savings ÷ Expense
```

---

### Mixing Income and Expense

Income and expenses should always be separated using conditional aggregation.

---

### Ignoring Zero Income

When calculating savings rate, ensure income is never zero to avoid division errors.

---

# Business Value Delivered

Savings analysis provides one of the strongest indicators of financial health.

This report enables businesses to:

- Measure financial stability
- Evaluate spending efficiency
- Track customer savings behavior
- Monitor long-term financial trends
- Build financial wellness dashboards
- Support budgeting and investment planning

The analysis transforms raw transaction data into meaningful financial insights that can support both operational and strategic decision-making.

---

# Key SQL Concepts Demonstrated

| SQL Concept | Used |
|-------------|------|
| CASE WHEN | ✅ |
| Conditional Aggregation | ✅ |
| SUM() | ✅ |
| ABS() | ✅ |
| DATE_TRUNC() | ✅ |
| GROUP BY | ✅ |
| Arithmetic Expressions | ✅ |
| Financial KPI Calculation | ✅ |
| Percentage Calculation | ✅ |
| Business Reporting | ✅ |

---

# Executive Summary & Key Business Insights

## Overview

This chapter analyzed financial transactions from multiple business perspectives to understand customer income, spending behavior, cash flow, and savings performance. By combining transaction-level data with SQL-based business analytics, the project transformed millions of raw records into meaningful financial insights.

The analyses demonstrate how SQL can be used not only for querying data but also for solving real-world business problems through KPI generation, trend analysis, and financial reporting.

---

# Overall Findings

The business analytics performed in this chapter reveal several important observations about customer financial behavior.

### Income Analysis

- Monthly income remained highly consistent throughout the observation period.
- Income gradually increased over time without major fluctuations.
- No significant decline in monthly earnings was observed.
- Positive transactions represented the majority of financial activity.

Overall, the customer population demonstrated a stable and predictable income pattern.

---

### Expense Analysis

Expense analysis showed that customer spending was concentrated within a few major merchant categories.

The highest spending categories included:

- Miscellaneous Food Stores
- Service Stations
- Passenger Railways
- Gardening Supplies
- Lodging and Hotels

Merchant location analysis further revealed that cities such as **Las Vegas**, **Oakland**, and **Houston** generated the highest expense volumes.

Daily and weekly analyses indicated relatively stable spending patterns without abnormal spikes, while weekday spending significantly exceeded weekend spending.

---

### Income vs Expense Analysis

Comparing monthly income and expenses provided a comprehensive picture of financial health.

The analysis demonstrated that:

- Monthly income consistently exceeded expenses.
- Positive cash flow was maintained throughout the entire dataset.
- No months recorded a negative financial balance.
- Financial performance remained stable over multiple years.

This indicates a financially healthy customer base.

---

### Savings Analysis

Savings analysis highlighted one of the strongest indicators of financial stability.

The project showed that:

- Monthly savings consistently exceeded ₹3.5 million.
- Savings remained positive throughout the observation period.
- Savings rates remained close to **88%** across nearly every month.
- Customer spending represented only a relatively small percentage of total income.

The consistency of these metrics suggests disciplined spending behavior and strong financial sustainability.

---

# Business Impact

The insights generated in this chapter can support several business functions, including:

- Executive financial reporting
- Customer spending analysis
- Budget planning
- Cash flow monitoring
- Financial health assessment
- Merchant performance evaluation
- Customer segmentation
- Business intelligence dashboard development

Organizations can use these analyses to monitor financial trends, identify changes in customer behavior, and support strategic decision-making.

---

# SQL Skills Demonstrated

This chapter demonstrates the practical application of SQL for business analytics.

The following SQL concepts were applied throughout the analyses:

| SQL Feature | Purpose |
|-------------|---------|
| SELECT | Retrieve business data |
| WHERE | Filter income and expense transactions |
| CASE WHEN | Conditional business logic |
| GROUP BY | Aggregate financial metrics |
| ORDER BY | Rank business results |
| SUM() | Calculate totals |
| AVG() | Compute average transaction values |
| COUNT() | Measure transaction volume |
| ABS() | Convert expense values for reporting |
| DATE_TRUNC() | Monthly and weekly trend analysis |
| EXTRACT() | Weekday and weekend analysis |
| INNER JOIN | Combine fact and dimension tables |
| Aggregate Functions | Generate KPIs |
| Financial Calculations | Income, Expense, Savings, Savings Rate |

These techniques form the foundation of business reporting in modern data analytics projects.

---

# Key Performance Indicators (KPIs)

The following KPIs were successfully generated during the analysis:

| KPI | Description |
|------|-------------|
| Monthly Income | Total monthly earnings |
| Monthly Expense | Total monthly spending |
| Monthly Savings | Income minus expenses |
| Savings Rate | Percentage of income retained |
| Average Expense | Mean expense transaction value |
| Expense Transaction Count | Total debit transactions |
| Income Transaction Count | Total credit transactions |
| Top Merchant Categories | Highest spending categories |
| Top Merchant Locations | Highest expense-generating cities |
| Daily Expense Trend | Day-wise spending |
| Weekly Expense Trend | Week-wise spending |
| Weekday vs Weekend Spending | Spending pattern comparison |
| Highest Expense Transactions | Largest debit transactions |

These KPIs are commonly used in financial dashboards, banking analytics, and executive reporting systems.

---

# Learning Outcomes

Through this chapter, the following analytical skills were developed:

- Converting raw transaction data into business insights.
- Building financial KPIs using SQL.
- Performing time-series analysis.
- Applying conditional aggregation for financial reporting.
- Using dimensional modeling for analytical queries.
- Combining multiple tables through joins.
- Producing dashboard-ready reports.
- Translating SQL results into business recommendations.

These skills are directly applicable to roles such as:

- Data Analyst
- Business Analyst
- Financial Analyst
- BI Developer
- SQL Developer
- Analytics Engineer

---

# Conclusion

This Business Analytics chapter demonstrates how SQL can be used to transform large-scale financial transaction data into meaningful business intelligence.

Starting from raw transaction records, the project successfully generated insights into income, expenses, savings, customer spending behavior, merchant performance, and overall financial health. By applying aggregation, conditional logic, joins, and time-based analysis, the project produced business-ready reports that closely resemble those used in real-world banking and financial analytics environments.

The analyses developed in this chapter provide a strong foundation for dashboard development, business intelligence reporting, predictive analytics, and advanced financial modeling. They also showcase practical SQL skills that are highly relevant for modern data analytics and business intelligence roles.

---

# Chapter Summary

In this chapter, the following analyses were completed:

- ✅ Income Analysis
- ✅ Expense Analysis
- ✅ Income vs Expense Analysis
- ✅ Savings Analysis
- ✅ Executive Business Summary

Together, these analyses transformed millions of financial transactions into actionable insights, demonstrating the complete workflow of SQL-based business analytics from raw data to executive-level reporting.

---