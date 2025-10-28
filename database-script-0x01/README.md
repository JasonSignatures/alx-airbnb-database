3NF Sales Order Database Schema

This repository contains the SQL schema for a basic Sales Order database designed following the principles of the Third Normal Form (3NF). The goal of this normalization is to eliminate data redundancy and ensure data integrity.

Database Structure

The schema is composed of three core tables, which address the necessary entity relationships and remove transitive dependencies present in a single, unnormalized table.

1. Salespersons

Purpose: Stores unique information about each salesperson.

Key: salesperson_id (Primary Key, PK)

Normalization: This table separates information about salesperson regions from the orders, ensuring that the salesperson_region is only dependent on the salesperson_id (satisfying 3NF).

2. Customers

Purpose: Stores unique information about each customer.

Key: customer_id (Primary Key, PK)

Normalization: Ensures customer names are stored only once, preventing update and insertion anomalies.

3. Orders

Purpose: The central transaction (fact) table that records individual orders.

Key: order_id (Primary Key, PK)

Relationships (Foreign Keys, FK):

customer_id (FK $\rightarrow$ Customers.customer_id)

salesperson_id (FK $\rightarrow$ Salespersons.salesperson_id)

Relationships and Constraints

The Orders table uses foreign keys to link to the Customers and Salespersons tables, establishing a many-to-one relationship (many orders to one customer/salesperson).

The Foreign Key constraints defined in the schema.sql are:

Foreign Key

Referenced Table

ON UPDATE

ON DELETE

fk_customer

Customers

CASCADE

RESTRICT

fk_salesperson

Salespersons

CASCADE

RESTRICT

Constraint Notes:

ON UPDATE CASCADE: If a primary key value (like customer_id) is changed in the parent table (Customers), the corresponding foreign key values in the child table (Orders) will automatically update.

ON DELETE RESTRICT: Prevents the deletion of a parent row (e.g., a customer) if there are still dependent records (orders) referencing it. This protects historical order data.