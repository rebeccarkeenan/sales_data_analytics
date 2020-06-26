WITH t1 AS

    (SELECT co.country, SUM(f.rental_rate) AS country_highest_spend
    FROM address ads
    JOIN customer cu
    USING(address_id)
    JOIN rental r 
    USING(customer_id)
    JOIN inventory i 
    USING(inventory_id)
    JOIN film f 
    USING(film_id)
    JOIN city ci
    USING(city_id)
    JOIN country co
    USING(country_id)
    GROUP BY 1
    ORDER BY 2 DESC
    LIMIT 1),

t2 AS

    (SELECT co.country, cat.name category_name, SUM(f.rental_rate) AS sum_rentalrate, COUNT(r.rental_date) AS count_rentdate
    FROM country co
    JOIN city ci
    USING(country_id)
    JOIN address ads
    USING(city_id)
    JOIN customer cu
    USING(address_id)
    JOIN payment p
    USING(customer_id)
    JOIN rental r
    USING(rental_id)
    JOIN inventory i
    USING(inventory_id)
    JOIN film f
    USING(film_id)
    JOIN film_category fc
    USING(film_id)
    JOIN category cat
    USING(category_id)
    GROUP BY 1,2
    ORDER BY 3 DESC
    LIMIT 6)

SELECT t1.country, t2.category_name, t2.sum_rentalrate AS rev_per_genre, ROUND((t2.sum_rentalrate / t2.count_rentdate),2) AS avg_genre_rentalrate, t2.count_rentdate AS count_rentals_by_genre
FROM t1
JOIN t2
ON t1.country = t2.country
GROUP BY 2,1,3,5
ORDER BY 3 DESC;
