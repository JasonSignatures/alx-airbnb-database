-- To make these queries work, we'll assume the following table structures:
--
-- Users Table:
--   user_id (Primary Key), user_name
-- Bookings Table:
--   booking_id (Primary Key), user_id (Foreign Key), property_id (Foreign Key)
-- Properties Table:
--   property_id (Primary Key), property_name

--------------------------------------------------------------------------------
-- Query 1: Aggregation with COUNT and GROUP BY
-- Objective: Find the total number of bookings made by each user.
--------------------------------------------------------------------------------
SELECT
    u.user_id,
    u.user_name,
    -- This counts all bookings for the group defined by GROUP BY.
    COUNT(b.booking_id) AS total_bookings
FROM
    Users u
JOIN
    Bookings b ON u.user_id = b.user_id
-- This creates "buckets" for each user. All bookings for a single user
-- go into their respective bucket to be counted.
GROUP BY
    u.user_id, u.user_name
ORDER BY
    total_bookings DESC; -- Sorting to see who has the most bookings


--------------------------------------------------------------------------------
-- Query 2: Window Function to Rank Properties
-- Objective: Rank properties based on the total number of bookings.
--------------------------------------------------------------------------------
-- We use a Common Table Expression (CTE) here to first calculate the counts.
-- Think of a CTE as a temporary, named result set that you can refer to later.
WITH PropertyBookingCounts AS (
    SELECT
        p.property_id,
        p.property_name,
        COUNT(b.booking_id) AS booking_count
    FROM
        Properties p
    JOIN
        Bookings b ON p.property_id = b.property_id
    GROUP BY
        p.property_id, p.property_name
)
-- Now, we select from our temporary result set and apply the window function.
SELECT
    property_name,
    booking_count,
    -- The OVER clause defines the "window" of data to look at.
    -- Here, it's the entire result set, ordered by booking_count.
    ROW_NUMBER() OVER (ORDER BY booking_count DESC) AS row_number_rank,
    RANK() OVER (ORDER BY booking_count DESC) AS rank_with_ties
FROM
    PropertyBookingCounts
ORDER BY
    rank_with_ties ASC; -- Ordering by the rank to see the results clearly.
