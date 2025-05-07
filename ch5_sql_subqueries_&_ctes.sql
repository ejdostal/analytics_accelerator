/* SQL Subqueries & CTEs

Whenever we need to use existing tables to create a new table that we then want to query again, 
this is an indication that we will need to use some sort of subquery. 

Question: Which channels send the most traffic per day on average? 

1. First, query the underlying to table to make sure the data makes sense for what you are trying to do. */ 
SELECT *
FROM web_events;

/* 2. Next, count up all the events by each channel by each day. */
SELECT DATE_TRUNC('day', occurred_at) AS day,
	channel, 
	COUNT(*) AS event_count
FROM web_events
GROUP BY 1,2
ORDER BY 1;

/* 3. The last step is to average across the events column that we created. 

In order to do that, we need to query against the results of this query. 

We do that by wrapping the query in parentheses and using it in the FROM
clause of the next query. */

SELECT *
FROM
(SELECT DATE_TRUNC('day', occurred_at) AS day,
		channel, 
		COUNT(*) AS event_count
	FROM web_events
	GROUP BY 1,2
	ORDER BY 1) sub

/* It is now a query within a query, also known as a subquery. 

Subqueries are required to have aliases, which are added after the parentheses - 
the same way you would add an alias to a table. 

Here we are just selecting all the data from the subquery. 

Let's go the last mile and average events per each channel. */

SELECT channel
FROM AVG (event_count) AS avg_event_count
(SELECT DATE_TRUNC('day', occurred_at) AS day,
		channel, 
		COUNT(*) AS event_count
	FROM web_events
	GROUP BY 1,2
) sub
GROUP BY 1
ORDER BY 2 DESC

/* Since the subquery acts as one table in the FROM clause, we'll put a GROUP BY 
clause after the subquery. 

Since we'll now reorder on the new aggregation in this query, we no longer need 
the ORDER BY statement in the subquery so we take it out to keep things clean. 

Since you broke out by day earlier, this is giving you an average per day.

To keep things clear, let's break down how this new query runs:

1. First the inner query will run. The inner query must run on it's own as
the database will treat it as an independent query.

2. Once your inner query is complete, the rest of the query, also known as the outer query,
will run across the result set created by the inner query.

	Note: A nice feature that many SQL editors share is the ability to highlight a portion 
	of the query and run only that portion. This is especially helpful when making changes 
	to an inner query.


4.6: More on Subqueries. 

In the first subquery you wrote, you created a table that you could then query again 
in the FROM statement. 

However, if you are only returning a single value, you might use that value in a 
logical statement like WHERE, HAVING, or even SELECT - the value could be nested
within a CASE statement.

Note that you should not include an alias when you write a subquery in a conditional statement. 
This is because a subquery in conditional logic is treated as an individual value (or set of values in the IN case) 
rather than as a table.

If we had returned an entire column IN would need to be used to perform a logical argument. 


If we are returning an entire table, then we must use an ALIAS for the table, 
and perform additional logic on the entire table.

Subqueries can be used anywhere you might use a table name, column name, or individual value.
They're especially useful using conditional logic, in conjunction with WHERE or JOIN clauses, 
or in the WHEN portion of a CASE statement.

Question: Return only orders that occurred in the same month as the company's first order ever. */

SELECT *
FROM orders;

/* 1. To get the date of the first order, you can write a subquery with a MIN function. */

SELECT MIN(occurred_at) AS min
FROM orders;

/* DATE_TRUNC is added below to get the month. */

SELECT DATE_TRUNC('month', MIN(occurred_at)) AS min_month
FROM orders;

/* Finally, let's write an outer query that uses this to filter the orders table
 and sorts by the occurred_at column. */

SELECT *
FROM orders
WHERE DATE_TRUNC('month', occurred_at) =
	(SELECT DATE_TRUNC('month', MIN(occurred_at)) AS min_month
	FROM orders)
	ORDER BY occurred_at;

/* This query works because the result of the subquery is only one cell. 
Most conditional logic will work with subqueries containing one-cell results. 

IN is the only type of conditonal logic that will work when the inner query
contains multiple results. 


Now let's try using the results of the previous query to also find the average 
for each type of paper qty in the month of the first order and the total amount 
spent on all orders in the month of the first order. */

SELECT AVG(gloss_qty) avg_gloss_qty,
	AVG(standard_qty) avg_standard_qty,
	AVG (poster_qty) avg_poster_qty,
	SUM(total_amt_usd) total_spent
FROM (SELECT *
	FROM orders
	WHERE DATE_TRUNC('month', occurred_at) =
		(SELECT DATE_TRUNC('month', MIN(occurred_at)) AS min_month
		FROM orders)
		ORDER BY occurred_at) sub;


/* 4.9 Quiz: Subquery Mania
--------------------------------

Question 1: Provide the name of the sales_rep in each region with the 
largest amount of total_amt_usd sales. */

SELECT t3.rep, t2.region, t2.max_sales
FROM (SELECT region, MAX(total_rep_sales) max_sales
		FROM 
		(SELECT s.name rep, r.name region, SUM(o.total_amt_usd) total_rep_sales
		FROM orders o
		JOIN accounts a
		ON o.account_id = a.id
		JOIN sales_reps s
		ON s.id = a.sales_rep_id
		JOIN region r
		ON r.id = s.region_id
		GROUP BY 1,2) t1
	GROUP BY 1) t2
JOIN
	(SELECT s.name rep, r.name region, SUM(o.total_amt_usd) total_rep_sales
	FROM orders o
	JOIN accounts a
	ON o.account_id = a.id
	JOIN sales_reps s
	ON s.id = a.sales_rep_id
	JOIN region r
	ON r.id = s.region_id
	GROUP BY 1,2
	ORDER BY 3 DESC) t3
ON t3.region = t2.region AND t3.total_rep_sales = t2.max_sales;

/* GROUP BY is not needed in the outer query because all aggregations were
already performed in the inner queries.

Table names are not defined for columns in t2 because the inner query 
has already fully run, so these variables are already defined. 

rep name is not returned to t2 because this would group results so they're
totals unique for each rep IN each region - you'd just get all the same rows 
from t1 back again, because sales rep names are already aggregated to appear 
only once there.

	This is also t2 had to be joined with a second copy of t1 - 
	to give you back the sales rep name associated with the Maxs
	for each region.
*/ 



/* Question 2: For the region with the largest (sum) of sales total_amt_usd, 
how many total (count) orders were placed? */

SELECT t1.region, SUM(o.total_amt_usd), COUNT(o.total_amt_usd) orders_count
FROM orders o
JOIN accounts a
ON o.account_id = a.id
JOIN sales_reps s
ON s.id = a.sales_rep_id
JOIN region r
ON r.id = s.region_id
HAVING SUM(o.total_amt_usd) = 

SELECT r.name region, SUM(o.total_amt_usd), COUNT(o.total_amt_usd) orders_count
FROM region r
JOIN sales_reps s
ON r.id = s.region_id
JOIN accounts a
ON a.sales_rep_id = s.id
JOIN orders o
ON a.id = o.account_id
GROUP BY 1
HAVING SUM(o.total_amt_usd) 
	= (SELECT MAX(total_amt) 
	   FROM (SELECT r.name region, SUM(o.total_amt_usd) total_amt 
			FROM region r
			JOIN sales_reps s
			ON r.id = s.region_id
			JOIN accounts a
			ON a.sales_rep_id = s.id
			JOIN orders o
			ON a.id = o.account_id 
			GROUP BY 1) sub);
			

/* Question 3: How many accounts had more total purchases than the account name 
which has bought the most standard_qty paper throughout their lifetime as a customer? */

SELECT COUNT(*)
FROM (SELECT a.name
	FROM accounts a
	JOIN orders o
	ON a.id = o.account_id
	GROUP BY 1
	HAVING SUM(o.total) > (SELECT total_purchases
		FROM(SELECT a.name, SUM(o.standard_qty) standard_qty, SUM(o.total) total_purchases
		   FROM orders o
		   JOIN accounts a
		   ON o.account_id = a.id
		   GROUP BY 1
		   ORDER BY 2 DESC
		   LIMIT 1) t1 )
	 ) t2;
	

/* Question 4: For the customer that spent the most (in total over their lifetime as a customer) total_amt_usd, 
how many web_events did they have for each channel? */

SELECT a.name, w.channel, COUNT(*) web_events_count
FROM accounts a
JOIN web_events w
ON a.id = w.account_id 
WHERE a.id = (SELECT id
	FROM (SELECT a.id AS id, a.name, SUM(o.total_amt_usd) total_spent
		FROM orders o
		JOIN accounts a
		ON a.id = o.account_id
		GROUP BY 1, 2
		ORDER BY 3 DESC
		LIMIT 1))
GROUP BY 1,2
ORDER BY 3 DESC;


/* Question 5:  What is the lifetime average amount spent in terms of total_amt_usd 
for the top 10 total spending accounts? */

SELECT AVG(total_spent)
FROM (SELECT a.id, a.name, SUM(o.total_amt_usd) total_spent
		FROM accounts a
		JOIN orders o
		ON o.account_id = a.id
		GROUP BY 1,2
		ORDER BY 3 DESC
		LIMIT 10) t1;


/* Question 6: What is the lifetime average amount spent in terms of total_amt_usd, 
including only the companies that spent more per order, on average, than the average 
of all orders. */

SELECT AVG(above_avg)
FROM (SELECT a.name, AVG(total_amt_usd) above_avg
	FROM accounts a
	JOIN orders o
	ON a.id = o.account_id
	GROUP BY 1
	HAVING AVG(total_amt_usd) > (SELECT AVG(total_amt_usd) avg_spent_overall
		FROM orders)
	 )



-------------------------------------------------------------------------------------------


-- Subqueries (4.3) --

SELECT channel,
	AVG(event_count) AS avg_event_count
FROM
(SELECT DATE_TRUNC('day', occurred_at) AS day,
	channel,
	COUNT(*) AS event_count
FROM web_events
GROUP BY 1,2) sub
GROUP BY 1
ORDER BY 2 DESC;
-- Returns the average number of events for each day for each channel.
	-- The subquery provides the the first table: the number of events for each channel on each day.
	-- The outer query runs across the result set of the inner query to average these values together, in a second query.
-- The inner query has to be able to run on it's own; the inner query acts as one table in the FROM clause of the outer query.

SELECT COUNT(*) num_events, channel, DATE_PART('day', occurred_at) AS day
FROM web_events
GROUP BY 2,3
ORDER BY day;
-- Counts the total number of events that occurred on each day for each channel, ordered by day number.

SELECT DATE_TRUNC('day',occurred_at) AS day,
       channel, COUNT(*) as events
FROM web_events
GROUP BY 1,2
ORDER BY 3 DESC;
-- Counts the total number of events that occurred on each day for each channel - sorted by day and channel combinations with with the greatest total number events to day and channel combinations with the least total number of events.
	-- Same as previous query, but uses DATE_TRUNC rather than DATE_PART (and slightly different syntax - from solutions page).
SELECT *
FROM (SELECT DATE_TRUNC('day',occurred_at) AS day,
                channel, COUNT(*) as events
          FROM web_events 
          GROUP BY 1,2
          ORDER BY 3 DESC) sub;
-- This query simply returns all the data from the subquery. 
	-- wraps subquery in parenthesis and sticks in the FROM clause of the outer query.
	-- Gives the subquery an alias, "sub"
	-- includes a * in outer SELECT statement 

SELECT channel, AVG(events) AS average_events
FROM (SELECT DATE_TRUNC('day',occurred_at) AS day,
                channel, COUNT(*) as events
         FROM web_events 
         GROUP BY 1,2) sub
GROUP BY channel
ORDER BY 2 DESC;
-- Shows the average number of events a day for each channel.
	-- Since the subquery breaks it out by day, this is giving you the average number of events by channel per day. 


-- Formatting Subqueries (4.5) --

SELECT *
FROM (SELECT DATE_TRUNC('day',occurred_at) AS day,
                channel, COUNT(*) as events
      FROM web_events 
      GROUP BY 1,2
      ORDER BY 3 DESC) sub;
-- Formatting SQL will help you understand your code better when you return to it.
-- When using subqueries, it's important to provide some way to easily determine which parts of the query will be executed together; 
	-- Most people do this by indenting the subquery in some way
	-- Helpful line breaks can also make it easier to read

SELECT *
FROM (SELECT DATE_TRUNC('day',occurred_at) AS day,
                channel, COUNT(*) as events
      FROM web_events 
      GROUP BY 1,2
      ORDER BY 3 DESC) sub
GROUP BY day, channel, events
ORDER BY 2 DESC;
-- Statements part of the same subquery (or query) should be indented to the same levels.
	-- This helps you to easily determine which parts of the query will be executed together.

SELECT DATE_TRUNC('month', MIN(occurred_at)) 
FROM orders;
-- Pulls the first month/year combo from the orders table.


SELECT *
FROM orders
WHERE DATE_TRUNC('month', occurred_at)=
(SELECT DATE_TRUNC('month', MIN(occurred_at)) AS min_month
	FROM orders)
ORDER BY occurred_at;
-- Returns all orders occurring in the same month as the company's first order ever. 
	-- Subquery returns the order month of the company's first order ever.
	-- Outer query then uses the subquery results (the first order month) to filter all orders in the orders table, ordering from earliest to latest order date within that timeframe.

SELECT AVG(standard_qty) standard_avg,
            AVG(gloss_qty) gloss_avg,
            AVG(poster_qty) poster_avg,
            SUM(total_amt_usd) total_spent_all
FROM orders 
WHERE DATE_TRUNC('month', occurred_at) =
(SELECT MIN(DATE_TRUNC('month', occurred_at)) first_order_month
FROM orders)
-- Finds only the orders that took place in the same month and year as the first order, and then pulls the average for each type of paper qty in this month; includes the total amount spent on all orders during this month as well. 


-- Subquery Mania (4.9) -- 
	
-- 1. Provides the name of the sales_rep in each region with the largest amount of total_amt_usd sales. --
	-- Step 1 --
	SELECT s.name rep_name, r.name region_name, SUM(o.total_amt_usd) total_amt
	FROM sales_reps s
	JOIN accounts a
	ON a.sales_rep_id = s.id
	JOIN orders o
	ON o.account_id = a.id
	JOIN region r
	ON r.id = s.region_id
	GROUP BY 1,2
	ORDER BY 3 DESC;
	-- Returns the total sales associated with each sales_rep, along with their names and region. --

	-- Step 2 --
	SELECT region_name, MAX(total_amt) total_amt
        FROM(SELECT s.name rep_name, r.name region_name, SUM(o.total_amt_usd) total_amt
                FROM sales_reps s
                JOIN accounts a
                ON a.sales_rep_id = s.id
                JOIN orders o
                ON o.account_id = a.id
                JOIN region r
                ON r.id = s.region_id
                GROUP BY 1, 2) t1
        GROUP BY 1;
	-- Outer query pulls only the maximum total sales for each region from the previous results. --
	-- sales_rep is NOT pulled in this outer query, because it would group results by unique sales_rep again - which would return all the entries that we filtered out. -- 
		-- each sales_rep is only included one time with their maximum total sales in the first query, so they would all be considered maxs in the second query.

	-- Step 3: Final Solution --
	SELECT t3.rep_name, t3.region_name, t3.total_amt
	FROM(SELECT region_name, MAX(total_amt) total_amt
		FROM(SELECT s.name rep_name, r.name region_name, SUM(o.total_amt_usd) total_amt
			FROM sales_reps s
			JOIN accounts a
			ON a.sales_rep_id = s.id
			JOIN orders o
			ON o.account_id = a.id
			JOIN region r
			ON r.id = s.region_id
			GROUP BY 1, 2) t1
		GROUP BY 1) t2
	JOIN (SELECT s.name rep_name, r.name region_name, SUM(o.total_amt_usd) total_amt
		FROM sales_reps s
		JOIN accounts a
		ON a.sales_rep_id = s.id
		JOIN orders o
		ON o.account_id = a.id
		JOIN region r
		ON r.id = s.region_id
		GROUP BY 1,2
		ORDER BY 3 DESC) t3
	ON t3.region_name = t2.region_name AND t3.total_amt = t2.total_amt;
	-- Is matching the results from the first and second query (t2) back to the results of the first table (t3 - essentially a second version of t1), 
		-- We are joining where the regions match AND the Max sales in t2 are equal to rows in t3; this will also pull the representatives associated with that max sale for that region.
	


-- 2. Finds how many total orders were placed for the region with the largest sales. --

	-- Step 1 --
	SELECT r.name region_name, SUM(o.total_amt_usd) total_amt
	FROM sales_reps s
	JOIN accounts a
	ON a.sales_rep_id = s.id
	JOIN orders o
	ON o.account_id = a.id
	JOIN region r
	ON r.id = s.region_id
	GROUP BY r.name;
	-- Finds the total sum of sales per region.

	-- Step 2 --
	SELECT MAX(total_amt)
	FROM (SELECT r.name region_name, SUM(o.total_amt_usd) total_amt
	                FROM sales_reps s
	                JOIN accounts a
	                ON a.sales_rep_id = s.id
	                JOIN orders o
	                ON o.account_id = a.id
	                JOIN region r
	                ON r.id = s.region_id
	                GROUP BY r.name) sub;
	-- Selects the region whose total sum of sales is the maximum of all the regions sum of sales.

	-- Step 3: Final Solution --
	SELECT r.name, COUNT(o.total) total_orders
	FROM sales_reps s
	JOIN accounts a
	ON a.sales_rep_id = s.id
	JOIN orders o
	ON o.account_id = a.id
	JOIN region r
	ON r.id = s.region_id
	GROUP BY r.name
	HAVING SUM(o.total_amt_usd) = (
	         SELECT MAX(total_amt)
	         FROM (SELECT r.name region_name, SUM(o.total_amt_usd) total_amt
	                 FROM sales_reps s
	                 JOIN accounts a
	                 ON a.sales_rep_id = s.id
	                 JOIN ord
	                 ON o.account_id = a.id
	                 JOIN region r
	                 ON r.id = s.region_i
	                 GROUP BY r.name) t1);

-- Returns the name and total orders placed for the region whose total sum of sales is the MAXIMUM of all regions total sums of sales.
-- t1: each region next to their total sum of sales (4 in total)
-- HAVING: filters down to only the row with highest sum of sales (from t1 results)
-- Outer query: returns the region name and count of total orders for the region with the highest sum of sales.


-- 3. Returns the number of accounts that had more total purchases than the account with the most standard_qty of paper purchased overall. --

	-- Step 1 -- 
	SELECT a.name account_name, SUM(o.standard_qty) total_std, SUM(o.total) total
	FROM accounts a
	JOIN orders o
	ON o.account_id = a.id
	GROUP BY 1
	ORDER BY 2 DESC
	LIMIT 1;
	-- Finds the account with the most standard_qty of paper purchased; also returns the total amount of paper that account purchased in general.

	-- Step 2 -- 
	SELECT a.name
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
	                            LIMIT 1) sub);
	-- Returns just the accounts with more total paper purchased in general than the account with the most standard_qty of paper purchased.

	-- Step 3: Final Solution --
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
	-- Counts all the rows returned for accounts purchasing more total paper than the account that purchased the most total standard paper. 

-- 4. Finds how many web events the customer who spent the most on orders had on each channel. --

	-- Step 1 -- 
	SELECT a.id, a.name, SUM(o.total_amt_usd) tot_spent
	FROM orders o
	JOIN accounts a
	ON a.id = o.account_id
	GROUP BY a.id, a.name
	ORDER BY 3 DESC
	LIMIT 1;
	--- Finds the customer with the most spent in lifetime value. 

	-- Step 2: Final Solution --
	SELECT a.name, w.channel, COUNT(*)
	FROM accounts a
	JOIN web_events w
	ON a.id = w.account_id AND a.id =  (SELECT id
	                        FROM (SELECT a.id, a.name, SUM(o.total_amt_usd) tot_spent
	                              FROM orders o
	                              JOIN accounts a
	                              ON a.id = o.account_id
	                              GROUP BY a.id, a.name
	                              ORDER BY 3 DESC
	                              LIMIT 1) inner_table)
	GROUP BY 1, 2
	ORDER BY 3 DESC;
	-- For the account with an account id equal to the one that spent the most on orders, the total number of web events per channel is calculated.
		-- An ORDER BY was added for no real reason.
		-- The account name was added to assure only one account was pulled.



-- 5. Finds the lifetime average amount spent (in total_amt_usd) for the top 10 total spending accounts. --

	-- Step 1 -- 
	SELECT a.id, a.name, SUM(o.total_amt_usd) tot_spent
	FROM orders o
	JOIN accounts a
	ON a.id = o.account_id
	GROUP BY a.id, a.name
	ORDER BY 3 DESC
	LIMIT 10;
	-- First, we just want to find the top 10 accounts in terms of highest total_amt_usd.

	-- Step 2 -- 
	SELECT AVG(tot_spent)
	FROM (SELECT a.id, a.name, SUM(o.total_amt_usd) tot_spent
	        FROM orders o
	        JOIN accounts a
	        ON a.id = o.account_id
	        GROUP BY a.id, a.name
	        ORDER BY 3 DESC
	        LIMIT 10) temp;
	-- Now, we just want the average of these 10 amounts.


-- 6. Finds the lifetime average amount spent (in total_amt_usd) just for the companies that spent more per order, on average, than the average of all orders. --

	-- Step 1 --
	SELECT AVG(o.total_amt_usd) avg_all 
	FROM orders o 
	-- First, we want to pull the average of all accounts in terms of total_amt_usd.
	
	-- Step 2 --
	SELECT o.account_id, AVG(o.total_amt_usd) 
	FROM orders o 
	GROUP BY 1 
	HAVING AVG(o.total_amt_usd) > 
		(SELECT AVG(o.total_amt_usd) avg_all FROM orders o); 
	-- Then, we want to only pull the accounts with more than this average amount.
	
	-- Step 3 --
	SELECT AVG(avg_amt) 
	FROM (SELECT o.account_id, AVG(o.total_amt_usd) avg_amt 
		FROM orders o 
		GROUP BY 1 
		HAVING AVG(o.total_amt_usd) > 
			(SELECT AVG(o.total_amt_usd) avg_all FROM orders o)) temp_table; 

	-- Finally, we just want the average of these values. 


-------------------------------------------------------------------------------------------


-- WITH (or CTE: Common Table Expressions) (4.11) --

	-- Comparison of subquery and CTE to solve the same problem. --
	-- Finds the average number of events per day in each marketing channel. --

	-- 1. Subquery --
	SELECT channel,
		AVG(event_count) AS avg_event_count
	FROM
	(SELECT DATE_TRUNC('day', occurred_at) AS day,
		channel,
		COUNT(*) AS event_count
		FROM web_events
	GROUP BY 1,2
	)sub
	GROUP BY 1
	ORDER BY 2 DESC;
	-- This query uses a subquery to find the average number of events per day in each marketing channel. 	
	-- One problem with subqueries is they can make your queries lengthy and difficult to read.


	-- 2. CTE --
	WITH events AS ( SELECT DATE_TRUNC('day', occurred_at) AS day,
		channel,
		COUNT(*) AS event_count
		FROM web_events
	GROUP BY 1,2)
		
	SELECT channel,
		AVG(event_count) AS avg_event_count
	FROM events
	GROUP BY 1
	ORDER BY 2 DESC;
	-- The subquery from the query above is broken out into its own common table expression (CTE).
		-- Common Table Expressions (CTEs) serve the same purpose as subqueries but are more common in practice and cleaner for a future reader to follow the logic. 
		-- The CTE is created using the WITH command
		-- CTEs need to be defined at the beginning of the query in order to use them in our final query at the bottom
		-- CTEs need to be given aliases just like subqueries (ex. events)

/* 5.11 WITH (CTE)
-------------------------
The WITH statement is often called a Common Table Expression or CTE. 
Though these expressions serve the exact same purpose as subqueries, 
they are more common in practice, as they tend to be cleaner for a 
future reader to follow the logic. */

/* QUESTION: You need to find the average number of events for each channel per day. 


Subquery Solution: */
-------------------------------
SELECT channel, AVG(events) AS average_events
FROM (SELECT DATE_TRUNC('day',occurred_at) AS day,
             channel, COUNT(*) as events
      FROM web_events 
      GROUP BY 1,2) sub
GROUP BY channel
ORDER BY 2 DESC;


/* WITH Solution (CTE) */
----------------------------------
WITH events AS (
SELECT DATE_TRUNC('day',occurred_at) AS day,
	 channel, COUNT(*) as events
FROM web_events 
GROUP BY 1,2 )


SELECT channel, AVG(events) AS average_events
FROM events
GROUP BY channel
ORDER BY 2 DESC;

/*  1. First, we pull the inner query. This is the part we put in the WITH statement. 
	We are aliasing the table as "events."

	2. Then, we can use this newly created events table as if it is any other 
	table in our database.



CTEs using multiple tables:  
----------------------------------
Above, we don't need anymore than the one additional table, but imagine 
we needed to create a second table to pull from. 

We can create an additional table to pull from in the following way. */

WITH table1 AS (
          SELECT *
          FROM web_events),

     table2 AS (
          SELECT *
          FROM accounts)

SELECT *
FROM table1
JOIN table2
ON table1.account_id = table2.id;

/* - When creating multiple tables using WITH, you add a comma after every table 
except the last table leading to your final query.
	
- The new table name is always aliased using table_name AS, which is followed 
by your query nested between parentheses. 



5.13 Quiz: WITH
---------------------------
Question 1: Provide the name of the sales_rep in each region with the largest 
amount of total_amt_usd sales. */

WITH t1 AS (
	SELECT s.name rep, r.name region, SUM(o.total_amt_usd) sum_of_sales
	FROM orders o
	JOIN accounts a
	ON o.account_id = a.id
	JOIN sales_reps s
	ON s.id = a.sales_rep_id
	JOIN region r
	ON r.id = s.region_id
	GROUP BY 1,2),
	-- The sales rep, region name and total sales in total_amt_usd for that sales rep in that region.
t2 AS (
	SELECT region, MAX(sum_of_sales) max_sales
	FROM t1
	GROUP BY 1)
	-- selects the region and largest total sales found in t1. 
SELECT t1.rep, t1.region, t1.sum_of_sales
FROM t1
JOIN t2
ON t2.max_sales = t1.sum_of_sales AND t1.region = t2.region;
/* The sales rep, region and total sales in total_amt_usd from t1
but only for rows where the total sales in t1 equals max sales value in t2 
and the region names are the same.


Question 2: For the region with the largest sales total_amt_usd, 
how many total orders were placed? */

WITH t1 AS (
      SELECT r.name region_name, SUM(o.total_amt_usd) total_amt
      FROM sales_reps s
      JOIN accounts a
      ON a.sales_rep_id = s.id
      JOIN orders o
      ON o.account_id = a.id
      JOIN region r
      ON r.id = s.region_id
      GROUP BY r.name), 
	-- Each region and their total sales in total_amt_usd.
t2 AS (
      SELECT MAX(total_amt)
      FROM t1)
	-- Selects the largest total in total_amt_usd sales from the first table.
SELECT r.name, COUNT(o.total) total_orders
FROM sales_reps s
JOIN accounts a
ON a.sales_rep_id = s.id
JOIN orders o
ON o.account_id = a.id
JOIN region r
ON r.id = s.region_id
GROUP BY r.name
HAVING SUM(o.total_amt_usd) = (SELECT * FROM t2);
-- Each region and their total number of purchases in total.
-- Filters results so they include only rows where sum of sales = the sum in t2.


/* Question 3: How many accounts had more total purchases than the account 
name which has bought the most standard_qty paper throughout their lifetime as a customer? */

WITH t1 AS (
	SELECT a.name account, SUM(o.standard_qty) standard_qty, SUM(o.total) total_qty
	FROM accounts a
	JOIN orders o
	ON a.id = o.account_id
	GROUP BY 1
	ORDER BY 2 DESC
	LIMIT 1),
	-- the account that bought the most standard_qty paper.
t2 AS (
	SELECT a.name
	FROM accounts a
	JOIN orders o
	ON a.id = o.account_id
	GROUP BY 1
	HAVING SUM(o.total) > (SELECT total_qty FROM t1))
	-- all account names with greater total purchases than the account with the most standard purchases.
SELECT COUNT(*)
FROM t2;
-- counts how many of these accounts there are.


/* Question 4: For the customer that spent the most (in total over their lifetime as a customer) 
total_amt_usd, how many web_events did they have for each channel? */

WITH t1 AS (
      SELECT a.id id, a.name, SUM(o.total_amt_usd) tot_spent
      FROM orders o
      JOIN accounts a
      ON a.id = o.account_id
      GROUP BY a.id, a.name
      ORDER BY 3 DESC
      LIMIT 1)
	-- Account id, name, and total sales for account with the largest total sales. 
SELECT a.name, w.channel, COUNT(*)
FROM accounts a
JOIN web_events w
ON a.id = w.account_id AND a.id = (SELECT id FROM t1)
GROUP BY 1, 2
ORDER BY 3 DESC;
/* The account name, channels, and total count of events per channel for the account whose id matches 
both the id found in t1 and the id found in the web_events table. */


/* Question 5: What is the lifetime average amount spent in terms of total_amt_usd for the top 10 total spending accounts? */ 

WITH t1 AS (
      SELECT a.id, a.name, SUM(o.total_amt_usd) tot_spent
      FROM orders o
      JOIN accounts a
      ON a.id = o.account_id
      GROUP BY a.id, a.name
      ORDER BY 3 DESC
      LIMIT 10)
	-- Account ids, account names, and sums of sales for top 10 accounts with the highest total sales.
SELECT AVG(tot_spent)
FROM t1;
-- Finds the average for all sums of sales found in t1. 


/* Question 6: What is the lifetime average amount spent in terms of total_amt_usd, including 
only the companies that spent more per order, on average, than the average of all orders. */

WITH t1 AS ( 
	SELECT AVG(o.total_amt_usd) avg_all 
	FROM orders o 
	JOIN accounts a 
	ON a.id = o.account_id),
	-- Finds the average of all orders.
t2 AS (SELECT o.account_id, AVG(o.total_amt_usd) avg_amt 
	FROM orders o 
	GROUP BY 1 
	HAVING AVG(o.total_amt_usd) > (SELECT * FROM t1)) 
	/* Selects the account ids and averages spent per order for only accounts where  
	the average spent per order is greater than the average of all orders, in t1)) */
SELECT AVG(avg_amt) FROM t2;
-- Returns the average all averages spent per order found in t2.


---------------------------------------------------------------------------------

/* 4.3: Write your first subquery. 

Whenever we need to use existing tables to create a new table that we then want to query again, 
this is an indication that we will need to use some sort of subquery. 

Question: Which channels send the most traffic per day on average? 

1. First, query the underlying to table to make sure the data makes sense for what you are trying to do. */ 

SELECT *
FROM web_events;

/* 2. Next, count up all the events by each channel by each day. */

SELECT DATE_TRUNC('day', occurred_at) AS day,
	channel, 
	COUNT(*) AS event_count
FROM web_events
GROUP BY 1,2
ORDER BY 1;

/* 3. The last step is to average across the events column that we created. 

In order to do that, we need to query against the results of this query. 

We do that by wrapping the query in parentheses and using it in the FROM
clause of the next query. */

SELECT *
FROM
(SELECT DATE_TRUNC('day', occurred_at) AS day,
		channel, 
		COUNT(*) AS event_count
	FROM web_events
	GROUP BY 1,2
	ORDER BY 1) sub

/* It is now a query within a query, also known as a subquery. 

Subqueries are required to have aliases, which are added after the parentheses - 
the same way you would add an alias to a table. 

Here we are just selecting all the data from the subquery. 

Let's go the last mile and average events per each channel. */

SELECT channel
FROM AVG (event_count) AS avg_event_count
(SELECT DATE_TRUNC('day', occurred_at) AS day,
		channel, 
		COUNT(*) AS event_count
	FROM web_events
	GROUP BY 1,2
) sub
GROUP BY 1
ORDER BY 2 DESC

/* Since the subquery acts as one table in the FROM clause, we'll put a GROUP BY 
clause after the subquery. 

Since we'll now reorder on the new aggregation in this query, we no longer need 
the ORDER BY statement in the subquery so we take it out to keep things clean. 

Since you broke out by day earlier, this is giving you an average per day.

To keep things clear, let's break down how this new query runs:

1. First the inner query will run. The inner query must run on it's own as
the database will treat it as an independent query.

2. Once your inner query is complete, the rest of the query, also known as the outer query,
will run across the result set created by the inner query.

	Note: A nice feature that many SQL editors share is the ability to highlight a portion 
	of the query and run only that portion. This is especially helpful when making changes 
	to an inner query.


4.6: More on Subqueries. 

In the first subquery you wrote, you created a table that you could then query again 
in the FROM statement. 

However, if you are only returning a single value, you might use that value in a 
logical statement like WHERE, HAVING, or even SELECT - the value could be nested
within a CASE statement.

Note that you should not include an alias when you write a subquery in a conditional statement. 
This is because a subquery in conditional logic is treated as an individual value (or set of values in the IN case) 
rather than as a table.

If we had returned an entire column IN would need to be used to perform a logical argument. 


If we are returning an entire table, then we must use an ALIAS for the table, 
and perform additional logic on the entire table.

Subqueries can be used anywhere you might use a table name, column name, or individual value.
They're especially useful using conditional logic, in conjunction with WHERE or JOIN clauses, 
or in the WHEN portion of a CASE statement.

Question: Return only orders that occurred in the same month as the company's first order ever. */

SELECT *
FROM orders;

/* 1. To get the date of the first order, you can write a subquery with a MIN function. */

SELECT MIN(occurred_at) AS min
FROM orders;

/* DATE_TRUNC is added below to get the month. */

SELECT DATE_TRUNC('month', MIN(occurred_at)) AS min_month
FROM orders;

/* Finally, let's write an outer query that uses this to filter the orders table
 and sorts by the occurred_at column. */

SELECT *
FROM orders
WHERE DATE_TRUNC('month', occurred_at) =
	(SELECT DATE_TRUNC('month', MIN(occurred_at)) AS min_month
	FROM orders)
	ORDER BY occurred_at;

/* This query works because the result of the subquery is only one cell. 
Most conditional logic will work with subqueries containing one-cell results. 

IN is the only type of conditonal logic that will work when the inner query
contains multiple results. 


Now let's try using the results of the previous query to also find the average 
for each type of paper qty in the month of the first order and the total amount 
spent on all orders in the month of the first order. */

SELECT AVG(gloss_qty) avg_gloss_qty,
	AVG(standard_qty) avg_standard_qty,
	AVG (poster_qty) avg_poster_qty,
	SUM(total_amt_usd) total_spent
FROM (SELECT *
	FROM orders
	WHERE DATE_TRUNC('month', occurred_at) =
		(SELECT DATE_TRUNC('month', MIN(occurred_at)) AS min_month
		FROM orders)
		ORDER BY occurred_at) sub;


/* 4.9 Quiz: Subquery Mania
--------------------------------

Question 1: Provide the name of the sales_rep in each region with the 
largest amount of total_amt_usd sales. */

SELECT t3.rep, t2.region, t2.max_sales
FROM (SELECT region, MAX(total_rep_sales) max_sales
		FROM 
		(SELECT s.name rep, r.name region, SUM(o.total_amt_usd) total_rep_sales
		FROM orders o
		JOIN accounts a
		ON o.account_id = a.id
		JOIN sales_reps s
		ON s.id = a.sales_rep_id
		JOIN region r
		ON r.id = s.region_id
		GROUP BY 1,2) t1
	GROUP BY 1) t2
JOIN
	(SELECT s.name rep, r.name region, SUM(o.total_amt_usd) total_rep_sales
	FROM orders o
	JOIN accounts a
	ON o.account_id = a.id
	JOIN sales_reps s
	ON s.id = a.sales_rep_id
	JOIN region r
	ON r.id = s.region_id
	GROUP BY 1,2
	ORDER BY 3 DESC) t3
ON t3.region = t2.region AND t3.total_rep_sales = t2.max_sales;

/* GROUP BY is not needed in the outer query because all aggregations were
already performed in the inner queries.

Table names are not defined for columns in t2 because the inner query 
has already fully run, so these variables are already defined. 

rep name is not returned to t2 because this would group results so they're
totals unique for each rep IN each region - you'd just get all the same rows 
from t1 back again, because sales rep names are already aggregated to appear 
only once there.

	This is also t2 had to be joined with a second copy of t1 - 
	to give you back the sales rep name associated with the Maxs
	for each region.
*/ 



/* Question 2: For the region with the largest (sum) of sales total_amt_usd, 
how many total (count) orders were placed? */

SELECT t1.region, SUM(o.total_amt_usd), COUNT(o.total_amt_usd) orders_count
FROM orders o
JOIN accounts a
ON o.account_id = a.id
JOIN sales_reps s
ON s.id = a.sales_rep_id
JOIN region r
ON r.id = s.region_id
HAVING SUM(o.total_amt_usd) = 

SELECT r.name region, SUM(o.total_amt_usd), COUNT(o.total_amt_usd) orders_count
FROM region r
JOIN sales_reps s
ON r.id = s.region_id
JOIN accounts a
ON a.sales_rep_id = s.id
JOIN orders o
ON a.id = o.account_id
GROUP BY 1
HAVING SUM(o.total_amt_usd) 
	= (SELECT MAX(total_amt) 
	   FROM (SELECT r.name region, SUM(o.total_amt_usd) total_amt 
			FROM region r
			JOIN sales_reps s
			ON r.id = s.region_id
			JOIN accounts a
			ON a.sales_rep_id = s.id
			JOIN orders o
			ON a.id = o.account_id 
			GROUP BY 1) sub);
			

/* Question 3: How many accounts had more total purchases than the account name 
which has bought the most standard_qty paper throughout their lifetime as a customer? */

SELECT COUNT(*)
FROM (SELECT a.name
	FROM accounts a
	JOIN orders o
	ON a.id = o.account_id
	GROUP BY 1
	HAVING SUM(o.total) > (SELECT total_purchases
		FROM(SELECT a.name, SUM(o.standard_qty) standard_qty, SUM(o.total) total_purchases
		   FROM orders o
		   JOIN accounts a
		   ON o.account_id = a.id
		   GROUP BY 1
		   ORDER BY 2 DESC
		   LIMIT 1) t1 )
	 ) t2;
	

/* Question 4: For the customer that spent the most (in total over their lifetime as a customer) total_amt_usd, 
how many web_events did they have for each channel? */

SELECT a.name, w.channel, COUNT(*) web_events_count
FROM accounts a
JOIN web_events w
ON a.id = w.account_id 
WHERE a.id = (SELECT id
	FROM (SELECT a.id AS id, a.name, SUM(o.total_amt_usd) total_spent
		FROM orders o
		JOIN accounts a
		ON a.id = o.account_id
		GROUP BY 1, 2
		ORDER BY 3 DESC
		LIMIT 1))
GROUP BY 1,2
ORDER BY 3 DESC;


/* Question 5:  What is the lifetime average amount spent in terms of total_amt_usd 
for the top 10 total spending accounts? */

SELECT AVG(total_spent)
FROM (SELECT a.id, a.name, SUM(o.total_amt_usd) total_spent
		FROM accounts a
		JOIN orders o
		ON o.account_id = a.id
		GROUP BY 1,2
		ORDER BY 3 DESC
		LIMIT 10) t1;


/* Question 6: What is the lifetime average amount spent in terms of total_amt_usd, 
including only the companies that spent more per order, on average, than the average 
of all orders. */

SELECT AVG(above_avg)
FROM (SELECT a.name, AVG(total_amt_usd) above_avg
	FROM accounts a
	JOIN orders o
	ON a.id = o.account_id
	GROUP BY 1
	HAVING AVG(total_amt_usd) > (SELECT AVG(total_amt_usd) avg_spent_overall
		FROM orders)
	 )
