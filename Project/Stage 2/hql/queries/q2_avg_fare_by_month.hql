USE team6_projectdb;

CREATE TABLE IF NOT EXISTS q2_results (
    month INT,
    avg_fare DOUBLE
)
STORED AS ORC;

INSERT OVERWRITE TABLE q2_results
SELECT 
    f.month,
    AVG(f.base_passenger_fare) AS avg_fare
FROM fact_fhv_trips_part f
GROUP BY f.month
ORDER BY f.month;