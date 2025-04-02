CREATE TYPE emp_address_type AS ( --composite attribute 
    house_number VARCHAR(20),
    street_name VARCHAR(50),
    city_name VARCHAR(50)
);

CREATE TABLE Employee (
    emp_id INTEGER PRIMARY KEY,
    emp_name VARCHAR(50) NOT NULL,
    emp_email VARCHAR(50),
    emp_manager_id INTEGER NOT NULL,--employee manages other employees  (aka manager;)
    emp_address emp_address_type,
    FOREIGN KEY (emp_manager_id) REFERENCES Employee(emp_id)
);

CREATE TABLE Supplier (
    sup_id INTEGER PRIMARY KEY,
    sup_name VARCHAR(20) NOT NULL,
    sup_email VARCHAR(50) NOT NULL, 
    sup_dolp DATE,
    emp_id INTEGER, NOT NULL
    emp_start_date DATE, -- rel attribute 
    FOREIGN KEY (emp_id) REFERENCES Employee(emp_id)
);

CREATE TYPE warehouse_address_type AS ( --composite attribute 
    warehouse_number VARCHAR(20) NOT NULL,
    warehouse_name VARCHAR(50) NOT NULL,
    city_name VARCHAR(50)
);

CREATE TABLE Warehouse ( 
    warehouse_id INTEGER PRIMARY KEY,
    warehouse_address warehouse_address_type
);

CREATE TABLE Product ( 
    prod_id INTEGER PRIMARY KEY,
    prod_name VARCHAR(50) NOT NULL,
    prod_stock INTEGER NOT NULL CHECK (prod_stock >=0), --total stock across all warehouses 
    sup_id INTEGER NOT NULL,
    FOREIGN KEY (sup_id) REFERENCES Supplier(sup_id), 
    warehouse_id INTEGER NOT NULL,
    FOREIGN KEY (warehouse_id) REFERENCES Warehouse(warehouse_id)
);

CREATE TABLE Prod_Ware ( -- Junction table due to N-M Relationship 
    prod_id INTEGER NOT NULL, 
    warehouse_id INTEGER NOT NULL, 
    prod_stock_ware INTEGER NOT NULL CHECK (prod_stock_ware >=0), --product stock across x warehouse; rel attribute
    cost_prod DECIMAL(10,2) NOT NULL CHECK (cost_prod >=0), --rel attribute 
    PRIMARY KEY (prod_id, warehouse_id),
    FOREIGN KEY (prod_id) REFERENCES Product(prod_id),
    FOREIGN KEY (warehouse_id) REFERENCES Warehouse(warehouse_id)
);
