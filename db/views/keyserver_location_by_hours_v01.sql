-- keyserver_location_by_hours
--
-- Session counts per location per hour of day, restricted to business hours
-- (08:00–22:59).  Off-peak hours (23:00–07:59) are excluded as they
-- contain negligible patron traffic.
--
-- Columns:
--   location    — Keyserver location label
--   hour_of_day — integer hour (8–22)
--   sessions    — number of sessions whose logon falls in that hour

SELECT
    ROW_NUMBER() OVER (ORDER BY location, EXTRACT(HOUR FROM logon)::int) AS id,
    location,
    EXTRACT(HOUR FROM logon)::int AS hour_of_day,
    COUNT(*)                      AS sessions
FROM keyserver_sessions
WHERE location IS NOT NULL
  AND location <> ''
  AND logon    IS NOT NULL
  AND EXTRACT(HOUR FROM logon) BETWEEN 8 AND 22
GROUP BY location, hour_of_day
ORDER BY location, hour_of_day
