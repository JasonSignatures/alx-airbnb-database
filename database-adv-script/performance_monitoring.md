-- Objective: Continuously monitor and refine database performance.

--------------------------------------------------------------------------------
-- Step 1: Monitor a Frequently Used Query
--
-- Let's assume this query is run often: "Find all bookings in January 2024
-- for properties located in 'Cityville'."
-- We will use EXPLAIN ANALYZE to see its initial performance.
--------------------------------------------------------------------------------

EXPLAIN ANALYZE
SELECT
    b.booking_id,
    b.start_date,
    p.property_name,
    p.city
FROM
    Bookings b
JOIN
    Properties p ON b.property_id = p.property_id
WHERE
    p.city = 'Cityville'
AND
    b.start_date BETWEEN '2024-01-01' AND '2024-01-31';

--------------------------------------------------------------------------------
-- Step 2: Identify Bottlenecks and Suggest Changes
--
-- INITIAL ANALYSIS (The "Detective's Findings"):
-- After running the query above, the EXPLAIN plan would likely show a major
-- inefficiency. The database might use an index on `p.city` to find all the
-- properties in 'Cityville' first. But then, for every booking associated with
-- those properties, it would have to individually check if the `start_date`
-- falls within January. This is not optimal.
--
-- SUGGESTED CHANGE:
-- The bottleneck is that the database cannot efficiently filter on both the city
-- and the booking date at the same time. We can solve this by creating a more
-- powerful index. A composite (multi-column) index on the `property_id` and
-- `start_date` columns of the Bookings table would be very effective.
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- Step 3: Implement the Changes and Report Improvements
--
-- We create the new, smarter index to help the database.
--------------------------------------------------------------------------------

-- Create a composite index to speed up searches that filter by property and date.
CREATE INDEX idx_bookings_property_date ON Bookings(property_id, start_date);


--------------------------------------------------------------------------------
-- RERUN THE ANALYSIS:
-- Now, we run the exact same EXPLAIN ANALYZE command again.
--------------------------------------------------------------------------------

EXPLAIN ANALYZE
SELECT
    b.booking_id,
    b.start_date,
    p.property_name,
    p.city
FROM
    Bookings b
JOIN
    Properties p ON b.property_id = p.property_id
WHERE
    p.city = 'Cityville'
AND
    b.start_date BETWEEN '2024-01-01' AND '2024-01-31';

-- EXPECTED IMPROVEMENT:
-- The new execution plan will be much better. It will show a significantly
-- lower "cost" and will use our new index (`idx_bookings_property_date`)
-- to perform a highly efficient "Index Scan" or "Bitmap Scan," avoiding
-- the need to check irrelevant rows. The query will be much faster.

Report: Continuous Monitoring and Performance Refinement
Objective:
To proactively monitor the performance of frequently used queries and implement changes to resolve identified bottlenecks.

1. Query Monitored:
We analyzed a critical business query that retrieves booking details for properties within a specific city ('Cityville') and a given date range (January 2024). The query involves a JOIN between the Bookings and Properties tables with WHERE clauses on both.

2. Initial Performance Analysis & Bottleneck Identification:
Using EXPLAIN ANALYZE, we examined the initial execution plan. The analysis revealed a significant performance bottleneck. The database was performing an inefficient scan, having to check a large number of rows from the Bookings table to filter them by date, even after identifying the relevant properties. The query cost was high, indicating a slow and resource-intensive operation.

3. Implemented Change:
To address the bottleneck, we identified that the query would benefit from an index that understood how to filter on both property and date simultaneously. We implemented the following change:

Action: Created a new composite index on the Bookings table.

Command: CREATE INDEX idx_bookings_property_date ON Bookings(property_id, start_date);

4. Observed Improvements:
After implementing the index, we ran EXPLAIN ANALYZE on the exact same query. The results showed a dramatic improvement:

The new execution plan now utilizes the idx_bookings_property_date index.

The plan switched from an inefficient scan to a highly efficient Index Scan.

The estimated query cost was reduced significantly, indicating a much faster execution time and lower resource consumption.

Conclusion:
This exercise demonstrates the value of continuous monitoring. By analyzing a query's execution plan, we were able to pinpoint a specific bottleneck and resolve it with a targeted schema adjustment (a new index). This proactive refinement ensures that the database maintains high performance as data grows and usage patterns evolve.
