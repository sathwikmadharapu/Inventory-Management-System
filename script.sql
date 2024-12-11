-- Create and use the database
CREATE DATABASE inventory_db;
USE inventory_db;

-- Create items table
CREATE TABLE items (
    item_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    quantity INT NOT NULL,
    reorder_level INT DEFAULT 10,
    last_updated TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- Create sales table
CREATE TABLE sales (
    sale_id INT PRIMARY KEY AUTO_INCREMENT,
    item_id INT,
    sale_date DATE NOT NULL,
    quantity_sold INT NOT NULL,
    FOREIGN KEY (item_id) REFERENCES items(item_id)
);

-- Create suppliers table
CREATE TABLE suppliers (
    supplier_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100),
    contact_info VARCHAR(255)
);

-- Create orders table
CREATE TABLE orders (
    order_id INT PRIMARY KEY AUTO_INCREMENT,
    item_id INT,
    supplier_id INT,
    order_date DATE,
    quantity_ordered INT,
    status ENUM('Pending', 'Received') DEFAULT 'Pending',
    FOREIGN KEY (item_id) REFERENCES items(item_id),
    FOREIGN KEY (supplier_id) REFERENCES suppliers(supplier_id)
);

-- Insert a sample item
INSERT INTO items (name, quantity, reorder_level) VALUES ('Item A', 50, 5);

-- Update item quantity
UPDATE items SET quantity = quantity - 10 WHERE item_id = 1;

-- Delete an item
DELETE FROM items WHERE item_id = 2;

-- Select all items
SELECT * FROM items;

-- Create trigger to check reorder level
DELIMITER //

CREATE TRIGGER check_reorder_level
AFTER UPDATE ON items
FOR EACH ROW
BEGIN
    IF NEW.quantity <= NEW.reorder_level THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Stock is below reorder level!';
    END IF;
END;
//

DELIMITER ;

-- Drop the procedure if it already exists
DROP PROCEDURE IF EXISTS forecast_demand;

-- Create stored procedure for demand forecasting
DELIMITER //

CREATE PROCEDURE forecast_demand(IN num_days INT)
BEGIN
    SELECT 
        i.item_id, 
        i.name, 
        SUM(s.quantity_sold) / num_days AS avg_daily_demand
    FROM 
        sales s
    JOIN 
        items i ON s.item_id = i.item_id
    WHERE 
        s.sale_date >= CURDATE() - INTERVAL num_days DAY
    GROUP BY 
        i.item_id, i.name;
END;
//

DELIMITER ;

-- Call the stored procedure
CALL forecast_demand(30);
