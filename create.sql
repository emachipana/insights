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

DROP TABLE IF EXISTS dishes;
CREATE TABLE dishes (
    id SERIAL PRIMARY KEY,
    name VARCHAR NOT NULL
);

DROP TABLE IF EXISTS restaurant_dishes;
CREATE TABLE restaurant_dishes (
    id SERIAL PRIMARY KEY,
    restaurant_id INT NOT NULL REFERENCES restaurants(id),
    dish_id INT NOT NULL REFERENCES dishes(id),
    price INT NOT NULL CHECK (price >= 0)
);
COMMIT;


DROP TABLE IF EXISTS clients_restaurant;
CREATE TABLE clients_restaurant (
    id SERIAL PRIMARY KEY,
    client_id INT NOT NULL REFERENCES clients(id),
    restaurant_dishes_id INT NOT NULL REFERENCES restaurant_dishes(id),
    visit_date DATE NOT NULL
);

