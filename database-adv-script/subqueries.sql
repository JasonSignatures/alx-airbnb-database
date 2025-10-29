-- Query 1: Non-Correlated Subquery
-- Objective: Find all properties with an average rating greater than 4.0.
--------------------------------------------------------------------------------
SELECT
    p.property_id,
    p.property_name
FROM
    Properties p
WHERE
    p.property_id IN (
        -- This "one-and-done" subquery runs first and only once.
        -- It creates a list of all property IDs that have an average rating above 4.
        SELECT
            r.property_id
        FROM
            Reviews r
        GROUP BY
            r.property_id
        HAVING
            AVG(r.rating) > 4.0
    )
ORDER BY
    p.property_name ASC;
-- Query 2: Correlated Subquery
-- Objective: Find users who have made more than 3 bookings.
--------------------------------------------------------------------------------
SELECT
    u.user_id,
    u.user_name
FROM
    Users u
WHERE
    (
        -- This "row-by-row" subquery runs for EACH user from the outer query.
        -- It counts the number of bookings for that specific user.
        -- The `u.user_id` is the "correlation" linking the inner and outer queries.
        SELECT
            COUNT(*)
        FROM
            Bookings b
        WHERE
            b.user_id = u.user_id
    ) > 3
ORDER BY
    u.user_name ASC;
