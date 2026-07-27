# Merchant Analysis

## Objective

Merchant Analysis evaluates merchant performance across the transaction ecosystem.

The objective is to identify:

- Highest revenue generating merchants
- Highest transaction volume merchants
- Best performing merchant locations
- Revenue by Merchant Category Code (MCC)
- High-value merchants
- Geographic merchant distribution

This analysis helps businesses understand where customers spend money and which merchants generate the highest business value.

---

# Business Questions

The analysis answers the following questions:

1. Which merchants generate the highest revenue?
2. Which merchants process the highest number of transactions?
3. Which merchant categories earn the highest revenue?
4. Which cities contribute the most merchant sales?
5. Which states generate maximum merchant revenue?
6. Which merchants have the highest average transaction value?

---

# SQL File

```
sql/10_business_analytics/06_merchant_analysis.sql
```

---

# Analysis Performed

## 1. Top Revenue Generating Merchants

Measures:

- Merchant ID
- Number of Transactions
- Total Revenue
- Average Transaction Value

Business Purpose:

Identifies the merchants contributing the highest overall revenue.

---

## 2. Top Merchant Cities

Measures:

- Merchant City
- Merchant State
- Transaction Count
- Total Sales

Business Purpose:

Shows geographical concentration of customer spending.

Useful for:

- Regional expansion
- Local marketing
- Merchant partnerships

---

## 3. Merchant Category (MCC) Analysis

Measures:

- MCC Code
- Number of Transactions
- Total Revenue
- Average Transaction Value

Business Purpose:

Determines which business sectors generate maximum customer spending.

---

## 4. Highest Average Transaction Merchants

Measures:

- Merchant ID
- Transaction Count
- Average Transaction Value

Business Purpose:

Identifies premium merchants where customers spend significantly more per transaction.

---

## 5. Merchant Performance by State

Measures:

- Merchant State
- Transactions
- Revenue
- Average Transaction

Business Purpose:

Compares merchant performance across different states.

Useful for regional business strategy.

---

# Business Insights

### Merchant Revenue

A small number of merchants contribute a significant portion of overall revenue.

This follows the Pareto Principle (80/20 rule), where relatively few merchants drive a large share of business.

---

### Geographic Performance

Major metropolitan cities generate substantially higher merchant sales than smaller regions.

Cities with high transaction activity indicate stronger customer purchasing behavior.

---

### Merchant Categories

Certain Merchant Category Codes consistently generate both:

- High transaction volumes
- High revenue

These categories represent the strongest business verticals.

---

### Premium Merchants

Several merchants process fewer transactions but maintain exceptionally high average transaction values.

These merchants contribute disproportionately to overall revenue.

---

### State Performance

Merchant revenue varies significantly across states.

Highly populated states generally contribute larger transaction volumes and higher sales.

---

# Business Value

Merchant Analysis supports:

- Merchant performance evaluation
- Revenue optimization
- Geographic expansion planning
- Customer spending analysis
- Business partnership decisions
- Merchant segmentation

---

# Files Used

```
sql/10_business_analytics/06_merchant_analysis.sql
```

---

# Output Tables

The SQL file generates the following analyses:

1. Top Revenue Merchants

2. Top Merchant Cities

3. Merchant Category Analysis (MCC)

4. Highest Average Transaction Merchants

5. Merchant Revenue by State

---

# Conclusion

Merchant Analysis provides a comprehensive understanding of where customers spend their money and which merchants contribute most to the overall business.

The analysis enables data-driven decisions regarding merchant partnerships, regional expansion, marketing strategy, and revenue optimization.