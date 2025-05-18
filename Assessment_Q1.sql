-- Assessment_Q1.sql --
/*1. High-Value Customers with Multiple Products
Scenario: The business wants to identify customers who have both a savings and an investment plan (cross-selling opportunity).
Task: Write a query to find customers with at least one funded savings plan AND one funded investment plan, sorted by total deposits.
Tables:
users_customuser
savings_savingsaccount
plans_plan */

/*This query finds customers who have at least one savings and one investment plan,
and ranks them by total deposits (converted from kobo to naira). */

use DataAnalytics_Assessment;
SELECT u.id AS owner_id,u.name,
    COUNT(DISTINCT s.id) AS savings_count,
    COUNT(DISTINCT i.id) AS investment_count,
    ROUND(SUM(sa.confirmed_amount) / 100.0, 2) AS total_deposits
FROM users_customuser u
LEFT JOIN plans_plan s ON s.owner_id = u.id AND s.is_regular_savings = 1
LEFT JOIN plans_plan i ON i.owner_id = u.id AND i.is_a_fund = 1
LEFT JOIN savings_savingsaccount sa ON sa.plan_id = s.id
WHERE s.id IS NOT NULL AND i.id IS NOT NULL
GROUP BY u.id, u.name
ORDER BY total_deposits DESC;