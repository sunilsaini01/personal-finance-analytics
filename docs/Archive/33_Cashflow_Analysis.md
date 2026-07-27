# Cash Flow Analysis

---

# Objective

Cash flow is one of the most important financial health indicators for any business.

Unlike revenue or expenses alone, cash flow shows whether the business is actually generating more money than it spends over time.

This document analyzes:

- Monthly Cash Flow
- Yearly Cash Flow
- Cash Flow Trends
- Month-over-Month Growth
- Year-over-Year Growth
- Rolling Cash Flow
- Cash Flow Volatility
- Running Cash Flow
- Best Performing Months
- Worst Performing Months
- Executive Cash Flow KPIs

---

# Dataset

Database

finance_analytics

Primary Table

fact_transactions

Measures

- Income
- Expense
- Net Cash Flow

Date Dimension

txn_date

---

# Business Formula

Net Cash Flow

Net Cash Flow = Income − Expense

Positive Cash Flow

Income > Expense

Negative Cash Flow

Expense > Income

Cash Flow Margin

(Net Cash Flow / Income) × 100

---

# Analysis 1
## Monthly Cash Flow

### Business Question

How much net cash flow is generated every month?

### Business Purpose

Finance teams monitor monthly cash flow to understand whether the company consistently generates more money than it spends.

Monthly cash flow also helps identify seasonal business patterns and supports budgeting decisions.

### SQL Logic

The query:

- Groups transactions by month
- Separates income and expenses
- Calculates monthly net cash flow

### Observation

The business generated positive cash flow every month.

Examples:

| Month | Net Cash Flow |
|--------|---------------:|
| Jan 2010 | 3.716 Million |
| Jul 2013 | 4.242 Million |
| Mar 2017 | 4.266 Million |

Monthly cash flow gradually increased throughout the years.

### Business Insight

The organization demonstrates excellent financial stability because monthly income consistently exceeds monthly expenses.

---

# Analysis 2
## Month-over-Month Cash Flow Growth

### Business Question

How did cash flow change compared to the previous month?

### Business Purpose

Business leaders monitor month-over-month growth to detect sudden increases or decreases in financial performance.

### SQL Concepts Used

- LAG()
- Window Functions

### Metrics

- Previous Month Cash Flow
- Cash Flow Change
- Growth Percentage

### Sample Observation

| Month | Growth |
|--------|--------:|
| Feb 2010 | -6.49% |
| Mar 2010 | +10.63% |
| Jul 2010 | +2.82% |

### Business Insight

Cash flow fluctuates naturally from month to month, but overall the business maintains a positive long-term growth trend.

---

# Analysis 3
## Highest Monthly Cash Flow

### Business Question

Which months generated the highest cash flow?

### Business Purpose

Identifying peak-performing months helps management understand seasonal business performance.

### Top Months

| Rank | Month | Net Cash Flow |
|------:|--------|--------------:|
| 1 | Mar 2017 | 4.266 Million |
| 2 | Jul 2017 | 4.259 Million |
| 3 | May 2017 | 4.253 Million |
| 4 | Jul 2016 | 4.250 Million |
| 5 | Jul 2018 | 4.247 Million |

### Business Insight

2017 contributed multiple months within the Top-10 list, indicating exceptionally strong business performance during that year.

---

# Analysis 4
## Lowest Monthly Cash Flow

### Business Question

Which months generated the lowest cash flow?

### Bottom Months

| Rank | Month | Net Cash Flow |
|------:|--------|--------------:|
| 1 | Feb 2010 | 3.474 Million |
| 2 | Feb 2011 | 3.554 Million |
| 3 | Feb 2012 | 3.697 Million |
| 4 | Jan 2010 | 3.716 Million |
| 5 | Feb 2013 | 3.727 Million |

### Business Insight

February appears repeatedly among the lowest cash flow months, suggesting a recurring seasonal trend that may require further investigation.