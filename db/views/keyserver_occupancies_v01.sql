WITH time_range AS (
  SELECT
    DATE_TRUNC('hour', MIN(start_time)) AS min_time,
    DATE_TRUNC('hour', MAX(end_time)) AS max_time
  FROM keyserver_sessions
),
time_grid AS (
  SELECT 
    ts AS hour_start,
    ts + INTERVAL '1 hour' AS hour_end
  FROM time_range,
  generate_series(
    time_range.min_time,
    time_range.max_time,
    '1 hour'::interval
  ) AS ts
),
session_hours AS (
  SELECT 
    time_grid.hour_start::date AS date,
    EXTRACT(HOUR FROM time_grid.hour_start) AS hour_of_day,
    EXTRACT(DOW FROM time_grid.hour_start) AS day_of_week,
    s.division,
    s.computers_per_division,
    s.computer_name,
    COALESCE(
      EXTRACT( EPOCH FROM SUM(
        LEAST(s.end_time, time_grid.hour_end) - 
        GREATEST(s.start_time, time_grid.hour_start)
      )), 
      0
    ) AS total_usage_time,
    COUNT(s.id) AS total_active_sessions
  FROM time_grid
  LEFT JOIN keyserver_sessions s ON 
    s.start_time < time_grid.hour_end AND
    s.end_time > time_grid.hour_start
  GROUP BY time_grid.hour_start, time_grid.hour_end, s.division, s.computers_per_division, s.computer_name
)
SELECT 
  division,
  computers_per_division,
  computer_name,
  date, 
  day_of_week,
  hour_of_day,
  SUM(total_active_sessions) AS total_active_sessions,  
  -- Active seconds per hour (Max possible is 3600 seconds)                 
  LEAST(SUM(total_usage_time), 3600.0) AS active_seconds,
  -- Occupancy (Active seconds / 3600 seconds in an hour)
  (LEAST(SUM(total_usage_time), 3600.0) / 3600.0)::numeric AS occupancy
FROM session_hours                                                                                                     
GROUP BY division, computers_per_division, computer_name, date, day_of_week, hour_of_day 
ORDER BY division, computers_per_division, computer_name, date, day_of_week, hour_of_day;