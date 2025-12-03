CREATE TABLE accounts (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    balance DECIMAL(10,2) DEFAULT 0.00
);

CREATE TABLE products (
    id SERIAL PRIMARY KEY,
    shop VARCHAR(100) NOT NULL,
    product VARCHAR(100) NOT NULL,
    price DECIMAL(10,2) NOT NULL
);

INSERT INTO accounts (name, balance) VALUES
  ('Alice', 1000.00),
  ('Bob', 500.00),
  ('Wally', 750.00);

INSERT INTO products (shop, product, price) VALUES
  ('Joe''s Shop', 'Coke', 2.50),
  ('Joe''s Shop', 'Pepsi', 3.00),
  ('Joe''s Shop', 'Fanta', 3.50);


BEGIN;
UPDATE accounts SET balance = balance - 100 WHERE name='Alice';
UPDATE accounts SET balance = balance + 100 WHERE name='Bob';
COMMIT;

-- Result: Alice=900, Bob=600


BEGIN;
UPDATE accounts SET balance = balance - 500 WHERE name='Alice';
ROLLBACK;

-- Alice returns to 1000

BEGIN;
UPDATE accounts SET balance = balance - 100 WHERE name='Alice';
SAVEPOINT s1;
UPDATE accounts SET balance = balance + 100 WHERE name='Bob';
ROLLBACK TO s1;
UPDATE accounts SET balance = balance + 100 WHERE name='Wally';
COMMIT;

-- Alice=900, Bob unchanged, Wally=850


BEGIN TRANSACTION ISOLATION LEVEL READ COMMITTED;
SELECT * FROM products WHERE shop='Joe''s Shop';
SELECT * FROM products WHERE shop='Joe''s Shop';
COMMIT;

-- SERIALIZABLE would enforce stricter consistency


BEGIN TRANSACTION ISOLATION LEVEL REPEATABLE READ;
SELECT MAX(price), MIN(price) FROM products WHERE shop='Joe''s Shop';
SELECT MAX(price), MIN(price) FROM products WHERE shop='Joe''s Shop';
COMMIT;


BEGIN TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
SELECT * FROM products WHERE shop='Joe''s Shop';
SELECT * FROM products WHERE shop='Joe''s Shop';
SELECT * FROM products WHERE shop='Joe''s Shop';
COMMIT;



BEGIN;
UPDATE accounts SET balance = balance - 200
 WHERE name='Bob' AND balance >= 200;
UPDATE accounts SET balance = balance + 200 WHERE name='Wally';
COMMIT;



BEGIN;
INSERT INTO products (shop, product, price) VALUES ('X','Y',1.00);
SAVEPOINT sp1;
UPDATE products SET price = 2.00 WHERE product='Y';
SAVEPOINT sp2;
DELETE FROM products WHERE product='Y';
ROLLBACK TO sp1;
COMMIT;

BEGIN;
SELECT balance FROM accounts WHERE name='Alice' FOR UPDATE;
UPDATE accounts SET balance = balance - 100 WHERE name='Alice';
COMMIT;

BEGIN;
SELECT balance FROM accounts WHERE name='Alice' FOR UPDATE;
UPDATE accounts SET balance = balance - 100 WHERE name='Alice';
COMMIT;


SELECT MAX(price) FROM products;
SELECT MIN(price) FROM products;

BEGIN TRANSACTION ISOLATION LEVEL REPEATABLE READ;
SELECT MAX(price) FROM products;
SELECT MIN(price) FROM products;
COMMIT;
