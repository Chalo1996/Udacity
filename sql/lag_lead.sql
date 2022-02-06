SELECT account_id, standard_sum,
    LAG(standard_sum) OVER (ORDER BY standard_sum) AS lag,
    standard_sum - LAG(standard_sum) OVER (ORDER BY standard_sum) AS lag_difference,
    LEAD(standard_sum) OVER (ORDER BY standard_sum) AS lead,
    LEAD(standard_sum) OVER (ORDER BY standard_sum) - standard_sum AS lead_difference

FROM(
    SELECT account_id,
    SUM(standard_qty) AS standard_sum
    FROM orders
    GROUP BY 1
) sub

/*Imagine you're an analyst at Parch & Posey and you want to determine how the current order's total revenue ("total" meaning from sales of all types of paper) compares to the next order's total revenue.*/
SELECT occurred_at, total_revenue, 
    LEAD(total_revenue) OVER (ORDER BY occurred_at) AS lead,
    LEAD(total_revenue) OVER (ORDER BY occurred_at) - total_revenue AS lead_difference
FROM(
    SELECT occurred_at,
    SUM(total_amt_usd) AS total_revenue
    FROM orders
    GROUP BY 1
) sub;