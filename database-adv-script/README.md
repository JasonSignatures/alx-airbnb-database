SQL Join Mastery: Database Queries

This repository contains SQL queries designed to demonstrate proficiency in various types of database joins, focusing on the Third Normal Form (3NF) relational model.

The queries are intended to be executed against a mock database schema representing a simple property rental or booking system.

📁 Included File

Filename

Description

joins.sql

Contains three distinct SQL queries demonstrating INNER JOIN, LEFT JOIN, and FULL OUTER JOIN.

📚 Assumed Database Schema

The queries in joins.sql are based on the following simplified tables:

USERS: Stores user details.

user_id (Primary Key)

user_name

email

BOOKINGS: Records property bookings made by users.

booking_id (Primary Key)

user_id (Foreign Key to USERS)

property_id

booking_date

PROPERTIES: Lists available properties.

property_id (Primary Key)

property_name

location

REVIEWS: Contains feedback left for properties.

review_id (Primary Key)

property_id (Foreign Key to PROPERTIES)

rating

review_text

🎯 Query Objectives

The joins.sql file includes the following three major queries:

INNER JOIN (Bookings & Users):

Objective: Retrieve a list of all successful bookings, linking them only to users who currently exist in the USERS table. This ensures all returned booking records are complete and valid.

LEFT JOIN (Properties & Reviews):

Objective: Retrieve all properties regardless of whether they have feedback. Properties with reviews will show the review data; properties without reviews will show NULL for the review columns.

FULL OUTER JOIN (Users & Bookings):

Objective: Demonstrate a comprehensive linkage, showing all users (even those with no bookings) and all bookings (even those not linked to a user).
