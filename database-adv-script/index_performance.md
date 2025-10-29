-- Objective: Create indexes to improve query performance.

--------------------------------------------------------------------------------
-- Step 1: Identify High-Usage Columns & Create Indexes
--
-- We look at our previous queries and see we often join or filter on these columns:
--   - `Bookings.user_id` (used to join with Users)
--   - `Bookings.property_id` (used to join with Properties)
--   - `Users.user_name` (might be used in a WHERE clause to find a user)
-- These are excellent candidates for indexes.
--------------------------------------------------------------------------------

-- Create an index on the user_id column in the Bookings table
CREATE INDEX idx_bookings_user_id ON Bookings(user_id);

-- Create an index on the property_id column in the Bookings table
CREATE INDEX idx_bookings_property_id ON Bookings(property_id);

-- Create an index on the user_name column for faster searches by name
CREATE INDEX idx_users_user_name ON Users(user_name);


--------------------------------------------------------------------------------
-- Step 2: Measure Performance Before and After
--
-- To see the effect, you would run the EXPLAIN command on a query
-- *before* creating the index, and then again *after*.
-- NOTE: The exact output depends on your specific SQL database (PostgreSQL, MySQL, etc.)
--------------------------------------------------------------------------------

-- EXAMPLE SCENARIO:

-- **BEFORE creating the index `idx_bookings_user_id`:**
-- You run this command:
EXPLAIN ANALYZE SELECT * FROM Bookings WHERE user_id = 123;

-- The output would likely show a "Sequential Scan" on the Bookings table,
-- indicating it had to check every row.
-- It might look something like this:
-- "Seq Scan on bookings (cost=0.00..155.00 rows=5 width=24) (actual time=0.021..0.751 rows=5 loops=1)"
-- The important part is "Seq Scan".


-- **AFTER creating the index `idx_bookings_user_id`:**
-- You run the exact same command:
EXPLAIN ANALYZE SELECT * FROM Bookings WHERE user_id = 123;

-- The new output should show an "Index Scan," which is much faster.
-- It might look something like this:
-- "Index Scan using idx_bookings_user_id on bookings (cost=0.15..8.17 rows=5 width=24) (actual time=0.024..0.026 rows=5 loops=1)"
-- The important part is "Index Scan", and the cost/time values are much lower.
