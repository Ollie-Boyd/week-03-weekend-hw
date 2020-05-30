DROP TABLE IF EXISTS tickets;
DROP TABLE IF EXISTS screenings;
DROP TABLE IF EXISTS users;
DROP TABLE IF EXISTS films;

CREATE TABLE users (
    id SERIAL PRIMARY KEY,
    name VARCHAR (255),
    funds INT
);

CREATE TABLE films (
    id SERIAL PRIMARY KEY,
    title VARCHAR(255),
    price INT
);

CREATE TABLE screenings (
    id SERIAL PRIMARY KEY,
    film_id INT REFERENCES films(id) ON DELETE CASCADE,
    time INT,
    capacity INT
);

CREATE TABLE tickets (
    id SERIAL PRIMARY KEY,
    user_id INT REFERENCES users(id) ON DELETE CASCADE,
    screening_id INT REFERENCES screenings(id) ON DELETE CASCADE
);


--Film
    --.users
    -- SELECT users.* FROM users
    -- INNER JOIN tickets ON tickets.user_id = users.id
    -- INNER JOIN screenings ON screenings.id = tickets.screening_id
    -- WHERE screenings.film_id = $1;

    --.tickets
    -- SELECT tickets.* FROM tickets
    -- INNER JOIN screenings ON tickets.screening_id = screenings.id
    -- WHERE screenings.film_id = $1;

    --.screenings
    -- SELECT screenings.* FROM screenings
    -- WHERE screenings.film_id = $1;

--Screenings
    --.users
        -- SELECT users.* FROM users
        -- INNER JOIN tickets ON tickets.user_id = users.id
        -- WHERE tickets.screening_id = $1;
    
    --.tickets 
        --SELECT tickets.* FROM tickets
        --WHERE tickets.screening_id = $1;

    --.film
        --SELECT films.* FROM films WHERE films.id = $1;

--Ticket
    --user
        -- SELECT users.* FROM users
        -- WHERE users.id = $1 ***@user_id***;

    --screening
        --SELECT screenings.* FROM screenings
        -- WHERE screenings.id = $1 ***@screening_id***;

    --film
        -- SELECT films.* FROM films
        -- INNER JOIN screenings ON screenings.film_id = films.id
        -- WHERE screenings.id = $1 ***@screening_id***;

--User

    --tickets
        -- SELECT tickets.* FROM tickets
        -- WHERE tickets.user_id = $1 ***@id***;

    --screenings
        -- SELECT screenings.* FROM screenings
        -- INNER JOIN tickets ON tickets.screening_id = screenings.id
        -- WHERE tickets.user_id = $1 ***@id***;

    --films
        -- SELECT DISTINCT films.* FROM films
        -- INNER JOIN screenings ON screenings.film_id = films.id
        -- INNER JOIN tickets ON tickets.screening_id = screenings.id
        -- WHERE tickets.user_id = $1 ***@user_id***;






