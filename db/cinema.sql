DROP TABLE IF EXISTS tickets;
DROP TABLE IF EXISTS screenings;
DROP TABLE IF EXISTS users;
DROP TABLE IF EXISTS films;

CREATE TABLE users (
    id SERIAL PRIMARY KEY
    name VARCHAR (255)
    funds INT
);

CREATE TABLE films (
    id SERIAL PRIMARY KEY
    title VARCHAR(255)
    price INT
);

CREATE TABLE tickets (
    id SERIAL PRIMARY KEY
    user_id INT REFERENCES users(id)
    screening_id INT REFERENCES screenings(id)
);

CREATE TABLE screenings (
    id SERIAL PRIMARY KEY
    film_id INT REFERENCES films(id)
    time INT
    capacity INT
);