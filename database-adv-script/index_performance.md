⚙️ Step 1: Choose a Query to Test

Example:
Suppose you want to find all bookings made by a particular user in a date range:

SELECT *
FROM Booking
WHERE user_id = 101
  AND booking_date BETWEEN '2025-01-01' AND '2025-12-31';

🔍 Step 2: Check Query Plan Before Adding Indexes

Run:

EXPLAIN ANALYZE
SELECT *
FROM Booking
WHERE user_id = 101
  AND booking_date BETWEEN '2025-01-01' AND '2025-12-31';

Sample Output (before indexing):
Seq Scan on Booking  (cost=0.00..25000.00 rows=500 width=100)
  Filter: (user_id = 101 AND booking_date BETWEEN '2025-01-01' AND '2025-12-31')
Execution Time: 85.231 ms


Interpretation:

Seq Scan = Sequential Scan → database scans every row in the table.

cost=0.00..25000.00 = Estimated CPU + I/O cost.

Execution Time: 85.231 ms = Actual runtime.

This indicates no index is being used, and the query is slow for large datasets.

🧱 Step 3: Add Appropriate Indexes

From earlier:

CREATE INDEX idx_booking_user_date
ON Booking(user_id, booking_date);

🚀 Step 4: Check Query Plan After Adding Indexes

Run the same query again:

EXPLAIN ANALYZE
SELECT *
FROM Booking
WHERE user_id = 101
  AND booking_date BETWEEN '2025-01-01' AND '2025-12-31';

Sample Output (after indexing):
Index Scan using idx_booking_user_date on Booking  (cost=0.42..350.00 rows=500 width=100)
  Index Cond: ((user_id = 101) AND (booking_date >= '2025-01-01'::date) AND (booking_date <= '2025-12-31'::date))
Execution Time: 3.482 ms


Interpretation:

Index Scan = database is now using the index instead of scanning the whole table.

Cost and execution time dropped significantly.

The query performance improved ~25x faster (85 ms → 3 ms).

📈 Step 5: Compare Performance Metrics
Metric	Before Index	After Index	Improvement
Execution Plan	Sequential Scan	Index Scan	✅ Uses index
Estimated Cost	25000	350	🔻 Reduced
Execution Time	85 ms	3 ms	⚡ 28× faster
🧠 Step 6: Test Across Multiple Queries

Repeat for other common queries:

Search by property location

EXPLAIN ANALYZE SELECT * FROM Property WHERE location = 'Lagos';


Get all bookings for a property

EXPLAIN ANALYZE SELECT * FROM Booking WHERE property_id = 5001;


Join User → Booking → Property

EXPLAIN ANALYZE
SELECT u.username, p.name, b.booking_date
FROM Booking b
JOIN User u ON b.user_id = u.user_id
JOIN Property p ON b.property_id = p.property_id
WHERE u.email = 'jane@example.com';


Each test should now show Index Scans or Nested Loop Joins using indexes rather than sequential scans.

✅ Step 7: Document Your Findings

Create a simple Markdown or SQL comment section like this:

-- ============================================
-- PERFORMANCE TEST SUMMARY
-- ============================================
-- Query: Find all bookings for user_id = 101 in 2025
-- Before Index: Seq Scan, Execution Time = 85.231 ms
-- After Index (idx_booking_user_date): Index Scan, Execution Time = 3.482 ms
-- Improvement: ~25x faster
-- ============================================
