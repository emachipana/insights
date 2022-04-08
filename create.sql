BEGIN;

DROP TABLE IF EXISTS clients;
CREATE TABLE clients (
    id SERIAL PRIMARY KEY,
    name VARCHAR NOT NULL,
    age INT NOT NULL CHECK (age >= 0),
    genre VARCHAR NOT NULL,
    occupation VARCHAR NOT NULL,
    nationality VARCHAR NOT NULL
);

DROP TABLE IF EXISTS restaurants;
CREATE TABLE restaurants (
    id SERIAL PRIMARY KEY,
    name VARCHAR NOT NULL,
    category VARCHAR NOT NULL,
    adress VARCHAR NOT NULL,
    city VARCHAR NOT NULL
);

COMMIT;
