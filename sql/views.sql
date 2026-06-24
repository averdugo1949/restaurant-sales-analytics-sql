




-- Create a reusable employee performance summary view
CREATE OR REPLACE VIEW employee_performance_summary AS
WITH sales_by_employee AS (
    SELECT
        e.employee_id,
        SUM(s.sale_amount) AS total_sales,
        SUM(s.quantity) AS total_items_sold,
        COUNT(s.sale_id) AS sales_records
    FROM employees e
    JOIN shifts sh
        ON e.employee_id = sh.employee_id
    JOIN sales s
        ON sh.shift_id = s.shift_id
    GROUP BY e.employee_id
),
tips_by_employee AS (
    SELECT
        e.employee_id,
        SUM(sh.tip_amount) AS total_tips,
        SUM(sh.hours_worked) AS total_hours_worked,
        COUNT(sh.shift_id) AS total_shifts
    FROM employees e
    JOIN shifts sh
        ON e.employee_id = sh.employee_id
    GROUP BY e.employee_id
)
SELECT
    e.employee_id,
    e.first_name,
    e.last_name,
    e.role,
    COALESCE(sbe.total_sales, 0) AS total_sales,
    COALESCE(sbe.total_items_sold, 0) AS total_items_sold,
    COALESCE(sbe.sales_records, 0) AS sales_records,
    COALESCE(tbe.total_tips, 0) AS total_tips,
    COALESCE(tbe.total_hours_worked, 0) AS total_hours_worked,
    COALESCE(tbe.total_shifts, 0) AS total_shifts
FROM employees e
LEFT JOIN sales_by_employee sbe
    ON e.employee_id = sbe.employee_id
LEFT JOIN tips_by_employee tbe
    ON e.employee_id = tbe.employee_id;



-- Query employee performance summary view
SELECT
    first_name,
    last_name,
    role,
    total_sales,
    total_tips,
    total_hours_worked,
    ROUND(total_sales / NULLIF(total_hours_worked, 0), 2) AS revenue_per_hour
FROM employee_performance_summary
ORDER BY total_sales DESC;



-- Create a reusable menu sales summary view
CREATE OR REPLACE VIEW menu_sales_summary AS
SELECT
    m.item_id,
    m.item_name,
    m.category,
    m.price,
    SUM(s.quantity) AS total_quantity_sold,
    SUM(s.sale_amount) AS total_revenue
FROM menu_items m
LEFT JOIN sales s
    ON m.item_id = s.item_id
GROUP BY
    m.item_id,
    m.item_name,
    m.category,
    m.price;

-- Query menu sales summary view
SELECT *
FROM menu_sales_summary
ORDER BY total_revenue DESC;
