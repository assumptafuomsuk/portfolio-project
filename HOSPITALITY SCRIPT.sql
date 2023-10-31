-- creating the database-- 
CREATE DATABASE hospitality;
USE hospitality;


-- creating a table called records in the database 
CREATE TABLE records(
reservation_id VARCHAR (40),
avg_room_rate FLOAT,
check_in_date VARCHAR(10),
stay_duration INT,
adults INT,
children INT,
room_type CHAR(10),
special_request_flag CHAR(5),
booking_channel VARCHAR(30),
reservation_status CHAR(20),
advanced_booking CHAR(5),
property CHAR(30),
booking_date VARCHAR(10),
rate_type CHAR(15)
);

-- checking to confirm if all columns were created
SELECT * 
FROM records;


-- I observed that our date column should ideally be a date data type instead of varchar. To rectify this, we need to follow the procedure outlined below.
-- 1. create a new column in the table with the right data type

 SET SQL_SAFE_UPDATES = 0;
 
ALTER TABLE records
ADD check_in_dates DATE;
 
ALTER TABLE records
ADD booking_dates DATE;

-- 2. update the record from the initial column into the new column and change the data format to the correct format 
UPDATE records 
SET booking_dates = STR_TO_DATE(booking_date, '%m/ %d/ %Y');

UPDATE records 
SET check_in_dates = STR_TO_DATE(check_in_date, '%m/ %d/ %Y');

-- Check to see that the date format is now correct
SELECT booking_date,
	   booking_dates,
       check_in_date,
       check_in_dates
FROM records;

--  Drop the old column with the wrong data format
ALTER TABLE records
DROP check_in_date;

ALTER TABLE records
DROP booking_date;

--  Selecting the table to make sure that columns were dropped
SELECT *
FROM records;

-- Create a new column called check_out_date
ALTER TABLE records
ADD COLUMN check_out_date DATE;

--  will be adding the check_in_date plus the stay_duration to generate a checkout date for each property.
UPDATE records
SET check_out_date = DATE_ADD(check_in_dates, INTERVAL stay_duration DAY);

SET SQL_SAFE_UPDATES = 1;

-- the total number of records in the table 
SELECT count(*)
FROM records;

 -- show distinct values in columns 
SELECT DISTINCT room_type
FROM records;

SELECT DISTINCT booking_channel
FROM records;

SELECT DISTINCT reservation_status
FROM records;

SELECT DISTINCT property
FROM records;

SELECT DISTINCT rate_type
FROM records;

-- 1. What is the rate paid for each room in each hotel?
SELECT property,
       room_type,
       rate_type,
       avg_room_rate 
FROM records
GROUP BY property,
         room_type,
         rate_type,
	 avg_room_rate
ORDER BY property;


-- 2. Different room types in each property and the number of times they were booked 
SELECT property,
       room_type,
       COUNT(*) AS room_type_count
FROM records
GROUP BY property, 
	 room_type
ORDER BY property;
         
	
-- 3. number of times guests checked into each hotel for the year
SELECT property,
       COUNT(*) AS number_of_check_in
FROM records
GROUP BY property
ORDER BY count(*) DESC;
	   

-- 4. most booked rate type 
SELECT rate_type,
	   COUNT(*) AS rate_type_count,
	   COUNT(*) / (SELECT COUNT(*) FROM records) * 100 AS percentage
FROM records
GROUP BY rate_type
ORDER BY COUNT(*) DESC;

-- 5. booking channels most used and revenue generated
SELECT booking_channel,
       ROUND(SUM(avg_room_rate*stay_duration), 2) AS revenue_generated 
FROM records
WHERE reservation_status !='No-show'
GROUP BY booking_channel
ORDER BY 2 DESC;


-- 6. what is the percentage of the different reservation status
SELECT property,
       reservation_status,
       COUNT(*) AS status_count,
       COUNT(*) / (SELECT COUNT(*) FROM records) * 100 AS percentage
FROM records
GROUP BY property, 
         reservation_status
ORDER BY 1,3 DESC;

    
-- 7. Revenue generated by each hotel 
SELECT property,
       ROUND(SUM(avg_room_rate*stay_duration), 2) AS revenue_generated
FROM records
WHERE reservation_status !='No-show'
GROUP BY property
ORDER BY 2 DESC; 


-- 8. What is the average stay duration 
SELECT CONCAT(ROUND(AVG(stay_duration)),' DAYS') AS average_stay_duration
FROM records; 

-- 9. booking trends over different months in a year 
SELECT booking_channel,
       DATE_FORMAT(check_in_dates, '%M') AS year_months,
       COUNT(*) AS booking_count
FROM records
GROUP BY booking_channel,
         DATE_FORMAT(check_in_dates, '%M')
ORDER BY  COUNT(*) DESC; 

-- 10. percentage of special request flags for all properties
SELECT special_request_flag
       COUNT(*) AS special_request_flag_count
       COUNT(*) / (SELECT COUNT(*) FROM records) * 100 AS percentage
FROM records
GROUP BY special_request_flag
ORDER BY COUNT(*) DESC;





