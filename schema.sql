-- Restaurant Sales Analytics SQL Project
-- This file creates the database tables used in the project.

CREATE TABLE employees (
    employee_id SERIAL PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    role VARCHAR(50) NOT NULL,
    hire_date DATE,
    hourly_rate NUMERIC(5,2) CHECK (hourly_rate >= 0)
);

CREATE TABLE shifts (
    shift_id SERIAL PRIMARY KEY,
    employee_id INT NOT NULL REFERENCES employees(employee_id),
    shift_date DATE NOT NULL,
    shift_type VARCHAR(20) NOT NULL,
    hours_worked NUMERIC(4,2) CHECK (hours_worked > 0),
    tip_amount NUMERIC(8,2) DEFAULT 0 CHECK (tip_amount >= 0)
);

CREATE TABLE menu_items (
    item_id SERIAL PRIMARY KEY,
    item_name VARCHAR(100) NOT NULL,
    category VARCHAR(50) NOT NULL,
    price NUMERIC(6,2) NOT NULL CHECK (price >= 0)
);

CREATE TABLE sales (
    sale_id SERIAL PRIMARY KEY,
    shift_id INT NOT NULL REFERENCES shifts(shift_id),
    item_id INT NOT NULL REFERENCES menu_items(item_id),
    quantity INT NOT NULL CHECK (quantity > 0),
    unit_price NUMERIC(6,2) NOT NULL CHECK (unit_price >= 0),
    sale_amount NUMERIC(8,2) NOT NULL CHECK (sale_amount >= 0)
);