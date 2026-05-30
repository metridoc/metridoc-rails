-- keyserver_location_by_dows
--
-- Session counts per location per day of week (0=Sun–6=Sat), all hours.
--
-- Columns:
--   location    — Keyserver location label
--   day_of_week — integer 0 (Sunday) … 6 (Saturday)
--   day_name    — abbreviated day name e.g. "Mon", "Tue"
--   sessions    — number of sessions whose logon falls on that day

SELECT
    ROW_NUMBER() OVER (ORDER BY location, EXTRACT(DOW FROM logon)::int) AS id,
    location,
    EXTRACT(DOW FROM logon)::int AS day_of_week,
    TO_CHAR(logon, 'Dy')        AS day_name,
    COUNT(*)                    AS sessions
FROM keyserver_sessions
WHERE location IS NOT NULL
  AND location <> ''
  AND logon    IS NOT NULL
GROUP BY location, day_of_week, day_name
ORDER BY location, day_of_week
