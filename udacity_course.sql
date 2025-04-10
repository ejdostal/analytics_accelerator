/* Clauses, Commands / Statements:

SELECT: chooses the columns to show (See all columns with *)

FROM: choose the tables you're pulling data from

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


** JOIN Statements ** 
    - The whole purpose of JOIN statements is to allow us to pull data from more than one table at a time. 
    - Joining tables gives you access to each of the tables in the SELECT statement through the table name, a ".", and the column name you want to pull from that table.

    SELECT: indicates which column(s) of data you'd like to see in the output. 
        - "TableA." gives us all the columns that table in the output.
         - "TableA.ColumnNameC" gives us that specific column from that table in the output. We need to specify the table every column comes from in the SELECT statement.
    
    FROM: indicates the first table from which we're pulling data; JOIN: indicates the second table. 
        - To join two tables, list them in the FROM and JOIN clauses.
        - For (inner) JOIN, the result is still the same if you were to switch the tables in the FROM and JOIN.
    
    ON: specifies the column on which you'd like to merge the two tables together; in the ON, we ALWAYS have the primary key (PK) equal to the foreign key (FK);  Primary-foreign key relationships are typically one-to-many, respectively.
        - A primary key (PK) exists in every table and is a unique column for each row; primary keys are unique for every row in a table. 
        - It is common for the primary key (PK) to be the first column in our tables in most databases. 
           
        - A foreign key (FK) is a column in one table that is a primary key in another table. 
        - Each FK links to a primary key in another table.

Aliases: Give table names aliases when performing joins. (This can save you a lot of typing)
    - The alias for a table is created in the FROM or JOIN clauses; use the alias to replace the table name throughout the rest of the query. 
    - You can alias tables and columns using AS or not using it.
    - Frequently an alias is just the first letter of the table name
    - As with column names, the best practice is for aliases to be all lowercase letters, and to use underscores instead of spaces. 
    - If you have two or more columns in your SELECT that have the same name after the table name (ex. accounts.name, sales_reps.name) you will NEED to alias them; otherwise it will only show ONE of those columns. 
        
** JOIN Types **
    JOIN: (INNER JOIN) Only returns rows that appear in both tables; pulls rows only if they exist as a match across two tables. 
    
    ** Motivation to use other Joins **
        - If we want to include data that doesn't exist in both tables, but only in one of the two tables we are using in our Join statement, we might use one of these joins.
        - Each of these new JOIN statements pulls all the same rows as an INNER JOIN, but they also potentially pull some additional rows.
        - If there is not matching information in the JOINed table, then you will have columns with empty cells; any cells without data are considered NULL. 
        - The results of an Outer Join will always have at least as many rows as an inner join if they have the same logic in the ON clause.
        - The table in the FROM statement is the Left table; the one in the JOIN statement is the Right table.
        
    LEFT JOIN: (LEFT OUTER JOIN) Includes all the results that match with Right table, just like an Inner JOIN, as well as any results in the Left table that did not match. 
            
    RIGHT JOIN: (RIGHT OUTER JOIN) Includes all the results that match with Left table, just like an Inner JOIN, as well as any results in the Left table that did not match. 
        - A LEFT JOIN and RIGHT JOIN do the same thing if we change the tables that are in the FROM and JOIN statements.
        - The rows in the Right table that don't match the rows in the Left table will be included at the bottom of the results. They don't match with rows in the Left table, so any columns from the Left table will contain no data for these rows.
               
    OUTER JOIN: (FULL OUTER JOIN) This will return the inner join result set, as well as any unmatched rows from either of the two tables being joined.
        - Again, this returns rows that do not match one another from the two tables. 
        - The use cases for a full outer join are very rare.
       
 
The three JOIN statements you are most likely to use are:
    - JOIN - an INNER JOIN that only pulls data that exists in both tables.
    - LEFT JOIN - pulls all the data tht exists in both tables, as well as all of the rows from the table in the FROM even if they do not exist in the JOIN statement.
    - RIGHT JOIN - pulls all the data that exists in both tables, as well as all of the rows from the table in the JOIN even if they do not exist in the FROM statement.

    - There are other a few other advanced JOINS that are used in very specific use cases: UNION and UNION ALL, CROSS JOIN, and the tricky SELF JOIN. It's useful to be aware that they exist, as they are useful in special cases.
    

- In order to get the exact results you're after, you need to be careful about exactly how you filter the data. As with joins, there are multiple options.
- For LEFT JOIN, logic in the ON clause reduces the rows BEFORE combining the tables.
- For LEFT JOIN, logic in the WHERE clause occurs AFTER the join occurs. Use logic in the ON clause with LEFT JOIN to prefilter data BEFORE the join occurs. 
- This only works for LEFT JOIN - it will not work of (inner) JOIN.
- Because (inner) JOIN only returns the rows for which the two tables match, moving this filter to the ON clause of an (inner) JOIN will simply produce the same result as keeping it in the WHERE clause.


        
------------------------------------

Derived columns - A new column created by manipulating existing columns in the database. 
- Give the column an alias by adding AS to the end of the line that produces the derived column.

------------------------------------

Best Practice:
- Write SQL COMMANDS in all uppercase letters, keep everything else in your query lowercase.
- Avoid using spaces in table names and column names. 
  - In Postgres, if you have spaces in column or table names, you need to refer to these columns/tables with double quotes around them (Ex: FROM "Table Name" as opposed to FROM table_name). 
  - In other environments, you might see this as square brackets instead (Ex: FROM [Table Name]). 
- Put a semicolon at the end of each statement. Depending on your SQL environment, your query may need a semicolon at the end to execute.
If you environment allows it, it will also allow you to run multiple queries at once. */




-- Queries from Udacity course --

------------------------------------
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
-- Rows that don't contain matches with orders are returned at the BOTTOM of the results set, with any columns from the orders table containing Null (or no data).  --
  

SELECT a.id, a.name, o.total
FROM accounts a
LEFT JOIN orders o 
ON o.account_id = a.id
-- RIGHT JOINs and LEFT JOINs are somewhat interchangeable. --
-- So if you change the query so the accounts table is in the FROM clause and the orders table in the JOIN clause and then run a LEFT JOIN instead, the results will be exactly the same as the RIGHT JOIN we did with the previous query. --

SELECT c.countryid, c.countryName, s.stateName
FROM Country c
JOIN State s
ON c.countryid = s.countryid;
-- an Inner JOIN; rows will only be joined where country id is shared between both Country and State tables; non-matching rows are dropped. --

SELECT c.countryid, c.countryName, s.stateName
FROM Country c
LEFT JOIN State s
ON c.countryid = s.countryid;
-- a LEFT JOIN; rows where country id is shared between both Country and State tables are joined together and listed in the results first; remaining rows in the Country table (the Left Table) without matches in the State table are still included, but tacked on at the end of the results. --


-- 2.17 --
SELECT c.countryid, c.countryName, s.stateName
FROM State s
LEFT JOIN Country c
ON c.countryid = s.countryid;
-- Also a LEFT JOIN, but State is now the Left Table and Country is now the Right Table; That means that any rows with unmatched country ids in the State table will now appear at the bottom of the results instead. -- 



-- JOINS and Filtering (2.18) --
SELECT orders.*,
accounts.*
FROM orders
LEFT JOIN accounts
ON orders.account_id = accounts.id
WHERE accounts.sales_rep_id = 321500
-- Shows only rows where column ids match between both orders and accounts tables, in addition to all other rows existing in the orders table, where the sales representative id is 321500. 
    -- Retrieves all columns from BOTH the orders table and the accounts table.
    -- Returns all rows where the account has matches in both the orders table and the accounts table - as well as any additional rows in the orders table where account id did not match a column id in the accounts table.
    -- Then filters those results down to just the rows in that subset containing a sales representative id of 32100.
    -- The logic in the ON clause reduces the rows BEFORE combining the tables - so the orders and accounts tables are combined FIRST here.
    -- The logic in the WHERE clause occurs AFTER the Join occurs - so the subset of rows from the Left Join is further filtered down to just show rows where sales_rep_id is 321500. 

SELECT orders.*,
accounts.*
FROM orders
LEFT JOIN accounts
ON orders.account_id = accounts.id
AND accounts.sales_rep_id = 321500
-- Pre-filters orders table down to ONLY the rows where sales representative id is 32100 by moving this filter to the ON clause.
    -- This effectively pre-filters the Right table to include only rows with sales rep id 321500 BEFORE the join is executed.
    -- In other words, it's like a WHERE clause that applies BEFORE the join, rather than after. 
-- You can think of this like joining orders with a different table - on that includes only a subset of rows from the original accounts table.
-- Includes all rows in the orders table, plus any data in this new prefiltered table that match the account id in the orders table. 
-- This only works of LEFT JOIN - moving this filter to the ON clause of an (inner) will simply the same result as keeping it in the WHERE clause.


-- (OUTER JOIN) Quiz: Last Check (2.19) --
-- 1 --
SELECT r.name region, s.name rep, a.name account
FROM region r
JOIN sales_reps s
ON r.id = s.region_id
AND r.name = 'Midwest'
JOIN accounts a
ON s.id = a.sales_rep_id
ORDER BY a.name;
-- Returns 3 columns - the region name, sales representative name, and the account name.
-- First, gathers only rows from the region table where the name is "Midwest" and joins THOSE rows with information in the sales_reps table where the region id matches those in the "Midwest" subset. 
-- Then new information from the accounts table is joined to this second subset wherever sales representative id matches with the accounts table. 
-- Results are ordered from A-Z by account name.

SELECT r.name region, s.name rep, a.name account
FROM region r
JOIN sales_reps s
ON r.id = s.region_id
AND r.name = 'Midwest'
JOIN accounts a
ON s.id = a.sales_rep_id
ORDER BY a.name;
-- You could also write the query #1 like this. It returns the same results. --
-- This was the answer in 2.20 Solutions: Last Check. --


-- 2 --
SELECT r.name region, s.name rep, a.name account
FROM region r
JOIN sales_reps s
ON r.id = s.region_id AND r.name = 'Midwest' AND s.name LIKE 'S%'
JOIN accounts a
ON s.id = a.sales_rep_id
ORDER BY a.name;
-- Returns the same 3 columns.
-- First, gathers only rows from the region table where region name is "Midwest" in a subset table
-- Also gathers only rows from the sales_reps table where the sales rep name begins with an "S" into a second subset table.
-- Then the "Midwest" subset table is joined with the "rep names that begin with an 'S'" subset table wherever region id matches between the two subsets - this creates a third subset. 
-- The "Midwest + rep names that begin with an 'S'" third subset is then joined with the accounts table wherever sales representative id matches between the third subset and the accounts table.
-- Results are ordered from A-Z by account name.

SELECT r.name region, s.name rep, a.name account
FROM region r
JOIN sales_reps s
ON r.id = s.region_id AND r.name = 'Midwest' AND s.name LIKE 'S%'
JOIN accounts a
ON s.id = a.sales_rep_id
ORDER BY a.name;
-- You could also write query #2 like this. It returns the same results. --
-- This was the answer in 2.20 Solutions: Last Check. --


-- 3 -- 
SELECT r.name region, s.name rep, a.name account
FROM sales_reps s
JOIN region r
ON s.region_id = r.id
JOIN accounts a
ON a.sales_rep_id = s.id
WHERE r.name = 'Midwest' AND s.name LIKE '% K%'
ORDER BY a.name;
-- This was the answer in 2.20 Solutions: Last Check. --
-- These 3 columns are returned from the region, sales_reps and accounts tables.
-- Rows in the sales_reps table is joined with rows in the region table wherever region id matches. This creates a subset.
-- Then this subset is joined with information in the accounts table wherever sales representative id matches between the two. This creates a second subset.
-- Then this second subset is filtered down to only show rows with a region name of "Midwest" and where the sales representative last name starts with a "K." This creates a third subset.
-- Then this third (and final) subset is displayed from A-Z by account name.

SELECT r.name region, s.name rep, a.name account
FROM region r
JOIN sales_reps s
ON r.id = region_id
AND s.name LIKE '% K%' AND r.name = 'Midwest'
JOIN accounts a
ON s.id = a.sales_rep_id
ORDER BY a.name;
-- You could also write query #3 like this. It returns the same results. --
-- This was my solution to 2.19 Quiz: Last Check. 

-- 4 --
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
-- Returns region name, account name and unit price of paper for all orders where standard paper order quantity exceeded $100.
-- Joins region table with sales_reps table wherever region id matches.
-- This subset of rows is then joined with the accounts table wherever sales representative id matches it. 
-- The remaining rows from THAT join is then combined with information from the orders table wherever account id matches it.
-- Then THOSE results are filtered to only show orders where the standard paper order quantity was greater than 100.
-- My solution AND the solution in 2.20 Solutions: Last Check. --

-- 5 --
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
ORDER BY unit_price;
-- Same as query #4, but the final subset was are even further so as to show only orders where standard order quanity is greater than $100 AND poster order quantity is greater than $50. 
-- Results are sorted from least to greatest unit price. 
-- My solution AND the solution in 2.20 Solutions: Last Check. --

-- 6 --
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
-- Same as query #5, but results are sorted from greatest to least unit price instead. 
-- My solution AND the solution in 2.20 Solutions: Last Check. 


-- 7 --
SELECT DISTINCT a.name, w.channel
FROM accounts a
JOIN web_events w
ON a.id = w.account_id
WHERE a.id = 1001;
-- Returns all the different channesl used by account id 1001. 
-- SELECT DISTINCT is used to narrow down the results to only the unique values.
-- My solution AND (basically) the solution in 2.20 Solutions: Last Check.

-- 8 -- 
SELECT o.occurred_at occurred_at, a.name account,
o.total, o.total_amt_usd
FROM orders o
JOIN accounts a
ON o.account_id = a.id
AND o.occurred_at BETWEEN '2015-01-01' AND '2016-01-01';
-- Finds all orders that occurred in 2015, showing the occurred_at, account name, order total, and total order amount in USD columns.
-- My solution AND (basically) the solution in 2.20 Solutions: Last Check. 

------------------------------------
