-- Foreign Key column for Customers
customer_id VARCHAR(10) NOT NULL,

-- Foreign Key column for Salespersons
salesperson_id VARCHAR(10) NOT NULL,

-- Define Foreign Key Constraints based on README.md specifications
CONSTRAINT fk_customer
    FOREIGN KEY (customer_id) 
    REFERENCES Customers(customer_id)
    ON UPDATE CASCADE
    ON DELETE RESTRICT,
    
CONSTRAINT fk_salesperson
    FOREIGN KEY (salesperson_id) 
    REFERENCES Salespersons(salesperson_id)
    ON UPDATE CASCADE
    ON DELETE RESTRICT


);
