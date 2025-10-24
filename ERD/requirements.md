1. USER Entity

Represents all users registered in the system (both hosts and guests).

Attribute	Description	Type / Example
user_id (PK)	Unique identifier for each user	INT / UUID
name	Full name of the user	VARCHAR(100)
email	User’s email address (unique)	VARCHAR(100)
password	Encrypted password	VARCHAR(255)
phone	Contact number	VARCHAR(20)
role	Type of user → ENUM('guest', 'host')	ENUM
created_at	Account creation date	DATETIME
🏠 2. PROPERTY Entity

Represents properties listed for rent by hosts.

Attribute	Description	Type / Example
property_id (PK)	Unique identifier for each property	INT / UUID
host_id (FK)	References User.user_id (owner)	INT
title	Property name or headline	VARCHAR(150)
description	Text description of the property	TEXT
location	City or address	VARCHAR(150)
price	Cost per night	DECIMAL(10,2)
created_at	Date property was listed	DATETIME
📅 3. BOOKING Entity

Tracks when a user books a property.

Attribute	Description	Type / Example
booking_id (PK)	Unique booking identifier	INT / UUID
user_id (FK)	References User.user_id (guest)	INT
property_id (FK)	References Property.property_id	INT
booking_date	When the booking was made	DATE
check_in	Start date of booking	DATE
check_out	End date of booking	DATE
status	ENUM('pending', 'confirmed', 'canceled')	ENUM
💳 4. PAYMENT Entity

Stores payment information for each booking.

Attribute	Description	Type / Example
payment_id (PK)	Unique payment record ID	INT / UUID
booking_id (FK)	References Booking.booking_id	INT
amount	Total payment amount	DECIMAL(10,2)
payment_date	Date of payment	DATE
status	ENUM('pending', 'completed', 'failed')	ENUM
method	Payment method (e.g., card, transfer)	VARCHAR(50)
⭐ 5. REVIEW Entity

Holds reviews written by users for properties.

Attribute	Description	Type / Example
review_id (PK)	Unique review identifier	INT / UUID
user_id (FK)	References User.user_id (author)	INT
property_id (FK)	References Property.property_id	INT
rating	Star rating (1–5)	INT
comment	Written review or feedback	TEXT
review_date	Date of submission	DATE
🔗 Summary of Relationships
Entity 1	Relationship	Entity 2	Type
User → Property	A user (host) can own many properties	1 : M	
User → Booking	A user (guest) can make many bookings	1 : M	
Property → Booking	A property can be booked multiple times	1 : M	

🔗 Entity Relationships
1️⃣ User → Property

Type: One-to-Many (1 : M)

Description: A single user (acting as a host) can own or list multiple properties, but each property belongs to only one host.

Implementation:

Property.host_id → User.user_id


Meaning:

One user can have many properties.

Each property must be owned by one specific user (host).

2️⃣ User → Booking

Type: One-to-Many (1 : M)

Description: A user (as a guest) can make many bookings, but each booking is made by one user.

Implementation:

Booking.user_id → User.user_id


Meaning:

One user may have several bookings.

Each booking must be linked to one user (who made it).

3️⃣ Property → Booking

Type: One-to-Many (1 : M)

Description: A property can be booked many times by different users, but each booking is for one specific property.

Implementation:

Booking.property_id → Property.property_id


Meaning:

One property can appear in multiple bookings.

Each booking corresponds to one property.

4️⃣ Booking → Payment

Type: One-to-One (1 : 1)

Description: Every booking has a corresponding payment record, and each payment belongs to a single booking.

Implementation:

Payment.booking_id → Booking.booking_id


Meaning:

One payment per booking.

Cannot have multiple payments for the same booking.

5️⃣ User → Review

Type: One-to-Many (1 : M)

Description: A user can write many reviews (for different properties), but each review is written by one user.

Implementation:

Review.user_id → User.user_id


Meaning:

One user can leave multiple reviews.

Each review belongs to one user.

6️⃣ Property → Review

Type: One-to-Many (1 : M)

Description: A property can have many reviews, but each review relates to one property.

Implementation:

Review.property_id → Property.property_id


Meaning:

One property receives reviews from different users.

Each review references one property.

🧭 Overall Relationship Summary
From Entity	To Entity	Relationship Type	Foreign Key
User	Property	1 : M	Property.host_id
User	Booking	1 : M	Booking.user_id
Property	Booking	1 : M	Booking.property_id
Booking	Payment	1 : 1	Payment.booking_id
User	Review	1 : M	Review.user_id
Property	Review	1 : M	Review.property_id

✅ In ERD terms:

User is connected to Property, Booking, and Review.

Property is connected to Booking and Review.

Booking connects User, Property, and Payment.

![Entity-Relationship ER](https://github.com/user-attachments/assets/a10d1f7a-e964-42c0-b2e9-1b42bfa3d4a4)

Booking → Payment	Each booking has one payment	1 : 1	
User → Review	A user can write multiple reviews	1 : M	
Property → Review	A property can have many reviews	1 : M
