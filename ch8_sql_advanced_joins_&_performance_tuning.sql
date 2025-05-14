/* SQL Advanced JOINS & Performance Tuning:

Most of the work in this lesson is covering edge cases. You won't use these functions daily, but when you need them,
you'll be glad that you learned them. 


JOINS:
------------------------------------------------
- INNER JOIN - rows for which the join condition is matched in both tables.
- LEFT JOIN - also includes unmatched rows from the left table, which is indicated in the “FROM” clause.
- RIGHT JOIN -  similar to left joins, but includes unmatched data from the right table -- the one that’s indicated in the JOIN clause.

JOIN is evaluated before WHERE
- Filtering in the JOIN clause eliminates rows BEFORE they are joined; 
- Filtering in the WHERE leaves those rows in and produces some nulls.

FULL JOIN - includes unmatched rows from both tables being joined. A full outer join returns unmatched records in each table with null values for the columns that came from the opposite table.
- A common application of this is when joining two tables on a timestamp.
- Is commonly used in conjunction with aggregations to understand the amount of overlap between two tables.
- If you wanted to return unmatched rows only, which is useful for some cases of data assessment, you can isolate them by adding the following line to the end of the query: 

*/   FULL OUTER JOIN /* with */ WHERE A.Key IS NULL OR B.Key IS NULL   /*

 - JOINs allow you to combine two data sets, side by side.

UNIONS:
-------------------------------------------------------
- UNION allows you to stack one data set on top of another; used to combine the result sets of 2 or more SELECT statements.
  - ex. when the same data is stored in multiple different places (ex. several lists of events, email addresses).
  - ex. to append an aggregation (ex. like a sum) to the end of a list of individual records.

- UNION removes duplicate rows.
- UNION ALL - does not remove duplicate rows.

* You'll likely use UNION ALL far more often than you'll use UNION. 

SQL's two strict rules for appending data (UNION and UNION ALL):
1. Both tables must have the same number of columns.
2. Those columns must have the same data types in the same order as the first table.

- A common misconception is that column names have to be the same. Column names, in fact, 
don't need to be the same to append two tables but you will find that they typically are.

Query Performance considerations:
--------------------------------------------------------

* Reduce the number of calculations that need to be performed to make a query run faster.  
Some high-level things that will affect the number of calculations a given query will make include:

1. Table size - if your query hits one or more tables with millions of rows or more it could affect performance.

  Use a subset of data to test a query first:
    - If you have time series data, limiting to a small time window can make your queries run more quickly.
    - You can always perform exploratory analysis on a subset of data, refine your work into a final query, then remove
    the limitation and run your work across the entire data set. The final query might take a long time to run, but at 
    least you can run the intermediate steps quickly.
    - This is why most SQL editors automatically append a limit to most SQL queries. They expect that for exploration 
    a limited result set is fine. Once you have a final query, you can turn off the limit and get the full results. 

  When working with subqueries:
    - When working with subqueries, limiting the amount of data you're working with in the place where it will be executed 
    first will have the maximum impact on query run time.
    - Keep in mind, that applying a limit to a sub query will dramatically alter your results. So you should use it to TEST query logic, but NOT to get actual results.
    - Generally, when working with subqueries, you should limit the amount of data you're working with in the place where it will be executed FIRST in order for
    it to have maximum impact on a query runtime. 

2. Joins - if your query joins two tables in a way that substantially increases the row count of the result set, youre query is likely to be slow.
  
3. Aggregations - requiring multiple rows to produce a result requires more computation than simply retrieving those rows. 
  - COUNT DISTINCT takes an especially long time because it must check all rows against one another for duplicate values.


Query runtime is also dependent on things you can't control related to the database itself:

1. Other users running queries concurrently on the database. 
  - it can be especially bad if others are performing particularly resource-intensive queries that fulfill some the criteria mentioned above.
2. Database software and optimization 
  - different databases vary in speed for a given task. For example, Postgres is optimized to read and write new rows quickly, while Redshift 
  is optimized to perform fast aggregations. If you know the system you're using using, you can work within its bounds to make your queries 
  more efficient. */


--- 8.3  FULL OUTER JOIN 

![Inner Join]('/Users/Erica/Documents/GitHub Repos/sql_udacity_queries_Github/analytics_accelerator/Images/8.2 - INNER JOIN.png') 

Shows each account who has a sales rep and each sales rep that has an account (all of the columns in these returned rows will be full)
but also each account that does not have a sales rep and each sales rep that does not have an account (some of the columns in these returned rows will be empty) */

SELECT *
FROM accounts a
FULL OUTER JOIN sales_reps s
ON a.sales_rep_id = s.id;
WHERE a.sales_rep_id IS NULL OR s.id IS NULL;   -- If unmatched rows do exist, you could isolate them by adding this line to the end of the query.


-- 8.5  JOINS with Comparison operators -- 

/* To understand how effective your campaigns are, you want to see all the actions a customer took before making 
their first purchase (ie. all thew web traffic events that occurred before that accounts first order).

Just returns the first order from each account: */

SELECT *
FROM orders
WHERE DATE_TRUNC('month', occurred_at) =
(SELECT DATE_TRUNC('month', MIN(occurred_at)) FROM orders)
ORDER BY occurred_at;

/* Joins the web_events and orders tables to show every web event associated with an account id where the where the web event occurred
before the that account's first order date. */ 

SELECT orders.id,
    orders.occurred_at AS order_date,
    events.*
FROM orders     -- keeps all records from the orders table
LEFT JOIN web_events events     
    ON events.account_id = orders.account_id     --- joins rows between both tables on account id
    AND events.occurred_at < orders.occurred_at     -- keeps only events from the web_events table that occurred before the first order date; 
WHERE DATE_TRUNC('month', occurred_at) =      
    (SELECT DATE_TRUNC('month', MIN(orders.occurred_at)) FROM orders)
ORDER BY occurred_at;

/* Inequality operators (a.k.a. comparison operators) don't only need to be date times or numbers, they also work on strings. 

This lists the primary point of contact and sales rep for each account, only where the sales primary point of contact's full 
name (starting with first name) comes before the sales rep's name alphabetically. */

SELECT a.name account, primary_poc, s.name rep
FROM sales_reps s
JOIN accounts a
ON a.sales_rep_id = s.id AND
a.primary_poc < s.name;

SELECT accounts.name as account_name,
       accounts.primary_poc as poc_name,
       sales_reps.name as sales_rep_name
  FROM accounts       --- keeps all accounts 
  LEFT JOIN sales_reps   
    ON accounts.sales_rep_id = sales_reps.id      -- joins accounts with sales reps records where sales rep id matches
   AND accounts.primary_poc < sales_reps.name       -- but only if the primary_poc's full name (starting with first name) comes before the sales reps name alphabetically


--- 8.8 Self JOINs ----

/* Sometimes it can be useful to join a table to itself. 
One of the most common use cases for self JOINs is in cases where two events occurred, one after another. Using inequalities in conjunction with self JOINs is common. (ex. When you want to show both parent and child relationships within a family tree.)

Figures out which account made multiple orders within 30 days: */

SELECT o1.id AS o1_id,    -- order id from 1st orders table
       o1.account_id AS o1_account_id,   -- account id from 1st orders table
       o1.occurred_at AS o1_occurred_at,   -- occurrence date from 1st orders table
       o2.id AS o2_id,    -- order id from 2nd orders table
       o2.account_id AS o2_account_id,    -- account id from 2nd orders table
       o2.occurred_at AS o2_occurred_at  -- occurrence date from 2nd orders table
  FROM orders o1      -- keeps all records from the 1st orders table
 LEFT JOIN orders o2
   ON o1.account_id = o2.account_id     -- joins the 1st orders table with the 2nd orders table where account id matches
  AND o2.occurred_at > o1.occurred_at      -- but only for orders that had occurrence dates AFTER the order from the 1st table
  AND o2.occurred_at <= o1.occurred_at + INTERVAL '28 days'   -- AND that happened less than or equal to 28 days after the original order. 
ORDER BY o1.account_id, o1.occurred_at

/* Performs interval analysis to find those web events that occurred no more than 1 day after another web event. */

SELECT w1.id AS w_id,
       w1.account_id AS w1_account_id,
       w1.occurred_at AS w1_occurred_at,
       w1.channel AS w1_channel,
       w2.id AS w2_id,
       w2.account_id AS w2_account_id,
       w2.occurred_at AS w2_occurred_at,
       w2.channel AS w2_channel
  FROM web_events w1             -- keeps all records in the first web events table (point of comparison)
 LEFT JOIN web_events w2         -- joins with all records in the second web events table where account id matches
   ON w1.account_id = w2.account_id    
  AND w1.occurred_at > w2.occurred_at    -- IF the web event in the second table occurs AFTER the web event in the first table
  AND w1.occurred_at <= w2.occurred_at + INTERVAL '1 day'  -- AND the web event in the first table is 1 DAY OR LESS EARLIER than the web event in the second table


--- 8.11 UNION: ---

/* UNION is typically used to pull together distinct values of specified columns that are spread across multiple tables.
- ex. a chef wants to pull together the ingredients and respective aisle across three separate meals that are maintained in different tables.
- ex. when you want to determine all reasons students are late. Currently, each late reason is maintained within tables corresponding to the grade the student is in.
  - The table with the students' information needs to be appended with the late reasons. It requires no aggregation or filter, but all duplicates need to be removed. 
    So the final use case is the one where the UNION operator makes the most sense.

- There must be the same number of expressions in both SELECT statements.
- The corresponding expressions must have the same data type in the SELECT statements
  - ex. expression1 must be the same data type in both the first and second SELECT statement.   

UNION only appends distinct values; More specifically, when you use UNION, the dataset is appended and any rows in the appended dataset 
that are exactly identical to rows in the first table are dropped.
 
Since you're writing two separate SELECT statements when you UNION, you can treat them differently before appending. These results show only rows from the Facebook channel for first web_events table where all rows from the web_events_2 table will be returned:  */

SELECT *
FROM web_events
WHERE channel = 'facebook'
UNION ALL
SELECT *
FROM web_events_2

/* Once you UNION two SELECT statements together, you can perform operations on the combined data set rather than just on the individual parts.
You can do this by UNIONing them together in a subquery or CTE so the combined results are treated as a single result set.

Takes the combined results from these two tables and use them to count up all of the sessions by channel - using a subquery: */

SELECT channel,
  COUNT(*) AS sessions
  FROM (
SELECT *
FROM web_events
UNION ALL
SELECT *
FROM web_events_2
  ) web_events
GROUP BY 1
ORDER BY 2 DESC;

/* Uses a common table expression (CTE) to do the UNION, then does aggregations in the main query. 
The results are the same but it's a lot easier to read the query logic. */

WITH web_events AS 
(SELECT *
FROM web_events
UNION ALL
SELECT *
FROM web_events_2 )

SELECT channel,
  COUNT(*) AS sessions
  FROM web_events
GROUP BY 1
ORDER BY 2 DESC;

/* Stacks all rows with names of "Walmart" from the accounts table on top of all rows with names of "Disney" from the accounts table: */ 

FROM accounts
WHERE name = 'Walmart'
UNION   -- removes duplicate rows
SELECT *
FROM accounts
WHERE name = 'Disney';

/* This is essentially the same thing as filtering on the WHERE clause using the following: */

 SELECT * 
 FROM accounts 
 WHERE name = 'Walmart' OR name = 'Disney'; 

/*  Counts the number of times a name appears in the accounts table when it is UNION ALLed with itself (doese not remove duplicates).  */ 
WITH double_accounts AS (
    SELECT *
      FROM accounts
    UNION ALL    -- stacks all rows from the first accounts table on top of all rows from the second accounts table, without removing duplicates; effectively creating duplicates of everything
    SELECT *
      FROM accounts
)
SELECT name,   -- can bring in just the "name" column specifically because all columns from the accounts were brought into the new "double_accounts" table - including "name"
       COUNT(*) AS name_count  -- counts the number of times a name appears in the new "double_accounts" table.
 FROM double_accounts 
GROUP BY 1
ORDER BY 2 DESC;


/* -- 8.15 Performance Tuning ---

- Filter the data to include only the observations you need. This can dramatically improve query speed. 
- Try performing exploratory analysis on a subset of data, refine your work into a final query, then 
remove the limitation and run your work across the entire data set. */

SELECT *
FROM orders
WHERE occurred_at >= '2016-01-01'
AND occurred_at < '2016-07-01'
-- If you have time series data, limiting to a small time window can make your queries run more quickly.


-- It's worth noting that LIMIT doesn't work quite the same with speeding up aggregation performance:
SELECT acccount_id,
  SUM(poster_qty) AS sum_poster_qty
FROM orders
WHERE occurred_at >= '2016-01-01'
AND occurred_at < '2016-07-01'
GROUP BY 1
LIMIT 10;
/* Placing a limit on the outer query won't really speed this query up. That's because the most "expensive" parts of the 
query (the aggregations) are performed FIRST, and THEN the result set is limited is limited 10, not the other way around. */


SELECT account_id, 
  SUM(poster_qty) AS sum_poster_qty
FROM (
  SELECT *
  FROM orders
  LIMIT 100) sub
WHERE occurred_at >= '2016-01-01'
AND occurred_at < '2016-07-01'
GROUP BY 1; 

/* Placing a limit of the inner query (a subquery or CTE), however, can significantly speed up performance.
- Limit the amount of data you're working with in the subquery or CTE that will be executed FIRST to have maximum impact on query run time.
- Keep in mind, though, applying a limit to a sub query will dramatically alter your results. So you should use only use this technique
 to TEST query logic - NOT to get actual findings. 


Making your JOINs less complicated will also speed up your queries - you can make your JOINs less complicated by reducing the number of rows that are evaluated during the JOIN.
To have maximum impact of performance, it's better to reduce table sizes before joining them. */

-- Original query --
SELECT
  accounts. name,
  COUNT (*) AS web_events
FROM accounts
JOIN web_events events
ON events.accounts_id = accounts.id
GROUP BY 1 
ORDER BY 2 DESC;

-- Same query, but a version that reduces the number of rows that evaluated during the JOIN by peforming the aggregation on the web_events table FIRST before joining it with the accounts table. 
SELECT
a. name,
sub.web_events
FROM (
  SELECT
  account_id,
  COUNT (*) AS web_events
  FROM web_events events
  ORDER BY 1 
) sub
FROM accounts a 
ON a.id = sub.acccount_id
ORDER BY 2 DESC;
-- When you do this, make sure what you're doing is still logically consistent - you should worry about the accuracy of your work BEFORE worrying about run speed.



/* Add EXPLAIN at the beginning of any working query to get a sense of how long it will take. It's not completely accurate, but it's a useful tool. This returns
a Query Plan. A Query Plan shows the order in which the query will be executed, with the first action performed at the bottom. A measure of "cost" will be listed 
next to the number rows. Higher numbers mean longer running time.  

1. Run EXPLAIN on a query.
2. Modify the steps that are expensive.
3. Then run EXPLAIN again to see if the cost is reduced. */

EXPLAIN
SELECT *
FROM web_events
WHERE occurred_at >= '2016-01-01'
AND occurred_at < '2016-02-01'
LIMIT 100


