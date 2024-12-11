# Inventory Management System

## Overview
This Inventory Management System is a database-driven solution for efficiently managing inventory, tracking sales, and handling supplier orders in a store or warehouse. The system is designed to support CRUD operations and includes features like automated restocking alerts and demand forecasting.

## Features

- **Inventory Management**: Add, update, and delete items with real-time quantity tracking.
- **Sales Tracking**: Record and analyze item sales data.
- **Supplier Management**: Maintain supplier details and manage orders with statuses.
- **Automated Restocking Alerts**: SQL triggers notify when stock falls below the reorder level.
- **Demand Forecasting**: Stored procedures calculate average daily demand based on recent sales data.

## Technology Used

- **MySQL** for database management
- **SQL Queries, Triggers, and Stored Procedures** for data operations
- **Relational tables** ensuring data integrity

## Database Structure

### Tables:
- **items**: Stores item details and inventory levels.
- **sales**: Tracks sales records linked to items.
- **suppliers**: Maintains supplier information.
- **orders**: Handles supplier orders and their statuses.

### Triggers:
- **check_reorder_level**: Ensures stock levels are monitored automatically.

### Stored Procedures:
- **forecast_demand**: Computes average daily demand for items over a specified period.

## Setup Instructions

1. Execute the SQL script provided to set up the database and tables.
2. Populate initial data using the `INSERT` statements or manually through a database client.
3. Use the triggers and procedures to automate inventory checks and analyze sales data.

## Usage Instructions

- Query the `items` table to check inventory status.
- Use the `sales` table to record and review sales data.
- Manage suppliers and orders using the `suppliers` and `orders` tables.
- Forecast demand using the `CALL forecast_demand(<num_days>)` command.

## Example Commands

### Insert a new item:
```sql
INSERT INTO items (name, quantity, reorder_level) VALUES ('New Item', 100, 15);
```

### Update item quantity after a sale:
```sql
UPDATE items SET quantity = quantity - 10 WHERE item_id = 1;
```

### Forecast demand for the last 30 days:
```sql
CALL forecast_demand(30);
