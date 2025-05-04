DROP DATABASE IF EXISTS team6_projectdb CASCADE;
CREATE DATABASE team6_projectdb LOCATION '/user/team6/project/hive/warehouse';
USE team6_projectdb;

-- Create external table for dim_base
CREATE EXTERNAL TABLE dim_base
STORED AS AVRO
LOCATION '/user/team6/project/warehouse/dim_base'
TBLPROPERTIES ('avro.schema.url'='/user/team6/project/warehouse/avsc/dim_base.avsc');

-- Create external table for dim_location
CREATE EXTERNAL TABLE dim_location
STORED AS AVRO
LOCATION '/user/team6/project/warehouse/dim_location'
TBLPROPERTIES ('avro.schema.url'='/user/team6/project/warehouse/avsc/dim_location.avsc');

-- Create external table for dim_calendar
CREATE EXTERNAL TABLE dim_calendar
STORED AS AVRO
LOCATION '/user/team6/project/warehouse/dim_calendar'
TBLPROPERTIES ('avro.schema.url'='/user/team6/project/warehouse/avsc/dim_calendar.avsc');

-- Create external table for fact_fhv_trips
CREATE EXTERNAL TABLE fact_fhv_trips
STORED AS AVRO
LOCATION '/user/team6/project/warehouse/fact_fhv_trips'
TBLPROPERTIES ('avro.schema.url'='/user/team6/project/warehouse/avsc/fact_fhv_trips.avsc');



-- Check table contents
SELECT * FROM dim_base LIMIT 10;
SELECT * FROM dim_location LIMIT 10;
SELECT * FROM dim_calendar LIMIT 10;
SELECT * FROM fact_fhv_trips LIMIT 10;
