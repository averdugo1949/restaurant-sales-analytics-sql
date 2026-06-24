-- Business analysis queries for the restaurant sales database.
-- Queries include employee sales, menu performance, wine sales, shift revenue, CASE statements, and views.

-- 1. Total sales by employee
SELECT  e.employee_id, 
		e.first_name, 
		e.last_name, 
		e.role,
    SUM(s.sale_amount) AS total_sales
FROM sales s
JOIN shifts sh 
	ON s.shift_id = sh.shift_id 
JOIN employees e
    ON sh.employee_id = e.employee_id
GROUP BY e.employee_id, e.first_name, e.last_name, e.role
ORDER BY total_sales DESC;

-- 2. Total tips by employee
SELECT e.employee_id, 
	   e.first_name, 
	   e.last_name, 
	   e.role,
    SUM(sh.tip_amount) AS total_tips
FROM shifts sh
JOIN employees e
    ON sh.employee_id = e.employee_id
GROUP BY e.employee_id, e.first_name, e.last_name, e.role
ORDER BY total_tips DESC;


-- 3. Best-selling menu items by quantity
SELECT
    m.item_id,
    m.item_name,
    m.category,
    SUM(s.quantity) AS total_quantity_sold,
    SUM(s.sale_amount) AS total_revenue
FROM sales s
JOIN menu_items m
    ON s.item_id = m.item_id
GROUP BY m.item_id, m.item_name, m.category
ORDER BY total_quantity_sold DESC;


-- 4. Revenue by menu category
SELECT
    m.category,
    SUM(s.quantity) AS total_items_sold,
    SUM(s.sale_amount) AS total_revenue
FROM sales s
JOIN menu_items m
    ON s.item_id = m.item_id
GROUP BY m.category
ORDER BY total_revenue DESC;


-- 5. Wine sales by employee
SELECT
    e.employee_id,
    e.first_name,
    e.last_name,
    e.role,
    SUM(s.quantity) AS wine_items_sold,
    SUM(s.sale_amount) AS wine_revenue
FROM sales s
JOIN shifts sh
    ON s.shift_id = sh.shift_id
JOIN employees e
    ON sh.employee_id = e.employee_id
JOIN menu_items m
    ON s.item_id = m.item_id
WHERE m.category = 'Wine'
GROUP BY e.employee_id, e.first_name, e.last_name, e.role
ORDER BY wine_revenue DESC;



-- 6. Revenue by shift type
SELECT
    sh.shift_type,
    COUNT(DISTINCT sh.shift_id) AS number_of_shifts,
    SUM(s.sale_amount) AS total_revenue,
    ROUND(SUM(s.sale_amount) / COUNT(DISTINCT sh.shift_id), 2) AS avg_revenue_per_shift
FROM sales s
JOIN shifts sh
    ON s.shift_id = sh.shift_id
GROUP BY sh.shift_type
ORDER BY total_revenue DESC;



-- 7. Revenue by weekday
SELECT
    EXTRACT(ISODOW FROM sh.shift_date) AS weekday_number,
    TO_CHAR(sh.shift_date, 'Day') AS weekday_name,
    SUM(s.sale_amount) AS total_revenue
FROM sales s
JOIN shifts sh
    ON s.shift_id = sh.shift_id
GROUP BY weekday_number, weekday_name
ORDER BY weekday_number;


-- 8. Employee sales performance tiers using CASE
WITH employee_sales AS (
    SELECT
        e.employee_id,
        e.first_name,
        e.last_name,
        e.role,
        SUM(s.sale_amount) AS total_sales
    FROM sales s
    JOIN shifts sh
        ON s.shift_id = sh.shift_id
    JOIN employees e
        ON sh.employee_id = e.employee_id
    WHERE e.role IN ('Server', 'Bartender')
    GROUP BY
        e.employee_id,
        e.first_name,
        e.last_name,
        e.role
),
ranked_sales AS (
    SELECT
        *,
        NTILE(3) OVER (ORDER BY total_sales DESC) AS sales_group
    FROM employee_sales
)
SELECT
    employee_id,
    first_name,
    last_name,
    role,
    total_sales,
    CASE
        WHEN sales_group = 1 THEN 'High Performer'
        WHEN sales_group = 2 THEN 'Solid Performer'
        ELSE 'Needs Review'
    END AS sales_tier
FROM ranked_sales
ORDER BY total_sales DESC;

-- 9. Menu item price tiers using CASE
SELECT
    item_id,
    item_name,
    category,
    price,
    CASE
        WHEN price >= 25 THEN 'Premium'
        WHEN price >= 12 THEN 'Standard'
        ELSE 'Low Cost'
    END AS price_tier
FROM menu_items
ORDER BY price DESC;

-- 10. Revenue per hour by employee 
    e.employee_id,
    e.first_name,
    e.last_name,
    e.role,
    SUM(s.sale_amount) AS total_sales,
    SUM(sh.hours_worked) AS total_hours_worked,
    ROUND(SUM(s.sale_amount) / NULLIF(SUM(sh.hours_worked), 0), 2) AS revenue_per_hour
FROM sales s
JOIN shifts sh
    ON s.shift_id = sh.shift_id
JOIN employees e
    ON sh.employee_id = e.employee_id
GROUP BY e.employee_id, e.first_name, e.last_name, e.role
ORDER BY revenue_per_hour DESC;










