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

JOIN: allows us to pull data from more than one table at a time. 
- Joining tables gives you access to each of the tables in the SELECT statement through the table name, a ".", and the column name you want to pull from that table.

    - SELECT indicates which column(s) of data you'd like to see in the output. 
        - "TableA." gives us all the columns that table in the output.
        - "TableA.ColumnNameC" gives us that specific column from that table in the output. We need to specify the table every column comes from in the SELECT statement.

    - The FROM clause indicates the first table from which we're pulling data, and the JOIN indicates the second table. To join two tables, list them in the FROM and JOIN clauses.
    - The result is still the same if you were to switch the tables in the FROM and JOIN.

    - The ON clause is used to specify the JOIN condition, by specifying the column on which you'd like to merge the two tables together. 
    - Which side of the = sign a column is listed doesn't matter.
    - Joining tables involves linking their PKs and FKS, usually in the ON clause.

    - A Primary Key (PK) exists in every table and is a unique column for each row. It’s often the first column in tables. The single line in an ERD indicates that a PK can only appear in one row in the table it touches.
    - A Foreign Key (FK) is a column in one table that’s a primary key in another. Each FK links to a primary key in another table. The crow’s foot in an ERD indicates that a FK can appear in multiple rows in the table it touches.
        - Foreign keys can appear multiple times in a single table, while primary keys can only appear once.
    
    - Aliases - When we JOIN tables together, each table is often given an alias. Frequently it's just the first letter of the table name. You can add aliases in the FROM or JOIN clauses by typing the table name, a space, and then the letter. 
    - While aliasing tables is the most common use case, selected columns can also be aliased give the resulting table more readable column names.
    - We can simply write our alias directly after the column name (in the SELECT) or table name (in the FROM or JOIN) by writing the alias directly following the column or table we would like to alias. 
    - This will allow you to create clear column names even if calculations are used to create the column, and you can be more efficient with your code by aliasing table names.

    - one-to-one and one-to-many relationships are common when working with PKs and FKs.
    - however, traditional databases do not allow for many-to-many relationships, as these break the schema down pretty quickly.

    - INNER JOIN (or JOIN is exactly the same command) - returns only rows that appear in both tables; only rows where the id that appears in the first table also matches the id in the second column.
    - ex. simply attaching account names to each order; excluding accounts without orders placed yet is probably fine
    - so far we've been working with inner joins; we have pulled rows only if they exist as a match across two tables.
    
    - OUTER JOIN - used to also include data (rows) that only exist in one table but not the other; allow us to pull rows that might only exist in one of the two tables.  This will introduce a new data type called NULL
    - ex. goal is to count up all the accounts in the region along with their quantities of paper purchased; probably want to include the accounts without any orders 
    - Outer joins (Left Join, Right Join, and Full Outer Join) still provide all of the resulting rows on an inner join - but you may also gain some additional rows.
    - The results of an Outer Join will always have at least as many rows as an inner join (if they have the same logic in the ON clause).
    - The table in the FROM statement is the Left table; the one in the Join statement is the Right table.
        
        LEFT JOIN (or LEFT OUTER JOIN is the exact same command) -  returns all rows matching with the Right table. It also returns any additional rows in the Left table that did not match. 

        RIGHT JOIN (or RIGHT OUTER JOIN is the exact same command) - returns all rows matching with the Left table. It also returns any additional rows from the Right table that did not match. 
        - The rows in the Right table that don't match the rows in the Left table will be included at the bottom of the results. They don't match with rows in the Left table, so any columns from the Left table will contain no data for these rows.
        - You can consider any cell without data as NULL.
        - Left and Right Joins are effectively interchangeable so you'll rarely see a Right Join "in the wild". (if you switch the tables in the FROM and JOIN clauses in a Left Join, you'll effectively still get the same results of a right join. 

        OUTER JOIN (or FULL OUTER JOIN is the exact same command) - this returns the inner join result set, as any unmatched rows from either of the two tables being joined.
        - Again, this returns rows that do not match one another from the two tables. 
        - The use cases for a full outer join are very rare.


        
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
-- (INNER) JOIN (2.3) --
SELECT orders.*,
    accounts.*
FROM accounts
JOIN orders
ON accounts.id = orders.account_id;
-- joins the orders table with the accounts table and pulls all data from both tables.

SELECT accounts.name, orders.occurred_at
FROM orders
JOIN accounts
ON orders.account_id = accounts.id;
-- The accounts table is joined with the orders table on account id, then returns only the account name from the accounts table and the dates in which that account placed orders from the orders table. --

SELECT *
FROM orders
JOIN accounts
ON orders.account_id = accounts.id;
-- The accounts table is joined with the orders table on account id, then returns all columns from BOTH the accounts table and orders table. --

SELECT orders.*
FROM orders
JOIN accounts
ON orders.account_id = accounts.id
-- The orders table is joined with the accounts table on account id, then then pulls all the information ONLY from the orders table. --
-- This query only pulls data from the orders table because SELECT only references columns from the orders table. --

SELECT orders.standard_qty,
orders.gloss_qty,
orders.poster_qty,
accounts.website,
accounts.primary_poc
FROM orders
JOIN accounts
ON orders.account_id = accounts.id;
-- Joins the orders table and accounts table on account id; them pulls these 2 columns from the orders table and these 2 columns from the accounts table. --

SELECT *
FROM web_events
JOIN accounts
ON web_events.account_id = accounts.id
ON accounts.id = orders.accounts_id;
-- Joins 3 tables using the same logic, pulling all data from all 3 joined tables. --
-- For efficiency reasons, we probably don't want to do this unless we actually need the information from all of the tables. --

SELECT web_events.channel,
accounts.name,
orders.total
FROM accounts
ON web_events.account_id = accounts.id
ON accounts.id = orders.accounts_id;
-- Joins 3 tables, again using the same logic. This time pulling only the channel column from the web_events table, the name column from the accounts table, and the total column from the orders table. --

SELECT o.*,
a.*
FROM orders o
JOIN accounts a
o.account_id = a.id;
-- Alias names of "o" and "a" are given for the orders and accounts tables in the FROM and JOIN clauses. The table names can then be replaced with their aliases throughout the rest of the query. (in SELECT and ON, in this case) --

------------------------------------
-- (INNER) JOIN Questions Part 1 (2.11) -- 
    
-- 1 --
SELECT accounts.primary_poc,
web_events.occurred_at,
web_events.channel,
accounts.name
FROM web_events
JOIN accounts
ON web_events.account_id = accounts.id
WHERE accounts.name = 'Walmart';

SELECT a.primary_poc, w.occurred_at, w.channel, a.name
FROM web_events w
JOIN accounts a
ON w.account_id = a.id
WHERE a.name = 'Walmart';
-- Both of these queries show the primary point of contact, time of web event, channel of web event, and the account name (in this case, all Walmart) for all web_events where the account name is "Walmart."
-- The only difference is the tables aren't given aliases in the first query, whereas the second query does give the tables aliases.
-- The web_events table is joined with the accounts table on account id to gather all selected columns for the output. --

-- 2 --
SELECT region.name AS region,
sales_reps.name AS sales_rep,
accounts.name AS account
FROM region
JOIN sales_reps
ON region.id = sales_reps.region_id
JOIN accounts
ON sales_reps.id = accounts.sales_rep_id
ORDER BY accounts.name;

SELECT r.name region, s.name rep, a.name account
FROM sales_reps s
JOIN region r
ON s.region_id = r.id
JOIN accounts a
ON a.sales_rep_id = s.id
ORDER BY a.name;
-- Both queries show the region name from the region table, the sales representative name from the sales_reps table, and the account name from the accounts table. --
    -- region and sales_reps are joined based on region id, meanwhile sales_reps and accounts are joined based on sales representative id. --
    -- The results are sorted from A-Z based by account name.
-- Both queries give the columns aliases for a more readable resulting table, but use different methods to achieve the same result.
-- The only difference is the tables aren't given aliases in the first query, whereas the second query does give the tables aliases. 

-- 3 --
SELECT region.name AS region, 
accounts.name AS account,
orders.total_amt_usd/(orders.total + 0.01) AS unit_price
FROM region
JOIN sales_reps
ON region.id = sales_reps.region_id   
JOIN accounts
ON sales_reps.id = accounts.sales_rep_id
JOIN orders
ON accounts.id = orders.account_id ;

SELECT r.name region, a.name account, 
           o.total_amt_usd/(o.total + 0.01) unit_price
FROM region r
JOIN sales_reps s
ON s.region_id = r.id
JOIN accounts a
ON a.sales_rep_id = s.id
JOIN orders o
ON o.account_id = a.id;
-- Both queries output the region name from the region table, account name from the accounts table, and calculate the order unit_price from the orders table. --
    -- "0.01" is added to the total column in the unit_price calculation to avoid division by zero - a few accounts had totals of 0. --
    -- region and sales_reps tables are joined on region id, sales_reps and accounts tables are joined on sales representative id, and accounts and orders tables or joined on account id. -- 
-- Both queries give the columns aliases for a more readable resulting table, but use different methods to achieve the same result.
-- The only difference is the tables aren't given aliases in the first query, whereas the second query does give the tables aliases. --

------------------------------------

-- OUTER JOINS (2.13) --

SELECT a.id, a.name, o.total
FROM orders o
JOIN accounts a
ON orders.account_id = accounts.id
-- This an example of an inner join (what you've done so far). --
-- This pulls the account id and account name from the accounts table and the total from the orders table - but only the rows where the account id in the orders table matches the account id in the accounts table. --

SELECT c.countryid, c.countryName, s.stateName
FROM Country c
JOIN State s
ON c.countryid = s.countryid;
-- an inner join; returns country id and country name from the Country table and state name from the State table - only for where the country id in the Country table matches the country id in the State table. --

SELECT c.countryid, c.countryName, s.stateName
FROM Country c
LEFT JOIN State s
ON c.countryid = s.countryid;
-- a left join, also returns country id and country name from the Country table and state name from the State table - includes all the rows where the country id matches in both tables. ALSO returns additional rows from the Country table where country id didn't match a country id in the State table. --
-- We are essentially JOINing the matching PK-FK links from the two tables, as we did before, but we are also pulling all the additional rows from the Country table even if they don't have a match in the State table. 
-- Therefore, we're obtaining all the rows of the INNER JOIN, but we also get additional rows from the table in the FROM.

SELECT c.countryid, c.countryName, s.stateName
FROM State s
LEFT JOIN Country c
ON c.countryid = s.countryid;
-- FINAL LEFT JOIN Note - If we were to flip the tables, we would actually obtain the same exact result as the (inner) JOIN statement directly above.
-- This is because if State is on the LEFT table, all of the rows exist in the RIGHT table again.








