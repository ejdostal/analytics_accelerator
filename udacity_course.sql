-- select 3 columns from web_events table, limited to first 15 rows. -- 

SELECT occurred_at,
  account_id
  channel
FROM web_events
LIMIT 15;
