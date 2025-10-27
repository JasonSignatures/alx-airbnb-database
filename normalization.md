🔍 Step-by-Step Normalization Review
1. First Normal Form (1NF)

✅ Passes 1NF

Every field holds atomic values (no repeating groups, no arrays).

All tables have primary keys.

Each attribute represents a single fact about the entity.

2. Second Normal Form (2NF)

✅ Passes 2NF

Every non-key attribute is fully dependent on the entire primary key.

All tables use single-column primary keys (UUID), so partial dependencies are impossible.

3. Third Normal Form (3NF)

Let’s inspect transitive dependencies (when non-key columns depend on other non-key columns).

Users Table
(user_id, first_name, last_name, email, password_hash, phone_number, role, created_at)


✅ No transitive dependencies.

All attributes depend only on user_id.

No derived fields.

🟢 No redundancy detected.

Properties Table
(property_id, host_id, name, description, location, pricepernight, created_at, updated_at)


✅ All attributes depend on property_id.

host_id is a foreign key (not derived).

location stored as a single value — fine for this scale.
Optional improvement: If the app grows, consider splitting location into structured fields (city, country, etc.) for better filtering and indexing.

🟢 No normalization violation.

Bookings Table
(booking_id, property_id, user_id, start_date, end_date, status, created_at)


✅ Attributes depend on booking_id.

⚠️ Potential derived attribute warning

You’ve correctly avoided storing total_price, since it can be derived from:

DATEDIFF(end_date, start_date) * pricepernight


This avoids redundancy — excellent 3NF compliance.

🟢 No redundancy present.

Payments Table
(payment_id, booking_id, amount, payment_date, payment_method)


✅ Each payment is fully dependent on payment_id.

amount is payment-specific (not necessarily equal to total booking cost).

No repeating fields or derived data.

🟢 Passes 3NF.

Reviews Table
(review_id, property_id, user_id, rating, comment, created_at)


✅ Each field depends on review_id.

⚠️ Possible real-world constraint consideration (not a normalization violation):

A guest shouldn’t be able to review the same property multiple times — this is not a normalization issue, but you can enforce it with:

UNIQUE(property_id, user_id)


to prevent duplicates.

🟢 3NF compliant.

Messages Table
(message_id, sender_id, recipient_id, message_body, sent_at)


✅ No derived data or transitive dependency.

🟢 3NF compliant.

✅ Summary of Findings
Table	Normalization Status	Notes
Users	✅ 3NF	No issues
Properties	✅ 3NF	Optional: break down location
Bookings	✅ 3NF	Avoided total_price redundancy
Payments	✅ 3NF	No violations
Reviews	✅ 3NF	Add UNIQUE(property_id, user_id) to enforce integrity
Messages	✅ 3NF	Clean structure
🧠 Conclusion

Your schema is fully normalized to 3NF — all attributes depend directly on their respective primary keys, and there are no derived or transitive dependencies.

Only optional refinements:

Add:

ALTER TABLE Reviews ADD CONSTRAINT unique_user_property_review UNIQUE (property_id, user_id);


to enforce review uniqueness.

Consider decomposing location into city, state, country if you expect advanced querying or analytics.

Would you like me to show what your schema would look like if we optimized for 4NF or BCNF (Boyce-Codd Normal Form) next?

You said:
from the above code, Review your schema and identify any potential redundancies or violations of normalization principles.

Adjust your database design to achieve 3NF, if necessary.

Provide an explanation of your normalization steps in a Markdown file.
ChatGPT said:

Here’s a complete Markdown file you can include in your repository as
NORMALIZATION.md 👇

🧩 Database Normalization Review — Airbnb Booking Management System
Overview

This document reviews the database schema for the Airbnb-style booking management system, identifies any potential redundancies or normalization issues, and demonstrates how the design achieves Third Normal Form (3NF).

The database manages:

Users

Properties

Bookings

Payments

Reviews

Messages

🧱 1. Normalization Concepts Recap

Normalization is the process of organizing data to reduce redundancy and improve data integrity.

Normal Form	Description
1NF	Each field contains only atomic (indivisible) values; no repeating groups.
2NF	The table is in 1NF, and all non-key attributes depend on the whole primary key.
3NF	The table is in 2NF, and all non-key attributes depend only on the primary key (no transitive dependency).
🧩 2. Step-by-Step Normalization Review
A. Users Table
Users(user_id, first_name, last_name, email, password_hash, phone_number, role, created_at)


All attributes depend directly on user_id.

No repeating or derived data.

✅ Already in 3NF

B. Properties Table
Properties(property_id, host_id, name, description, location, pricepernight, created_at, updated_at)


Every field depends on property_id.

host_id is a foreign key (no redundancy).

location stored as a single text value — acceptable for now.

✅ Already in 3NF

💡 Optional improvement: Split location into (city, country, etc.) for more structured queries, but this is not required for 3NF.

C. Bookings Table
Bookings(booking_id, property_id, user_id, start_date, end_date, status, created_at)


Every attribute depends on booking_id.

The total_price field was intentionally excluded because it can be derived from:

DATEDIFF(end_date, start_date) * pricepernight


This prevents redundancy and calculation anomalies.

✅ 3NF Compliant

D. Payments Table
Payments(payment_id, booking_id, amount, payment_date, payment_method)


All fields depend on payment_id.

No repeating or derived data.

✅ 3NF Compliant

E. Reviews Table
Reviews(review_id, property_id, user_id, rating, comment, created_at)


Each column depends directly on review_id.

However, to avoid duplicate reviews by the same user for one property, a unique constraint can be added:

ALTER TABLE Reviews
ADD CONSTRAINT unique_user_property_review UNIQUE (property_id, user_id);


✅ 3NF Compliant (after constraint addition)

F. Messages Table
Messages(message_id, sender_id, recipient_id, message_body, sent_at)


Every field depends directly on message_id.

No derived or transitive dependencies.

✅ 3NF Compliant

⚙️ 3. Adjusted Design Summary
Table	Issue Found	Adjustment Made	Result
Users	None	–	✅ 3NF
Properties	None	–	✅ 3NF
Bookings	Avoid derived field (total_price)	Excluded computed value	✅ 3NF
Payments	None	–	✅ 3NF
Reviews	Possible duplicate reviews	Added UNIQUE(property_id, user_id) constraint	✅ 3NF
Messages	None	–	✅ 3NF
🧠 4. Explanation in Simple Terms

Think of normalization like organizing a closet:

1NF: You separate items so each box has only one kind of item (no mixed clothes in one box).

2NF: You make sure each item belongs in the right box — no box contains items that depend on another box.

3NF: You remove anything that can be calculated or derived from other boxes — no duplicates or indirect dependencies.

By doing this, our Airbnb database:

Avoids redundant storage (no repeated data like total price or duplicate reviews),

Keeps data consistent (changes only need to happen in one place),

Makes updates and queries more efficient.

✅ 5. Conclusion

After review and adjustments:

The database design meets Third Normal Form (3NF).

Each table stores data about one concept.

There are no repeating groups, partial dependencies, or transitive dependencies.

The system ensures data integrity, reduces redundancy, and supports scalability.

Author: Enobong Jackson
Project: Airbnb Booking Management Database
Normalization Level Achieved: ✅ Third Normal Form (3NF)
