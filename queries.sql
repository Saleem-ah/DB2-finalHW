## -- 1. Most Rented Films

SELECT
f.title,
SUM(fr.rental_count) AS total_rentals
FROM Fact_Rental fr
JOIN Dim_Film f
ON fr.film_key = f.film_key
GROUP BY f.title
ORDER BY total_rentals DESC;

---

## -- 2. Top Customers by Number of Rentals

SELECT
c.full_name,
COUNT(fr.rental_key) AS total_rentals
FROM Fact_Rental fr
JOIN Dim_Customer c
ON fr.customer_key = c.customer_key
GROUP BY c.full_name
ORDER BY total_rentals DESC;

---

## -- 3. Revenue by Store

SELECT
s.store_id,
SUM(fp.payment_amount) AS total_revenue
FROM Fact_Payment fp
JOIN Dim_Staff st
ON fp.staff_key = st.staff_key
JOIN Dim_Store s
ON st.store_id = s.store_id
GROUP BY s.store_id
ORDER BY total_revenue DESC;

---

## -- 4. Monthly Revenue Trend

SELECT
    d.year,
    d.month_number,
    d.month_name,
    SUM(fp.payment_amount) AS total_revenue
FROM Fact_Payment fp
JOIN Dim_Date d
    ON fp.payment_date_key = d.date_key
GROUP BY d.year, d.month_number, d.month_name
ORDER BY d.year, d.month_number ASC;

---

## -- 5. Films Returned Late Most Often

SELECT
f.title,
COUNT(*) AS late_returns
FROM Fact_Rental fr
JOIN Dim_Film f
ON fr.film_key = f.film_key
WHERE fr.late_return_flag = 1
GROUP BY f.title
ORDER BY late_returns DESC;

---

## -- 6. Most Popular Film Categories

SELECT
f.category,
COUNT(fr.rental_key) AS total_rentals
FROM Fact_Rental fr
JOIN Dim_Film f
ON fr.film_key = f.film_key
GROUP BY f.category
ORDER BY total_rentals DESC;
