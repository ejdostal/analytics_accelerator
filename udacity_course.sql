/* Clauses, Commands / Statements:

SELECT: chooses the columns to show in the output. 
    - To see all columns, use *.
    - when using JOINs, SELECT also needs to the table every column comes from. 
        - "TableA. " gives us all the columns from that table in the output.
        - "TableA.ColumnNameC" gives us that specific column from that specific table in the output. 

FROM: choose the tables you're pulling data from.

WHERE: filters your results based on a set criteria; a "subset" of the table
- When using WHERE with non-numeric data fields, LIKE, NOT, or IN operators are often used.
- SQL requires single quotes around text values. 

    LIKE: use LIKE within the WHERE clause.
    - requires the use of wildcards (ex. % represents any number of characters)
    - useful in any case where you have a lot of similar, but slightly different, values in a column.
    - uppercase and lowercase letters are not the same in a string (ex. Searching for 'T' is not the same as searching for 't'.)

    IN: use IN within the WHERE clause.
    - allows you to check conditions for multiple column values within the same query 
    - can use IN with both numeric and text columns
    - you could also use OR operator to perform these tasks, but the IN operator is cleaner
    - In most SQL environments, you can use single or double quotation marks around text values - although you may NEED to use double quotation marks if the text itself contains an apostrophe. --

    NOT: use NOT with LIKE, IN and similar operators within the WHERE clause.
    - By specifying NOT LIKE or NOT IN, we can grab all of the rows that do not meet a particular criteria.
    - NOT provides the inverse results for IN.

    AND: use AND within the WHERE clause.
    - selects rows that satisfy both of the conditions
    - used to consider more than one column at a time; you may link as many statements as you would like to consider at the same time.
    - Each time you link a new statement with an AND, you need to state the column of interest independently, even when referring to the same column.
    - AND works with arithmetic operators (+, *, -, /).
    - LIKE, IN, and NOT operators can be linked using the AND operator. 

    BETWEEN:
    - When using the same column for different parts of an AND statement, BETWEEN is often a cleaner replacement.
    AND: WHERE column >= 6 AND column <=10
    BETWEEN: WHERE column BETWEEN 6 AND 10 --> cleaner
    - BETWEEN is inclusive, which means that the end points of BETWEEN statements are included in final results.
    - BETWEEN assumes the time is at 00:00:00 (i.e. midnight) for dates.
    - For that reason, you'll want to set the last endpoint one day later than the actual date. 
    - Ex. To find all dates in 2016, you'd set it as date BETWEEN '2016-01-01' AND '2017-01-01' - finding all dates between midnight on Jan 1st 2016 and midnight on Jan 1st 2017.

    OR: use OR within the WHERE clause.
    - works similarly to AND; but selects rows that satisfy either of the conditions.
    - also used to consider more than one column at a time; you may link as many statements as you would like to consider at the same time.
    - OR works with arithmetic operators (+, *, -, /).
    - LIKE, IN, NOT, AND, and BETWEEN logic can be linked using the OR operator. 
    - When combining multiple of these operations, you frequently might need to use parentheses to assure that the logic you want to perform is being executed correctly.

ORDER BY: sorts results by the data in any column
- useful when you want to sort orders by date, for example
- the default is to sort in Ascending order: A to Z, lowest to highest, or earliest to latest. 
- DESC can be added after the column in your ORDER BY statement to flip the sort. 
- SQL queries only sort data temporarily, unlike sorting a spreadsheet by a column in Excel or Google Sheets which permanently alters the data until you change or undo it.
- you can also use ORDER BY over multiple columns to achieve results. The sorting with happen in the order that you specify the columns.
- Ex. ORDER BY account_id, total_amount_usd DESC; 
- This orders results by account id (from smallest to largest), then records within each account are ordered from largest total_amount_usd to smallest. 

LIMIT: limits results to the first few rows in the table.
- useful when you want to see just the first few rows of a table. This can be much faster for loading than if we load the entire dataset. 
- the LIMIT command is always the very last part of a query.

JOIN clauses: allows us to pull data from more than one table at a time. 
    - Joining tables gives you access to each of the tables in the SELECT statement through the table name, a ".", and the column name you want to pull from that table.
    - To join two tables, list them in the FROM and JOIN clauses.
    - The table in the FROM statement is the Left table (and the first table from which your pulling data); the one in the JOIN statement is the Right table.
    
        ON: specifies the column on which you'd like to merge the two tables together; in the ON, we always have the primary key (PK) equal to the foreign key (FK)
               - A Primary key (PK) exists in every table and is a unique column for each row; Primary keys are unique for every row in a table; It is common for the primary key (PK) to be the first column in our tables in most databases. 
               - A Foreign key (FK) is a column in one table that is a primary key in another table; Each FK links to a primary key in another table; Foreign keys are what allow rows in a join to be non-unique.
    
        Aliases: Give table names aliases when performing joins. (This can save you a lot of typing)
            - The alias for a table is created in the FROM or JOIN clauses; use the alias to replace the table name throughout the rest of the query. 
            - You can alias tables and columns using AS or not using it.
            - Frequently an alias is just the first letter of the table name
            - As with column names, the best practice is for aliases to be all lowercase letters, and to use underscores instead of spaces. 
            - If you have two or more columns in your SELECT that have the same name after the table name (ex. accounts.name, sales_reps.name) you will NEED to alias them; otherwise it will only show ONE of those columns. 
    
    JOIN (inner join): an INNER JOIN only pulls data that exists in both tables.
        * Table Order - The results of inner join are the same whichever order you stick the tables in the FROM and JOIN clauses.
        * Filtering - Where you filter a table (in the ON clause or in the WHERE) clause doesn't matter; that because unmatched rows in both tables are dropped anyways.
        
    *** LEFT JOIN, RIGHT JOIN, and FULL OUTER JOIN are all considered Outer Joins.
        - If we want to include data that doesn't exist in both tables, but only in one of the two tables we are using in our Join statement, we might use one of these joins.
        - Each of these new JOIN statements pulls all the same rows as an INNER JOIN, but they also potentially pull some additional rows; The results of an Outer Join will always have at least as many rows as an inner join if they have the same logic in the ON clause.
        - If there is not matching information in the JOINed table, then you will have columns with empty cells; any cells without data are considered NULL. 
    
    LEFT JOIN (LEFT OUTER JOIN): pulls all the data tht exists in both tables, as well as all of the rows from the table in the FROM, even if they do not exist in the JOIN statement.
        * Table Order - The results of a left join can change depending on the order you stick the tables in FROM and JOIN clauses.
        * Prefiltering vs. Postfiltering - When the database executes the query, it executes the join and everything in the ON clause first, building a new result set; THEN that new result set is filtered using the WHERE clause. 
            - You can prefilter data BEFORE the join occurs by using logic in the ON clause instead of in WHERE.
                - This is like joining the FROM table with a different table in LEFT JOIN - one that only includes a subset of the rows in the original table.
            - If you choose to keep the filter logic in the WHERE clause,the results are filtered AFTER the join occurs.               
    
    RIGHT JOIN (RIGHT OUTER JOIN): pulls all the data that exists in both tables, as well as all of the rows from the table in the JOIN even if they do not exist in the FROM statement. 
         - A LEFT JOIN and RIGHT JOIN do the same thing if we change the tables that are in the FROM and JOIN statements.
         - Rows in the Right table that Don't match the rows in the Left table, will still be included at the bottom of the results.
             - Because they Don't match with the Left table, these columns from the Left table will contain no data (Nulls) for these rows.
    
    OUTER JOIN: (FULL OUTER JOIN) This will return the inner join result set, as well as any unmatched rows from either of the two tables being joined.
            - Again, this returns rows that do not match one another from the two tables. 
            - The use cases for a full outer join are very rare.
        
    Advanced JOINs - a few other advanced JOINS that are used in very specific use cases: UNION and UNION ALL, CROSS JOIN, and SELF JOIN.
        - It's useful to be aware that they exist. 

-----------
Derived columns - A new column created by manipulating existing columns in the database. 
-----------

Nulls: a datatype that specifies where data does not exist.
    - Nulls are often ignored in aggregation functions.
    - When identifying NULLs in a WHERE clause, we write IS NULL or IS NOT NULL. (We don't use =, because NULL isn't considered a value in SQL. Rather, it is a property of the data.)
    - NULLs frequently occur when performing a LEFT or RIGHT JOIN. 
    - NULLs can also occur from simply missing data in our database
- Use ISNULL or IS NOT NULL to SHOW all the rows in a specific column for which their is or isn't Null values.


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
    
    

------------

** Best Practice **
- Write SQL COMMANDS in all uppercase letters, keep everything else in your query lowercase.
- Avoid using spaces in table names and column names. 
  - In Postgres, if you have spaces in column or table names, you need to refer to these columns/tables with double quotes around them (Ex: FROM "Table Name" as opposed to FROM table_name). 
  - In other environments, you might see this as square brackets instead (Ex: FROM [Table Name]). 
- Put a semicolon at the end of each statement. Depending on your SQL environment, your query may need a semicolon at the end to execute.
If you environment allows it, it will also allow you to run multiple queries at once. */


----------------------------------
-- Queries from Udacity course --
----------------------------------

-- SELECT and FROM (1.11) --
SELECT * 
FROM orders  
-- shows every row in the orders table, showing all available columns --

SELECT id, account_id, occurred_at
FROM orders;
-- shows data from just these 3 columns in the orders table. --

------------------------------------
-- LIMIT and ORDER BY (1.15) --
SELECT *
FROM orders
LIMIT 10; 
-- shows all columns in the orders table, but only the first 10 rows of data. -- 

SELECT occurred_at, account_id, channel
FROM web_events
LIMIT 15;
-- shows only these 3 columns from the web_events table, limited to only the first 15 rows of data. -- 

SELECT id, occurred_at, total_amt_usd
FROM orders
ORDER BY occurred_at
LIMIT 10;
-- returns the these 3 columns for the 10 earliest orders in the orders table (sorts the data from lowest to highest based on the occurred_at column, then limits to only the first 10 rows of data.) --

SELECT id, account_id, total_amt_usd
FROM orders
ORDER BY total_amt_usd DESC
LIMIT 5;
 -- returns these 3 columns for the 5 largest orders in terms of sales (total_amt_usd). --

SELECT id, account_id, total_amt_usd
FROM orders
ORDER BY total_amt_usd
LIMIT 20;
-- returns these 3 columns for the 20 smallest orders in terms of sales (total_amt_usd). --

SELECT account_id, total_amt_usd
FROM orders
ORDER BY account_id, total_amt_usd DESC;

SELECT id, account_id, total
FROM orders
ORDER BY account_id, total DESC; 
-- orders results by account id (from smallest to largest). Within each account, sorts orders from largest total dollar amount (total_amt_usd or total) to smallest --
-- In the queries above, all of the orders for each account ID are grouped together, and then within each of those groupings, the orders appear from the greatest order amount to the least. --

SELECT account_id, total_amt_usd
FROM orders
ORDER BY total_amount_usd DESC, account_id;

SELECT id, account_id, total
FROM orders
ORDER BY total DESC, account_id;
-- orders results largest total dollar amount (total_amt_usd or total) to smallest. If there are any orders with the exact same sales value, those will be sorted by account_id from smallest to largest. --
/* In the queries above, the orders will appear from greatest to least regardless of which account ID they were from. Then they are sorted by account ID next. 
The secondary sorting by account ID will be difficult to see here, since only if there were two orders with equal total dollar amounts would there need to be any sorting by account ID.) */

------------------------------------
--- WHERE (1.24) ---
SELECT *
FROM orders
WHERE gloss_amt_usd >= 1000
LIMIT 5; 
-- shows the first 5 rows from the orders table that have a dollar amount of 1000 or greater for gloss_amt_usd. --

SELECT *
FROM orders
WHERE gloss_amt_use < 500
LIMIT 10;
-- shows the first 10 rows from the orders table that have a dollar amount less than 500 for gloss_amt_usd. --

SELECT name, website, primary_poc
FROM accounts
WHERE name = 'Exxon Mobil';
-- filters down to just these 3 columns where records are named "Exon Mobil." 

------------------------------------
-- Arithmetic Operators (1.30) --
SELECT id, (standard_amt_usd/total_amt_usd)*100 AS std_percent, total_amt_usd
FROM orders
LIMIT 10; 
-- returns the id column, total_amt_usd column, and temporarily creates a std_percent column (derived from 2 original columns), limits to the first 10 rows of data. --
-- std_percent column finds the standard paper percent for the order by dividing the standard paper dollar amount by the total order amount.  --

SELECT id, account_id, standard_amt_usd / standard_qty AS standard_unit_price
FROM orders
LIMIT 10;
-- shows id, account_id columns, and derived column calculating the unit price for standard paper in the order, limits to the first 10 rows. --

SELECT id, account_id, (poster_amt_usd / (standard_amt_usd + gloss_amt_usd + poster_amt_usd))*100 AS poster_percent_rev
FROM orders
LIMIT 10;
-- shows id, account_id columns, and derived column calculating the percentage of revenue that comes from poster paper for each order. --

------------------------------------
-- LIKE (1.34) --
SELECT *
FROM demo.web_events_full
WHERE referrer_url LIKE '%google%';
-- captures all refer urls with same domain (google),by finding all urls that contain 'google', but with any number of characters before or after it (represented by the % signs). --

SELECT * 
FROM accounts
WHERE name LIKE 'C%'; 
-- shows all records for companies whose name starts with "C" --

SELECT *
FROM accounts
WHERE name LIKE '%one%';
-- shows all records for companies whose name contains the string "one" somewhere in the name --

SELECT *
FROM accounts
WHERE name LIKE '%s';
-- shows all records for companies whose name ends in "s". --

------------------------------------
-- IN (1.37) --
SELECT *
FROM demo.orders
WHERE account_id IN (1001, 1021);
-- returns all records just for account ids 1001 and 1002. These records will appear all jumbled together because there's not ORDER BY clause here. --

SELECT name, primary_poc, sales_rep_id
FROM accounts
WHERE name IN ('Walmart','Target', 'Nordstrom');
-- returns these 3 columns for all accounts named "Walmart", "Target", and "Nordstrom". --

SELECT *
FROM web_events
WHERE channel IN ('organic', 'adwords');
-- returns records for all web events in which individuals were contacted via "organic" and "adwords" channels. --

SELECT sales_rep_id,name
FROM demo.accounts
ORDER BY sales_rep_id;
-- shows the sales rep id and name columns for all sales accounts, order in ascending order by sales rep id (least to greatest). --

SELECT sales_rep_id,name
FROM demo.accounts
WHERE sales_rep_id IN (321500, 321570)
ORDER BY sales_rep_id;
-- filters down to just the sales accounts associated with sales rep ids 321500 and 321570. --

------------------------------------
-- NOT (1.40) --
SELECT sales_rep_id,name
FROM demo.accounts
WHERE sales_rep_id NOT IN (321500, 321570)
ORDER BY sales_rep_id;
-- returns the inverse or all accounts NOT included in the previous query; filters down to all sales accounts NOT associated with those sales rep ids. --

SELECT *
FROM demo.orders
WHERE occurred_at >= '2016-04-01' AND occurred_at <= '2016-10-01'
ORDER BY occurred_at DESC
-- filters down to only purchases made by customers between April and October 2016 (April 1st to October 1st). --
-- reorders results from most recent to oldest purchase dates; helps to confirm that orders after October 1st were actually excluded. --
-- Notice how the column needs to be stated independently each time, even when operating on the same column name.

------------------------------------  
-- AND and BETWEEN (1.43) --  
SELECT *
FROM orders
WHERE standard_qty > 1000 AND poster_qty = 0 AND gloss_qty = 0;
-- returns all orders where the standard quantity is over 1000, the poster quantity is 0, and the gloss quantity is 0. --

SELECT name
FROM accounts
WHERE name NOT LIKE 'C%' AND name NOT LIKE '%s';
-- returns all company names that do not begin with a "C" or end in an "s".

SELECT occurred_at, gloss_qty
FROM orders 
WHERE gloss_qty BETWEEN 24 and 29;
-- returns the order date and gloss quantity columns for all columns where the gloss quantity is between 24 and 29. --
-- BETWEEN is inclusive so gloss quantities of 24 and 29 would be included in the results. --

SELECT *
FROM web_events
WHERE channel IN ('organic', 'adwords')
AND occurred_at BETWEEN '2016-01-01' AND '2017-01-01'
ORDER BY occurred_at DESC;
-- returns all records for individuals who contacted via organic or adwords channels and started their accounts at some point in 2016, sorted from newest to oldest customers. --
-- BETWEEN '2016-01-01' AND '2017-01-01' is finding all dates between midnight on Jan 1st 2016, and midnight on Jan 1st 2017 
-- midnight on Jan 1st 2017 is basically only one minute into 2017; which is why we set the right-side endpoint of the period at '2017-01-01.' --

------------------------------------
-- OR (1.46) --
SELECT account_id, occurred_at, standard_qty, gloss_qty, poster_qty
FROM demo.orders
WHERE standard_qty = 0 OR glossy_qty = 0 OR poster_qty = 0;
-- returns these columns for any records where one of the three paper types was omitted from the order. --

SELECT account_id, occurred_at, standard_qty, gloss_qty, poster_qty
FROM demo.orders
WHERE (standard_qty = 0 OR glossy_qty = 0 OR poster_qty = 0)
AND occurred_at >= '2016-10-01';
-- returns these columns for all records where one of the three paper types was omitted from the order AND the order occurred sometime after October 1st 2016. --

SELECT id
FROM orders
WHERE gloss_qty > 4000 OR poster_qty > 4000;
-- returns all ids where the order has a poster quantity of over 4000 or a glossy quantity of over 4000.

SELECT *
FROM orders
WHERE standard_qty = 0 
AND (gloss_qty > 1000 OR poster_qty > 1000);
-- returns a list of all orders where the standard qunatity was 0 or either the glossy quantity was over 1000 or the poster quantity was over 1000. ---

SELECT *
FROM accounts
WHERE (name LIKE 'C%' OR name LIKE 'W%')
    AND ((primary_poc LIKE '%ana%' OR primary_poc LIKE '%Ana%')
    AND primary_poc NOT LIKE '%eana%');
-- shows records where the company name starts with either "C" or "W" and the primary point of contact contains the string "ana" or "Ana", but does not contain the string "eana". --


------------------------------------
-- JOIN (2.3) --
SELECT orders.*,
    accounts.*
FROM accounts
JOIN orders
ON accounts.id = orders.account_id;
-- A JOIN clause means an INNER join; Here account names are added to each order. --
    
SELECT orders.*
FROM orders
JOIN accounts
ON orders.account_id = accounts.id;
    -- The SELECT clause tells us which columns to display in the output (all columns in the orders table). --
    -- The FROM clause tells us the first table from which we're pulling data (orders). --
    -- The JOIN clause gives us the second table (accounts). --
    -- The ON clause specifies the column on which you'd like to merge the two tables together (where "account_id" in the orders table matches "id" in the accounts table). --
-- Pulls all the information from ONLY the orders table. --
    -- Above, we are only pulling data from the orders table since in the SELECT statement we only reference columns from the orders table. --

SELECT accounts.name, orders.occurred_at
FROM orders
JOIN accounts
ON orders.account_id = accounts.id;
-- Pulls the account name and the dates in which that account placed an order, but none of the other columns. --

SELECT *
FROM orders
JOIN accounts
ON orders.account_id = accounts.id;
-- Pulls all the columns from BOTH the accounts and orders table. --

SELECT orders.*, accounts.*
FROM accounts
JOIN orders
ON accounts.id = orders.account_id;
-- Pulls all the data from the accounts table and all the data from the orders table. --
-- Notice that we need to specify every table a column comes from in the SELECT statement. --

SELECT orders.*, accounts.*
FROM orders
JOIN accounts
ON accounts.id = orders.account_id;
-- This result is the same as if you switched the tables in the FROM and JOIN. 
    
SELECT orders.*, accounts.*
FROM accounts
JOIN orders
ON orders.account_id = accounts.id;
-- Additionally, which side of the = a column is listed doesn't matter.

SELECT orders.standard_qty, orders.gloss_qty,orders.poster_qty,
accounts.website, accounts.primary_poc
FROM orders
JOIN accounts
ON orders.account_id = accounts.id;
-- Pulls standard order quantity, glossy order quantity, and poster order quantity from the orders table and pulls website and primary point of contact from the accounts table. --

SELECT *
FROM web_events
JOIN accounts
ON web_events.account_id = accounts.id
JOIN orders
ON accounts.id = orders.account_id;
-- Joins all three of these tables together(the web_events table, accounts table, and the orders table) using the same logic as above; the code pulls all of the data from all of the joined tables. --

SELECT web_events.channel, accounts.name, orders.total
FROM web_events
JOIN accounts
ON web_events.account_id = accounts.id
JOIN orders
ON accounts.id = orders.account_id;
-- Again, joins all three tables together, but only returns the channel column from the web_events table, the account name column from accounts table, and the order total column from orders table. --
-- We could continue this same process to link all of the tables if we wanted! But for efficiency reasons, we probably dont't want to do this unless we actually need information from all of the tables. :-) --


-- Aliases in JOINS (2.10) --  
SELECT o.*,
a.*
FROM orders o
JOIN accounts a
o.account_id = a.id;
-- Frequently an alias is just the first letter of the table name. lias names of "o" and "a" are given for the orders and accounts tables in the FROM and JOIN clauses. --

SELECT a.primary_poc, w.occurred_at, w.channel, a.name
FROM web_events w
JOIN accounts a
ON w.account_id = a.id
WHERE a.name = 'Walmart';
-- Provides all web_events associated with account name of "Walmart"; returning only the primary point of contact, event date, channel, and account name columns. --

SELECT r.name region, s.name rep, a.name account
FROM sales_reps s
JOIN region r
ON s.region_id = r.id
JOIN accounts a
ON a.sales_rep_id = s.id
ORDER BY a.name;
-- Shows the region for each sales representative, along with their associated accounts. Sorts results alphabetically (A-Z) on account name. --

SELECT r.name region, a.name account, 
o.total_amt_usd/(o.total + 0.01) unit_price
FROM region r
JOIN sales_reps s
ON s.region_id = r.id
JOIN accounts a
ON a.sales_rep_id = s.id
JOIN orders o
ON o.account_id = a.id;
-- Provides the region for every order, as well as the account name and the unit price they paid (total amount in USD / by the total) for the order.  
-- "0.01" is added to the total column in the unit_price calculation to avoid division by zero (A few accounts have 0 for total). --


-- LEFT JOIN & RIGHT JOIN (2.14) --
SELECT a.id, a.name, o.total
FROM orders o
JOIN accounts a
ON o.account_id = a.id
-- This is an Inner Join; It returns only rows for account ids that appear in both the orders table and the accounts table. --
-- So if there are any accounts that haven't placed orders yet (aka they don't appear in the orders table), these accounts WON'T be included in these results. --

SELECT a.id, a.name, o.total
FROM orders o
LEFT JOIN accounts a
ON o.account_id = a.id
-- This will include all the results that match with the Right table (accounts), as well as any results in the Left table that did not match (orders). --  
-- The table in the FROM is considered the Left table, the table in the JOIN is considered the Right table. --

SELECT a.id, a.name, o.total
FROM orders o
RIGHT JOIN accounts a
ON o.account_id = a.id
-- This will include all results that match with the Left table (orders), as well as any rows in the Right table that don't match (accounts). --
-- In this query, accounts that haven't placed any orders (aka they don't appear in the orders table) ARE included in the results. --  
-- Rows that don't contain matches are returned at the BOTTOM of the results set, with any columns from the orders table containing Null (or no data).  --
  
SELECT a.id, a.name, o.total
FROM accounts a
LEFT JOIN orders o 
ON o.account_id = a.id
-- RIGHT JOINs and LEFT JOINs are somewhat interchangeable. --
-- So if you change the query so the accounts table is in the FROM clause and the orders table in the JOIN clause and then run a LEFT JOIN instead, the results will be exactly the same as the Right Join done in the previous query. --

SELECT c.countryid, c.countryName, s.stateName
FROM Country c
JOIN State s
ON c.countryid = s.countryid;
-- an Inner JOIN; rows will only be joined where country id is shared between both Country and State tables; non-matching rows are dropped. --

SELECT c.countryid, c.countryName, s.stateName
FROM Country c
LEFT JOIN State s
ON c.countryid = s.countryid;
-- a LEFT JOIN; rows where country id is shared between both Country and State tables are joined together and listed in the results first; rows in the Country table (the Left Table) without matches in the State table are tacked on to the end of the results with Nulls in the State columns. --

SELECT c.countryid, c.countryName, s.stateName
FROM State s
LEFT JOIN Country c
ON c.countryid = s.countryid;
-- Also a LEFT JOIN, but State is now the Left Table and Country is now the Right Table --
-- In this query, any rows with unmatched country ids remaining in the State table (Left Table) now appear the bottom of the results instead; Country table columns in these rows are Null. --

-- LEFT JOIN and Filtering (2.18) --
SELECT orders.*,
accounts.*
FROM orders
LEFT JOIN accounts
ON orders.account_id = accounts.id
WHERE accounts.sales_rep_id = 321500 
-- The orders table is joined with the accounts table on account_id. --
-- First, rows where country id matches between orders and accounts tables are joined (Inner join). --
-- Second, remaining rows in the orders table (the FROM or Left Table) without matches are tacked to end of the subset, with Nulls in their accounts columns. --
-- Third, the subset of rows from his join filtered down further (so just rows where sales_rep_id is 321500 are returned). --
-- This returns only the orders booked by sales rep 321500. --

SELECT orders.*,
accounts.*
FROM orders
LEFT JOIN accounts
ON orders.account_id = accounts.id
AND accounts.sales_rep_id = 321500
-- The same query as above, but pre-filtering data BEFORE the LEFT JOIN is executed.
-- First, the table in the LEFT JOIN clause (accounts) is filtered down to include ONLY accounts with a sales representative id of 321500 attached to them. --
-- Next, rows in the Left Table (orders) where sales representative id = 321500 is combined with the rows in new prefiltered subset from the accounts table. --
-- Third, any rows remaining in the Left Table (orders) where sales representative id did NOT equal 321500 are tacked on to the end of the results, with Nulls in the accounts columns. --
-- Maybe use to mark all the orders made by sales rep 321500, while keeping all other orders in the result set as well. --
-- Filtering on the ON clause will be incredibly useful when working with data aggregation though. --
    
SELECT r.name region, s.name rep, a.name account
FROM region r
JOIN sales_reps s
ON r.id = s.region_id
AND r.name = 'Midwest'
JOIN accounts a
ON s.id = a.sales_rep_id
ORDER BY a.name;
-- Provides all sales reps in the Midwest with their associated accounts. --

SELECT r.name region, s.name rep, a.name account
FROM region r
JOIN sales_reps s
ON r.id = s.region_id AND r.name = 'Midwest' AND s.name LIKE 'S%'
JOIN accounts a
ON s.id = a.sales_rep_id
ORDER BY a.name;
-- Provides all sales reps in the Midwest region whose first name starts with an "S", with their associated accounts. --

SELECT r.name region, s.name rep, a.name account
FROM sales_reps s
JOIN region r
ON s.region_id = r.id
JOIN accounts a
ON a.sales_rep_id = s.id
WHERE r.name = 'Midwest' AND s.name LIKE '% K%'
ORDER BY a.name;
-- Provides the region for each sales rep in the Midwest whose last name starts with a "K", with their associated accounts. --

SELECT r.name region, a.name account,
o.total_amt_usd/(o.total + 0.01) unit_price
FROM region r
JOIN sales_reps s
ON r.id = s.region_id
JOIN accounts a
ON s.id = a.sales_rep_id
JOIN orders o
ON a.id = o.account_id
WHERE o.standard_qty > 100 ;
-- Provides the name of each region for every order, as well as the account name and the unit price they paid for the order, only if the standard order quantity exceeded $100. --

SELECT r.name region, a.name account, o.total_amt_usd/(o.total + 0.01) unit_price
FROM region r
JOIN sales_reps s
ON s.region_id = r.id
JOIN accounts a
ON a.sales_rep_id = s.id
JOIN orders o
ON o.account_id = a.id
WHERE o.standard_qty > 100 AND o.poster_qty > 50
ORDER BY unit_price;
-- Provides the name of each region for every orders, as well as the account name and the unit price they paid for the order - but only provides results if the standard order quantity exceeds $100 AND the poster order quantity exceed 50. -- 
-- Results sorted from least to greatest by unit price. --

SELECT r.name region, a.name account, 
o.total_amt_usd / (o.total + 0.01) unit_price
FROM region r
JOIN sales_reps s
ON r.id = s.region_id
JOIN accounts a
ON s.id = a.sales_rep_id
JOIN orders o
ON a.id = o.account_id
WHERE standard_qty > 100 
AND poster_qty > 50
ORDER BY unit_price DESC;
-- Same as query directly above, but sort is reversed; Results are sorted from greatest to least unit price. 

SELECT DISTINCT a.name, w.channel
FROM accounts a
JOIN web_events w
ON a.id = w.account_id
WHERE a.id = 1001;
-- Lists all the different channels used by account_id: 1001. SELECT DISTINCT narrows down the results to only the unique values. --

SELECT o.occurred_at occurred_at, a.name account,
o.total, o.total_amt_usd
FROM orders o
JOIN accounts a
ON o.account_id = a.id
AND o.occurred_at BETWEEN '2015-01-01' AND '2016-01-01';
-- Finds all the orders that occurred in 2015. --


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
	-- Finds the total sales for each region.

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
	-- Selects just the region with the Max total sales from the results of the first query.  

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
	                 JOIN orders o
	                 ON o.account_id = a.id
	                 JOIN region r
	                 ON r.id = s.region_id
	                 GROUP BY r.name) sub);

-- Pulls the name and total number of orders placed only from the region where total sales is equivalent to the Maximum total sales across all regions.


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

