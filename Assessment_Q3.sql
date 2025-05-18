/* 3. Account Inactivity Alert
Scenario: The ops team wants to flag accounts with no inflow transactions for over one year.
Task: Find all active accounts (savings or investments) with no transactions in the last 1 year (365 days) .
Tables:
plans_plan
savings_savingsaccount */

-- Get latest transaction per plan
WITH latest_tx AS (
    SELECT plan_id,
        MAX(transaction_date) AS last_transaction_date
    FROM savings_savingsaccount
    GROUP BY plan_id
),
-- Join with plans and calculate inactivity
plan_activity AS (
    SELECT pp.id AS plan_id,
        pp.owner_id,
        CASE 
            WHEN pp.is_regular_savings = 1 THEN 'Savings'
            WHEN pp.is_a_fund = 1 THEN 'Investment'
            ELSE 'Other'
        END AS type,
        lt.last_transaction_date,
        DATEDIFF(CURDATE(), lt.last_transaction_date) AS inactivity_days
    FROM plans_plan pp
    LEFT JOIN latest_tx lt ON pp.id = lt.plan_id
    WHERE pp.is_regular_savings = 1 OR pp.is_a_fund = 1
)
-- Filter plans with inactivity > 365
SELECT plan_id,owner_id,
    type,
    last_transaction_date,
    inactivity_days
FROM plan_activity
WHERE last_transaction_date IS NOT NULL
  AND inactivity_days > 365
ORDER BY inactivity_days DESC;