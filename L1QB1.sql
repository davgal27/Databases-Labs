CREATE TABLE Supplier (
	sup_id INTEGER PRIMARY KEY,
	sup_name VARCHAR(20) NOT NULL,
	sup_email VARCHAR(50) NOT NULL, 
	sup_dolp DATE 
);

CREATE TABLE Product ( 
	prod_id INTEGER PRIMARY KEY,
	prod_name VARCHAR(50) NOT NULL,
	prod_stock INTEGER NOT NULL CHECK (prod_stock >=0),
	sup_id INTEGER, 
	FOREIGN KEY (sup_id) REFERENCES Supplier(sup_id) 
);
