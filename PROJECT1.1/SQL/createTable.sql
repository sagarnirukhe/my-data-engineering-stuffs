-- Creats DATABASE
CREATE DATABASE IF NOT EXISTS customer_db;

-- Use the customer_db database.
USE customer_db;
 
-- Drop an customer table. 
DROP TABLE IF EXISTS customer;

-- Create an actor table.
CREATE TABLE IF NOT EXISTS customer
(custid INT,
username varchar(30),
quote_count varchar(30),
ip varchar(30),
entry_time varchar(30),
prp_1 varchar(30),
prp_2 varchar(30),
prp_3 varchar(30),
ms varchar(30),
http_type varchar(30),
purchase_category varchar(30),
total_count varchar(30),
purchase_sub_category varchar(30),
http_info varchar(250),
status_code integer(10),
filename varchar(50),
create_dt date
);

-- Create an archive table.
CREATE TABLE IF NOT EXISTS customer_archive
(custid INT,
username varchar(30),
quote_count varchar(30),
ip varchar(30),
entry_time varchar(30),
prp_1 varchar(30),
prp_2 varchar(30),
prp_3 varchar(30),
ms varchar(30),
http_type varchar(30),
purchase_category varchar(30),
total_count varchar(30),
purchase_sub_category varchar(30),
http_info varchar(250),
status_code integer(10),
filename varchar(50),
archive_dt date not null DEFAULT (current_date));

