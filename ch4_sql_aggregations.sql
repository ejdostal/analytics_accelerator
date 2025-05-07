/* SQL Aggregations

Aggregations: These functions operate down columns, not across rows.
- An important thing to remember: aggregators only aggregate vertically - the values of a column. 
- If you want to perform a calculation across rows, you would do this with simple arithmetic.
- Use row-level output for early exploratory work, when searching your database to better understand the data.
- Once you get a since of what the data looks like, aggregates become more helpful in answering your questions.

    COUNT: Counts how many rows are in a table; Helps you to identify the number of Null values in any particular column. 
        - COUNT ignores Nulls.
        - This is why COUNT is used to find which rows that have missing data:
            1. Find total rows in a table: The result produced by a COUNT(*) is typically equally to the number of rows in the table; it's very unusual to have a row that is entirely null. 
            2. Identify the number of Null values in a particular column (or the specific number of rows in column that are not Null) ; COUNT(column_name)
        - The difference between the COUNT(*) and the COUNT of the column is the total number of Nulls in that column.
        - You can use COUNT on non-numerical columns.

    SUM: Adds together all the values in a particular column
        - You can only use SUM of numeric columns.
        - SUM will ignore Nulls; it treats Nulls as 0. 

    MIN / MAX: Return the lowest and highest values in a particular column. 
        - Ignores Null values.
        - Can be used to count numerical values (like COUNT)
        - Depending on the column type, MIN will return the lowest number, earliest date, or non-numerical value as early in the alphabet as possible. 
        - Depending on the column type, MAX will return the highest number, the latest date, or the non-numerical value closest alphabetically to “Z.”

    Average: Returns the mean of the data; the sum of all the values in the column, divided by the number of values in the column; what can we expect to see on regular basis?
       - Can only be used on numerical columns 
        - Ignores Null values completely; Rows with Null values are NOT calculated in the numerator or the denominator when calculating the average. 
            - If you want to count Nulls as 0, you'll need to take a SUM and divide it be the COUNT, rather than using the AVG function. 
    - Note: the Median might be a more appropriate measure of center for data than AVG for data, but finding the Median happens to be a pretty difficult thing to get using SQL alone.

GROUP BY: allows you to create segments that will aggregate independent from one another; in other words, it takes the sum of data limited to each account, rather than across the entire dataset.
- Used to aggregate data within subsets of data (ex. grouping for different accounts, different regions, or different sales representatives.)
- Any column in the SELECT statement that is not within an aggregator must be in the GROUP BY clause.
- The GROUP BY always goes between WHERE and ORDER BY.
- SQL evaluates the aggregations before the LIMIT clause, so you know all data is evaluated for aggregation.
- If you don’t group by any columns, you’ll get a 1-row result; you're aggregating across the entire dataset.
- If you group by a column with enough unique values that it exceeds the LIMIT number, the aggregates will be calculated, and then some rows will simply be omitted from the results.
- Wherever there's a field in the SELECT statement that's not being aggregated, the query expects it to be in the GROUP BY clause; a column that's not aggregated and not in the GROUP BY will return an error.
- If you want to segment your data into even more granular chunks, you can group by multiple columns.  
- You can GROUP BY multiple columns at once. This is often useful to aggregate across a number of different segments.
- GROUP BY and ORDER BY can be used with multiple columns in the same query. 
- The order in the ORDER BY determines which column is ordered on first.  
- You can order DESC for any column in your ORDER BY.
- The order of column names in your GROUP BY clause doesn’t matter—the results will be the same regardless. 
- As with ORDER BY, you can substitute numbers for column names in the GROUP BY clause. 
    - It’s generally recommended to do this only when you’re grouping many columns, or if something else is causing the text in the GROUP BY clause to be excessively long.

DISTINCT:
- always used in SELECT statements
- provides the unique rows for ALL columns written in the SELECT statement (to do this for all columns, use it only once, immediately after SELECT)
- NOTE: DISTINCT can slow your queries down quite a bit, particularly in aggregations.
- if you want to group columns but DON'T need to include aggregations, use DISTINCT instead of GROUP BY.

HAVING:
- anytime you want to perform a WHERE on an element of your query containing an aggregate, you have to using HAVING instead
- HAVING is like WHERE, but it works on logical statements involving aggregations.
- the WHERE clause doesn't allow you to filter on aggregate columns
- a clean way to filter a query that has been aggregated 
- HAVING appears after the GROUP BY clause, but before the ORDER BY clause.
- commonly done using subqueries

- Only useful with aggregates when grouping columns; if there's no grouping, the output is across the entire dataset so its only one line anyway.
    - WHERE subsets the returned data based on a logical condition.
    - WHERE appears after the FROM, JOIN, and ON clauses, but before GROUP BY.

DATE_TRUNC:


DATE PART:    
*/ 


-- NULLS (3.3) --

SELECT *
FROM accounts 
WHERE primary_poc IS NULL;
-- Shows all the accounts for which there are no values in the primary point of contact column. --
    -- If you don't have point of contact, chances are you're not going to be able to keep that customer for much longer. --

SELECT *
FROM accounts 
WHERE primary_poc IS NOT NULL;
-- Finds the inverse of the query above; Returns all rows for which there ARE values in the primary point of contact field. --


-- COUNT (3.4) --

SELECT *
FROM orders
WHERE occurred_at >= '2016-12-01'
AND occurred_at < '2017-01-01';
-- Returns a list of all orders from the month of December 2016
-- Also tells you how many total results there are, in the upper right hand corner. (ex. 463) 

SELECT COUNT(*) AS order_count
FROM orders
WHERE occurred_at >= '2016-12-01'
AND occurred_at >= '2017-01-01';
-- Also returns the total number of rows in the orders table for the month of December 2016 - but as a single numeric value, or aggregation, across the entire dataset. (ex. 463)
    -- The COUNT function returns a count of all the rows containing some non-null data. 
    -- It is very unusual to have a row that is entirely null, so the result produced by a COUNT(*) is typically equal to the number of rows in the table. 
-- COUNT(*) and COUNT(column_name) is particularly useful with GROUP BY.

SELECT COUNT(*) AS account_count
FROM accounts;
-- Finds the total number of rows in the table as a single numeric value, or aggregation. (ex. 354)

SELECT COUNT(id) AS account_count
FROM accounts;
-- Finds the total number of non-null records in the individual id column.
-- Since there are NO non-null values in the id column, it returns the same number of records as COUNT(*). (ex. also 354)

SELECT COUNT(primary_poc) AS account_primary_poc_count
FROM accounts;
-- Finds the total number non-null records in the primary point of contact column. 
-- Since there are 9 non-Null values in the primary_poc_count column, only 345 rows are returned (9 less than the total number of rows in the table).

SELECT *
FROM accounts
WHERE primary_poc IS NULL;
-- Returns a list of the 9 rows with Null values in the primary_poc column; also tells you how many total results there are in the upper right hand corner. (ex. 9) 
-- This verifies there are 9 Null values in the primary_poc column.
    -- Note that the COUNT function can also be used on non-numerical columns.


-- SUM (3.6) --

SELECT SUM(standard_qty) AS standard,
SUM(gloss_qty) AS gloss,
SUM(poster_qty) AS poster
FROM orders;
-- Totals up the sum of all numerical values in each column and then lists them as aggregations, in columns next to each other. 
-- Finds the total quantity of paper sold across all orders for each paper type column.
-- Potentially useful for inventory planning, answers: How much of each paper type should we produce? 

SELECT SUM(poster_qty) AS total_poster_sales
FROM orders;
-- Sums the total amount of poster paper ordered across all orders in the orders table, using the poster_qty column. --  

SELECT SUM(standard_qty) AS total_standard_sales
FROM orders;
-- Sums the total amount of standard paper ordered across all orders in the orders table, using the standard_qty column. --  

SELECT SUM(total_amt_usd) AS total_dollar_sales
FROM orders;
-- Sums the total dollar amount of sales generated across all orders in the orders table, using the total_amt_usd column. --  

SELECT standard_amt_usd + gloss_amt_usd AS standard_glossy_total_amt
FROM orders;
-- Sums the total dollar amount spent on standard paper AND glossy paper across all orders in the orders table, using the sum of the summed standard_amt_usd column AND the summed + gloss_amt_usd column. --

SELECT SUM(standard_amt_usd)/ SUM(standard_qty) AS standard_price_per_unit
FROM orders;
-- Finds the standard paper price per unit across all of the sales made in the orders table. -- 
    -- Divides the summed prices of all standard paper ordered BY the summed totals of all standard paper quantities ordered. --
    -- Though the price (standard_amt_usd) and standard paper quantity ordered (standard_qty) varies from one order to the next, this ratio is across all of the sales made in the orders table. --


-- MIN and MAX (3.9) --

SELECT MIN(standard_qty) AS standard_min,
    MIN(gloss_qty) AS gloss_min,
    MIN(poster_qty) AS poster_min,
    MAX(standard_qty) AS standard_max,
    MAX(gloss_qty) AS gloss_max,
    MAX(poster_qty) AS poster_max,
FROM orders;
-- Picks the minimum amount of paper ordered in the orders table for each paper type column, the maximum amount of paper order ordered across all orders for each paper type column
    -- Potential implications: If the single largest individual order qty ordered is for poster paper (the MAX of the maximums returned) and you know from prior querying that it also has the least total orders overall by far of all the paper types, you might want to consider keeping poster paper stocked in large amounts to anticipate large order quantities. 
    -- Implication: Less popular products might still be ordered in larger quantities, so even though it's not the most popular item, company might want to produce enough of this item to be able to fulfill pretty big orders at any given time. 

-- Depending on the column type, MIN will return the lowest number, earliest date, or non-numerical value as early in the alphabet as possible. 
-- Depending on the column type, MAX will return the highest number, the latest date, or the non-numerical value closest alphabetically to “Z.”


-- AVG (3.10) --

SELECT AVG(standard_qty) AS standard_avg,
    AVG(gloss_qty) AS gloss_avg,
    AVG(poster_qty) AS poster_avg
FROM orders;
-- Returns the average quantity of paper ordered for each paper type (average order quantity size) across all orders in the orders table. 
    -- Answers: What order size can we expect to see on a regular basis? 

SELECT MIN(occurred_at)
FROM orders;
-- Returns the date of the earliest order ever placed, using an aggregation.
-- Depending on the column type, MIN will return the lowest number, earliest date, or non-numerical value as early in the alphabet as possible. 

SELECT occurred_at
FROM orders
ORDER BY occurred_at
LIMIT 1;
-- Returns the date of the earliest order every placed, using ORDER BY and LIMIT. --

SELECT MAX(occurred_at)
FROM web_events;
-- Returns the date the most recent (latest) web event occurred, using an aggregation. --

SELECT occurred_at
FROM web_events 
ORDER BY occurred_at DESC
LIMIT 1;
-- Returns the date the most recent (latest) web event occurred, using ORDER BY and LIMIT. --

SELECT AVG(standard_qty) AS mean_standard,
    AVG(gloss_qty) AS mean_gloss,
    AVG(poster_qty) AS mean_poster,
    AVG(standard_amt_usd) AS mean_standard_usd,
    AVG(gloss_amt_usd) AS mean_gloss_usd,
    AVG(poster_amt_usd) AS mean_poster_usd,
FROM orders;
-- Finds the mean (Average) amount spent per order for each paper type, as well as the mean amount of each paper type purchased per order. --
-- Average number of sales for each paper type, as well as the average amount of paper qty ordered for each paper type. --

SELECT *
FROM (SELECT total_amt_usd
        FROM orders
        ORDER BY total_amt_usd
        LIMIT 3457) AS Table1
ORDER BY total_amt_usd DESC
LIMIT 2;
-- Finds the median of total sales (total_amt_usd spent) on all orders. -- 
    -- A median is a more appropriate representation of the data here than average because there are outliers. --
    -- Note, this is more advanced than the topics we have covered thus far to build a general solution, but we can hard code a solution in the above way. --


-- GROUP BY: one column (3.13) -- 

SELECT account_id,
    SUM(standard_qty) AS standard_sum,
    SUM(gloss_qty) AS gloss_sum,
    SUM(poster_qty) AS poster_sum
FROM orders
    GROUP BY account_id
    ORDER BY account_id;
-- Sums the total quantites of paper ordered, by paper type, for every account in the dataset.
-- Creates a separate set of sums for each account id in the dataset.
-- account id is added to a GROUP BY clause to clarify that is is to be made into a grouping - not summed and collapsed like the other columns.
-- Aggregates results into segments - where each segment is one  of the values in the account id column.
-- Takes the sum of data limited to each account, rather than across the entire dataset. --

SELECT a.name, o.occurred_at
FROM accounts a
JOIN orders o
ON a.id = o.account_id
ORDER BY o.occurred_at
LIMIT 1;
-- Returns the account that placed the earliest order in the orders table, by both account name and occurrance date. --

SELECT a.name account, SUM(o.total_amt_usd) total_sales
FROM orders o
JOIN accounts a
ON o.account_id = a.id
GROUP BY a.name;
-- Finds the total sum of sales (in USD) for each account. --

SELECT w.occurred_at, w.channel, a.name
FROM web_events w
JOIN accounts a
ON w.account_id = a.id
ORDER BY w.occurred_at DESC
LIMIT 1;
-- Returns the channel date and account name for the most recent (or latest) web event. --

SELECT channel, COUNT(*)
FROM web_events 
GROUP BY channel;
-- Groups each channel by the its total number of web_events that took place (all rows in the web_events table, by each channel). --

SELECT a.primary_poc, MIN(w.occurred_at) earliest_event
FROM accounts a 
JOIN web_events w
ON a.id = w.account_id
GROUP BY a.primary_poc;
-- Returns the earliest web event for each primary point of contact.

SELECT a.primary_poc
FROM accounts a
JOIN web_events w
ON a.id = w.account_id
ORDER BY w.occurred_at
LIMIT 1;
-- Returns the primary contact associated with the earliest web_event. 

SELECT a.name, MIN(o.total_amt_usd) smallest_order
FROM orders o
JOIN accounts a
ON o.account_id = a.id
GROUP BY a.name
ORDER BY MIN(o.total_amt_usd);
-- Finds the smallest order (in sales) placed for each account, sorted from smallest to greatest individual order sales. 

SELECT r.name, COUNT(*) num_reps
FROM region r
JOIN sales_reps s
ON r.id = s.region_id
GROUP BY r.name
ORDER BY num_reps;
-- Finds the total number of sales reps associated with each region, order by regions with the fewest representatives to those with the most. 


-- GROUP BY: multiple columns (3.16) --

SELECT account_id,
    channel,
    COUNT(id) AS events
FROM web_events
GROUP BY account_id, channel
ORDER BY account_id, events DESC;
-- Counts the total number of web events for each channel on account id. Sorted first by smallest to largest account id; then from largest total web events to least. --
    -- This is a good start into analyzing how each account interacted with various advertising channels. From here you might go on to answer: 
        -- ex. How much traffic are we obtaining from each channel? 
        -- ex. Which channels are driving traffic and leading to purchases? 
        -- ex. Are we investing in channels that aren't worth the cost? 
-- see DISTINCT (below) for a deeper look into this query.

SELECT a.name account, AVG(standard_qty) standard_qty_avg,
AVG(gloss_qty) gloss_qty_avg,
AVG(poster_qty) poster_qty_avg
FROM accounts a
JOIN orders o
ON a.id = o.account_id
GROUP BY a.name;
-- Finds the average quantity of standard paper ordered for each account, across all orders in the orders table; also finds the average quantity of gloss paper and average quantity of poster paper ordered for each account, across all orders in the orders table.

SELECT a.name account, AVG(o.standard_amt_usd) avg_standard,
AVG(o.gloss_amt_usd) avg_gloss,
AVG(o.poster_amt_usd) avg_poster
FROM accounts a
JOIN orders o
ON a.id = o.account_id
GROUP BY a.name;
-- For each account, Determines the average amount spent per order on each paper type. --

SELECT s.name rep, w.channel, COUNT(*) num_events
FROM sales_reps s
JOIN accounts a
ON a.sales_rep_id = s.id
JOIN web_events w
ON w.account_id = a.id
GROUP BY s.name, w.channel
ORDER BY num_events DESC;
-- Counts how many times each channel is used in association with each sales rep, ordered from most occurrances to least occurences. -- 

SELECT r.name region, w.channel, COUNT(*) num_events
FROM region r
JOIN sales_reps s
ON r.id = s.region_id
JOIN accounts a
ON s.id = a.sales_rep_id
JOIN web_events w
ON a.id = w.account_id
GROUP BY r.name, w.channel
ORDER BY num_events DESC;
-- Counts the number of times a particular channel was used in the web_events table for each region, ordered from most occurrances to least occurences.


-- DISTINCT (3.19) --

-- Comparison between when to use GROUP BY vs when to use DISTINCT. ---
SELECT account_id,
    channel,
    COUNT(id) AS events
FROM web_events
GROUP BY account_id, channel
ORDER BY account_id, events DESC;
-- Shows the total web events for each channel by account.
    -- GROUP BY is used to group results by columns when performing aggregations.

SELECT DISTINCT account_id,
    channel
FROM web_events
ORDER BY account_id
-- Lists every channel used by each account id.
    -- DISTINCT provides the unique rows for all columns written in the SELECT statement; DISTINCT comes immediately after the SELECT clause.
    -- DISTINCT can also be used to group results by column when you don't use aggregations.
    -- No aggregations are in the SELECT statement, so GROUP BY isn't needed here either.

-- Tests if there are any accounts associated with more than one region. --    
    SELECT a.id as "account id", r.id as "region id", 
    a.name as "account name", r.name as "region name"
    FROM accounts a
    JOIN sales_reps s
    ON s.id = a.sales_rep_id
    JOIN region r
    ON r.id = s.region_id;
    -- returns all accounts and their associated regions. --
    -- ex. returns 351 results

    SELECT DISTINCT id, name
    FROM accounts;
    -- returns every unique account in the company.
    -- ex. returns 351 results; Because the counts are the same, each account is associated with only one region. 
    --  If each account was associated with more than one region, the first query should have returned more rows than the second query.

-- Tests if there are any sales reps who have worked on more than one account. --
    SELECT s.id, s.name, COUNT(*) num_accounts
    FROM accounts a
    JOIN sales_reps s
    ON s.id = a.sales_rep_id
    GROUP BY s.id, s.name
    ORDER BY num_accounts;
    -- Groups by sales rep id and name, and then counts up all their accounts. -- 
    -- ex. Counts show that the fewest number of accounts any sales rep works on is 3.
    -- ex. There are 50 results.
    -- There are 50 sales reps, and they all have more than one account.

    SELECT DISTINCT id, name
    FROM sales_reps;
    -- returns every unique sales rep in the company.
    -- ex. returns 50 results; Confirms that all of the sales reps are accounted for in the first query. 


-- HAVING (3.22) --

    SELECT account_id, 
        SUM(total_amt_usd) AS sum_total_amt_usd
    FROM orders
    GROUP BY 1
    GROUP BY 2 DESC;
    -- gets the sum of sales for each account, ordered from highest to lowest sales.
    -- the WHERE clause doesn't allow you to filter on aggregate columns; so it's hard to filter here by specific values (ex. show only accounts with over $250,0000 in sales)

    SELECT account_id, 
    SUM(total_amt_usd) AS sum_total_amt_usd
    FROM orders
    GROUP BY 1
    HAVING SUM(total_amt_usd) >= 250000;
    -- filters the query down to just the account ids with more than $250,000 in sales.   
    -- HAVING was used here instead of WHERE because you're filtering on an aggregate.
    -- HAVING is only useful when grouping by one or more columns; No grouping on an aggregate means you'll jsut be returned one line anyway. 

SELECT s.id, s.name, COUNT(*) num_accounts
FROM accounts a
JOIN sales_reps s
ON s.id = a.sales_rep_id
GROUP BY s.id, s.name
HAVING COUNT(*) > 5
ORDER BY num_accounts;
-- Returns all the sales reps that have more than 5 accounts. 
-- You can't use an alias in HAVING; you have to use the aggregate for it to work.
-- All non-aggregated columns in SELECT must also appear in GROUP BY.

SELECT a.id, a.name, COUNT(*) num_orders
FROM accounts a
JOIN orders o
ON a.id = o.account_id
GROUP BY a.id, a.name
HAVING COUNT(*) > 20
ORDER BY num_orders;
-- Returns all accounts with more than 20 orders.
-- You can't use an alias in GROUP BY; you need to identify by original table and column name (see above).

SELECT a.id, a.name, SUM(o.total_amt_usd) total_spent
FROM accounts a
JOIN orders o
ON a.id = o.account_id
GROUP BY a.id, a.name
HAVING SUM(o.total_amt_usd) > 30000
ORDER BY total_usd;
-- Returns all accounts that spent more than $30,000 usd total across all orders.

SELECT a.id, a.name, SUM(o.total_amt_usd) total_spent
FROM accounts a
JOIN orders o
ON a.id = o.account_id
GROUP BY a.id, a.name
HAVING SUM(o.total_amt_usd) < 1000
ORDER BY total_usd;
-- Returns all accounts that spent less than $1000 usd total across all orders.

SELECT a.id, a.name, SUM(o.total_amt_usd) total_spent
FROM accounts a
JOIN orders o
ON a.id = o.account_id
GROUP BY a.id, a.name
ORDER BY total_spent DESC
LIMIT 1;
-- Returns the account that has spent the most 
    -- Sums the totals of all orders for each accounts, listing them from highest total to least total; limited to 1 to return just one company with the single highest total.

SELECT a.id, a.name, SUM(o.total_amt_usd) total_spent
FROM accounts a
JOIN orders o
ON a.id = o.account_id
GROUP BY a.id, a.name
ORDER BY total_spent
LIMIT 1;
-- Returns the account that has spent the least. 

SELECT a.id, a.name, w.channel, COUNT(*) use_of_channel
FROM accounts a
JOIN web_events w
ON a.id = w.account_id
GROUP BY a.id, a.name, w.channel
HAVING COUNT(*) > 6 AND w.channel = 'facebook'
ORDER BY use_of_channel;
-- Shows the total number of times the facebook channel was used to contact customers, for each account, but only shows accounts where that total was greater than 6.

SELECT a.id, a.name, w.channel, COUNT(*) use_of_channel
FROM accounts a
JOIN web_events w
ON a.id = w.account_id
WHERE w.channel = 'facebook'
GROUP BY a.id, a.name, w.channel
ORDER BY use_of_channel DESC
LIMIT 1;
-- Returns account that used the facebook channel the most.
    -- Note: It is a best practice to use a larger limit number first such as 3 or 5 to see if there are ties before using LIMIT 1.

SELECT a.id, a.name, w.channel, COUNT(*) use_of_channel
FROM accounts a
JOIN web_events w
ON a.id = w.account_id
GROUP BY a.id, a.name, w.channel
ORDER BY use_of_channel DESC
LIMIT 10;
-- Returns the top 10 channels most frequently used by most accounts (ex. all of the top 10 are for the direct channel).


-- DATE Functions (3.25) --

-- Why we have to use date functions to aggregate with dates. --
    SELECT occurred_at,
        SUM(standard_qty) AS standard_qty_sum
    FROM orders
    GROUP BY occurred_at
    ORDER BY occurred_at;
    -- Most timestamps are unique, so aggregating by date fields won't be very practical unless you round each date to the nearest day, week, or year first. 
    
    SELECT DATE_TRUNC('day', occurred_at) AS day,
        SUM(standard_qty) AS standard_qty_sum
    FROM orders
    GROUP BY DATE_TRUNC('day', occurred_at)
    ORDER BY DATE_TRUNC('day', occurred_at);
    -- Sums the quantites of standard paper by day
    -- It's important to group by the same metric that's included in the SELECT statement to ensure your results are consistent
     -- The easiest way to make sure you're grouping correctly is to use column numbers instead of retyping the exact functions.

SELECT DATE_PART('dow', occurred_at) AS day_of_week,
    SUM(total) AS total_qty
FROM orders
GROUP BY 1
ORDER BY 2 DESC;
-- Answers: What day of the week are the most sales made?
    -- DATE_PART Pulls out only the day of the week for each occurence date; 'dow' pulls the day of the week with 0 as Sunday and 6 as Saturday.
    -- The 1 and 2 here identify these columns in the SELECT statement
-- After aggregation, the query groups each dow by the total sum of sales across all orders, ordered from day of the week with the largest total sales to the day of the week with the least. 


SELECT DATE_PART('year', occurred_at) AS year,
SUM(total_amt_usd) total_sales
FROM orders 
GROUP BY 1
ORDER BY 1, 2 DESC;
-- Finds the total sales in terms of total dollars for all orders in a year, ordered from least to greatest.
-- ex. In the results, you'll notice that 2013 and 2017 have much smaller totals than the other years.
    -- If we look further into the monthly data, we see that this is because there is only one month of sales for each of these years (December for 2013 and January for 2017)
        -- Therefore neither of these years are being evenly represented.
    -- Sales have been increasing year over year, with 2016 being the largest sales to date. At this rate, we might expect 2017 to have the largest sales.

SELECT DATE_PART('month', occurred_at) ord_month, SUM(total_amt_usd) total_spent
FROM orders
WHERE occurred_at BETWEEN '2014-01-01' AND '2017-01-01'
GROUP BY 1
ORDER BY 2 DESC; 
-- Answers the question: Which month had the greatest sales in terms of total dollars?
-- Sums total sales made for each month, listed from highest total sales to least. 
-- Filters the data so that only data from 2014 through 2016 is considered, because 2013 and 2017 are not evenly represented in this dataset (see note in query above)

SELECT DATE_PART('year', occurred_at) year,  COUNT(*) total_orders
FROM orders
GROUP BY 1
ORDER BY 2 DESC;
-- Answers the question: which year had the greatest sales in terms of total number of orders?
-- Counts the total number of orders placed in each year, then orders years from greatest total orders to least total orders.
    -- ex. Again, 2013 and 2017 are not evenly represented to the other years in the dataset.

SELECT DATE_PART('month', occurred_at) ord_month, COUNT(*) total_sales
FROM orders
WHERE occurred_at BETWEEN '2014-01-01' AND '2017-01-01'
GROUP BY 1
ORDER BY 2 DESC; 
-- Answers the question: which month had the greatest sales in terms of total number of orders?
-- Counts the total number of orders placed in each month, then orders months from greatest total orders to least total orders.
    -- To make a fair comparison from one month to another 2017 and 2013 data were removed.

SELECT DATE_TRUNC('month', o.occurred_at) month_yr,
SUM(o.gloss_amt_usd) gloss_total_sales
FROM orders o
JOIN accounts a
ON o.account_id = a.id
WHERE a.name = 'Walmart'
GROUP BY 1
ORDER BY 2 DESC
LIMIT 1;
-- Answers the question: Which month of which year did Walmart spend the most on gloss paper in terms of dollars?
-- Truncates order timestamp to the month level, then groups each month by the total sales made for that month in gloss paper.
-- Filters results down to just the accounts with a name of "Walmart", and orders from largest total sales made in a month to least total sales made; limits to the first result (the greatest total). 


-- CASE (3.29) -- 

-- How to get around problems with division by 0, using CASE. --
    SELECT id, account_id, standard_amt_usd/standard_qty AS unit_price
    FROM orders
    LIMIT 10;
    -- In the Basic SQL lesson, you avoided problems with division by 0 by limiting results to only records not containing quantites of 0. (ex. the first 10 records)

    SELECT account_id, CASE WHEN standard_qty = 0 OR standard_qty IS NULL THEN 0
        ELSE standard_amt_usd/standard_qty END AS unit_price
    FROM orders
    LIMIT 10; 
    -- Any time the standard_qty is zero, it returns a 0, otherwise, it returns the unit_price.
        -- ex. the results show that we essentially charge all of our accounts 4.99 for standard paper; It makes sense this doesn't fluctuate.


-- CASE and Aggregations (3.30) -- 

-- When to use CASE vs. when to use WHERE. --
    SELECT CASE WHEN total > 500 THEN 'Over 500'
        ELSE '500 or under' END AS total_group,
        COUNT(*) AS order_count
    FROM orders
    GROUP BY 1;
    -- The easiest way to count all the members of a group is to create a column that groups the way you want it to, then create another column to count by that group. 
    -- There are some advantages to separating data into separate columns like this depending on what you want to do, 
        -- But often this level of separation might be easier to do in another programming language - rather than with SQL.

    SELECT COUNT(1) orders_over_500_units
    FROM orders
    WHERE total > 500;
    -- getting the same information using a WHERE clause means only being able to get one set of data from the CASE at a time.


SELECT account_id, total_amt_usd,
CASE WHEN total_amt_usd >= 3000 THEN 'Large'
ELSE 'Small' END AS order_level
FROM orders;
-- Displays the account id, total amount of the order and "Large" or "Small" in the order_level column, depending on whether the total order amount was less than $3,000 or not. 

SELECT CASE WHEN total >= 2000 THEN 'At Least 2000'
	  WHEN total >= 1000 AND total < 2000 THEN 'Between 1000 and 2000'
      ELSE 'Less than 1000' END AS order_category,
COUNT(*) AS order_count
FROM orders
GROUP BY 1;
-- Displays the number of items in each order and classifies them according to 3 levels in the order_category column, depending on their totals: "At Least 2000", "Between 1000 and 2000" and "Less than 1000".

SELECT a.name, SUM(total_amt_usd) total_spent, 
        CASE WHEN SUM(total_amt_usd) > 200000 THEN 'top'
        WHEN  SUM(total_amt_usd) > 100000 THEN 'middle'
        ELSE 'low' END AS customer_level
FROM orders o
JOIN accounts a
ON o.account_id = a.id 
GROUP BY a.name
ORDER BY 2 DESC;
-- Organizes customers (accounts) into 3 different branches based on their lifetime values (total sale of all orders). 
-- > 100,000 is being used in the second CASE statement - instead of BETWEEN 200,000 and 100,000 
	-- isn't BETWEEN inclusive though ?

SELECT a.name, SUM(total_amt_usd) total_spent, 
        CASE WHEN SUM(total_amt_usd) > 200000 THEN 'top'
        WHEN  SUM(total_amt_usd) > 100000 THEN 'middle'
        ELSE 'low' END AS customer_level
FROM orders o
JOIN accounts a
ON o.account_id = a.id
WHERE occurred_at > '2015-12-31' 
GROUP BY 1
ORDER BY 2 DESC;
-- Performs a similar calculation to the query above, but only the total amount customers (accounts) spent in 2016 and 2017.
-- BETWEEN assumes the time is at 00:00:00 (i.e. midnight) for dates. Also, the entire datatset only goes to Jan 2 2017. 

SELECT s.name, COUNT(*) num_orders, CASE WHEN COUNT(*)> 200 THEN 'top' ELSE 'not' END top_performing
FROM sales_reps s
JOIN accounts a
ON s.id = a.sales_rep_id
JOIN orders o
ON a.id = o.account_id
GROUP BY s.name
ORDER BY 2 DESC;
-- Identifies the top performing sales reps by orders of greater than 200, sorted by sales rep with the most to least number of orders.

SELECT s.name, COUNT(*), SUM(o.total_amt_usd) total_spent, 
        CASE WHEN COUNT(*) > 200 OR SUM(o.total_amt_usd) > 750000 THEN 'top'
        WHEN COUNT(*) > 150 OR SUM(o.total_amt_usd) > 500000 THEN 'middle'
        ELSE 'low' END AS sales_rep_level
FROM orders o
JOIN accounts a
ON o.account_id = a.id 
JOIN sales_reps s
ON s.id = a.sales_rep_id
GROUP BY s.name
ORDER BY 3 DESC;
-- Identifies top performing sales reps by orders of greater than 200 OR total sales greater than $75,000 across all orders.
-- Middle performers are those with orders greater than 150 (but less than 200) OR total sales greater than $50,000 (but less than $75,000).
-- Low performers are sales reps with less than 150 orders AND total sales less than $50,000.