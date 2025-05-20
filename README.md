# Modification

Under this topic there four different types of statements which are **insert**, **update**, **delete** and **upsert**

For you to follow along you need to create this tables in your database.

```sql
--users tables
CREATE TABLE users (
    user_id SERIAL PRIMARY KEY,
    username VARCHAR(50) NOT NULL,
    active BOOLEAN DEFAULT TRUE,
    email VARCHAR(100) UNIQUE NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
--categories table
CREATE TABLE categories (
    category_id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    discount_percent DECIMAL(5, 2) DEFAULT 0.00
);
--orders table
CREATE TABLE orders (
    order_id SERIAL PRIMARY KEY,
    user_id INT REFERENCES users(user_id) ON DELETE CASCADE,
    order_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    status VARCHAR(20) DEFAULT 'pending'
);
--orders_item tables
CREATE TABLE order_items (
    item_id SERIAL PRIMARY KEY,
    order_id INT REFERENCES orders(order_id) ON DELETE CASCADE,
    product_name VARCHAR(100) NOT NULL,
    category_id INT REFERENCES categories(category_id),
    quantity INT NOT NULL CHECK (quantity > 0),
    price DECIMAL(10,2) NOT NULL
);
```

Insert basic dummy data for working with

```sql
-- INSERT USERS
INSERT INTO users (username, email, active) VALUES
    ('shakirah', 'shakirah@duck.com', False),
    ('alex', 'alex@gmail.com', True),
    ('jane', 'jane@gmail.com', True),
    ('phantom', 'phantom8526@duck.com', True),
    ('kevin', 'kevin@duck.com', False);

-- INSERT CATEGORIES
INSERT INTO categories (name, discount_percent) VALUES
    ('Electronics', 10.00),
    ('Books', 5.00),
    ('Furniture', 0.00);

-- INSERT ORDERS
INSERT INTO orders (user_id, status) VALUES
    (1, 'pending'),
    (2, 'shipped'),
    (3, 'pending'),
    (5, 'pending'); -- make sure one of the users has active False

-- INSERT ORDER ITEMS
INSERT INTO order_items (order_id, product_name, category_id, quantity, price) VALUES
    (1, 'Bluetooth Speaker', 1, 2, 50.00),
    (1, 'Sci-Fi Novel', 2, 1, 20.00),
    (2, 'Bookshelf', 3, 1, 80.00),
    (3, 'USB Cable', 1, 3, 10.00);
```

**Returning clause**
This is a statement that can be added at the end of any statemnt related to *insert*, *update*, and *delete*. It is inserted at the end of the sql statment followed by columns you wish(* for the whole row).

```sql
    -- for returning the whole row
    statement returning *
    --for returning specific columns in that row
    returning column1,column2,...
```

## 1. Insert

Insert is used to add rows to a table. Can be used for adding single or multiple rows.

```sql
--single row
 INSERT INTO table_name
  SET(column1,column2,...) 
  VALUES (value1,value2,...)

 --multiple rows
 INSERT INTO table_name
  SET(column1,column2,...) 
  VALUES (value1,value2,...),
  (value1,value2,...)
```

* ### Single row

In this only one row is inserted.

```sql
 INSERT INTO users (username,email,active)
 VALUES ('maina','maina@duck.com',False);

```

* ### Multiple row

Multiple rows get inserted within one query.

```sql
 INSERT INTO users (username,email,active)
 VALUES ('sharon','sharon@duck.com',True),
 ('joy','joy@gmail.com',True),
 ('ken','ken@gmail.com',False);
```

* ### Returning clause(Insert Version)

Addin returning clause at the end then specify which columns in the inserted row need to be retrived.

```sql
--the whole row
 INSERT INTO users(username,email)
    VALUES ('antony','antony@duck.com') RETURNING *;
 --the specific column
  INSERT INTO users (username,email)
    VALUES ('serah','serah@duck.com')RETURNING email,username;
```

## 2. Update

Update is used to update already existing data in the table.

```sql
--single columne
UPDATE table_name
SET column = 'value'
WHERE condition;

--multiple column
UPDATE table_name
SET column1 = 'newValue1', column2='newValue2',...
WHERE condition;
```

* ### Basic update

```sql
UPDATE users
SET email = 'phantom@newmail.com'
WHERE username = 'phantom';
```

* ### Update multiple columns

Update multiple columns in a row.
  
```sql
UPDATE users
SET email = 'serah_updated@gmail.com',
    active = FALSE
WHERE username = 'serah';
```

* ### Returning clause(update version)

Used to return columns updates within a row. It can be the whole row or specified columns.

```sql
--the whole row
UPDATE users
SET active = False
WHERE username = 'sharon' RETURNING *;
--specific row
UPDATE users
SET email = 'peter34@gmail.com',
active = FALSE
WHERE username = 'phantom' RETURNING email,username;
```

* ### update the whole column
  
  will update the whole column for price, increase it by 10% on each product

```sql
UPDATE order_items
SET price = price * 1.10 RETURNING *;
```

* ### update depending on another table

Trying to update order_items price, based on categories table discount.

```sql
UPDATE order_items oi
SET price = price * (1 - c.discount_percent / 100.0)
FROM categories c
WHERE oi.category_id = c.category_id
  AND c.discount_percent > 0
RETURNING oi.product_name, oi.price;
```

## 3. DELETE

Delete is used when you want to delete one or more rows.

* ### delete one row
  
``` sql
DELETE FROM users
WHERE user_id = 5;
```

* ### delete using join (using keyword)

delete orders where user not active
  
```sql
DELETE FROM orders o
USING users u
WHERE o.user_id = u.user_id
  AND u.active = FALSE RETURNING *;
```

* ### delete multiple rows match condition
  
```sql
DELETE FROM users
WHERE active = FALSE;
  ```

* ### returning clause (delete version)
  
```sql
--whole row
DELETE FROM users
WHERE username = 'antony' RETURNING *;
--specific columne
DELETE FROM users
WHERE username = 'joy' RETURNING email,username;
  ```

## 4. UPSERT

UPSERT = Insert + Update
It means:

* ✅ Insert a new row if it doesn’t exist, but </br>
* 🔁 Update the existing row if it does (based on conflict).

```sql
INSERT INTO table_name (column1, column2, ...)
VALUES (value1, value2, ...)
ON CONFLICT (conflict_column)
DO UPDATE SET
    column1 = EXCLUDED.column1,
    column2 = EXCLUDED.column2,
    column3 = 'custom_value'
RETURNING *;
```

Example:

```sql
INSERT INTO users (email, username, active)
VALUES ('phantom@duck.com', 'phantomX', FALSE)
ON CONFLICT (email)
DO UPDATE SET
    username = EXCLUDED.username,
    active = EXCLUDED.active
RETURNING *;
```
