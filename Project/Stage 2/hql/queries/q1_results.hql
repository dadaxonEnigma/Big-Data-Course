USE team6_projectdb;

DROP TABLE IF EXISTS q1_results;

CREATE TABLE q1_results (
    hour_of_day INT,
    trip_count BIGINT,
    avg_driver_income DOUBLE,
    income_per_hour DOUBLE,
    tip_percentage DOUBLE
)
STORED AS ORC;

INSERT OVERWRITE TABLE q1_results
SELECT 
  HOUR(from_unixtime(CAST(request_datetime/1000 AS BIGINT))) AS hour_of_day,
  COUNT(*) AS trip_count,
  ROUND(AVG(driver_pay + tips), 2) AS avg_driver_income,
  ROUND(AVG((driver_pay + tips)/(trip_time/60.0)), 2) AS income_per_hour,
  ROUND(AVG(tips/base_passenger_fare)*100, 2) AS tip_percentage
FROM fact_fhv_trips_part
WHERE 
  trip_time > 60 
  AND driver_pay > 0 
  AND base_passenger_fare > 0
  AND request_datetime IS NOT NULL
  AND on_scene_datetime IS NOT NULL
  AND on_scene_datetime > request_datetime 
GROUP BY HOUR(from_unixtime(CAST(request_datetime/1000 AS BIGINT)))
ORDER BY 
  income_per_hour DESC,
  hour_of_day ASC;