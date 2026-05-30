-- keyserver_software_usage_profiles
--
-- All managed products (product IS NOT NULL) with at least one checkout
-- event on a non-staff computer.
--
-- Columns:
--   product              — managed product name
--   checkouts            — total launch / start events
--   distinct_users       — unique usernames (count only; identities anonymised)
--   sessions_per_user    — checkouts ÷ distinct_users;
--                          high = power-user concentration, low = broad casual use
--   first_checkout       — earliest checkout date in the dataset
--   last_checkout        — most recent checkout date in the dataset
--   days_since_checkout  — calendar days between last_checkout and the dataset
--                          ceiling (max occurred_at across all events).
--                          Relative to the dataset, not today, so the number
--                          is stable across runs.
--   status               — Active  : days_since_checkout ≤  90
--                          Stale   : days_since_checkout ≤ 365
--                          Dormant : days_since_checkout >  365

WITH non_staff_computers AS (
    SELECT computer_name
    FROM keyserver_sessions
    WHERE computer_name IS NOT NULL
      AND computer_name <> ''
      AND computer_name <> 'Computer Not Found'
    GROUP BY computer_name
    HAVING
        COUNT(*) FILTER (
            WHERE location IS NOT NULL
              AND location <> ''
              AND location <> 'Staff'
        ) > 0
        AND COUNT(*) FILTER (WHERE location = 'Staff') = 0
),
dataset_ceiling AS (
    SELECT MAX(occurred_at) AS ceiling_date FROM keyserver_events
),
usage AS (
    SELECT
        e.product,
        COUNT(*) FILTER (WHERE e.event_type IN (
            'launch', 'logged launch', 'launch offline', 'logged launch offline',
            'license start', 'product usage start'
        ))                                                                          AS checkouts,
        COUNT(DISTINCT e.user_name) FILTER (WHERE e.event_type IN (
            'launch', 'logged launch', 'launch offline', 'logged launch offline',
            'license start', 'product usage start'
        ))                                                                          AS distinct_users,
        MIN(e.occurred_at) FILTER (WHERE e.event_type IN (
            'launch', 'logged launch', 'launch offline', 'logged launch offline',
            'license start', 'product usage start'
        ))                                                                          AS first_checkout,
        MAX(e.occurred_at) FILTER (WHERE e.event_type IN (
            'launch', 'logged launch', 'launch offline', 'logged launch offline',
            'license start', 'product usage start'
        ))                                                                          AS last_checkout
    FROM keyserver_events e
    JOIN non_staff_computers ns USING (computer_name)
    WHERE e.product IS NOT NULL
      AND e.product <> ''
      AND e.event_type NOT IN (
            'obtain', 'return', 'logon', 'logoff', 'block',
            'info', 'up', 'down',
            'shadow info', 'shadow up', 'shadow down',
            'audited', 'issued', 'revoked', 'deny unkeyed',
            'session idle start', 'session idle stop'
      )
    GROUP BY e.product
    HAVING COUNT(*) FILTER (WHERE e.event_type IN (
        'launch', 'logged launch', 'launch offline', 'logged launch offline',
        'license start', 'product usage start'
    )) > 0
)
SELECT
    u.product,
    u.checkouts,
    u.distinct_users,
    ROUND(
        u.checkouts::numeric / NULLIF(u.distinct_users, 0),
        1
    )                                                                   AS sessions_per_user,
    u.first_checkout,
    u.last_checkout,
    (dc.ceiling_date::date - u.last_checkout::date)                     AS days_since_checkout,
    CASE
        WHEN (dc.ceiling_date::date - u.last_checkout::date) <=  90 THEN 'Active'
        WHEN (dc.ceiling_date::date - u.last_checkout::date) <= 365 THEN 'Stale'
        ELSE 'Dormant'
    END                                                                 AS status
FROM usage u
CROSS JOIN dataset_ceiling dc
ORDER BY u.checkouts DESC
