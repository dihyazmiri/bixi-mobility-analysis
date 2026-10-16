-- 02_station_net_balance.sql
-- Question: which stations lose the most bikes (departures > arrivals)?
-- Net balance = arrivals - departures. Negative = station empties over the year.
-- Stations with 1,000 trips or fewer are excluded to avoid statistical noise.

WITH dep AS (
    SELECT start_station_id AS station_id, COUNT(*) AS departures
    FROM fact_trips
    WHERE start_station_id IS NOT NULL
    GROUP BY start_station_id
),
arr AS (
    SELECT end_station_id AS station_id, COUNT(*) AS arrivals
    FROM fact_trips
    WHERE end_station_id IS NOT NULL
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
WHERE COALESCE(d.departures, 0) + COALESCE(a.arrivals, 0) > 1000
ORDER BY net_balance
LIMIT 10;