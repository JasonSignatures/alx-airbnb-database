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
