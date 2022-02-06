/*
For each account, determine the average amount of each type of paper they purchased across their orders. Your result should have four columns - one for the account name and one for the average quantity purchased for each of the paper types for each account.

For each account, determine the average amount spent per order on each paper type. Your result should have four columns - one for the account name and one for the average amount spent on each paper type.

Determine the number of times a particular channel was used in the web_events table for each sales rep. Your final table should have three columns - the name of the sales rep, the channel, and the number of occurrences. Order your table with the highest number of occurrences first.

Determine the number of times a particular channel was used in the web_events table for each region. Your final table should have three columns - the region name, the channel, and the number of occurrences. Order your table with the highest number of occurrences first.
*/

SELECT a.name,
    AVG(o.standard_qty) standard,
    AVG(o.gloss_qty) gloss,
    AVG(o.poster_qty) poster
FROM orders o
    LEFT JOIN accounts a
    ON o.account_id = a.id
GROUP BY a.name;


SELECT a.name,
    AVG(o.standard_amt_usd) standard_avg,
    AVG(o.gloss_amt_usd) gloss_avg,
    AVG(o.poster_amt_usd) poster_avg
FROM orders o
    LEFT JOIN accounts a
    ON o.account_id = a.id
GROUP BY a.name;


SELECT s.name,
    COUNT(*) num_events,
    w.channel
FROM accounts a
    LEFT JOIN web_events w
    ON a.id = w.account_id
    JOIN sales_reps s
    ON s.id = a.sales_rep_id
GROUP BY s.name, w.channel
ORDER BY num_events DESC;


SELECT r.name, w.channel, COUNT(*) num_events
FROM accounts a
    JOIN web_events w
    ON a.id = w.account_id
    JOIN sales_reps s
    ON s.id = a.sales_rep_id
    JOIN region r
    ON r.id = s.region_id
GROUP BY r.name, w.channel
ORDER BY num_events DESC;
