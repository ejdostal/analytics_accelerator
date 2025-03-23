/* 
Clauses, Commands / Statements:
- SELECT: choose columns (See all columns with *)

- FROM: choose tables

- ORDER BY: sorts results by the data in any column
  - Useful when you want to sort orders by date, for example
  - The default is to sort in Ascending order: A to Z, lowest to highest, or earliest to latest. 
  - DESC can be added after the column in your ORDER BY statement to flip the sort. 
  - SQL queries only sort data temporarily, unlike sorting a spreadsheet by a column in Excel or Google Sheets which permanently alters the data until you change or undo it.
  - You can also use ORDER BY over multiple columns to achieve results. The sorting with happen in the order that you specify the columns.
    --> Ex. ORDER BY account_id, total_amount_usd DESC; <--
    This orders results by account id (from smallest to largest), then records within each account are ordered from largest total_amount_usd to smallest. 

- LIMIT: limits results to the first few rows in the table.
  - Useful when you want to see just the first few rows of a table. This can be much faster for loading than if we load the entire dataset. 
  - The LIMIT command is always the very last part of a query.


Best Practice:
- Write SQL COMMANDS in all uppercase letters, keep everything else in your query lowercase.
- Avoid using spaces in table names and column names. 
  - In Postgres, if you have spaces in column or table names, you need to refer to these columns/tables with double quotes around them (Ex: FROM "Table Name" as opposed to FROM table_name). 
  - In other environments, you might see this as square brackets instead (Ex: FROM [Table Name]). 
- Put a semicolon at the end of each statement. Depending on your SQL environment, your query may need a semicolon at the end to execute.
If you environment allows it, it will also allow you to run multiple queries at once
*/ 


-- Queries from Udacity course --

-- SELECT & FROM -- 
SELECT * 
FROM orders  
  -- shows every row in the orders table, showing all available columns --

SELECT id, account_id, occurred_at
FROM orders;
  -- shows data from just these 3 columns in the orders table. --


-- LIMIT & ORDER BY -- 
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
