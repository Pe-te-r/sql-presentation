-- INSERT modification

    --single row insert
INSERT INTO users (username,email) VALUES ('peter','peter@duck.com')
    --multi row insert
INSERT INTO users (username,email)
 VALUES
  ('peter','peter@duck.com'),
  ('peter','peter@duck.com')

    --returing the whole inserted row
INSERT INTO users (username,email) VALUES ('peter','peter@duck.com') RETURNING *
    --returing specific column wish to inserted
INSERT INTO users (username,email) VALUES ('phantom','phantom@duck.com') RETURNING user_id,username


---UPDATE modification
    --update one column in a row
UPDATE products
SET price = 54.99  -- New price
WHERE product_id = 3;

    --update whole column
        -- Before: Show original data
SELECT product_id, name, price FROM products;
        -- Update entire price column (add 10% to all products)
UPDATE products
SET price = price * 1.10;
        -- After: Show updated data
SELECT product_id, name, price FROM products;

    --update with join
        -- Update prices with category discounts
UPDATE products p
SET price = price * (1 - c.discount_percent/100),
    last_updated = CURRENT_TIMESTAMP
FROM categories c
WHERE p.category_id = c.category_id
AND c.discount_percent > 0;
    --update row
UPDATE products
SET price = 59.99
WHERE product_id = 5;
    --update  row with return clause
UPDATE products
SET price = 59.99
WHERE product_id = 5
RETURNING *;

--DELETE Modification





