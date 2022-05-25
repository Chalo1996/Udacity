/*Here is the necessary quiz to pull the first month/year combo from the orders table.*/

SELECT DATE_TRUNC('month', MIN(occurred_at)) 
FROM orders;


/*Then to pull the average for each, we could do this all in one query, but for readability, I provided two queries below to perform each separately.*/

SELECT AVG(standard_qty) avg_std, AVG(gloss_qty) avg_gls, AVG(poster_qty) avg_pst
FROM orders
WHERE DATE_TRUNC('month', occurred_at) = 
     (SELECT DATE_TRUNC('month', MIN(occurred_at)) FROM orders);

SELECT SUM(total_amt_usd)
FROM orders
WHERE DATE_TRUNC('month', occurred_at) = 
      (SELECT DATE_TRUNC('month', MIN(occurred_at)) FROM orders);
