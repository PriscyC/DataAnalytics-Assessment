# DataAnalytics-Assessment

## Overview

This repository contains SQL solutions to the Cowrywise Data Analyst technical assessment. Each question focuses on real-world data problems, involving customer segmentation, transaction analysis, inactivity detection, and customer lifetime value estimation.

---

## Question 1: High-Value Customers with Multiple Products

**Approach:**

- Joined `users_customuser`, `plans_plan` and `savings_savingsaccount` tables.
- Filtered customers with at least one savings plan (`is_regular_savings = 1`) and one investment plan (`is_a_fund = 1`).
- Calculated total deposits (converted from kobo to naira).
- Grouped by customer and sorted by total deposits descending.

**Challenges:**

- Ensuring correct join conditions to count distinct savings and investment plans per customer.
- Converting monetary values from kobo to naira for readability.
- Filtering for users who have both product types.

---

## Question 2: Transaction Frequency Analysis

**Approach:**

- Calculated total transactions per customer from `savings_savingsaccount`.
- Derived active months based on first and last transaction dates.
- Computed average monthly transactions and categorized customers:
  - High Frequency (≥10)
  - Medium Frequency (3–9)
  - Low Frequency (≤2)
- Grouped customers by frequency category and calculated category averages.

**Challenges:**

- Handling customers with short transaction history to avoid divide-by-zero.
- Verifying the actual transaction date column (ensured `transaction_date` exists or replaced with `created_at`).

---

## Question 3: Account Inactivity Alert

**Approach:**

- Found the most recent inflow transaction (`MAX(transaction_date)`) for each plan.
- Calculated inactivity in days using `DATEDIFF(CURDATE(), last_transaction_date)`.
- Flagged plans with no transaction activity for more than 365 days.
- Included plan type (Savings or Investment) using conditional logic.

**Challenges:**

- Ensuring plan types were correctly interpreted using `is_regular_savings` and `is_a_fund`.
- Validating actual column names for transaction timestamps.


---

## Question 4: Customer Lifetime Value (CLV) Estimation

**Approach:**

- Calculated account tenure (months since `date_joined`) from `users_customuser`.
- Counted total transactions and summed transaction value (`confirmed_amount`) from `savings_savingsaccount`.
- Estimated average profit per transaction as 0.1% of total amount.
- Applied the given CLV formula and sorted by highest value.

**Challenges:**

- Avoiding to divide-by-zero using `GREATEST(tenure_months, 1)` and `NULLIF` where needed.
- Ensuring accurate conversion from kobo to naira before applying percentage.

---

## ✅ Notes

- All SQL queries are written and tested in MySQL syntax.
- Code is modular, readable, and uses Common Table Expression (CTEs) for clarity.
- Comments are included in each `SQL` file to explain non-obvious logic.
- No additional files or data exports are included, per assessment rules.

---

## Summary

This assessment tested SQL querying skills, aggregation, joins, date calculations, and business metric derivations. The solutions balance accuracy, efficiency, and readability.

---

Thank you for the opportunity! 
