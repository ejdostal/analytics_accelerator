
-- Ch 5: SQL Subqueries & CTEs --
/*
- Subqueries are also known as inner queries or nested queries. 
- Whenever we need to use existing tables to create a new table that we then want to query again, this is an indication that we will need to use some sort of subquery.
- Statements part of the same subquery (or query) should be indented to the same levels. This helps you to easily determine which parts of the query will be executed together.
- Subqueries are required to have aliases, which are added after the parentheses (the same way you would add an alias to a table).  
- Many SQL editors share an  ability to highlight a portion of the query and then run only that portion. This is especially helpful when making changes 
to an inner query. You can make the change, then quickly change the inner queries output to make sure it looks correct before running the outer query again.     */


-- Subqueries (5.2) --

-- Which channels send the most traffic per day on average? --

	SELECT DATE_TRUNC('day', occurred_at) AS day,
	channel, 
	COUNT(*) AS event_count
	FROM web_events
	GROUP BY 1,2
	ORDER BY 1;
	-- a. Counts up all the events in each channel on each day.
	-- First, the inner query runs. 
	-- The inner query must run on it's own as the database will treat it as an independent query.

	SELECT *
	FROM
	(SELECT DATE_TRUNC('day', occurred_at) AS day,
		channel, 
		COUNT(*) AS event_count
		FROM web_events
		GROUP BY 1,2
		ORDER BY 1) sub
	-- b. Selects all the data from the "sub" subquery.
	-- Once your inner query is complete, the rest of the query (the outer query) runs across the result set created by the inner query.

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
	-- c. Gives a table showing the average number of events a day for each channel (answer).
	-- Since we broke out by day earlier in the subquery, this this gives you an average per day.


-- Subquery Formatting (5.5) --
/* 
- The important thing to remember when using subqueries is to provide some way for the reader to easily determine 
which parts of the query will be executed together. Most people do this by indenting the subquery in some way 
-  Make sure that parts of the query that run together are indented to the same level. */


-- Subqueries - Part 2 (5.6) --
/* 
- Subqueries can essentially be used anywhere you might use a table name, column name, or individual value.
	- Use a subquery in the FROM clause to create a table and then query again from the results of that table.
	- If you are only returning a single value, you can use a subquery in a logical statement like WHERE, HAVING, or even SELECT - the value could be nested within a CASE statement in the WHEN portion.
	- If the subquery returns an entire column, IN would need to be used to perform a logical argument. 
- You should NOT include an alias when you write a subquery in a conditional statement. This is because the subquery is treated as an individual value (or set of values in the IN case) rather than as a table.
- You should include an alias when you write a subquery that returns an entire table. Then you'll need to perform additional logic on that table. 
- Subqueries are especially useful using conditional logic, in conjunction with WHERE or JOIN clauses, and in the WHEN portion of a CASE statement. */

-- Return only orders that occurred in the same month as the company's first order ever. --

	SELECT MIN(occurred_at) AS min
	FROM orders;
	-- a. Gets the date of the first order ever.
		
	SELECT DATE_TRUNC('month', MIN(occurred_at)) AS min_month
	FROM orders;
	-- b. Gets the month (and year) of the first order ever.

	SELECT *
	FROM orders
	WHERE DATE_TRUNC('month', occurred_at) =
		(SELECT DATE_TRUNC('month', MIN(occurred_at)) AS min_month
		FROM orders)
	ORDER BY occurred_at;
	-- c. Outer query uses the month (and year) returned by the subquery to filter the results of the orders table (answer).
	-- Most conditional logic will work with subqueries containing one-cell results. 
	-- IN is the only type of conditonal logic that will work when the inner query contains multiple results. 

-- Find the average qunatity sold for each paper type during the same month (and year) as the very first order. --

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
-- c. Averages the quantities sold of each paper type during the same month (and year) of the very first order ever (answer).


-- Subquery Mania (5.9) --

-- Provide the name of the sales representative in each region that has the largest amount of total sales. --

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
	-- a. Returns each sales rep name, region, and the total sum of sales associated with that sales rep in that region.

	SELECT region_name, MAX(total_amt) total_amt
    FROM(SELECT s.name rep_name, r.name region_name, SUM(o.total_amt_usd) total_amt
		FROM sales_reps s
		JOIN accounts a
		ON a.sales_rep_id = s.id
		JOIN orders o
		ON o.account_id = a.id
		JOIN region r
		ON r.id = s.region_id
		GROUP BY 1, 2
		) t1
	GROUP BY 1;
	/*
	b. Outer query pulls the results of the previous query (t1) using the FROM clause. Only the region name and the max amount of total sales per region (found in the total_amt column in the t1 table) are returned (4 results for 4 regions).
	- Notice how the sales rep name isn't pulled here. That's because each sales rep name is unique in the t1 table (it only appears once).
	- Including sales rep name in the grouping would just return the max amount of total sales associated with EVERY sales rep name within EVERY unique region - 
	essentially returning ALL the values from t1 anyway. */

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
	/*
	c. Results from the previous outer query and subquery combined become "t2" and is pulled from in the FROM clause of an outer query. 
	- The new outer query (with "t2" in the FROM clause) is then joined with a duplicate copy of the original t1 table (now named "t3"). Rows are only joined if region name AND total sum of sales match between both rows.
	- The max sum of sales for each region and the corresponding region name are now pulled out again in the SELECT statement of the outer query from the results of "t2".
	- The corresponding sales rep name associated with each of the max sales in each region is now also pulled back out, from the results of the JOIN between "t2" and "t3" (the duplicate of "t1"). 
	- Table names are not defined for columns in "t2" because the inner query has already fully run, so these variables are already defined. */

-- For the region with the largest (sum of) sales in USD, how many total (count) orders were placed? --

	SELECT r.name region_name, SUM(o.total_amt_usd) total_amt
	FROM sales_reps s
	JOIN accounts a
	ON a.sales_rep_id = s.id
	JOIN orders o
	ON o.account_id = a.id
	JOIN region r
	ON r.id = s.region_id
	GROUP BY r.name;
	-- a. Finds the total sum of sales for each region.

	SELECT MAX(total_amt)
	FROM (SELECT r.name region_name, SUM(o.total_amt_usd) total_amt
		FROM sales_reps s
		JOIN accounts a
		ON a.sales_rep_id = s.id
		JOIN orders o
		ON o.account_id = a.id
		JOIN region r
		ON r.id = s.region_id
		GROUP BY r.name) t1;
	-- b. Pulls the highest value found the total_amt column from "t1" (previous query). (the highest total sales found out of all the regions)

	SELECT r.name, COUNT(o.total) total_orders
	FROM sales_reps s
	JOIN accounts a
	ON a.sales_rep_id = s.id
	JOIN orders o
	ON o.account_id = a.id
	JOIN region r
	ON r.id = s.region_id
	GROUP BY r.name
	HAVING SUM(o.total_amt_usd) 
	= (SELECT MAX(total_amt)
		FROM (SELECT r.name region_name, SUM(o.total_amt_usd) total_amt
				FROM sales_reps s
				JOIN accounts a
				ON a.sales_rep_id = s.id
				JOIN ord
				ON o.account_id = a.id
				JOIN region r
				ON r.id = s.region_id
				GROUP BY r.name
				) 
		t1);
	-- c. Returns the region name and total count of orders for the region that returned the highest sum of sales in "t1" (answer).
			
-- How many accounts had more total purchases than the account that bought the most standard_qty of paper during their lifetime as a customer? --

	SELECT a.name account_name, SUM(o.standard_qty) total_std, SUM(o.total) total
	FROM accounts a
	JOIN orders o
	ON o.account_id = a.id
	GROUP BY 1
	ORDER BY 2 DESC
	LIMIT 1;
	/*
	a. Returns each account, the total quantity of standard paper they bought, and the total sum of their purchases across all paper types.
	- Orders the resulting rows so the quantities of standard paper bought (and their associated information) are ordered from highest to lowest.
	- Limits the results returned to only the first row (the max total standard quantity of paper bought, that account name, and that accounts total sum of purchases). */

	SELECT a.name
	FROM orders o
	JOIN accounts a
	ON a.id = o.account_id
	GROUP BY 1
	HAVING SUM(o.total) > 
		(SELECT total 
		FROM (SELECT a.name act_name, SUM(o.standard_qty) tot_std, SUM(o.total) total
			FROM accounts a
			JOIN orders o
			ON o.account_id = a.id
			GROUP BY 1
			ORDER BY 2 DESC
			LIMIT 1) 
		t1);
	-- b. Returns all account names from "t1" that have a total sum of purchases greater than then total sum of purchases oc the account that had purchased the most standard paper (qty).

	SELECT COUNT(*)
	FROM (SELECT a.name
		FROM orders o
		JOIN accounts a
		ON a.id = o.account_id
		GROUP BY 1
		HAVING SUM(o.total) > 
			(SELECT total 
			FROM (SELECT a.name act_name, SUM(o.standard_qty) tot_std, SUM(o.total) total
				FROM accounts a
				JOIN orders o
				ON o.account_id = a.id
				GROUP BY 1
				ORDER BY 2 DESC
				LIMIT 1) 
			t1)
		) t2;
	-- c. Counts all the accounts returned in "t2" (counts all accounts that had more total purchases across all paper types than the account buying the highest quantity of standard paper).

-- For the customer that spent the most (in total over their lifetime as a customer) total_amt_usd, how many web_events did they have for each channel? --

	SELECT a.id, a.name, SUM(o.total_amt_usd) tot_spent
	FROM orders o
	JOIN accounts a
	ON a.id = o.account_id
	GROUP BY a.id, a.name
	ORDER BY 3 DESC
	LIMIT 1;
	/* 
	a. Returns the account id, account name, and their respective total sum of sales in USD.
	- Returns results in order of account with the largest total sum of sales to smallest.
	- Limits rows to only the first row (the customers that spent the most in USD during their lifetime). */

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
			LIMIT 1) t1)
	GROUP BY 1, 2
	ORDER BY 3 DESC;
	/* 
	c. References the row with the max total sum of sales from the previous query using "t1" in the FROM clause.
	- Outer query joins the accounts table with the web_events table, combining rows only where account ids match between both tables AND those account ids are equal
	to the account id found in "t1". (effectively returning web events only for the account with highest sum of sales)
	- Resulting rows (representing different web events) are then counted and grouped by the channels they occurred in.
	- The account name was added to the grouping in SELECT to help ensure that only one account was pulled. 
	- In other words: for the account with an account id equal to the one that spent the most on orders, the total number of web events per channel is calculated. */

-- What is the lifetime average amount spent in terms of total_amt_usd for the top 10 total spending accounts? --

	SELECT a.id, a.name, SUM(o.total_amt_usd) tot_spent
	FROM orders o
	JOIN accounts a
	ON a.id = o.account_id
	GROUP BY a.id, a.name
	ORDER BY 3 DESC
	LIMIT 10;
	-- a. Finds the total sum of sales in USD for each account, sorted from highest sum of sales to lowest; limited to just the first 10 rows. 

	SELECT AVG(tot_spent)
	FROM (SELECT a.id, a.name, SUM(o.total_amt_usd) tot_spent
		FROM orders o
		JOIN accounts a
		ON a.id = o.account_id
		GROUP BY a.id, a.name
		ORDER BY 3 DESC
		LIMIT 10
		) t1;
	-- b. Selects the 10 rows returned from the previous query using "t1" and averages their total sums of sales from the tot_spent column in "t1". (answer)

-- What is the lifetime average amount spent in terms of total_amt_usd, including only the companies that spent more per order, on average, than the average of all orders. --

	SELECT AVG(o.total_amt_usd) avg_all 
	FROM orders o 
	-- a. Averages the total sum of sales in USD for all orders in the orders table.

	SELECT o.account_id, AVG(o.total_amt_usd) 
	FROM orders o 
	GROUP BY 1 
	HAVING AVG(o.total_amt_usd) > 
		(SELECT AVG(o.total_amt_usd) avg_all 
		FROM orders o); 
	/* b. Returns account id and the average sales in USD across for all of that account's orders, but only including accounts had a higher 
	 average sales than the average sales in USD across all orders. */
	
	SELECT AVG(avg_amt) 
	FROM (SELECT o.account_id, AVG(o.total_amt_usd) avg_amt 
		FROM orders o 
		GROUP BY 1 
		HAVING AVG(o.total_amt_usd) > 
			(SELECT AVG(o.total_amt_usd) avg_all 
			FROM orders o)) t1; 
	/* c. The average sales for each of the top 10 accounts are then average to return the lifetime average of companies that spent more, on average, 
	than the average sales in USD across all orders. */




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
