-- 1. Which films are rented most frequently?
SELECT
    f.title,
    COUNT(fr.rental_key) AS total_rentals
FROM Fact_Rental fr
JOIN Dim_Film f
    ON fr.film_key = f.film_key
GROUP BY f.title
ORDER BY total_rentals DESC;


-- 2. Which film categories are most popular among customers?
SELECT
    f.category,
    COUNT(fr.rental_key) AS total_rentals
FROM Fact_Rental fr
JOIN Dim_Film f
    ON fr.film_key = f.film_key
GROUP BY f.category
ORDER BY total_rentals DESC;


-- 3. Which films are returned late most often?
SELECT
    f.title,
    COUNT(fr.rental_key) AS late_return_count,
    SUM(fr.days_overdue) AS total_days_overdue
FROM Fact_Rental fr
JOIN Dim_Film f
    ON fr.film_key = f.film_key
WHERE fr.late_return_flag = 1
GROUP BY f.title
ORDER BY late_return_count DESC, total_days_overdue DESC;


-- 4. Which films generate the highest total revenue?
SELECT
    f.title,
    SUM(fp.payment_amount) AS total_revenue
FROM Fact_Payment fp
JOIN Dim_Film f
    ON fp.film_key = f.film_key
GROUP BY f.title
ORDER BY total_revenue DESC;


-- 5. Which customers rent the most films overall?
SELECT
    c.full_name,
    c.email,
    COUNT(fr.rental_key) AS total_rentals
FROM Fact_Rental fr
JOIN Dim_Customer c
    ON fr.customer_key = c.customer_key
GROUP BY c.full_name, c.email
ORDER BY total_rentals DESC;


-- 6. Which customers generate the highest total revenue?
SELECT
    c.full_name,
    c.email,
    SUM(fp.payment_amount) AS total_revenue
FROM Fact_Payment fp
JOIN Dim_Customer c
    ON fp.customer_key = c.customer_key
GROUP BY c.full_name, c.email
ORDER BY total_revenue DESC;


-- 7. What are the most active customer locations (cities and countries)?
SELECT
    c.city,
    c.country,
    COUNT(fr.rental_key) AS total_rentals
FROM Fact_Rental fr
JOIN Dim_Customer c
    ON fr.customer_key = c.customer_key
GROUP BY c.city, c.country
ORDER BY total_rentals DESC;


-- 8. Which stores generate the highest number of rentals?
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


-- 9. Which stores generate the highest revenue?
SELECT
    s.store_id,
    s.city,
    s.country,
    SUM(fp.payment_amount) AS total_revenue
FROM Fact_Payment fp
JOIN Dim_Store s
    ON fp.store_key = s.store_key
GROUP BY s.store_id, s.city, s.country
ORDER BY total_revenue DESC;


-- 10. Which staff members process the most rentals or payments?
SELECT
    st.full_name,
    COUNT(DISTINCT fr.rental_key) AS total_rentals,
    COUNT(DISTINCT fp.payment_key) AS total_payments
FROM Dim_Staff st
LEFT JOIN Fact_Rental fr
    ON st.staff_key = fr.staff_key
LEFT JOIN Fact_Payment fp
    ON st.staff_key = fp.staff_key
GROUP BY st.full_name
ORDER BY total_rentals DESC, total_payments DESC;


-- 11. How does total revenue change by month, quarter, or year?
SELECT
    d.year,
    d.quarter,
    d.month_number,
    d.month_name,
    SUM(fp.payment_amount) AS total_revenue
FROM Fact_Payment fp
JOIN Dim_Date d
    ON fp.payment_date_key = d.date_key
GROUP BY d.year, d.quarter, d.month_number, d.month_name
ORDER BY d.year, d.month_number;


-- 12. Which time periods see the highest rental activity?
SELECT
    d.year,
    d.quarter,
    d.month_number,
    d.month_name,
    COUNT(fr.rental_key) AS total_rentals
FROM Fact_Rental fr
JOIN Dim_Date d
    ON fr.rental_date_key = d.date_key
GROUP BY d.year, d.quarter, d.month_number, d.month_name
ORDER BY total_rentals DESC;