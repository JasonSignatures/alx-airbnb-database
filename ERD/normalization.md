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
