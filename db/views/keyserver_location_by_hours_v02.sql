-- keyserver_location_by_hours
--
-- Session counts per location per hour of day (all hours, 0–23).
--
-- Columns:
--   location    — Keyserver location label
--   hour_of_day — integer hour (0–23)
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
GROUP BY location, hour_of_day
ORDER BY location, hour_of_day
