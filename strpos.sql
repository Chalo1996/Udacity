/*Use the accounts table to create first and last name columns that hold the first and last names for the primary_poc.*/
SELECT LEFT(primary_poc, STRPOS(primary_poc, ' ') -1 ) first_name, 
RIGHT(primary_poc, LENGTH(primary_poc) - STRPOS(primary_poc, ' ')) last_name
FROM accounts;
/*OR*/
SELECT LEFT(name, STRPOS(primary_poc, ' ')) fname,
       RIGHT(name, LENGTH(name) - STRPOS(primary_poc, ' ')) lname
FROM accounts;

/*Now see if you can do the same thing for every rep name in the sales_reps table. Again provide first and last name columns.*/
SELECT LEFT(name, STRPOS(name, ' ') -1 ) first_name, 
       RIGHT(name, LENGTH(name) - STRPOS(name, ' ')) last_name
FROM sales_reps;
/*OR*/
SELECT LEFT(name, STRPOS(name, ' ')) fname,
        RIGHT(name, LENGTH(name)-STRPOS(name, ' '))lname
FROM sales_reps