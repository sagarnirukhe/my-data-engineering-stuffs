--Create Database
CREATE DATABASE IF NOT EXISTS ${hivevar:hive_db_name};
USE ${hivevar:hive_db_name};

--Drop manage table
DROP TABLE IF EXISTS ${hivevar:hive_tbl_name};

--Create Manage table
CREATE TABLE IF NOT EXISTS ${hivevar:hive_tbl_name}(custid int,username string,quote_count int,ip string,entry_time string,prp_1 string,prp_2 string,prp_3 string,ms string, http_type string,purchase_category string,total_count string,purchase_sub_category string,http_info string,status_code int,filename string,create_dt date) ROW FORMAT SERDE  'org.apache.hadoop.hive.serde2.avro.AvroSerDe' WITH SERDEPROPERTIES ('avro.schema.url'='${hivevar:hive_avaro_schema}') STORED as INPUTFORMAT 'org.apache.hadoop.hive.ql.io.avro.AvroContainerInputFormat' OUTPUTFORMAT 'org.apache.hadoop.hive.ql.io.avro.AvroContainerOutputFormat' LOCATION '${hivevar:hive_op_path}';

-- Drop External Table If Exists
DROP TABLE IF EXISTS ${hivevar:hive_ext_tbl_name};

--Create External Table
CREATE EXTERNAL TABLE IF NOT EXISTS ${hivevar:hive_ext_tbl_name}(custid int,username string,quote_count int,ip string,entry_time string,prp_1 string,prp_2 string,prp_3 string,ms string, http_type string,purchase_category string,total_count string,purchase_sub_category string,http_info string,status_code int,filename string,create_dt date) PARTITIONED BY (year string, month string) ROW FORMAT SERDE 'org.apache.hadoop.hive.serde2.avro.AvroSerDe' WITH SERDEPROPERTIES ('avro.schema.url'='${hivevar:hive_avaro_schema}') STORED as INPUTFORMAT 'org.apache.hadoop.hive.ql.io.avro.AvroContainerInputFormat' OUTPUTFORMAT 'org.apache.hadoop.hive.ql.io.avro.AvroContainerOutputFormat';

show tables;

--Set Dynamic Partition Properties
set hive.exec.dynamic.partition=true;
set hive.exec.dynamic.partition.mode=nonstrict;
set hive.exec.max.dynamic.partitions=250;
set hive.exec.max.dynamic.partitions.pernode=250;
set hive.stats.column.autogather=false;

--Insert data from Manage table to partitioed External Table
INSERT INTO TABLE ${hivevar:hive_ext_tbl_name} PARTITION (year,month) (custid,username,quote_count,ip,entry_time,prp_1,prp_2,prp_3,ms,http_type,purchase_category,total_count,purchase_sub_category,http_info ,status_code,filename,create_dt,year,month) SELECT custid,username,quote_count,ip,entry_time,prp_1,prp_2,prp_3,ms,http_type,purchase_category,total_count,purchase_sub_category,http_info ,status_code,filename,create_dt,year(from_unixtime(unix_timestamp(substr(entry_time,1,instr(entry_time,':')-1),'dd/MMM/yyy'))) year,lpad(month(from_unixtime(unix_timestamp(substr(entry_time,1,instr(entry_time,':')-1),'dd/MMM/yyy'))),2,'0') month FROM ${hivevar:hive_tbl_name};

--Drop manage table
DROP TABLE IF EXISTS ${hivevar:hive_tbl_name};

