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
🧭 1. Check if the file exists

If you’re in your project directory (e.g., the root folder of your database scripts), run this in your terminal or VS Code:

ls | grep database_index.sql


If you’re on Windows PowerShell, use:

dir | findstr database_index.sql


If no result shows, the file doesn’t exist yet.

🏗️ 2. Create the database_index.sql file

Run:

touch database_index.sql


Or manually create it in your editor:

Right-click → New File

Name it: database_index.sql

🧱 3. Add your index creation SQL statements

Open the new file and paste the following content inside:

-- =========================================
-- User Table Indexes
-- =========================================
CREATE INDEX idx_user_email ON User(email);
CREATE INDEX idx_user_created_at ON User(created_at);

-- =========================================
-- Property Table Indexes
-- =========================================
CREATE INDEX idx_property_location ON Property(location);
CREATE INDEX idx_property_host_id ON Property(host_id);
CREATE INDEX idx_property_price_per_night ON Property(price_per_night);

-- =========================================
-- Booking Table Indexes
-- =========================================
CREATE INDEX idx_booking_user_id ON Booking(user_id);
CREATE INDEX idx_booking_property_id ON Booking(property_id);
CREATE INDEX idx_booking_status ON Booking(status);
CREATE INDEX idx_booking_start_date ON Booking(start_date);


Then save the file.

🧪 4. Verify the file exists and is not empty

Run:

ls -l database_index.sql


You should see a file size greater than 0.

To check its contents:

cat database_index.sql


If it prints out your SQL commands, ✅ the file exists and is not empty.

✅ Summary
Step	Command	Result
Check if exists	`ls	grep database_index.sql`
Create file	touch database_index.sql	Creates empty file
Add SQL	(copy code above)	Adds index creation queries
Verify	cat database_index.sql	Confirms file is not empty
database_index.sql	Contains all CREATE INDEX statements (see above).
Performance screenshots or report	Show EXPLAIN or EXPLAIN ANALYZE results before and after indexing.
