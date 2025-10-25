🧩 Database Normalization to Third Normal Form (3NF)
Objective

To ensure the database design is free of redundancy and update anomalies by applying normalization rules up to the Third Normal Form (3NF).

1. Understanding Normalization

Normalization is the process of organizing data in a database to reduce redundancy and improve data integrity.
The main goal is to decompose larger tables into smaller, well-structured ones without losing information.

2. Normalization Steps
Step 1: First Normal Form (1NF)

A table is in 1NF if:

Each cell contains only atomic (indivisible) values.

Each record is unique (no duplicate rows).

✅ Actions Taken:

Ensured all attributes contain single values (e.g., split full name into first_name, last_name).

Added a Primary Key for each entity (e.g., user_id, property_id, booking_id).

Example (Before → After 1NF):

user_id	full_name	phone_numbers
1	Jane Doe	08012345678, 08123456789

➡️ After 1NF

user_id	first_name	last_name	phone_number
1	Jane	Doe	08012345678
1	Jane	Doe	08123456789
Step 2: Second Normal Form (2NF)

A table is in 2NF if:

It is already in 1NF.

All non-key attributes are fully dependent on the entire primary key (not part of it).

✅ Actions Taken:

Removed partial dependencies in tables with composite keys.

Created new tables for attributes that depended only on part of a composite key.

Example:
In the Booking table, suppose we had:

(booking_id, property_id, user_name, property_location)


Here, property_location depends only on property_id, not the whole key.

➡️ Solution: Moved property_location to the Property table.

Step 3: Third Normal Form (3NF)

A table is in 3NF if:

It is already in 2NF.

There are no transitive dependencies (non-key attributes do not depend on other non-key attributes).

✅ Actions Taken:

Removed transitive dependencies.

Moved attributes that depended on other non-key attributes into new tables.

Example:

property_id	property_name	owner_id	owner_email

Here, owner_email depends on owner_id, not directly on property_id.

➡️ Solution:

Created an Owner (or User) table to hold owner details.

property_id now only stores a foreign key (owner_id).

3. Final 3NF Schema Overview

Entities and Keys:

User (user_id, first_name, last_name, email, phone)

Property (property_id, owner_id, name, type, location, price)

Booking (booking_id, user_id, property_id, booking_date, status)

Payment (payment_id, booking_id, amount, method, payment_date)

Relationships:

One User → Many Bookings

One Property → Many Bookings

One Booking → One Payment

4. Benefits of 3NF

✅ Eliminates redundancy
✅ Prevents update, insert, and delete anomalies
✅ Ensures data consistency and integrity
✅ Makes queries more efficient and relationships clearer

5. Conclusion

After applying normalization rules up to Third Normal Form (3NF), the database schema:

Stores each fact in only one place.

Maintains clear and consistent relationships.

Supports efficient data retrieval and updates.
