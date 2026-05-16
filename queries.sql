USE rental_dw;

-- =====================================
-- Rental Analysis Queries
-- =====================================

-- 1. Which films are rented most frequently?
SELECT
    f.title,
    COUNT(fr.rental_key) AS total_rentals
FROM Fact_Rental fr
JOIN Dim_Film f
    ON fr.film_key = f.film_key
GROUP BY f.title
ORDER BY total_rentals DESC;


-- 2. Which film categories are most popular?
SELECT
    f.category,
    COUNT(fr.rental_key) AS total_rentals
FROM Fact_Rental fr
JOIN Dim_Film f
    ON fr.film_key = f.film_key
GROUP BY f.category
ORDER BY total_rentals DESC;


-- 3. Which rentals were returned late most often?
SELECT
    f.title,
    COUNT(*) AS late_returns,
    SUM(fr.days_overdue) AS total_days_overdue
FROM Fact_Rental fr
JOIN Dim_Film f
    ON fr.film_key = f.film_key
WHERE fr.late_return_flag = 1
GROUP BY f.title
ORDER BY late_returns DESC, total_days_overdue DESC;


-- 4. How does rental activity change over time?
SELECT
    d.year,
    d.month_number,
    d.month_name,
    COUNT(fr.rental_key) AS total_rentals
FROM Fact_Rental fr
JOIN Dim_Date d
    ON fr.rental_date_key = d.date_key
GROUP BY d.year, d.month_number, d.month_name
ORDER BY d.year, d.month_number;


-- 5. Which stores process the highest number of rentals?
SELECT
    s.store_id,
    s.city,
    s.country,
    COUNT(fr.rental_key) AS total_rentals
FROM Fact_Rental fr
JOIN Dim_Store s
    ON fr.store_key = s.store_key
GROUP BY s.store_id, s.city, s.country
ORDER BY total_rentals DESC;


-- =====================================
-- Payment and Revenue Analysis Queries
-- =====================================

-- 6. Which films generate the highest revenue?
SELECT
    f.title,
    SUM(fp.payment_amount) AS total_revenue
FROM Fact_Payment fp
JOIN Dim_Film f
    ON fp.film_key = f.film_key
GROUP BY f.title
ORDER BY total_revenue DESC;


-- 7. Which customers generate the highest revenue?
SELECT
    c.full_name,
    c.email,
    SUM(fp.payment_amount) AS total_revenue
FROM Fact_Payment fp
JOIN Dim_Customer c
    ON fp.customer_key = c.customer_key
GROUP BY c.full_name, c.email
ORDER BY total_revenue DESC;


-- 8. How does revenue change over time?
SELECT
    d.year,
    d.month_number,
    d.month_name,
    SUM(fp.payment_amount) AS total_revenue
FROM Fact_Payment fp
JOIN Dim_Date d
    ON fp.payment_date_key = d.date_key
GROUP BY d.year, d.month_number, d.month_name
ORDER BY d.year, d.month_number;


-- =====================================
-- Inventory Analysis Queries
-- =====================================

-- 9. How many inventory copies are available for each film and store?
SELECT
    f.title,
    s.store_id,
    s.city,
    COUNT(fi.inventory_key) AS total_inventory_copies
FROM Fact_Inventory fi
JOIN Dim_Film f
    ON fi.film_key = f.film_key
JOIN Dim_Store s
    ON fi.store_key = s.store_key
GROUP BY f.title, s.store_id, s.city
ORDER BY total_inventory_copies DESC;


-- =====================================
-- Overall Business Performance Query
-- =====================================

-- 10. Which stores perform best in terms of rentals, inventory, and revenue?
SELECT
    s.store_id,
    s.city,
    s.country,
    COALESCE(r.total_rentals, 0) AS total_rentals,
    COALESCE(i.total_inventory_copies, 0) AS total_inventory_copies,
    COALESCE(p.total_revenue, 0) AS total_revenue
FROM Dim_Store s
LEFT JOIN (
    SELECT store_key, COUNT(*) AS total_rentals
    FROM Fact_Rental
    GROUP BY store_key
) r ON s.store_key = r.store_key
LEFT JOIN (
    SELECT store_key, COUNT(*) AS total_inventory_copies
    FROM Fact_Inventory
    GROUP BY store_key
) i ON s.store_key = i.store_key
LEFT JOIN (
    SELECT store_key, SUM(payment_amount) AS total_revenue
    FROM Fact_Payment
    GROUP BY store_key
) p ON s.store_key = p.store_key
ORDER BY total_revenue DESC;