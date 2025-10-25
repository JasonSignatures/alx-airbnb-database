# Airbnb Database System

## Overview

This repository contains the full database design and sample data for an Airbnb-style booking management system. It includes:

- Entity-Relationship Diagram (ERD) design
- Database normalization to 3NF
- SQL DDL (Create Table statements)
- SQL seed script with sample data

The system manages Users, Properties, Bookings, Payments, Reviews, and Messages, reflecting realistic usage patterns.

---

## 1. Entity-Relationship Diagram (ERD)

### Entities and Attributes

#### User
- `user_id` (PK)
- `first_name`
- `last_name`
- `email` (unique)
- `password_hash`
- `phone_number`
- `role` (guest, host, admin)
- `created_at`

#### Property
- `property_id` (PK)
- `host_id` (FK → User.user_id)
- `name`
- `description`
- `location`
- `pricepernight`
- `created_at`
- `updated_at`

#### Booking
- `booking_id` (PK)
- `property_id` (FK → Property.property_id)
- `user_id` (FK → User.user_id)
- `start_date`
- `end_date`
- `status` (pending, confirmed, canceled)
- `created_at`

#### Payment
- `payment_id` (PK)
- `booking_id` (FK → Booking.booking_id)
- `amount`
- `payment_date`
- `payment_method` (credit_card, paypal, stripe)

#### Review
- `review_id` (PK)
- `property_id` (FK → Property.property_id)
- `user_id` (FK → User.user_id)
- `rating` (1–5)
- `comment`
- `created_at`

#### Message
- `message_id` (PK)
- `sender_id` (FK → User.user_id)
- `recipient_id` (FK → User.user_id)
- `message_body`
- `sent_at`

### Relationships

- **User → Property**: One-to-Many (a host owns multiple properties)
- **User → Booking**: One-to-Many (a guest can make multiple bookings)
- **Property → Booking**: One-to-Many (a property can have multiple bookings)
- **Booking → Payment**: One-to-Many (a booking can have multiple payments)
- **User ↔ Property (via Review)**: Many-to-Many (guests can review multiple properties; properties can have multiple reviews)
- **User ↔ User (via Message)**: Many-to-Many (users send and receive messages)

---

## 2. Database Normalization (3NF)

### Steps Taken

- **1NF**: All attributes are atomic; no repeating groups.
- **2NF**: All non-key attributes depend on the primary key; no partial dependencies.
- **3NF**: Removed transitive dependencies.
  - `total_price` in Bookings is derived dynamically from `DATEDIFF(end_date, start_date) * pricepernight` to avoid redundancy.

**Result**: Database is fully normalized and free of redundancy or anomalies.

---

## 3. SQL Database Schema (DDL)

```sql
-- Users Table
CREATE TABLE Users (
    user_id UUID PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    password_hash VARCHAR(255) NOT NULL,
    phone_number VARCHAR(20),
    role ENUM('guest', 'host', 'admin') NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_user_email ON Users(email);

-- Properties Table
CREATE TABLE Properties (
    property_id UUID PRIMARY KEY,
    host_id UUID NOT NULL,
    name VARCHAR(100) NOT NULL,
    description TEXT NOT NULL,
    location VARCHAR(150) NOT NULL,
    pricepernight DECIMAL(10,2) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT fk_property_host FOREIGN KEY (host_id) REFERENCES Users(user_id)
);

CREATE INDEX idx_property_host ON Properties(host_id);

-- Bookings Table
CREATE TABLE Bookings (
    booking_id UUID PRIMARY KEY,
    property_id UUID NOT NULL,
    user_id UUID NOT NULL,
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    status ENUM('pending', 'confirmed', 'canceled') NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_booking_property FOREIGN KEY (property_id) REFERENCES Properties(property_id),
    CONSTRAINT fk_booking_user FOREIGN KEY (user_id) REFERENCES Users(user_id)
);

CREATE INDEX idx_booking_property ON Bookings(property_id);
CREATE INDEX idx_booking_user ON Bookings(user_id);

-- Payments Table
CREATE TABLE Payments (
    payment_id UUID PRIMARY KEY,
    booking_id UUID NOT NULL,
    amount DECIMAL(10,2) NOT NULL,
    payment_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    payment_method ENUM('credit_card', 'paypal', 'stripe') NOT NULL,
    CONSTRAINT fk_payment_booking FOREIGN KEY (booking_id) REFERENCES Bookings(booking_id)
);

CREATE INDEX idx_payment_booking ON Payments(booking_id);

-- Reviews Table
CREATE TABLE Reviews (
    review_id UUID PRIMARY KEY,
    property_id UUID NOT NULL,
    user_id UUID NOT NULL,
    rating INT CHECK (rating >= 1 AND rating <= 5) NOT NULL,
    comment TEXT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_review_property FOREIGN KEY (property_id) REFERENCES Properties(property_id),
    CONSTRAINT fk_review_user FOREIGN KEY (user_id) REFERENCES Users(user_id)
);

CREATE INDEX idx_review_property ON Reviews(property_id);
CREATE INDEX idx_review_user ON Reviews(user_id);

-- Messages Table
CREATE TABLE Messages (
    message_id UUID PRIMARY KEY,
    sender_id UUID NOT NULL,
    recipient_id UUID NOT NULL,
    message_body TEXT NOT NULL,
    sent_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_message_sender FOREIGN KEY (sender_id) REFERENCES Users(user_id),
    CONSTRAINT fk_message_recipient FOREIGN KEY (recipient_id) REFERENCES Users(user_id)
);

CREATE INDEX idx_message_sender ON Messages(sender_id);
CREATE INDEX idx_message_recipient ON Messages(recipient_id);
