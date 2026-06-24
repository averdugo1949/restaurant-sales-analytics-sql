-- Row count checks
SELECT COUNT(*) AS employee_count FROM employees;
SELECT COUNT(*) AS menu_item_count FROM menu_items;
SELECT COUNT(*) AS shift_count FROM shifts;
SELECT COUNT(*) AS sales_count FROM sales;

-- Check for shifts without matching employees
SELECT sh.*
FROM shifts sh
LEFT JOIN employees e
    ON sh.employee_id = e.employee_id
WHERE e.employee_id IS NULL;

-- Check for sales without matching shifts
SELECT s.*
FROM sales s
LEFT JOIN shifts sh
    ON s.shift_id = sh.shift_id
WHERE sh.shift_id IS NULL;

-- Check for sales without matching menu items
SELECT s.*
FROM sales s
LEFT JOIN menu_items m
    ON s.item_id = m.item_id
WHERE m.item_id IS NULL;

-- Check sale amount calculation
SELECT
    sale_id,
    quantity,
    unit_price,
    sale_amount,
    quantity * unit_price AS expected_sale_amount
FROM sales
WHERE sale_amount <> quantity * unit_price;

-- Check sales unit price against menu item price
SELECT
    s.sale_id,
    s.item_id,
    m.item_name,
    s.unit_price,
    m.price
FROM sales s
JOIN menu_items m
    ON s.item_id = m.item_id
WHERE s.unit_price <> m.price;

-- Reset SERIAL sequences after importing CSV files with manually assigned IDs
SELECT setval('employees_employee_id_seq', (SELECT MAX(employee_id) FROM employees));
SELECT setval('menu_items_item_id_seq', (SELECT MAX(item_id) FROM menu_items));
SELECT setval('shifts_shift_id_seq', (SELECT MAX(shift_id) FROM shifts));
SELECT setval('sales_sale_id_seq', (SELECT MAX(sale_id) FROM sales));
