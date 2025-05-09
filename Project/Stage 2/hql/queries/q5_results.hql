USE team6_projectdb;

DROP TABLE IF EXISTS q5_results;

CREATE TABLE q5_results (
  is_weekend BOOLEAN,
  hour INT,
  trip_count BIGINT,
  avg_fare DOUBLE,
  avg_duration_min DOUBLE,
  avg_tips DOUBLE,
  avg_wait_time_min DOUBLE,
  day_part STRING
)
STORED AS ORC
TBLPROPERTIES ('orc.compress'='SNAPPY');

INSERT OVERWRITE TABLE q5_results
SELECT 
  c.is_weekend,
  HOUR(from_unixtime(CAST(f.request_datetime/1000 AS BIGINT))) AS hour,
  COUNT(*) AS trip_count,
  ROUND(AVG(base_passenger_fare), 2) AS avg_fare,
  ROUND(AVG(trip_time)/60.0, 2) AS avg_duration_min,
  ROUND(AVG(tips), 2) AS avg_tips,
  ROUND(AVG((on_scene_datetime - request_datetime)/60000.0), 2) AS avg_wait_time_min,
  CASE
    WHEN HOUR(from_unixtime(CAST(f.request_datetime/1000 AS BIGINT))) BETWEEN 6 AND 11 THEN 'Morning'
    WHEN HOUR(from_unixtime(CAST(f.request_datetime/1000 AS BIGINT))) BETWEEN 12 AND 17 THEN 'Afternoon'
    WHEN HOUR(from_unixtime(CAST(f.request_datetime/1000 AS BIGINT))) BETWEEN 18 AND 23 THEN 'Evening'
    ELSE 'Night'
  END AS day_part
FROM fact_fhv_trips_part f
JOIN dim_calendar c 
  ON MONTH(from_unixtime(CAST(f.request_datetime/1000 AS BIGINT))) = c.month 
  AND DAY(from_unixtime(CAST(f.request_datetime/1000 AS BIGINT))) = c.day
WHERE 
  c.year = 2024 
  AND f.on_scene_datetime > f.request_datetime
  AND f.base_passenger_fare > 0
  AND f.trip_time > 0
  AND f.request_datetime IS NOT NULL
  AND f.on_scene_datetime IS NOT NULL
GROUP BY 
  c.is_weekend, 
  HOUR(from_unixtime(CAST(f.request_datetime/1000 AS BIGINT))),
  CASE
    WHEN HOUR(from_unixtime(CAST(f.request_datetime/1000 AS BIGINT))) BETWEEN 6 AND 11 THEN 'Morning'
    WHEN HOUR(from_unixtime(CAST(f.request_datetime/1000 AS BIGINT))) BETWEEN 12 AND 17 THEN 'Afternoon'
    WHEN HOUR(from_unixtime(CAST(f.request_datetime/1000 AS BIGINT))) BETWEEN 18 AND 23 THEN 'Evening'
    ELSE 'Night'
  END
ORDER BY is_weekend, hour;
