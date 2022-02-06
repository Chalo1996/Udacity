/*Provide the name of the sales_rep in each region with the largest amount of total_amt_usd sales.*/
SELECT t3.rep_name, t3.region_name, t3.total_amt
FROM
    (SELECT region_name, MAX(total_amt) total_amt
    FROM
        (SELECT s.name rep_name, r.name region_name,
            SUM(o.total_amt_usd) total_amt
        FROM sales_reps s
            JOIN accounts a
            ON s.id = a.sales_rep_id
            JOIN region r
            ON r.id = s.region_id
            JOIN orders o
            ON o.account_id = a.id
        GROUP BY 1,2) t1
    GROUP BY 1) t2

    JOIN
    (SELECT s.name rep_name, r.name region_name,
        SUM(o.total_amt_usd) total_amt
    FROM sales_reps s
        JOIN accounts a
        ON a.sales_rep_id = s.id
        JOIN region r
        ON r.id = s.region_id
        JOIN orders o
        ON a.id = o.account_id
    GROUP BY 1, 2
    ORDER BY 3 DESC
) t3

    ON t3.region_name = t2.region_name AND t3.total_amt = t2.total_amt;

/*For the region with the largest sales total_amt_usd, how many total orders were placed?*/
SELECT r.name, COUNT(o.total) total_orders
FROM sales_reps s
JOIN accounts a
ON a.sales_rep_id = s.id
JOIN region r
ON r.id = s.region_id
JOIN orders o
ON  a.id = o.account_id
GROUP BY 1
HAVING SUM(o.total_amt_usd) = (
    SELECT MAX(total_amt)
    FROM(SELECT r.name region_name, SUM(o.total_amt_usd) total_amt
    FROM sales_reps s
    JOIN accounts a
    ON a.sales_rep_id = s.id
    JOIN region r
    ON s.region_id = r.id
    JOIN orders o
    ON o.account_id = a.id
    GROUP BY 1) sub
);

/*How many accounts had more total purchases than the account name which has bought the most standard_qty paper throughout their lifetime as a customer?*/
SELECT a.name, COUNT(o.total) more_by
FROM orders o
    JOIN accounts a
    ON a.id = o.account_id
GROUP BY 1
HAVING SUM(o.total) > (SELECT total
FROM (SELECT a.name account_name, SUM(o.standard_qty) total_std,
        SUM(o.total) total
    FROM accounts a
        JOIN orders o
        ON o.account_id = a.id
    GROUP BY 1
    ORDER BY 2 DESC
    LIMIT 1) sub);

    /*Also, the following code will give us the exact number of accounts having more total purchases than standard_qty account.*/

    SELECT COUNT(*)
FROM (SELECT a.name
       FROM orders o
       JOIN accounts a
       ON a.id = o.account_id
       GROUP BY 1
       HAVING SUM(o.total) > (SELECT total 
                   FROM (SELECT a.name act_name, SUM(o.standard_qty) tot_std, SUM(o.total) total
                         FROM accounts a
                         JOIN orders o
                         ON o.account_id = a.id
                         GROUP BY 1
                         ORDER BY 2 DESC
                         LIMIT 1) inner_tab)
             ) counter_tab;

/*For the customer that spent the most (in total over their lifetime as a customer) total_amt_usd, how many web_events did they have for each channel?*/
SELECT a.name, w.channel, COUNT(*) num_events
FROM accounts a
JOIN web_events w
ON a.id = w.account_id 
AND a.id = (SELECT id
    FROM(
        SELECT a.id, a.name, SUM(o.total_amt_usd) tot_spent
        FROM orders o
        JOIN accounts a
        ON o.account_id = a.id
        GROUP BY 1, 2
        ORDER BY 3 DESC
        LIMIT 1)inner_table)
GROUP BY 1, 2
ORDER BY 3 DESC;

/*What is the lifetime average amount spent in terms of total_amt_usd for the top 10 total spending accounts?*/
SELECT AVG(total_spent)
FROM (
    SELECT a.id, a.name, SUM(o.total_amt_usd) total_spent
FROM orders o
    JOIN accounts a
    ON a.id = o.account_id
GROUP BY 1, 2
ORDER BY 3 DESC
LIMIT 10) sub;

/*What is the lifetime average amount spent in terms of total_amt_usd, including only the companies that spent more per order, on average, than the average of all orders.*/
SELECT AVG(avg_amt)
FROM( 
    SELECT o.account_id, AVG(o.total_amt_usd) avg_amt
FROM orders o
GROUP BY 1
HAVING AVG(o.total_amt_usd) > (
    SELECT AVG(o.total_amt_usd) avg_all
FROM orders o)) sub;

