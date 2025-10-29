Explanation of SQL Performance Refactoring
This document breaks down the process shown in the performance.sql file, explaining how to identify an inefficient query and refactor it to be much faster.

Step 1: The Initial, Inefficient Query (The "Scavenger Hunt")
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
    );

What it does: This query successfully finds the booking ID, user name, and property name for all bookings where the payment amount was over $500.

Why it's inefficient: The problem lies in the WHERE b.booking_id IN (...) clause. This tells the database to perform two separate steps:

Inner "Scavenger Hunt": First, it must execute the subquery (SELECT booking_id FROM Payments WHERE amount > 500) to create a temporary, in-memory list of all relevant booking IDs.

Outer Search: Then, it joins Bookings, Users, and Properties, and for every single row it produces, it has to check if the booking_id is present in the temporary list it just created. This can be very slow, especially if the Payments table is large.

Step 2: Analyzing the Performance with EXPLAIN ANALYZE
This command is like asking the database for its "battle plan." It doesn't just run the query; it runs it and then reports back on the strategy it used and how long each step took. When you run EXPLAIN ANALYZE on the first query, the plan will show the multi-step process described above and will likely have a high "cost" associated with it, flagging it as inefficient.

Step 3: The Refactored, Efficient Query (The "Assembly Line")
SELECT
    b.booking_id,
    u.user_name,
    p.property_name,
    py.amount
FROM
    Bookings b
JOIN
    Users u ON u.user_id = b.user_id
JOIN
    Properties p ON p.property_id = b.property_id
JOIN
    Payments py ON b.booking_id = py.booking_id
WHERE
    py.amount > 500;

What changed: The subquery was completely removed. Instead, we added a direct JOIN to the Payments table and moved the filter (amount > 500) into the main WHERE clause.

Why it's better: This version gives the database's query optimizer all the information at once. It sees all four tables, how they are connected, and the final filter criteria. This allows it to create a single, highly efficient plan to get the data. It can filter the Payments table first and then join only the necessary rows, or use indexes on the booking_id columns to match everything up quickly. It's a single, streamlined process.

The key takeaway is that JOINs often allow the database to create a much more efficient execution plan than a subquery in a WHERE IN clause.
