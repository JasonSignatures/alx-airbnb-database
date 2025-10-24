 1. Entities and Attributes
 USER

Represents all users on the platform (guests and/or hosts).

Attribute	Description
user_id (PK)	Unique ID for each user
name	User’s full name
email	User’s email (unique)
password	Encrypted password
phone	Contact number
role	ENUM('guest', 'host')
created_at	Date account was created
🏠 PROPERTY

Represents listings or spaces available for booking.

Attribute	Description
property_id (PK)	Unique ID for each property
host_id (FK → User.user_id)**	The owner (host) of the property
title	Property name or headline
description	Text description
location	City or address
price	Nightly rate
created_at	Date listed
 BOOKING

Represents when a user books a property.

Attribute	Description
booking_id (PK)	Unique booking ID
user_id (FK → User.user_id)**	User who made the booking
property_id (FK → Property.property_id)**	Property being booked
booking_date	When the booking was made
check_in	Start date
check_out	End date
status	ENUM('pending', 'confirmed', 'canceled')
 PAYMENT

Tracks payments made for bookings.

Attribute	Description
payment_id (PK)	Unique payment ID
booking_id (FK → Booking.booking_id)**	Booking being paid for
amount	Payment amount
payment_date	Date payment was made
status	ENUM('pending', 'completed', 'failed')
method	Payment method (e.g., card, transfer)
 REVIEW

Tracks feedback left by users about properties.

Attribute	Description
review_id (PK)	Unique review ID
user_id (FK → User.user_id)**	User who wrote the review
property_id (FK → Property.property_id)**	Property being reviewed
rating	Numeric rating (1–5)
comment	Text review
review_date	Date review was submitted
 2. Relationships Between Entities
Relationship	Type	Description
User → Property	1 : M	A user (host) can own many properties
User → Booking	1 : M	A user (guest) can make many bookings
Property → Booking	1 : M	A property can have many bookings
Booking → Payment	1 : 1	Each booking has one payment record
User → Review	1 : M	A user can write many reviews
Property → Review	1 : M	A property can have many reviews
 3. ER Diagram Summary (Textual Representation)
USER (user_id PK)
   |---< BOOKING (booking_id PK, user_id FK)
   |         |---< PAYMENT (payment_id PK, booking_id FK)
   |
   |---< REVIEW (review_id PK, user_id FK, property_id FK)
   |
   |---< PROPERTY (property_id PK, host_id FK)
             |---< BOOKING (booking_id PK, property_id FK)
             |---< REVIEW (review_id PK, property_id FK)

 4. Key Relationships

User–Property: A host owns multiple properties

User–Booking: A guest can make multiple bookings

Property–Booking: A property can be booked multiple times

Booking–Payment: Each booking triggers one payment

User–Review: A guest can post multiple reviews

Property–Review: Each property can have multiple reviews
