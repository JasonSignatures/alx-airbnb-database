Sales Order Database (3NF)

This repository contains the SQL scripts for a simplified Sales Order database system designed and normalized to the Third Normal Form (3NF). The goal of this design is to eliminate data redundancy and improve data integrity.

💾 Schema Overview

The database is split into three main tables to manage the relationships between orders, customers, and sales personnel:

Table Name

Purpose

Primary Key

Foreign Keys

Salespersons

Stores unique information about each salesperson and their assigned region.

salesperson_id

None

Customers

Stores unique information about each customer.

customer_id

None

Orders

Stores transaction details, linking orders back to a specific customer and salesperson.

order_id

customer_id (FK to Customers), salesperson_id (FK to Salespersons)

🔑 Data Integrity and Constraints

The schema enforces data integrity through the following constraints:

Primary Keys: Defined on id columns (salesperson_id, customer_id, order_id) to ensure unique identification for every record.

Foreign Keys: The Orders table uses foreign keys to ensure that every order references a valid existing customer and salesperson.

Indexes: Explicit indexes have been created on foreign key columns (Orders.customer_id, Orders.salesperson_id) to optimize join performance.

📊 Reporting Queries

The reporting_queries.sql file contains several example queries to extract meaningful insights from the normalized data. These queries demonstrate essential SQL concepts:

Query 1: Detailed Order List: Uses JOIN to retrieve full details (customer name, salesperson region) for every order.

Query 2: Regional Performance: Uses GROUP BY and COUNT to summarize the total number of orders per sales region.

Query 3: Customer History: Filters orders for a specific customer.

Query 4: Top Customer: Uses GROUP BY, COUNT, and LIMIT to identify the customer with the highest number of orders.

Query 5: Inactive Sales Staff: Uses a LEFT JOIN and WHERE IS NULL to find salespersons who have not placed any orders.

To set up the database, execute the schema.sql file first, followed by the sample_data.sql file.