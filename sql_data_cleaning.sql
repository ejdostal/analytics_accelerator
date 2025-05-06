/* SQL Data Cleaning Techniques - Get from raw data to clean data that's useful for analysis.

1. Clean and re-structure messy data.
2. Convert columns to different data types.
3. Tricks for manipulating NULLs. 

- Text fields: make clean groups that will be useful to aggregate across. 
- When using functions inside of other functions - the innermost functions will be evaluated first - followed by the functions that encapsulate them. 

- LEFT pulls a specified number of characters for each row in a specified column starting at the beginning (or from the left)
- RIGHT pulls a specified number of characters for each row in a specified column starting at the end (or from the right)
- LENGTH provides the number of characters for each row of a specified column; returns the length of the string.
- POSITION takes a character and a column, and provides the index where that character is for each row. The index of the first position is 1 in SQL. 
- STRPOS provides the same result as POSITION, but the syntax for achieving those results is a bit different --> STRPOS(city_state, ',') vs. POSITION(',' IN city_state)
  - POSITION and STRPOS are case-sensitive, so if you want to pull an index regardless of the case of a letter, you might need to use LOWER or UPPER.
- CONCAT and Pipping || both allow you to combine columns together across rows.

- CAST changes a column from one data type to another.
  - Both CAST and :: allow for the converting of one data type to another (the CAST function get a little tricky to read).
  - Remember Dates in SQL are stored YYYY - MM - DD.
  - CAST is useful to change lots of column types, but most useful for numbers or dates.
    - Performing any type of string operation on a number (ex. LEFT, RIGHT, SUBSTRING) while automatically turn it into a string anyway.

- TO_DATE converts string to date according to the given format.
- DATE_TRUNC estimates your date to a particular part of your date-time column (day, month, year)
- DATE_PART pulls a specific portion of a date from your date-time column, elliminating the rest (ex. pulls just the dow for the order)
- TRIM removes characters from the beginning and end of a string. (often moving data from Excel to other storage systems can add unwanted spaces to the beginning or end of a row.)
- SUBSTR extracts a portion of the string, starting a given number of characters in and then returning a given number of characters. 
- COALESCE returns the first non-NULL value passed for each row.
  - ex. display Nulls as "0" when wanting to use numerical data
  - ex. When performing OUTER JOINs resulting in some unmatched rows to display Nulls as something other than a Null value
  - ex. When working with COUNT, AVERAGE, or another function that treats Nulls differently from 0's


Queries:
--------
  
Pulls area code, phone number without area code (twice, in two different ways) for each customer name. */ 

SELECT first_name,
  last_name,
  phone_number
  LEFT(phone_number, 3) AS area_code,       -- pulls the area code out of the phone number.
  RIGHT(phone_number, 8) AS phone_number_only,     -- pulls the entire phone number, with hyphen, but without area code.
  RIGHT(phone_number, LENGTH(phone_number) - 4) AS phone_number_alt     -- you can also represent the RIGHT function as a function of the length: the full phone number (12 characters) - the area code, with hyphen (4 characters) =  the phone number, with hyphen, without area code.
FROM customer_data 
  
-- Provides the type of web address (or extension) each company is using for their website and provides how many of each website type exist in the accounts table. 

SELECT RIGHT(website, 3) AS domain, 
  COUNT(*) num_companies
FROM accounts
GROUP BY 1
ORDER BY 2 DESC;

-- Pulls the first character of each company name to see the distribution of company names that begin with each letter (or number).

SELECT LEFT(UPPER(name), 1) AS first_letter, COUNT(*) num_companies    -- UPPER ensures that both upper and lowercase versions of the same letter end up in the same group. 
FROM accounts
GROUP BY 1
ORDER BY 2 DESC;

-- Separates company names into two groups: one where company names start with a number, another where company names start with a letter. Then finds the proportion of company names that start with a letter vs. starts with a number. 

WITH t1 AS ( 
SELECT name, 
CASE WHEN LEFT(UPPER(name), 1) IN('0','1','2','3','4','5','6','7','8','9') 
    THEN 1 ELSE 0 END AS num,      -- in the "num" group, company names that start with a number return 1, names that start with a letter return 0. 
CASE WHEN LEFT(UPPER(name), 1) IN ('0','1','2','3','4','5','6','7','8','9') 
    THEN 0 ELSE 1 END AS letter    -- in the "letter" group, company name names that start with a number return 0, names that start with a letter return 1. 
FROM accounts
) 
SELECT SUM(num) nums, SUM(letter) letters 
FROM t1;     -- in the "nums" column, all values in the "num" group are summed. (company names starting with a number returned 1's)
             -- in the "letters" column, all values in the "letter" group are summed. (company names starting with a letter  returned 1's)


-- Finds the proportion of company names starting with a vowel vs. those starting with something else (consonant). 

SELECT SUM(vowels) vowels, SUM(other) others   -- In the "vowels" column, all 1's in the "vowel" group are summed up, in the "others" column all 1's in the "others" group are summed.
FROM (SELECT name, 
  CASE WHEN LEFT(UPPER(name), 1) IN ('A','E','I','O','U') 
      THEN 1 ELSE 0 END AS vowels,    -- in the "vowels" group, company names that start with a vowel return 1, names that DON'T start with a vowel return 0. 
  CASE WHEN LEFT(UPPER(name), 1) IN ('A','E','I','O','U') 
      THEN 0 ELSE 1 END AS other      -- in the "other" group, company names that DON'T start with a vowel return 1, names that start with a vowel 0. 
FROM accounts) t1;


-- Separates city and state, then returns just the city name in a "city" column.

SELECT first_name,
  last_name,
  city_state,
  POSTITION(',' IN city_state) AS comma_position,     -- returns the index number for where the comma in city_state in each row (using POSITION).
  STRPOS(city_state, ',') AS substr_comma_position,   -- also returns the index number for where the comma in city_state in each row (using STRPOS).
  LOWER(city_state) AS lowercase,        -- converts all letters in city_state field to lowercase.
  UPPER(city_state) AS uppercase,        -- converts all letters in city_state field to uppercase.
  LEFT(city_state, POSITION(',' IN city_state) - 1) AS city    -- returns the full text up to the position of the comma, minus the actual comma.
FROM customer_data;


-- 1a) Separates the first name and last name of the primary_poc in 2 different columns.

SELECT LEFT(primary_poc, POSITION(' ' IN primary_poc) -1 ) first_name,         -- finds the index number of the space in the primary_poc column, the returns the full text in the primary_poc column up to the position of that space, minus the actual space.
RIGHT(primary_poc, LENGTH(primary_poc) - POSITION(' ' IN primary_poc)) last_name    
  /* Finds the total number of characters of the text in the primary_poc column
    then finds the index number of the space in the primary_poc column
    Subtracts the number of characters to the space in the text from the total number of characters in the text
    Then returns everything that number of characters to the right of the text. (everything after the space) */
FROM accounts;


-- 2a) Also separates the first name and last name of the primary_poc in 2 different columns - but uses STRPOS syntax to find the index rather than POSITION.
  
SELECT LEFT(primary_poc, STRPOS(primary_poc, ' ') -1 ) first_name,       -- calculates the index position of the space, then returns everything to the left of it, minus the actual space
RIGHT(primary_poc, LENGTH(primary_poc) - STRPOS(primary_poc, ' ')) last_name      -- calculates the index position of the space, subtracts the position of the space in the text from the total number of characters in the text, then returns everything that number of characters from the right, or end, of the text. 
FROM accounts;


-- 1b) Separates the first name and last name of the sales rep into 2 different columns, using POSITION to find the index of the space in the text.
SELECT LEFT(name, POSITION(' ' IN name) - 1) first_name,    -- finds the index position of the space in the text, then returns everything that number of characters in, minus the actual space. 
RIGHT(name, LENGTH(name) - POSITION(' ' IN name)) last_name   --- finds the index position of the space in the text, subtracts that from the total number of characters in the whole text, thne returns everyhting that number of the characters from the right, or end, of the text. 
FROM sales_reps;

-- 2b) Separates the first name and last name of the sales rep into 2 different columns, using STRPOS to find the index of the space in the text.

SELECT LEFT(name, STRPOS(name, ' ') - 1) first_name, 
RIGHT(name, LENGTH(name) - STRPOS(name, ' ')) last_name
FROM sales_reps;


-- Combines first and last name (from 2 different columns) into a single column (full name).

SELECT first_name,
  last_name, 
  CONCAT(first_name, ' ', last_name) AS full_name,  -- concatenates first and last name together into one "full_name" column, using CONCAT()
  first_name || ' ' || last_name AS full_name_alt   -- concatenates first and last name together into one "full_name_alt" column, using Piping (||)
FROM customer_data;


-- 3a) Creates an email address for each primary_poc in a company from the primary_poc's name and the company's name - using a Subquery and POSITION.

SELECT first_name, last_name, CONCAT(first_name, '.', last_name, '@', name, '.com') email_address
FROM (SELECT name,
    LEFT(primary_poc, POSITION( ' ' IN primary_poc)-1) first_name, 
    RIGHT(primary_poc, LENGTH(primary_poc) - POSITION(' ' IN primary_poc)) last_name
  FROM accounts
  )                                           
AS t1;

-- 3b) Also creates an email address for each primary_poc in a company from the primary_poc's name and the company's name - instead using a CTE and STRPOS.

WITH t1 AS (
    SELECT LEFT(primary_poc, STRPOS(primary_poc, ' ') -1 ) first_name,  
    RIGHT(primary_poc, LENGTH(primary_poc) - STRPOS(primary_poc, ' ')) last_name, name
    FROM accounts
    )

SELECT first_name, last_name, CONCAT(first_name, '.', last_name, '@', name, '.com')
FROM t1;


-- 3c Creates an email address for each primary_poc in a company from the primary_poc's name and the company's name, effectively removing all the spaces from the company name (so the email address will work).

WITH t1 AS (
  SELECT LEFT(primary_poc,    
  STRPOS(primary_poc, ' ') -1 ) first_name,  
  RIGHT(primary_poc, LENGTH(primary_poc) - STRPOS(primary_poc, ' ')) last_name, 
  name
  FROM accounts
)
          
SELECT first_name, 
  last_name, 
  CONCAT(first_name, '.', last_name, '@', REPLACE(name, ' ', ''), '.com')
FROM  t1;


-- 4a. Creates an initial password that the primary_poc can change on their first login. 

WITH t1 AS (
SELECT LEFT(primary_poc, POSITION(' ' IN primary_poc) -1) first_name,
RIGHT(primary_poc, LENGTH(primary_poc) - POSITION(' ' in primary_poc)) last_name,
REPLACE(name, ' ', '') company_name                                 FROM accounts
 ),

t2 AS (
  SELECT LEFT(first_name, 1) first_letter_first,
  RIGHT (first_name, 1) last_letter_first,
  LEFT(last_name, 1) first_letter_last,
  RIGHT (last_name, 1) last_letter_last,
  LENGTH(first_name) len_first_name,
  LENGTH(last_name) len_last_name,
  company_name
  FROM t1)

SELECT UPPER(CONCAT(first_letter_first, last_letter_first, first_letter_last, last_letter_last, len_first_name, len_last_name, company_name)) AS password
FROM t2


-- 4b. Also, creates an initial password that the primary_poc can change on their first login - but perhaps better because it uses less code.

WITH t1 AS (
    SELECT LEFT(primary_poc,     
    STRPOS(primary_poc, ' ') -1 ) first_name,  
    RIGHT(primary_poc, LENGTH(primary_poc) - STRPOS(primary_poc, ' ')) last_name, 
    name
    FROM accounts) -- isolates the first and last names of the primary_poc

SELECT first_name, 
last_name, 
CONCAT(first_name, '.', last_name, '@', name, '.com'), 
LEFT(LOWER(first_name), 1) || RIGHT(LOWER(first_name), 1) || LEFT(LOWER(last_name), 1) || RIGHT(LOWER(last_name), 1) || LENGTH(first_name) || LENGTH(last_name) || REPLACE(UPPER(name), ' ', '')
FROM t1;         -- Concatenates the first and last letters of the first name, first and last letters of the last name, the length of both names, and the company name - all in uppercase letters - into a password for each primary_poc


-- Takes 3 separate columns of day, month, and year of each given record and converts it into a single date.

SELECT *,
  DATE_PART('month', TO_DATE(month, 'month')) AS clean_month,   -- takes a text month (ex. January) and converts it from a string type to a date type, then pulls just the month from it (ex. 1).
  year || '-' || DATE_PART('month', TO_DATE(month, 'month')) || '-' day AS concatenated_date,   -- concatenates the new "clean_month" column with existing day and month columns to produce something that looks like a date for each record.
  CAST (year || '-' || DATE_PART('month', TO_DATE(month, 'month')) || '-' || day AS date) AS formatted_date   -- changes the new "concatenated_date" column into a date format (so the database now understands that this is a date).
  (year || '-' || DATE_PART('month', TO_DATE(month, 'month')) || '-' day)::date AS fromatted_date_alt    -- also changes the new "concatenated_date" column into a date format, but using shorthand for CAST
FROM ad_clicks


-- 5a. Pulls the values from the date column into a "yyyy-mm-dd" format using SUBSTR and LEFT.

SELECT date orig_date, 
(SUBSTR(date, 7, 4)  -- starting with the 7th character in the string, pulls the 4 digits of the year.
|| '-' 
|| LEFT(date, 2)     -- starting from the beginning of the string (LEFT is used instead of SUBSTR), pulls the 2 digits for the month 
|| '-'
|| SUBSTR(date, 4, 2)  -- starting with the 4th character in the string, pulls the 2 digits for the day.
) new_date     -- all substrings are combined in the new "new_date" column.
FROM sf_crime_data;


-- 5b. Also pulls the values from the date column into a "yyyy-mm-dd" format using SUBSTR and LEFT, then converts the new "new_date" column into a date type.

SELECT date orig_date, 
(SUBSTR(date, 7, 4) || '-' || LEFT(date, 2) || '-' || SUBSTR(date, 4, 2))::DATE new_date
FROM sf_crime_data;


-- Replaces the Null values in the primary_poc column with "no POC."

SELECT *,
COALESCE (primary_poc, 'no POC') AS primary_poc_modified 
FROM accounts
WHERE primary_poc IS NULL 


-- Counts the primary_poc column, ignoring Nulls in "regular_count" column ; including Nulls in "modified_count" column, using COALESCE.

SELECT COUNT(primary_poc) AS regular_count,
COUNT(COALESCE (primary_poc, 'no POC')) AS modified_count 
FROM accounts
WHERE primary_poc IS NULL 