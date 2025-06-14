-- Ch. 7 Window Functions -- 
--------------------------------
-- Window functions allow you to compare one row to another without doing any joins 
-- Use to create running totals
-- Use to determine whether one row was greater than a previous row, then classify it based on your finding

-- Window function performs a calculation across a set of table rows, comparable to an aggregate function
	-- Aggregate function - cause rows to become grouped into a single output rows
	-- Window function -  window functions allow the rows to retain their separate identities 

-- OVER and PARTITION BY are key to window functions.
-- Not every window functions uses PARTITION BY and ORDER BY

-- the window is the ordered subset of data over which all of these calculations are made
-- ORDER and PARTITION are what define the window 
	-- Adding OVER designates it as a window function.
	-- PARTITION BY function is narrows the window from the entire data set to individual groups in a dataset 

-- Note: You CAN'T use window functions and standard aggregations in the same query. 
-- More specifically, you can’t include window functions in a GROUP BY clause.

-- Syntax for calculating a Running total:
-- Aggregation-of (column) OVER (PARTITION BY column) ORDER BY column) AS running total


-- 7.2: Running Total --
-------------------------
-- You can create an aggregation - Running total - without using GROUP BY.

-- 1a) Calculate a running total of how much standard paper sold to date.

SELECT standard_qty,
	SUM(standard_qty) OVER (ORDER BY occurred_at) AS running_total
FROM orders; 
-- You could read this as:
-- Take the sum of standard_qty across all rows leading up to a given row, in order by occurred_at.

-- 1b) Calculate a running total of how much standard paper we've sold to date, starting over at the beginning of each month.

SELECT standard_qty,
	DATE_TRUNC ('month', occurred_at) AS month,
	SUM(standard_qty) OVER (PARTITION BY DATE_TRUNC ('month', occurred_at) ORDER BY occurred_at) AS running_total
FROM orders; 
-- to narrow the window from the entire dataset to individual groups within the dataset, use PARTITION BY.
-- This query groups and orders the query by the month in which the transaction occurred; within each month it's ordered by occurred_at
-- ORDER BY treats each partition as separate and defines the running total 
	-- without ORDER BY each value will simply be a sum of all the standard quantity values in its respective month

-- 2a) Calculate a running total of standard_amt_usd over order time (with no date truncation). 

SELECT standard_amt_usd,
  SUM(standard_amt_usd) OVER (ORDER BY occurred_at) AS running_total
FROM orders;
-- Take the sum of standard_amt_usd across all rows leading up to a given row, in order by occurred_at. 
-- Running total continues across all orders in the dataset.

-- 2b) Calculate a partitioned running total of standard_amt_usd over order time by year. 
SELECT standard_amt_usd,
DATE_TRUNC('year', occurred_at) AS year,
SUM(standard_amt_usd) OVER (PARTITION BY DATE_TRUNC('year', occurred_at) ORDER BY occurred_at) AS running_total
FROM orders;
-- Take the sum of standard_amt_usd across all rows leading up to a given row, in order by occurred_at. 
-- Running total continues across all orders within a year, then starts over at the start of the next year.
-- Can also think of as grouping and ordering by the year in which the transaction occurred. 


-- 7.7: ROW_NUMBER & RANK -- 
----------------------------
-- The easiest place to start using Window Functions is with functions that just count - they don't aggregate.

-- ROW NUMBER () displays the number of a given row in the window you define.
-- Row number orders the rows according to the ORDER BY part of the window statement.
-- Row Number does not require you to specifiy a variable within the parentheses.

-- 1.b) Ranks rows in order from earliest to most recent order date.

SELECT id,
	account_id,
	occurred_at,
	ROW_NUMBER() OVER (ORDER BY occurred_at) AS row_num
FROM orders;
-- sorts rows from earliest to most recent order date, regardless of account_id

-- 1c) Group rows by account_id, then ranks order within from earliest order to most recent order for each account_id.
	-- gives each order date a unique, sequential rank in the group, regardless of whether 2 dates are exactly the same (ex. 5,6) 
SELECT id,
	account_id,
	occurred_at,
	ROW_NUMBER() OVER (PARTITION BY account_id ORDER BY occurred_at) AS row_num
FROM orders;
-- groups rows by account_id, sorting by order date within each group
-- within each partition, row_num 1 stands for the first order that occurred within that account_id

--  RANK is similar to ROW_NUMBER, but has a subtle difference. --
	-- ROW_NUMBER() gives all rows different numbers.
	-- RANK will give two rows with the same value the same rank number. 
	-- Wherever there is more than one row assigned the same number, RANK will skip some values to make up for the repeated rank.
	-- DENSE_RANK will also give two rows with the same value the same rank number, but won't skip numbers to make up for it.

 -- 1e) Group rows by account_id, then ranks order within from earliest order to most recent order for each account_id.
	-- gives each order date a sequential rank in the group, giving 2 dates that are exactly the same the same rank - and then skipping values after to make up for i. (ex. 5,5,7) 
 SELECT id,
	account_id,
	DATE_TRUNC('month', occurred_at) AS month,
	occurred_at,
	RANK() OVER (PARTITION BY account_id ORDER BY DATE_TRUNC('month', occurred_at)) AS row_num
FROM orders;
-- Shows orders for each account, also by occurrence date - but orders with the same occurrence date are given the same rank. 
-- To make up for rows where the same rank number is repeated, rank will skip some values following it.

-- 1f) Group rows by account_id, then ranks order within from earliest order to most recent order for each account_id.
	-- gives each order date a sequential rank in the group, giving 2 dates that are exactly the same the same rank - doesn't skipping values after. (ex. 5,5,6) 
SELECT id,
	account_id,
	DATE_TRUNC('month', occurred_at) AS month,
	occurred_at,
	DENSE_RANK() OVER (PARTITION BY account_id ORDER BY DATE_TRUNC('month', occurred_at)) AS row_num
FROM orders;

-- 2a) Rank total quantities of paper ordered from highest to lowest for each account.

SELECT id, account_id, total,
RANK() OVER (PARTITION BY account_id ORDER BY total DESC) AS total_rank
FROM orders;
-- Groups orders within each account_id, ranking them from order with the highest paper quantity sold to the lowest.


-- 7.11 Aggregates in Window Functions ---

SELECT id,
       account_id,
       standard_qty,
       DATE_TRUNC('month', occurred_at) AS month,
       DENSE_RANK() OVER (PARTITION BY account_id ORDER BY DATE_TRUNC('month',occurred_at)) AS dense_rank,
       SUM(standard_qty) OVER (PARTITION BY account_id ORDER BY DATE_TRUNC('month',occurred_at)) AS sum_std_qty,
       COUNT(standard_qty) OVER (PARTITION BY account_id ORDER BY DATE_TRUNC('month',occurred_at)) AS count_std_qty,
       AVG(standard_qty) OVER (PARTITION BY account_id ORDER BY DATE_TRUNC('month',occurred_at)) AS avg_std_qty,
       MIN(standard_qty) OVER (PARTITION BY account_id ORDER BY DATE_TRUNC('month',occurred_at)) AS min_std_qty,
       MAX(standard_qty) OVER (PARTITION BY account_id ORDER BY DATE_TRUNC('month',occurred_at)) AS max_std_qty
FROM orders;
/* ORDER BY creates an aggregation without using GROUP BY. 
So the running sums of standard_qty of paper for that account id partition are grouped together by month.
The running dense_rank for that account id partition are also grouped together by month.
The running count for that account id partition are also grouped together by month.
The running average for that account id partition are also grouped together by month. 
	- The running average is the running sum divided by the running count. (ex. 819/ 3 = 273 ; 1430 / 5 = 286, etc.)
MIN shows the lowest value up until that point in the entire window. (ex. 123 is the lowest value until 85 rolls around.)
	- the lowest standard_qty value will stay until standard_qty shows a smaller value OR the partition changes 
	(ex. the account id changes to 1011 instead of 1001)
MAX works the same way as MIN; it always shows the highest value up to the given row in the current window. */


SELECT id,
       account_id,
       standard_qty,
       DATE_TRUNC('month', occurred_at) AS month,
       DENSE_RANK() OVER (PARTITION BY account_id) AS dense_rank,
       SUM(standard_qty) OVER (PARTITION BY account_id) AS sum_std_qty,
       COUNT(standard_qty) OVER (PARTITION BY account_id) AS count_std_qty,
       AVG(standard_qty) OVER (PARTITION BY account_id) AS avg_std_qty,
       MIN(standard_qty) OVER (PARTITION BY account_id) AS min_std_qty,
       MAX(standard_qty) OVER (PARTITION BY account_id) AS max_std_qty
FROM orders;
/* removes "ORDER BY DATE_TRUNC('month',occurred_at)" in each line of the query
Without ORDER BY, rows within the partition aren't grouped together by anything.
- So sum just shows the total sum of standard_qty paper purchased across each entire account.
- Rows only belong to one group - the partition - so they all just have a dense_rank of 1. 
When the partition changes, it just starts back up again at 1 anyway.
- Like sum, count just shows the total count of orders placed for standard paper across the entire account.
- Avg just shows the running sum divided by the running average so this doesn't change across either until it reaches a new account_id.
- Min shows the smallest value in standard_qty recorded across the entire account.
- Like min, Max the largest value in standard_qty recorded across the entire account.
*/


/* Aliases for Multiple Window Functions 
If you're planning to write several window functions in the same query, 
using the same window, you can create an alias.

Define the alias using a WINDOW clause. This goes between the WHERE and GROUP BY clauses.*/

SELECT id,
       account_id,
       standard_qty,
       DATE_TRUNC('month', occurred_at) AS month,
       DENSE_RANK() OVER main_window AS dense_rank,
       SUM(standard_qty) OVER main_window AS sum_std_qty,
       COUNT(standard_qty) OVER main_window AS count_std_qty,
       AVG(standard_qty) OVER main_window AS avg_std_qty,
       MIN(standard_qty) OVER main_window AS min_std_qty,
       MAX(standard_qty) OVER main_window AS max_std_qty
FROM orders
WINDOW main_window AS (PARTITION BY account_id ORDER BY DATE_TRUNC('month',occurred_at));
-- The results are exactly the same as above, but the query is much easier to read.


-- Create an use an alias to shorten this query:

SELECT id,
       account_id,
       DATE_TRUNC('year',occurred_at) AS year,
       DENSE_RANK() OVER (PARTITION BY account_id ORDER BY DATE_TRUNC('year',occurred_at)) AS dense_rank,
       total_amt_usd,
       SUM(total_amt_usd) OVER (PARTITION BY account_id ORDER BY DATE_TRUNC('year',occurred_at)) AS sum_total_amt_usd,
       COUNT(total_amt_usd) OVER (PARTITION BY account_id ORDER BY DATE_TRUNC('year',occurred_at)) AS count_total_amt_usd,
       AVG(total_amt_usd) OVER (PARTITION BY account_id ORDER BY DATE_TRUNC('year',occurred_at)) AS avg_total_amt_usd,
       MIN(total_amt_usd) OVER (PARTITION BY account_id ORDER BY DATE_TRUNC('year',occurred_at)) AS min_total_amt_usd,
       MAX(total_amt_usd) OVER (PARTITION BY account_id ORDER BY DATE_TRUNC('year',occurred_at)) AS max_total_amt_usd
FROM orders;

SELECT id,
       account_id,
       DATE_TRUNC('year',occurred_at) AS year,
       DENSE_RANK() OVER account_year_window AS dense_rank,
       total_amt_usd,
       SUM(total_amt_usd) OVER account_year_window AS sum_total_amt_usd,
       COUNT(total_amt_usd) OVER account_year_window AS count_total_amt_usd,
       AVG(total_amt_usd) OVER account_year_window AS avg_total_amt_usd,
       MIN(total_amt_usd) OVER account_year_window AS min_total_amt_usd,
       MAX(total_amt_usd) OVER account_year_window AS max_total_amt_usd
FROM orders
WINDOW account_year_window AS (PARTITION BY account_id ORDER BY DATE_TRUNC('year',occurred_at));



/* LAG and LEAD 
You can use LAG and LEAD functions whenever you are trying to compare the values in adjacent rows or rows that are offset by a certain number.
It can be useful to compare rows to preceding or following rows, especially if you have the data in an order that makes sense.
Useful for time-based events.
*/


SELECT account_id,
	standard_sum,
	LAG(standard_sum) OVER (ORDER BY standard_sum) AS lag,
	LEAD(standard_sum) OVER (ORDER BY standard_sum) AS lead,
	standard_sum - LAG(standard_sum) OVER (ORDER BY standard_sum) AS lag_difference,
	LEAD(standard_sum) OVER (ORDER BY standard_sum) - standard_sum AS lead_difference
FROM(
	SELECT account_id,
		SUM(standard_qty) AS standard_sum
	FROM orders
	GROUP BY 1
	) sub;

-- Inner query shows how much standard paper an account has purchased over all time.
-- Lag and Lead are used to create columns that pull values from other rows.
	-- The syntax describes which column to pull from and how many rows away you'd like to pull. 
	-- Lag pulls from the previous rows. 
		-- The first row of the Lag column in Null because there are no previous rows from which to pull in the standard_sum column.
		-- This continues down for the rest of the dataset.
	-- Lead pulls from the following rows.
		-- The Lead column goes in the opposite direction.
		-- This can be especially useful for calculating differences between two rows.
-- The new lag_difference and lead_difference columns compare the standard sum to the prior and following rows.
-- lag_difference shows the difference between the current row and the prior row.
-- lead_difference shows the difference between the current row and the next row.


-- Determine how the current order's total revenue ("total" meaning from sales of all types of paper) compares to the next order's total revenue.

SELECT occurred_at,
       total_amt_usd,
       LEAD(total_amt_usd) OVER (ORDER BY occurred_at) AS lead,
       LEAD(total_amt_usd) OVER (ORDER BY occurred_at) - total_amt_usd AS lead_difference
FROM (
SELECT occurred_at,
       SUM(total_amt_usd) AS total_amt_usd
  FROM orders 
 GROUP BY 1
) sub;
-- Compares a row to a previous row.
	


/* 7.19: Percentiles

- analysis for inventory planning
- Looked at MIN, MAX and AVG order size to get an idea of what size orders you
need to be ready to fill at any given time.
- But really the best way to understand this would be to look at Percentiles:
to see where MOST orders fall. 

- use window functions to identify what subdivision a given row falls into.
- syntax: NTILE (# of buckets)
- ORDER BY determines which column to use to determine the subdivisions 
(percentiles, quartiles, quintiles, or whatever number of ntiles you specify)
- You can use partitions with percentiles to determine the percentile of a specific subset of all rows.

Note:
------
- If you only had two records and you were measuring percentiles, you’d expect one record to define 
the 1st percentile, and the other record to define the 100th percentile. But using the NTILE function, what you’d actually 
see is one record in the 1st percentile, and one in the 2nd percentile.

- When you use a NTILE function, but the number of rows in the partition is less than the NTILE(number of groups), 
then NTILE will divide the rows into as many groups as there are members (rows) in the set but then stop short of 
the requested number of groups. 

- If you’re working with very small windows, keep this in mind and consider using quartiles or similarly small bands. */


SELECT id,
	account_id, 
	occurred_at, 
	standard_qty,
	NTILE(4) OVER (ORDER BY standard_qty) AS quartile,
	NTILE(5) OVER (ORDER BY standard_qty) AS quintile,
	NTILE(100) OVER (ORDER BY standard_qty) AS percentile
FROM orders
ORDER BY standard_qty DESC;

-- the smallest standard_qty would fall in the 1st quartile and the highest value fall in the 4th quartile.


/* Determine the largest orders (in terms of quantity) a specific customer has made to encourage 
them to order more similarly sized large orders. You only want to consider the NTILE for that customer's account_id. */

SELECT account_id,
	occurred_at,
	standard_qty,
	NTILE(4) OVER (PARTITION BY account_id ORDER BY standard_qty) AS standard_quartile
FROM orders
ORDER BY account_id DESC;
-- Divides the accounts into 4 levels based on standard_qty.

SELECT account_id,
	occurred_at,
	gloss_qty,
	NTILE(2) OVER(PARTITION BY account_id ORDER BY gloss_qty) AS gloss_half
FROM orders
ORDER BY account_id DESC;
-- Divides the accounts into 2 levels based on gloss_qty.

SELECT account_id,
	occurred_at,
	total_amt_usd,
	NTILE(100) OVER(PARTITION BY account_id ORDER BY total_amt_usd) AS total_percentile
FROM orders
ORDER BY account_id DESC;
-- Divides each order by the percentile it falls into for each account.
-- ORDER BY is what we use to determine the subdivisions in an NTILE.


------------------------------------------------------------------------------------------



-- 7.2 Window Functions

SELECT standard_qty,
	SUM(standard_qty) OVER (ORDER BY occurred_at) AS running_total
FROM orders; 

-- Takes the sum of standard_qty across all rows leading up to a given row, in order by occurred_at.
-- This query creates an aggregation without using GROUP BY.

SELECT standard_qty, 
DATE_TRUNC('month', occurred_at) AS month,
SUM(standard_qty) OVER(PARTITION BY DATE_TRUNC('month', occurred_at)) AS running_total
FROM orders
	
-- Takes the sum of standard_qty across all rows leading up to a given row, partitioned by the month in which 
the transaction occurred and ordered by occurrence timestamp. 
-- This query groups and orders the query by the month in which the transaction occurred. 
-- The running total will start over at the beginning of each month.
-- ORDER BY treats every partition as separate and is what creates the running total.	

SELECT standard_qty,
	DATE_TRUNC ('month', occurred_at) AS month,
	SUM(standard_qty) OVER (PARTITION BY DATE_TRUNC ('month', occurred_at)) AS running_total
FROM orders; 
-- Without ORDER BY each value would simply be the sum of all the standard quantity values in its respective month. 



