CREATE INDEX idx_bookings_user_id ON BOOKINGS (user_id);

Purpose: Speeds up joins between BOOKINGS and USERS.

CREATE INDEX idx_bookings_date ON BOOKINGS (booking_date);

Purpose: Optimizes filtering using WHERE clauses and sorting using ORDER BY on the booking date.

CREATE INDEX idx_properties_name ON PROPERTIES (property_name);

Purpose: Improves the performance of the ORDER BY clause that sorts results by property name.

CREATE INDEX idx_reviews_property_id ON REVIEWS (property_id);

Purpose: Speeds up the LEFT JOIN operation between PROPERTIES and REVIEWS.
