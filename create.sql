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

COMMIT;
