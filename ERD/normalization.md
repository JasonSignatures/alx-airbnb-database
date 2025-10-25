🧾 Normalization Review of Schema
1. USER Table

Proposed structure:

User(
  user_id INT PRIMARY KEY,
  first_name VARCHAR(50),
  last_name VARCHAR(50),
  email VARCHAR(100),
  phone VARCHAR(20),
  address VARCHAR(255),
  date_joined DATE
)

✅ Review:

Each field is atomic → satisfies 1NF.

No composite keys → 2NF automatically satisfied.

All attributes depend only on the key (user_id) → no transitive dependency.
✅ 3NF compliant.

⚠️ Potential Issue:

If you also store city and country within User, and these same values repeat across many users, you may introduce redundancy.

Fix:
Create a Location table:

Location(
  location_id INT PRIMARY KEY,
  city VARCHAR(100),
  country VARCHAR(100)
)

-- then
User(location_id INT FOREIGN KEY REFERENCES Location(location_id))

2. PROPERTY Table

Proposed structure:

Property(
  property_id INT PRIMARY KEY,
  owner_id INT,
  property_name VARCHAR(100),
  description TEXT,
  location VARCHAR(100),
  price DECIMAL(10,2),
  property_type VARCHAR(50)
)

⚠️ Review:

All columns atomic → 1NF ✅

No composite key → 2NF ✅

Possible violation of 3NF:
If owner_id refers to a user and you also store owner details here (e.g., owner_name, owner_email), those fields depend on owner_id, not directly on property_id.

Fix:
Remove those attributes and ensure they live in the User table:

ALTER TABLE Property
DROP COLUMN owner_name,
DROP COLUMN owner_email;


✅ After fix, Property depends only on its primary key — 3NF satisfied.

3. BOOKING Table

Proposed structure:

Booking(
  booking_id INT PRIMARY KEY,
  user_id INT,
  property_id INT,
  booking_date DATE,
  check_in DATE,
  check_out DATE,
  total_price DECIMAL(10,2),
  status VARCHAR(50)
)

✅ Review:

Each field atomic → 1NF ✅

Non-key fields depend on the whole primary key (booking_id) → 2NF ✅

No field depends on another non-key field (e.g., total_price should be computed but not stored redundantly).
✅ 3NF compliant.

⚠️ Potential Issue:

If you store both property_price and total_price here, it creates redundancy (price is derived from Property and duration).
Fix: Keep only total_price or calculate it dynamically using joins.

4. PAYMENT Table

Proposed structure:

Payment(
  payment_id INT PRIMARY KEY,
  booking_id INT,
  amount DECIMAL(10,2),
  method VARCHAR(50),
  payment_date DATE,
  status VARCHAR(50)
)

✅ Review:

Each column atomic → 1NF ✅

Non-key attributes depend only on payment_id → 2NF ✅

No transitive dependency (e.g., don’t include user_email or property_name here).
✅ 3NF compliant.

5. POTENTIAL REDUNDANCIES (Summary Table)
Table	Violation	Description	Normalization Fix
User	None (possible location redundancy)	Repeated city/country values	Create Location table
Property	3NF	Owner details depend on owner_id	Move to User table
Booking	Derived data redundancy	Storing both property and total price	Calculate or remove redundant field
Payment	None	All dependencies correct	Keep as-is
✅ Conclusion

After review:

User, Booking, and Payment are in 3NF.

Property needed minor adjustment (removing owner info redundancy).

Optionally, User location data can be normalized further.

Your schema now fully satisfies Third Normal Form (3NF) — ensuring minimal redundancy and strong data integrity.
User(user_id, name, email, phone, role_id)
Property(property_id, owner_id, name, price, location)
...
# 📘 Database Normalization Process (Up to 3NF)

## 🎯 Objective
To refine the database schema by removing redundancy and ensuring data integrity through normalization up to the **Third Normal Form (3NF)**.

---

## 🧩 1. Understanding Normalization
**Normalization** is the process of structuring a relational database to minimize data redundancy and improve data consistency.  
Each *normal form* adds rules to achieve a cleaner, more efficient design.

---

## 🧱 2. Normalization Steps

### 🥇 Step 1: First Normal Form (1NF)
**Rule:**  
- Each table cell must contain a single (atomic) value.  
- Each record must be unique.

**Action Taken:**  
- Split multi-valued attributes (e.g., multiple phone numbers → separate rows or table).  
- Added **primary keys** to each table (`user_id`, `property_id`, `booking_id`, `payment_id`).

**Example:**
| user_id | full_name | phone_numbers |
|----------|------------|---------------|
| 1        | Jane Doe   | 0801, 0812    |

➡ **After 1NF**
| user_id | first_name | last_name | phone_number |
|----------|-------------|------------|---------------|
| 1        | Jane        | Doe        | 0801          |
| 1        | Jane        | Doe        | 0812          |

✅ **Result:** Each column now holds atomic values; duplicates removed.

---

### 🥈 Step 2: Second Normal Form (2NF)
**Rule:**  
- Must already satisfy **1NF**.  
- All non-key attributes must depend on the *whole* primary key (no partial dependency).

**Action Taken:**  
- Identified composite keys and removed partial dependencies.  
- Moved attributes that depended only on part of a composite key into separate tables.

**Example (Violation):**
Here, `property_location` depends only on `property_id`, not the composite key.

➡ **Fix:** Move `property_location` to the `Property` table.

✅ **Result:** Each non-key attribute fully depends on the entire primary key.

---

### 🥉 Step 3: Third Normal Form (3NF)
**Rule:**  
- Must already satisfy **2NF**.  
- No transitive dependencies (non-key attributes cannot depend on other non-key attributes).

**Action Taken:**  
- Removed transitive dependencies such as `owner_email` depending on `owner_id`.  
- Created a `User` (or `Owner`) table to hold those details.

**Example (Violation):**
Here, `owner_email` depends on `owner_id`, not directly on `property_id`.

➡ **Fix:**  
Move `owner_email` to the `User` table and link using a foreign key:

✅ **Result:** All non-key attributes now depend *only* on the table’s primary key.

---

## 🧮 3. Final 3NF Schema Overview

| Entity   | Primary Key | Key Attributes | Notes |
|-----------|--------------|----------------|--------|
| **User** | user_id | first_name, last_name, email, phone | Each user uniquely identified |
| **Property** | property_id | owner_id (FK), name, location, price, type | No redundant owner data |
| **Booking** | booking_id | user_id (FK), property_id (FK), booking_date, check_in, check_out, total_price, status | Fully dependent on booking_id |
| **Payment** | payment_id | booking_id (FK), amount, method, payment_date, status | Linked directly to booking |

---

## ✅ 4. Benefits of 3NF
- Eliminates redundant data storage  
- Prevents update, insertion, and deletion anomalies  
- Improves data consistency  
- Simplifies maintenance and querying  

---

## 🏁 5. Conclusion
After applying normalization up to **Third Normal Form (3NF)**:
- Each table stores a single, well-defined concept.  
- All non-key attributes depend directly on the primary key.  
- The schema is free of partial and transitive dependencies.  

This ensures a **clean, efficient, and reliable** database design.

---

