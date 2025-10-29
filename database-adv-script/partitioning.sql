-- Objective: Implement table partitioning to optimize queries on large datasets.
-- NOTE: The exact syntax can vary slightly between SQL databases (e.g., PostgreSQL, MySQL).
-- This example uses a syntax similar to PostgreSQL.

--------------------------------------------------------------------------------
-- Step 1: Create a Partitioned Booking Table
--
-- We create a new table, `Bookings_Partitioned`, and declare that it will be
-- partitioned by a RANGE on the `start_date` column.
--------------------------------------------------------------------------------

CREATE TABLE Bookings_Partitioned (
    booking_id SERIAL,
    user_id INT NOT NULL,
    property_id INT NOT NULL,
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    total_price DECIMAL(10, 2),
    PRIMARY KEY (booking_id, start_date) -- The partition key must be part of the primary key.
) PARTITION BY RANGE (start_date);


--------------------------------------------------------------------------------
-- Step 2: Create the Partitions (The "Drawers" in our Filing Cabinet)
--
-- Now we create the actual sub-tables where the data will be stored.
-- Here, we'll create a partition for each quarter of 2024.
--------------------------------------------------------------------------------

-- Partition for Q1 2024
CREATE TABLE bookings_2024_q1 PARTITION OF Bookings_Partitioned
    FOR VALUES FROM ('2024-01-01') TO ('2024-04-01');

-- Partition for Q2 2024
CREATE TABLE bookings_2024_q2 PARTITION OF Bookings_Partitioned
    FOR VALUES FROM ('2024-04-01') TO ('2024-07-01');

-- Partition for Q3 2024
CREATE TABLE bookings_2024_q3 PARTITION OF Bookings_Partitioned
    FOR VALUES FROM ('2024-07-01') TO ('2024-10-01');

-- Partition for Q4 2024
CREATE TABLE bookings_2024_q4 PARTITION OF Bookings_Partitioned
    FOR VALUES FROM ('2024-10-01') TO ('2025-01-01');

-- (You would continue creating partitions for other time periods as needed)


--------------------------------------------------------------------------------
-- Step 3: Test Query Performance
--
-- Now, when you run a query with a date range in the WHERE clause, the database
-- will be smart enough to scan only the relevant partition(s).
--------------------------------------------------------------------------------

-- This query will ONLY scan the `bookings_2024_q2` partition.
-- It completely ignores all the others, making it extremely fast.
EXPLAIN ANALYZE
SELECT *
FROM Bookings_Partitioned
WHERE start_date >= '2024-04-15' AND start_date < '2024-05-01';
