-- 03_morning_rush_imbalance.sql
-- Question: which stations empty out the most during the weekday morning rush?
-- Window: Monday to Friday, 6:00 to 8:59 (Montreal local time).
-- Net balance = arrivals - departures within the window. Negative = station loses bikes.
-- Departures are filtered on start_time, arrivals on end_time.

WITH dep AS (
    SELECT start_station_id AS station_id, COUNT(*) AS departures
    FROM fact_trips
    WHERE start_station_id IS NOT NULL
      AND EXTRACT(ISODOW FROM start_time AT TIME ZONE 'America/Montreal') BETWEEN 1 AND 5
      AND EXTRACT(HOUR   FROM start_time AT TIME ZONE 'America/Montreal') BETWEEN 6 AND 8
    GROUP BY start_station_id
),
arr AS (
    SELECT end_station_id AS station_id, COUNT(*) AS arrivals
    FROM fact_trips
    WHERE end_station_id IS NOT NULL
      AND EXTRACT(ISODOW FROM end_time AT TIME ZONE 'America/Montreal') BETWEEN 1 AND 5
      AND EXTRACT(HOUR   FROM end_time AT TIME ZONE 'America/Montreal') BETWEEN 6 AND 8
    GROUP BY end_station_id
)
SELECT
    s.station_name,
    COALESCE(d.departures, 0) AS departures,
    COALESCE(a.arrivals, 0)   AS arrivals,
    COALESCE(a.arrivals, 0) - COALESCE(d.departures, 0) AS net_balance
FROM dim_station s
LEFT JOIN dep d ON d.station_id = s.station_id
LEFT JOIN arr a ON a.station_id = s.station_id
WHERE COALESCE(d.departures, 0) + COALESCE(a.arrivals, 0) > 500
ORDER BY net_balance
LIMIT 10;