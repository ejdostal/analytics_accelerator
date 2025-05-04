/* SQL Data Cleaning Techniques - Get from raw data to clean data that's useful for analysis.

1. Clean and re-structure messy data.
2. Convert columns to different data types.
3. Tricks for manipulating NULLs. 

- Text fields: make clean groups that will be useful to aggregate across. 
- When using functions inside of other functions - the innermost functions will be evaluated first - followed by the functions that encapsulate them. 

- LEFT pulls a specified number of characters for each row in a specified column starting at the beginning (or from the left)
- RIGHT pulls a specified number of characters for each row in a specified column starting at the end (or from the right)
- LENGTH provides the number of characters for each row of a specified column; returns the length of the string. */

-- Queries --

/* Pulls area code, phone number without area code (twice, in two different ways) for each customer name. */ 

SELECT first_name,
  last_name,
  phone_number
  LEFT(phone_number, 3) AS area_code,      
  -- pulls the area code out of the phone number.
  
  RIGHT(phone_number, 8) AS phone_number_only,    
  -- pulls the entire phone number, with hyphen, but without area code.
  
  RIGHT(phone_number, LENGTH(phone_number) - 4) AS phone_number_alt   
  -- you can also represent the RIGHT function as a function of the length: the full phone number (12 characters) - the area code, with hyphen (4 characters) =  the phone number, with hyphen, without area code. 
FROM customer_data 


/* Provides the type of web address (or extension) each company is using for their website and provides how many of each website type exist in the accounts table. */

SELECT RIGHT(website, 3) AS domain, COUNT(*) num_companies
FROM accounts
GROUP BY 1
ORDER BY 2 DESC;
