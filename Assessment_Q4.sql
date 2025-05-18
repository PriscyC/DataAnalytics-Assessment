/*4. Customer Lifetime Value (CLV) Estimation
Scenario: Marketing wants to estimate CLV based on account tenure and transaction volume (simplified model).
Task: For each customer, assuming the profit_per_transaction is 0.1% of the transaction value, calculate:
Account tenure (months since signup)
Total transactions
Estimated CLV (Assume: CLV = (total_transactions / tenure) * 12 * avg_profit_per_transaction)
Order by estimated CLV from highest to lowest
Tables:
users_customuser
savings_savingsaccount */

-- Summarize transaction data per customer
WITH txn_summary AS (
    SELECT sa.owner_id,COUNT(*) AS total_transactions,SUM(sa.confirmed_amount) / 100.0 AS total_amount_naira  -- convert from kobo
    FROM savings_savingsaccount sa
    GROUP BY sa.owner_id
),
-- Calculate tenure from user table
user_tenure AS (
    SELECT u.id AS customer_id,u.name,TIMESTAMPDIFF(MONTH, u.date_joined, CURDATE()) AS tenure_months
    FROM users_customuser u
),
-- Combine transaction + tenure and calculate CLV
combined AS (
SELECT ut.customer_id,ut.name,GREATEST(ut.tenure_months, 1) AS tenure_months,ts.total_transactions,
	ROUND((ts.total_amount_naira * 0.001) / NULLIF(ts.total_transactions, 0), 2) AS avg_profit_per_transaction
    FROM user_tenure ut
    JOIN txn_summary ts ON ut.customer_id = ts.owner_id
),
-- CLV calculation
clv_calc AS (
    SELECT customer_id,name,tenure_months,total_transactions,ROUND((total_transactions / tenure_months) * 12 * avg_profit_per_transaction, 2) AS estimated_clv
    FROM combined
)
-- result
SELECT *
FROM clv_calc
ORDER BY estimated_clv DESC;