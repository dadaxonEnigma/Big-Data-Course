USE team6_projectdb;

DROP TABLE IF EXISTS q4_results;

CREATE TABLE q4_results (
  from_zone STRING,
  to_zone STRING,
  empty_runs_count BIGINT,
  avg_distance_miles DOUBLE
)
STORED AS ORC;

WITH vehicle_movements AS (
  SELECT 
    dispatching_base_num,
    pu_location_id,
    do_location_id,
    request_datetime,
    LEAD(pu_location_id) OVER(PARTITION BY dispatching_base_num ORDER BY request_datetime) AS next_pu_location
  FROM fact_fhv_trips_part
)

INSERT OVERWRITE TABLE q4_results
SELECT 
  l1.zone AS from_zone,
  l2.zone AS to_zone,
  COUNT(*) AS empty_runs_count,
  AVG(f.trip_miles) AS avg_distance_miles
FROM vehicle_movements v
JOIN fact_fhv_trips_part f ON v.dispatching_base_num = f.dispatching_base_num 
                          AND v.request_datetime = f.request_datetime
JOIN dim_location l1 ON v.do_location_id = l1.location_id
JOIN dim_location l2 ON v.next_pu_location = l2.location_id
WHERE v.do_location_id != v.next_pu_location
GROUP BY l1.zone, l2.zone
ORDER BY empty_runs_count DESC
LIMIT 100;
