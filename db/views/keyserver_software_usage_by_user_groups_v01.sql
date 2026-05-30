-- keyserver_software_usage_by_user_groups
--
-- Checkout counts per product per Alma user_group, joined via
-- user_name = pennkey.  Same scope and privacy constraints as
-- keyserver_software_usage_by_schools.
--
-- Columns:
--   product         — managed product name
--   user_group      — Alma user_group label (NULL if user not in demographics)
--   checkouts       — checkout events for this product × user_group combination
--   distinct_users  — distinct user_name values (count only; never exposed)

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
)
SELECT
    ROW_NUMBER() OVER (ORDER BY e.product, d.user_group NULLS LAST) AS id,
    e.product,
    d.user_group,
    COUNT(*)                    AS checkouts,
    COUNT(DISTINCT e.user_name) AS distinct_users
FROM keyserver_events e
JOIN non_staff_computers ns ON e.computer_name = ns.computer_name
LEFT JOIN upenn_alma_demographics d ON e.user_name = d.pennkey
WHERE e.product IS NOT NULL
  AND e.product <> ''
  AND e.event_type IN (
      'launch', 'logged launch', 'launch offline', 'logged launch offline',
      'license start', 'product usage start'
  )
GROUP BY e.product, d.user_group
ORDER BY e.product, d.user_group NULLS LAST
