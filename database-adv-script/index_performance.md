-- Database Indexing Strategy
-- Objective: Create indexes on high-usage columns (Foreign Keys, WHERE, and ORDER BY clauses)
-- to speed up the join operations defined in joins.sql and common filtering tasks.
-- Primary keys are typically indexed automatically, so we focus on FKs and common query targets.

-- -------------------------------------------------------------------
-- 1. Indexing on BOOKINGS Table
-- -------------------------------------------------------------------

-- Index on the Foreign Key (FK) column 'user_id'.
-- This significantly speeds up the INNER JOIN and FULL OUTER JOIN on the USERS table.
CREATE INDEX idx_bookings_user_id ON BOOKINGS (user_id);

-- Index on 'booking_date'.
-- This column is extremely likely to be used in WHERE clauses (e.g., filter by date range)
-- and ORDER BY clauses (e.g., show the most recent bookings).
CREATE INDEX idx_bookings_date ON BOOKINGS (booking_date);

-- -------------------------------------------------------------------
-- 2. Indexing on PROPERTIES Table
-- -------------------------------------------------------------------

-- Index on 'property_name'.
-- This column is explicitly used in the ORDER BY clause in the LEFT JOIN query.
-- Indexing this column will speed up sorting operations on the result set.
CREATE INDEX idx_properties_name ON PROPERTIES (property_name);

-- -------------------------------------------------------------------
-- 3. Indexing on REVIEWS Table
-- -------------------------------------------------------------------

-- Index on the Foreign Key (FK) column 'property_id'.
-- This significantly speeds up the LEFT JOIN operation connecting properties to their reviews.
CREATE INDEX idx_reviews_property_id ON REVIEWS (property_id);

-- -------------------------------------------------------------------
-- Performance Measurement Instructions
-- -------------------------------------------------------------------

-- To measure the query performance before and after adding these indexes, you should
-- use the database's query analysis tool (e.g., EXPLAIN PLAN in Oracle/PostgreSQL,
-- EXPLAIN in MySQL) on the queries found in joins.sql.

-- Example for measuring performance BEFORE/AFTER index creation (using PostgreSQL/MySQL syntax):
-- 1. Run the query BEFORE creating the indexes:
--    EXPLAIN ANALYZE SELECT ... FROM Properties P LEFT JOIN Reviews R ON P.property_id = R.property_id;

-- 2. Execute the CREATE INDEX commands in this file.

-- 3. Run the query AFTER creating the indexes:
--    EXPLAIN ANALYZE SELECT ... FROM Properties P LEFT JOIN Reviews R ON P.property_id = R.property_id;

-- Compare the "cost" and "time" metrics to see the speed improvement.
