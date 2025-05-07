/* SQL Joins

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

Nulls: a datatype that specifies where data does not exist.
    - Nulls are often ignored in aggregation functions.
    - When identifying NULLs in a WHERE clause, we write IS NULL or IS NOT NULL. (We don't use =, because NULL isn't considered a value in SQL. Rather, it is a property of the data.)
    - NULLs frequently occur when performing a LEFT or RIGHT JOIN. 
    - NULLs can also occur from simply missing data in our database
- Use ISNULL or IS NOT NULL to SHOW all the rows in a specific column for which their is or isn't Null values.

*/ 

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