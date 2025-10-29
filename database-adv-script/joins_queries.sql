-- To make these queries work, we'll assume the following table structures:
--
-- Users Table:
--   user_id (Primary Key)
--   user_name
--   email
--
-- Bookings Table:
--   booking_id (Primary Key)
--   user_id (Foreign Key linking to Users table)
--   property_id (Foreign Key linking to Properties table)
--   booking_date
--
-- Properties Table:
--   property_id (Primary Key)
--   property_name
--
-- Reviews Table:
--   review_id (Primary Key)
--   property_id (Foreign Key linking to Properties table)
--   review_text
--   rating

--------------------------------------------------------------------------------
-- Query 1: INNER JOIN
-- Objective: Retrieve all bookings and the respective users who made those bookings.
--------------------------------------------------------------------------------

SELECT
    b.booking_id,       -- Select the booking ID from the Bookings table
    b.booking_date,     -- Select the booking date from the Bookings table
    u.user_id,          -- Select the user ID from the Users table
    u.user_name,        -- Select the user's name from the Users table
    u.email             -- Select the user's email from the Users table
FROM
    Bookings b          -- Start with the Bookings table (aliased as 'b' for brevity)
INNER JOIN
    Users u ON b.user_id = u.user_id -- Join it with the Users table (aliased as 'u') where the user_id in both tables match.
ORDER BY
    b.booking_date DESC; -- Sort the results to show the most recent bookings first.


--------------------------------------------------------------------------------
-- Query 2: LEFT JOIN
-- Objective: Retrieve all properties and their reviews, including properties that
--            have no reviews.
--------------------------------------------------------------------------------

SELECT
    p.property_id,      -- Select the property ID from the Properties table
    p.property_name,    -- Select the property name from the Properties table
    r.review_text,      -- Select the review text from the Reviews table
    r.rating            -- Select the rating from the Reviews table
FROM
    Properties p        -- Start with the Properties table (our "left" table)
LEFT JOIN
    Reviews r ON p.property_id = r.property_id -- Join with Reviews where property_id matches.
                                                -- If a property has no matching review, review_text and rating will be NULL.
ORDER BY
    p.property_name ASC; -- Sort the results alphabetically by property name.


--------------------------------------------------------------------------------
-- Query 3: FULL OUTER JOIN
-- Objective: Retrieve all users and all bookings, even if the user has no booking
--            or a booking is not linked to a user.
--------------------------------------------------------------------------------

SELECT
    u.user_id,          -- Select user ID from the Users table
    u.user_name,        -- Select user name from the Users table
    b.booking_id,       -- Select booking ID from the Bookings table
    b.booking_date      -- Select booking date from the Bookings table
FROM
    Users u             -- Start with the Users table
FULL OUTER JOIN
    Bookings b ON u.user_id = b.user_id -- Join with Bookings where user_id matches.
                                         -- This will include all users (with or without bookings)
                                         -- and all bookings (with or without users).
ORDER BY
    u.user_name ASC, b.booking_date DESC; -- Sort by user name, and for users with multiple bookings, show the newest booking first.

