USE team6_projectdb;

SET hive.exec.dynamic.partition=true;
SET hive.exec.dynamic.partition.mode=nonstrict;
SET hive.enforce.bucketing=true;

CREATE EXTERNAL TABLE IF NOT EXISTS fact_fhv_trips_part (
    hvfhs_license_num STRING,
    dispatching_base_num STRING,
    originating_base_num STRING,
    request_datetime BIGINT,
    on_scene_datetime BIGINT,
    dropoff_datetime BIGINT,
    pu_location_id INT,
    do_location_id INT,
    trip_miles DOUBLE,
    trip_time BIGINT,
    base_passenger_fare DOUBLE,
    tolls DOUBLE,
    bcf DOUBLE,
    sales_tax DOUBLE,
    congestion_surcharge DOUBLE,
    airport_fee DOUBLE,
    tips DOUBLE,
    driver_pay DOUBLE,
    shared_match_flag STRING,
    access_a_ride_flag STRING,
    wav_request_flag STRING,
    wav_match_flag STRING,
    index_level_0 BIGINT
)
PARTITIONED BY (
    month INT
)
CLUSTERED BY (pu_location_id) INTO 32 BUCKETS
STORED AS AVRO
LOCATION '/user/team6/project/hive/warehouse/fact_fhv_trips_part'
TBLPROPERTIES ('AVRO.COMPRESS'='SNAPPY');

INSERT OVERWRITE TABLE fact_fhv_trips_part
PARTITION (month)
SELECT 
    hvfhs_license_num,
    dispatching_base_num,
    originating_base_num,
    request_datetime,
    on_scene_datetime,
    dropoff_datetime,
    pu_location_id,
    do_location_id,
    trip_miles,
    trip_time,
    base_passenger_fare,
    tolls,
    bcf,
    sales_tax,
    congestion_surcharge,
    airport_fee,
    tips,
    driver_pay,
    shared_match_flag,
    access_a_ride_flag,
    wav_request_flag,
    wav_match_flag,
    `___index_level_0__` AS index_level_0,
    MONTH(FROM_UNIXTIME(CAST(pickup_datetime/1000 AS BIGINT))) AS month
FROM fact_fhv_trips;