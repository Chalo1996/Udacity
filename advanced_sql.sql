/*You’re not likely to use FULL JOIN (which can also be written as FULL OUTER JOIN) too often, but the syntax is worth practicing anyway. LEFT JOIN and RIGHT JOIN each return unmatched rows from one of the tables—FULL JOIN returns unmatched rows from both tables. FULL JOIN is commonly used in conjunction with aggregations to understand the amount of overlap between two tables.

Say you're an analyst at Parch & Posey and you want to see:

    each account who has a sales rep and each sales rep that has an account (all of the columns in these returned rows will be full)
    but also each account that does not have a sales rep and each sales rep that does not have an account (some of the columns in these returned rows will be empty)

This type of question is rare, but FULL OUTER JOIN is perfect for it. In the following SQL Explorer, write a query with FULL OUTER JOIN to fit the above described Parch & Posey scenario (selecting all of the columns in both of the relevant tables, accounts and sales_reps) then answer the subsequent multiple choice quiz.*/
SELECT a.sales_rep_id AS sales_rep, s.id AS sales_rep_account
FROM accounts a
FULL OUTER JOIN sales_reps s
ON a.sales_rep_id = s.id

/*For the above query, there are no unmatched rows, but if they existed, the following code would've eliminated them*/

WHERE a.sales_rep_id IS NULL OR s.id IS NULL

SELECT o.id,
    o.occurred_at order_date,
    events*
FROM orders o
LEFT JOIN events e
ON o.account_id = e.account_id
AND e.occurred_at < o.occurred_at
WHERE DATE_TRUNC('month', o.occurred_at) = 
(SELECT DATE_TRUNC('month', MIN(o.occurred_at)) FROM orders)
GROUP BY o.account_id, o.occurred_at

/*In the following SQL Explorer, write a query that left joins the accounts table and the sales_reps tables on each sale rep's ID number and joins it using the < comparison operator on accounts.primary_poc and sales_reps.name, like so:
The query results should be a table with three columns: the account name (e.g. Johnson Controls), the primary contact name (e.g. Cammy Sosnowski), and the sales representative's name (e.g. Samuel Racine). Then answer the subsequent multiple choice question.*/
SELECT accounts.name account_name, 
        accounts.primary_poc poc_name, 
        sales_reps.name sale_name
FROM accounts
LEFT JOIN sales_reps
ON accounts.sales_rep_id = sales_reps.id
AND accounts.primary_poc < sales_reps.name

/*Self joins*/
SELECT o1.id AS o1_id,
    o1.account_id AS o1_account_id,
    o1.occurred_at AS o1_occurred_at,
    o2.id AS o2_id,
    o2.account_id AS o2_account_id,
    o2.occurred_at AS o2_occurred_at
FROM orders o1
LEFT JOIN orders o2
ON o1.account_id = o2.account_id
AND o2.occurred_at > o1.occurred_at
AND o2.occurred_at <= o1.occurred_at + INTERVAL '28 days'
GROUP BY 1, 2, 3

/*Modify the query from the previous video, which is pre-populated in the SQL Explorer below, to perform the same interval analysis except for the web_events table. Also:

    change the interval to 1 day to find those web events that occurred after, but not more than 1 day after, another web event
    add a column for the channel variable in both instances of the table in your query*/

SELECT w1.id web_one_id, 
    w2.id web_two_id, 
    w1.account_id w1_one_account_id,
    w2.account_id w2_one_account_id,
    w1.occurred_at web_one_date,
    w2.occurred_at web_two_date, 
    w1.channel web_one_chanel,
    w2.channel web_two_channel
FROM web_events w1
LEFT JOIN web_events w2
ON w1.account_id = w2.account_id
AND w1.occurred_at > w2.occurred_at
AND w1.occurred_at <= w2.occurred_at + INTERVAL '1 day'
ORDER BY 1, 2

/*The following question is not related to the Porch and Posey datebase. It is meant for further understanding: 
I need to compare two dates and return the count of a field based on the date values. For example, I have a date field in a table called last updated date. I have to check if trunc(last_updated_date >= trunc(sysdate-13).*/
SELECT a.code AS Code, 
    a.name AS Name,
    COUNT(b.Ncode)
    FROM cdmaster a, nmmaster b
    WHERE a.code = b.code
    AND a.status = 1
    AND b.status = 1
    AND b.Ncode <> 'a10'
    AND TRUNC(laste_updated_date) <= TRUN(sysdate-13)
    GROUP BY 1, 2
    UNION
SELECT a.code AS Code, 
    a.name AS Name,
    COUNT(b.Ncode)
    FROM cdmaster, nmmaster
    WHERE a.code = b.code
    AND a.status = 1
    AND b.status = 1
    ANd b.Ncode <> 'a10'
    AND TRUNC(last_updated_date) > TRUNC(sysdate-13)
    GROUP BY 1, 2

/*################################################*/
WITH web_events AS(
    SELECT *
    FROM web_events
    UNION ALL
    SELECT *
    FROM web_events_2
    )

SELECT channel,
    COUNT(*) AS sessions
FROm web_events
GROUP BY 1
ORDER BY 2 DESC

/*Write a query that uses UNION ALL on two instances (and selecting all columns) of the accounts table. Then inspect the results and answer the subsequent quiz.*/
WITH double_accounts AS(
    SELECT *
FROM accounts a1
-- WHERE name = 'Walmart'
UNION ALL
SELECT* 
FROM accounts a2
-- WHERE name = 'Disney'
)

SELECT id, name,
    COUNT(*) AS name_counts
FROM double_accounts
GROUP BY 1, 2

/*JOINING sunqueries to improve performance STAGE ONE*/
SELECT DATE_TRUNC('day', o.occurred_at) AS date,
    COUNT(DISTINCT a.sales_rep_id) AS active_sales_reps,
    COUNT(DISTINCT o.id) AS orders,
    COUNT(DISTINCT we.id) AS web_visits
FROM accounts a
JOIN orders o
ON o.account_id = a.id
JOIN web_events we
ON DATE_TRUNC('day', we.occurred_at) = DATE_TRUNC('day', o.occurred_at)
GROUP BY 1
ORDER BY 1 DESC

/*The above code can be made more efficient by joining the subqueries as shown below*/
SELECT COALESCE(orders.date, web_events.date) AS date,
    orders.active_sales_reps,
    orders.orders,
    web_events.web_visits
FROM(
    SELELCT DATE_TRUNC('day', o.occurred_at) AS date,
    COUNT(a.sales_rep_id) AS active_sales_reps,
    COUNT(o.id) AS orders
FROM accounts a
JOIN orders o
ON o.account_id = a.id
GROUP BY 1
)orders

FULL JOIN

(
    SELECT DATE_TRUNC('day', we.occurred_at) AS date,
    COUNT(we.id) AS web_visits
    FROM web_events we
    GROUP BY 1
)web_events

ON web_events.date = orders.date
ORDER BY 1 DESC