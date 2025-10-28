
-- 1. Populate the `User` table
-- First, create users. Other records will reference these user_ids.

INSERT INTO `User` (user_id, first_name, last_name, email, password_hash, phone_number, created_at) VALUES
-- ('unique_user_id_1', 'FirstName', 'LastName', 'email1@example.com', 'a_secure_password_hash', '08011112222', NOW()),
-- ('unique_user_id_2', 'AnotherFirstName', 'AnotherLastName', 'email2@example.com', 'another_secure_hash', '09033334444', NOW());
('user_host_placeholder_01', 'Host', 'One', 'host1@example.com', 'hash_placeholder', '11111111111', NOW()),
('user_guest_placeholder_02', 'Guest', 'Two', 'guest2@example.com', 'hash_placeholder', '22222222222', NOW());


-- 2. Populate the `Property` table
-- A property must be owned by an existing user (host_id).

INSERT INTO `Property` (property_id, host_id, name, description, location, price_per_night, created_at, updated_at) VALUES
-- ('unique_property_id_1', 'unique_user_id_1', 'Name Of The Property', 'A lovely description of the property.', 'Location, City', 50000.00, NOW(), NOW());
('prop_placeholder_01', 'user_host_placeholder_01', 'Placeholder Property', 'A description for the placeholder property.', 'Placeholder Location, City', 50000.00, NOW(), NOW());


-- 3. Populate the `Booking` table
-- A booking connects a user (guest) to a property. Both user_id and property_id must already exist.

INSERT INTO `Booking` (booking_id, property_id, user_id, start_date, end_date, total_price, status, created_at) VALUES
-- ('unique_booking_id_1', 'unique_property_id_1', 'unique_user_id_2', 'YYYY-MM-DD', 'YYYY-MM-DD', 100000.00, 'confirmed', NOW());
('booking_placeholder_01', 'prop_placeholder_01', 'user_guest_placeholder_02', '2025-12-01', '2025-12-03', 100000.00, 'confirmed', NOW());


-- 4. Populate the `Payment` table
-- A payment is linked to an existing booking.

INSERT INTO `Payment` (payment_id, booking_id, amount, payment_method, payment_date) VALUES
-- ('unique_payment_id_1', 'unique_booking_id_1', 100000.00, 'card', NOW());
('payment_placeholder_01', 'booking_placeholder_01', 100000.00, 'card', NOW());


-- 5. Populate the `Review` table
-- A review is left by a user for a property. Both user_id and property_id must exist.

INSERT INTO `Review` (review_id, property_id, user_id, rating, comment, created_at) VALUES
-- ('unique_review_id_1', 'unique_property_id_1', 'unique_user_id_2', 5, 'A fantastic and descriptive review goes here.', NOW());
('review_placeholder_01', 'prop_placeholder_01', 'user_guest_placeholder_02', 5, 'This is a placeholder review for the property.', NOW());


-- 6. Populate the `Message` table
-- A message is sent from one existing user to another.

INSERT INTO `Message` (message_id, sender_id, recipient_id, message_body, sent_at) VALUES
-- ('unique_message_id_1', 'unique_user_id_2', 'unique_user_id_1', 'A sample message body goes here.', NOW());
('message_placeholder_01', 'user_guest_placeholder_02', 'user_host_placeholder_01', 'This is a placeholder message.', NOW());