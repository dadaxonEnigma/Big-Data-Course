USE team6_projectdb;

DROP TABLE IF EXISTS q3_results;

CREATE TABLE q3_results (
  zone STRING,
  trip_count BIGINT,
  total_airport_fees DOUBLE,
  avg_company_profit DOUBLE,
  avg_driver_income DOUBLE
)
STORED AS ORC;

INSERT OVERWRITE TABLE q3_results
SELECT 
  l.zone,
  COUNT(*) AS trip_count,
  SUM(airport_fee) AS total_airport_fees,
  AVG(base_passenger_fare + tolls + airport_fee - driver_pay) AS avg_company_profit,
  AVG(driver_pay + tips) AS avg_driver_income
FROM fact_fhv_trips_part f
JOIN dim_location l ON f.pu_location_id = l.location_id
WHERE l.zone LIKE '%Airport%' OR airport_fee > 0
GROUP BY l.zone
ORDER BY avg_company_profit DESC;
