-- 01_trips_by_hour.sql
-- Question: at what hour of the day do most trips start? (Montreal local time)
-- Note: start_time is stored in UTC (TIMESTAMPTZ), so we convert it first.

SELECT
    EXTRACT(HOUR FROM start_time AT TIME ZONE 'America/Montreal')::int AS hour,
    COUNT(*) AS n_trips
FROM fact_trips
GROUP BY hour
ORDER BY hour;