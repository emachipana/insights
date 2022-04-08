BEGIN;

DROP TABLE IF EXISTS visit_date;
CREATE TABLE visit_date (
    id SERIAL PRIMARY KEY,
    date DATE NOT NULL
);

DROP TABLE IF EXISTS restaurants;
CREATE TABLE restaurants (
    id SERIAL PRIMARY KEY,
    name VARCHAR NOT NULL,
    category VARCHAR NOT NULL,
    adress VARCHAR NOT NULL
);

DROP TABLE IF EXISTS dishes;
CREATE TABLE dishes (
    id SERIAL PRIMARY KEY,
    name VARCHAR NOT NULL,
    price INT NOT NULL CHECK (price >= 0)
);

DROP TABLE IF EXISTS clients;
CREATE TABLE clients (
    id SERIAL PRIMARY KEY,
    name VARCHAR NOT NULL,
    age INT NOT NULL CHECK (age > 0),
    gender VARCHAR NOT NULL,
    occupation VARCHAR NOT NULL,
    nationality VARCHAR NOT NULL,
    v_date_id INT REFERENCES visit_date(id)
);

DROP TABLE IF EXISTS clients_restaurant;
CREATE TABLE clients_restaurant (
    id SERIAL PRIMARY KEY,
    client_id INT REFERENCES clients(id),
    restaurant_id INT REFERENCES restaurants(id)
);

DROP TABLE IF EXISTS restaurant_dishes;
CREATE TABLE restaurant_dishes (
    id SERIAL PRIMARY KEY,
    restaurant_id INT REFERENCES restaurants(id),
    dish_id INT REFERENCES dishes(id)
);

COMMIT;
