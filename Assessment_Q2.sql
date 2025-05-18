-- 2. Transaction Frequency Analysis
/*Scenario: The finance team wants to analyze how often customers transact to segment them (e.g., frequent vs. occasional users).
Task: Calculate the average number of transactions per customer per month and categorize them:
"High Frequency" (≥10 transactions/month)
"Low Frequency" (≤2 transactions/month)
Tables:
savings_savingsaccount */

/*This query calculates the average number of transactions per customer per month,
categorizes them, and counts customers per category.*/
DESCRIBE savings_savingsaccount;
DESCRIBE withdrawals_withdrawal;
DESCRIBE plans_plan;
SHOW TABLES;
-- Getting total transactions and months active per customer
WITH txn_summary AS (
    SELECT owner_id,
        COUNT(*) AS total_transactions,
        TIMESTAMPDIFF(MONTH, MIN(transaction_date), MAX(transaction_date)) + 1 AS active_months
    FROM savings_savingsaccount
    GROUP BY owner_id
),
-- Calculating average monthly transactions
avg_tx_per_user AS (
    SELECT ts.owner_id,
        ROUND(ts.total_transactions / ts.active_months, 2) AS avg_tx_per_month
    FROM txn_summary ts
),
-- Categorizing frequency
categorized_users AS (
    SELECT uc.id AS customer_id,
        uc.name,
        au.avg_tx_per_month,
        CASE
            WHEN au.avg_tx_per_month >= 10 THEN 'High Frequency'
            WHEN au.avg_tx_per_month BETWEEN 3 AND 9 THEN 'Medium Frequency'
            ELSE 'Low Frequency'
        END AS frequency_category
    FROM avg_tx_per_user au
    JOIN users_customuser uc ON uc.id = au.owner_id
)
-- Aggregate results
SELECT frequency_category,
    COUNT(*) AS customer_count,
    ROUND(AVG(avg_tx_per_month), 2) AS avg_transactions_per_month
FROM categorized_users
GROUP BY frequency_category
ORDER BY FIELD(frequency_category, 'High Frequency', 'Medium Frequency', 'Low Frequency');