USE team6_projectdb;

CREATE TABLE IF NOT EXISTS q1_results (
    zone STRING,
    trip_count BIGINT
)
STORED AS ORC;

INSERT OVERWRITE TABLE q1_results
SELECT 
    dl.zone,
    COUNT(*) AS trip_count
FROM fact_fhv_trips_part f
JOIN dim_location dl ON f.pu_location_id = dl.location_id
GROUP BY dl.zone
ORDER BY trip_count DESC;
