WITH t1 AS

    (SELECT fa.film_id, f.title, COUNT(r.rental_date) AS count_rental_date
    FROM film f
    JOIN inventory i
    USING(film_id)
    JOIN rental r
    USING(inventory_id)
    JOIN film_actor fa
    USING(film_id)
    GROUP BY 1,2
    ORDER BY 3 DESC
    LIMIT 10),

t2 AS

    (SELECT fa.film_id, a.first_name || ' ' || a.last_name AS actor_name
    FROM actor a
    JOIN film_actor fa
    USING(actor_id)
    GROUP BY 1,2)

SELECT t2.actor_name, COUNT(t1.film_id) AS actors_in_top_ten_rentals
FROM t1
JOIN t2
ON t1.film_id = t2.film_id
GROUP BY 1
ORDER BY 2 DESC;
