-- User Table
User(id, name, email, created_at)

-- Property Table
Property(id, host_id, location, price_per_night, created_at)

-- Booking Table
Booking(id, user_id, property_id, start_date, end_date, status, created_at)
Common Query Scenarios
Table	Common Query	Columns Involved	Why Index Helps
User	Search by email	email	Unique lookups
User	Sort/filter by signup date	created_at	Sorting/filter
Property	Search/filter by location	location	Geographic filtering
Property	Filter by host	host_id	Frequent joins
Property	Filter by price	price_per_night	Price-based search
Booking	Get user bookings	user_id	Foreign key join
Booking	Get property bookings	property_id	Foreign key join
Booking	Filter by date or status	start_date, status	Date/status filters

-- ============================================================
-- DATABASE INDEX CREATION SCRIPT
-- Objective: Improve query performance using indexes
-- ============================================================

-- ========== USER TABLE INDEXES ==========
-- Faster lookup by email
CREATE INDEX idx_user_email ON User(email);

-- Faster sorting/filtering by creation date
CREATE INDEX idx_user_created_at ON User(created_at);


-- ========== PROPERTY TABLE INDEXES ==========
-- Faster search by location
CREATE INDEX idx_property_location ON Property(location);

-- Faster joins/filtering by host
CREATE INDEX idx_property_host_id ON Property(host_id);

-- Faster price-based sorting/filtering
CREATE INDEX idx_property_price_per_night ON Property(price_per_night);


-- ========== BOOKING TABLE INDEXES ==========
-- Faster joins between Booking and User
CREATE INDEX idx_booking_user_id ON Booking(user_id);

-- Faster joins between Booking and Property
CREATE INDEX idx_booking_property_id ON Booking(property_id);

-- Faster filtering by booking status
CREATE INDEX idx_booking_status ON Booking(status);

-- Faster filtering/sorting by start date
CREATE INDEX idx_booking_start_date ON Booking(start_date);

-- Optional composite index for frequent multi-column joins
CREATE INDEX idx_booking_user_property ON Booking(user_id, property_id);

EXPLAIN SELECT * FROM Booking WHERE user_id = 5 AND status = 'confirmed';
EXPLAIN ANALYZE SELECT * FROM Booking WHERE user_id = 5 AND status = 'confirmed';
type: ALL  | key: NULL | rows: 50000 | Extra: Using where
type: ref  | key: idx_booking_user_id | rows: 3 | Extra: Using where
