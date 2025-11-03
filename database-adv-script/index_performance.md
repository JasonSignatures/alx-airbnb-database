-- ==============================
-- USER TABLE INDEXES
-- ==============================

-- Index on email for quick lookup during login
CREATE INDEX idx_user_email ON User(email);

-- Index on username for user searches
CREATE INDEX idx_user_username ON User(username);


-- ==============================
-- PROPERTY TABLE INDEXES
-- ==============================

-- Index on location to speed up searches by city or area
CREATE INDEX idx_property_location ON Property(location);

-- Index on host_id to optimize joins with User (host)
CREATE INDEX idx_property_host_id ON Property(host_id);


-- ==============================
-- BOOKING TABLE INDEXES
-- ==============================

-- Index on user_id for fast lookup of user bookings
CREATE INDEX idx_booking_user_id ON Booking(user_id);

-- Index on property_id for fast lookup of bookings per property
CREATE INDEX idx_booking_property_id ON Booking(property_id);

-- Index on booking_date for date range queries and reports
CREATE INDEX idx_booking_date ON Booking(booking_date);

-- Index on status for filtering bookings (e.g., confirmed, cancelled)
CREATE INDEX idx_booking_status ON Booking(status);
