WITH t1 AS

    (SELECT i.inventory_id, f.title, DATE_PART('day', r.return_date - r.rental_date) AS days_returned_after_rental, f.rental_duration
    FROM rental r
    JOIN inventory i
    USING(inventory_id)
    JOIN film f
    USING(film_id)
    GROUP BY 2,1,3,4
    ORDER BY 2),
        
t2 AS

        (SELECT t1.title as film_title, COUNT(t1.inventory_id) count_returned_late
        FROM t1
        WHERE t1.days_returned_after_rental > t1.rental_duration
        GROUP BY 1
        ORDER BY 2 DESC)

SELECT t2.film_title, t2.count_returned_late, SUM(t2.count_returned_late) OVER (ORDER BY t2.count_returned_late) AS running_total_returned_late
FROM t2
GROUP BY 1,2
ORDER BY 2 DESC
LIMIT 10;
