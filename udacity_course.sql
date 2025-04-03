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
    - used to consider more than one column at a time; you may link as many statements as you would like to consider at the same time.
    - Each time you link a new statement with an AND, you need to state the column of interest independently, even when referring to the same column.
    - AND works with arithmetic operators (+, *, -, /).
    - LIKE, IN, and NOT operators can be linked using the AND operator. 

    BETWEEN:
    - When using the same column for different parts of an AND statement, BETWEEN is often a cleaner replacement.
    AND: WHERE column >= 6 AND column <=10
    BETWEEN (cleaner): WHERE column BETWEEN 6 AND 10
    - BETWEEN is inclusive, which means that the end points of BETWEEN statements are included in final results.
    - BETWEEN assumes the time is at 00:00:00 (i.e. midnight) for dates.
    - For that reason, you'll want to set the last endpoint one day later than the actual date. 
    - Ex. To find all dates in 2016, you'd set it as date BETWEEN '2016-01-01' AND '2017-01-01' - finding all dates between midnight on Jan 1st 2016 and midnight on Jan 1st 2017.

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


*****

Derived columns - A new column created by manipulating existing columns in the database. 
- Give the column an alias by adding AS to the end of the line that produces the derived column.

*****

Best Practice:
- Write SQL COMMANDS in all uppercase letters, keep everything else in your query lowercase.
- Avoid using spaces in table names and column names. 
  - In Postgres, if you have spaces in column or table names, you need to refer to these columns/tables with double quotes around them (Ex: FROM "Table Name" as opposed to FROM table_name). 
  - In other environments, you might see this as square brackets instead (Ex: FROM [Table Name]). 
- Put a semicolon at the end of each statement. Depending on your SQL environment, your query may need a semicolon at the end to execute.
If you environment allows it, it will also allow you to run multiple queries at once

*/


-- Queries from Udacity course --
*****
    
-- SELECT and FROM (1.11) --
SELECT * 
FROM orders  
-- shows every row in the orders table, showing all available columns --

SELECT id, account_id, occurred_at
FROM orders;
-- shows data from just these 3 columns in the orders table. --


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



