🧱 Step 1: Identify High-Usage Columns

Typically, these columns are used in:

WHERE clauses (filtering)

JOIN clauses (relationships)

ORDER BY clauses (sorting)

GROUP BY clauses (aggregations)

Example schema (simplified)
User(id, name, email, created_at)
Property(id, host_id, location, price_per_night, created_at)
Booking(id, user_id, property_id, start_date, end_date, status, created_at)

Likely high-usage columns
Table	Columns frequently used in queries	Reason
User	email, created_at	Filtering by email or recent signups
Property	location, price_per_night, host_id	Searching/filtering listings
Booking	user_id, property_id, start_date, status	Common for joins and date filters
🧩 Step 2: Create Indexes

Create a new file called database_index.sql, and add the following SQL statements:

📄 database_index.sql
-- =========================================
-- User Table Indexes
-- =========================================

-- Index for quick lookup by email (unique values)
CREATE INDEX idx_user_email ON User(email);

-- Index for sorting/filtering users by creation date
CREATE INDEX idx_user_created_at ON User(created_at);

-- =========================================
-- Property Table Indexes
-- =========================================

-- Index for searching by location
CREATE INDEX idx_property_location ON Property(location);

-- Index for filtering by host (foreign key)
CREATE INDEX idx_property_host_id ON Property(host_id);

-- Index for sorting/filtering by price
CREATE INDEX idx_property_price_per_night ON Property(price_per_night);

-- =========================================
-- Booking Table Indexes
-- =========================================

-- Index for joining bookings with users
CREATE INDEX idx_booking_user_id ON Booking(user_id);

-- Index for joining bookings with properties
CREATE INDEX idx_booking_property_id ON Booking(property_id);

-- Index for filtering by status (e.g., confirmed/pending)
CREATE INDEX idx_booking_status ON Booking(status);

-- Index for filtering or sorting by start_date
CREATE INDEX idx_booking_start_date ON Booking(start_date);


💡 Note:

Use composite indexes if queries often combine columns, e.g.:

CREATE INDEX idx_booking_user_property ON Booking(user_id, property_id);

⚙️ Step 3: Measure Query Performance

Before and after adding indexes, compare performance using:

For MySQL:
EXPLAIN SELECT * FROM Booking WHERE user_id = 10 AND status = 'confirmed';

For PostgreSQL:
EXPLAIN ANALYZE SELECT * FROM Booking WHERE user_id = 10 AND status = 'confirmed';


You’ll see output like:

Type	Key	Rows	Extra
ALL	NULL	50000	Using where

After indexing, the plan should show:

Type	Key	Rows	Extra
ref	idx_booking_user_id	3	Using where

➡️ This confirms that the index is being used, reducing full table scans.

🧮 Step 4: Optional Validation Queries

You can also check index usage statistics (MySQL example):

SHOW INDEX FROM Booking;
SHOW INDEX FROM Property;
SHOW INDEX FROM User;

✅ Deliverables
File	Description
database_index.sql	Contains all CREATE INDEX statements (see above).
Performance screenshots or report	Show EXPLAIN or EXPLAIN ANALYZE results before and after indexing.
