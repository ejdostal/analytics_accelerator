/* SQL Advanced JOINS & Performance Tuning:

- INNER JOIN - produces results for which the join condition is matched in both tables.
- LEFT JOIN - also includes unmatched rows from the left table, which is indicated in the “FROM” clause.
- RIGHT JOIN -  similar to left joins, but includes unmatched data from the right table -- the one that’s indicated in the JOIN clause.

FULL JOIN - includes unmatched rows from both tables being joined. A full outer join returns unmatched records in each table with null values for the columns that came from the opposite table.
- A common application of this is when joining two tables on a timestamp.
- Is commonly used in conjunction with aggregations to understand the amount of overlap between two tables.
- If you wanted to return unmatched rows only, which is useful for some cases of data assessment, you can isolate them by adding the following line to the end of the query: */
FULL OUTER JOIN /* with */ WHERE A.Key IS NULL OR B.Key IS NULL

/* 8.3: Shows each account who has a sales rep and each sales rep that has an account (all of the columns in these returned rows will be full)
but also each account that does not have a sales rep and each sales rep that does not have an account (some of the columns in these returned rows will be empty) */

SELECT *
FROM accounts a
FULL OUTER JOIN sales_reps s
ON a.sales_rep_id = s.id;


/* If unmatched rows exist, you could isolate them by adding the following line to the end of the query: */

SELECT *
FROM accounts a
FULL OUTER JOIN sales_reps s
ON a.sales_rep_id = s.id
WHERE a.sales_rep_id IS NULL OR s.id IS NULL;

