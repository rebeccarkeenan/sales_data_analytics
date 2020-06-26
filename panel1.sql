SELECT sub2.customerid, sub2.rentals_per_week, sub2.email
FROM
    (SELECT sub.r2_customer_id AS customerid, COUNT(sub.r2_rental_id) / 52 AS rentals_per_week, cu.email
    FROM
        (SELECT r1.rental_id AS r1_rental_id,
                r1.customer_id AS r1_customer_id,
                CAST(r1.rental_date AS date) AS r1_rental_date,
                r2.rental_id AS r2_rental_id,
                r2.customer_id AS r2_customer_id,
                CAST(r2.rental_date AS date) AS r2_rental_date
        FROM rental r1
        LEFT JOIN rental r2
        ON r1.customer_id = r2.customer_id
        AND r1.rental_date < r2.rental_date
        AND r2.rental_date <= r1.rental_date + INTERVAL '7 days'
        ORDER BY r1.customer_id, r1.rental_date) sub
    JOIN customer cu
    ON cu.customer_id = sub.r2_customer_id
    WHERE (sub.r1_rental_date BETWEEN '2005-01-01' AND '2005-12-31')
    GROUP BY 1,3
    ORDER BY 2 DESC) sub2
WHERE sub2.rentals_per_week >= 2
GROUP BY 1,2,3
ORDER BY 2 DESC;
