-- keyserver_non_staff_computers
--
-- A computer is classified as non-staff when:
--   • it has at least one session with a known, non-Staff location, AND
--   • it has never appeared with location = 'Staff'
--
-- Computers whose only sessions have NULL/blank location are excluded;
-- analysis confirms those machines are almost exclusively staff machines
-- where Keyserver location was not configured.

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
