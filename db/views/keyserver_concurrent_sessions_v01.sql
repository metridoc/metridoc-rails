WITH session_events AS (
  -- 1. Flatten all starts and ends into an atomic timeline of change events
  SELECT 
    division, 
    start_time AS event_time, 
    1 AS event_change 
  FROM keyserver_sessions

  UNION ALL

  SELECT 
    division, 
    end_time AS event_time, 
    -1 AS event_change 
  FROM keyserver_sessions
),
timeline AS (
  -- 2. Build the sequential, rolling rolling total per division per day
  SELECT 
    division,
    event_time::date AS session_date,
    SUM(event_change) OVER (
      PARTITION BY division, event_time::date 
      ORDER BY event_time 
      ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
    ) AS concurrent_count
  FROM session_events
)
-- 3. Extract the maximum peak reached on each specific calendar day
SELECT
  md5(division || session_date::text) AS id,
  division,
  session_date,
  MAX(concurrent_count) AS peak_sessions
FROM timeline
GROUP BY division, session_date
ORDER BY session_date DESC;