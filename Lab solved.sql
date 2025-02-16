-- 1 Determine the number of copies of the film "Hunchback Impossible" that exist in the inventory system.
SELECT f.title as films, COUNT(i.inventory_id) as inventory from film as f
JOIN inventory as i
ON f.film_id=i.film_id
GROUP BY films
HAVING title LIKE "%Hunchback Impossible%"; 
-- 2List all films whose length is longer than the average length of all the films in the Sakila database.
SELECT * FROM film
WHERE length > (SELECT AVG(length) FROM film);
-- 3 Use a subquery to display all actors who appear in the film "Alone Trip".

SELECT a.first_name AS first_name, 
       a.last_name AS last_name, 
       f.title 
FROM actor AS a
JOIN film_actor AS fa ON a.actor_id = fa.actor_id
JOIN film AS f ON fa.film_id = f.film_id
WHERE f.film_id IN (
    SELECT film_id 
    FROM film 
    WHERE title LIKE '%Alone Trip'
);

-- Bonus:

-- 4 Sales have been lagging among young families, and you want to target family movies for a promotion. Identify all movies categorized as family films.
SELECT f.title AS film, 
       c.name as category
FROM film as f
JOIN film_category AS fc ON f.film_id = fc.film_id
JOIN category AS c ON fc.category_id = c.category_id
WHERE c.category_id IN (
    SELECT category_id 
    FROM category 
    WHERE name LIKE '%Family%'
);
-- 5 Retrieve the name and email of customers from Canada using both subqueries and joins. To use joins, you will need to identify the relevant tables and their primary and foreign keys.
SELECT cu.first_name as customer_name, cu.email as customer_email, co.country as customer_country FROM customer as cu
JOIN address as a
ON cu.address_id = a.address_id
JOIN city as ci
ON a.city_id = ci.city_id
JOIN country as co
ON ci.country_id=co.country_id
WHERE co.country in(
SELECT country 
FROM country 
WHERE country like "%Canada%");

-- 6 Determine which films were starred by the most prolific actor in the Sakila database. A prolific actor is defined as the actor who has acted in the most number of films. First, you will need to find the most prolific actor and then use that actor_id to find the different films that he or she starred in.
SELECT fa.actor_id as actor_id, f.film_id as Film_ID, f.title as Film FROM film as f
JOIN film_actor as fa
ON f.film_id=fa.film_id
WHERE actor_id in (
SELECT actor_id  as films FROM film_actor
GROUP BY COUNT(film_id)
ORDER BY films DESC
LIMIT 1);

-- 7 Find the films rented by the most profitable customer in the Sakila database. You can use the customer and payment tables to find the most profitable customer, i.e., the customer who has made the largest sum of payments.
SELECT f.title AS 'Film Title'
FROM film AS f
JOIN inventory AS i ON f.film_id = i.film_id
JOIN rental AS r ON i.inventory_id = r.inventory_id
JOIN payment AS p ON r.rental_id = p.rental_id
WHERE r.customer_id = (
    SELECT customer_id
    FROM payment
    GROUP BY customer_id
    ORDER BY SUM(amount) DESC
    LIMIT 1
);
-- 8 Retrieve the client_id and the total_amount_spent of those clients who spent more than the average of the total_amount spent by each client. You can use subqueries to accomplish this.
SELECT customer_id, total_amount_spent
FROM (
    SELECT c.customer_id, SUM(p.amount) AS total_amount_spent
    FROM customer AS c
    JOIN payment AS p ON c.customer_id = p.customer_id
    GROUP BY c.customer_id
) AS customer_totals
WHERE total_amount_spent > (
    SELECT AVG(total_amount_spent)
    FROM (
        SELECT SUM(p.amount) AS total_amount_spent
        FROM customer AS c
        JOIN payment AS p ON c.customer_id = p.customer_id
        GROUP BY c.customer_id
    ) AS avg_totals
);