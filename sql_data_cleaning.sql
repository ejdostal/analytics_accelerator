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


-- Separates city and state, then returns just the city for each row in the "city" column.

SELECT first_name,
  last_name,
  city_state,
  POSTITION(',' IN city_state) AS comma_position,     -- returns the index number for where the comma in city_state in each row (using POSITION).
  STRPOS(city_state, ',') AS substr_comma_position,   -- also returns the index number for where the comma in city_state in each row (using STRPOS).
  LOWER(city_state) AS lowercase,        -- converts all letters in city_state field to lowercase.
  UPPER(city_state) AS uppercase,        -- converts all letters in city_state field to uppercase.
  LEFT(city_state, POSITION(',' IN city_state) - 1) AS city    -- returns the full text up to the position of the comma, minus the actual comma.
FROM customer_data;





