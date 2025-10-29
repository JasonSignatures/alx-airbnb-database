-- Objective: Refactor a complex query to improve performance.
-- We will assume a Payments table exists:
--   payment_id (PK), booking_id (FK), amount, payment_date

--------------------------------------------------------------------------------
-- Step 1: Write an Initial, Inefficient Query
--
-- Objective: Get details for all bookings over $500 made by 'John Smith'.
-- This query uses a subquery with 'IN', which can be inefficient.
--------------------------------------------------------------------------------

SELECT
    b.booking_id,
    u.user_name,
    p.property_name
FROM
    Bookings b
JOIN
    Users u ON u.user_id = b.user_id
JOIN
    Properties p ON p.property_id = b.property_id
WHERE
    b.booking_id IN (
        -- This subquery runs first, creating a temporary list of booking IDs.
        -- The outer query then has to check each booking against this list.
        SELECT booking_id FROM Payments WHERE amount > 500
    ) AND u.user_name = 'John Smith'; -- <-- Added this condition

--------------------------------------------------------------------------------
-- Step 2: Analyze the Query's Performance
--
-- This is where we use the EXPLAIN ANALYZE command to see the database's
-- execution plan and identify the inefficiencies (like a "Seq Scan").
--------------------------------------------------------------------------------

EXPLAIN ANALYZE
SELECT
    b.booking_id,
    u.user_name,
    p.property_name
FROM
    Bookings b
JOIN
    Users u ON u.user_id = b.user_id
JOIN
    Properties p ON p.property_id = b.property_id
WHERE
    b.booking_id IN (
        SELECT booking_id FROM Payments WHERE amount > 500
    ) AND u.user_name = 'John Smith';

--------------------------------------------------------------------------------
-- Step 3: Refactor the Query for Better Performance
--
-- We replace the subquery with a direct JOIN to the Payments table.
-- This allows the database to build a more efficient plan from the start.
--------------------------------------------------------------------------------

SELECT
    b.booking_id,
    u.user_name,
    p.property_name,
    py.amount -- We can now easily access columns from the Payments table too!
FROM
    Bookings b
JOIN
    Users u ON u.user_id = b.user_id
JOIN
    Properties p ON p.property_id = b.property_id
-- This JOIN is more efficient. It connects all tables and filters them in one go.
JOIN
    Payments py ON b.booking_id = py.booking_id
WHERE
    py.amount > 500 AND u.user_name = 'John Smith'; -- <-- Added this condition
