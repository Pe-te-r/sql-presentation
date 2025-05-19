# Modification

Under this topic we study four different types of statements which are **insert**, **update**, **delete** and **upsert**

For you to follow along you need to create this tables in your database.

```sql
--users tables
CREATE TABLE users (
    user_id SERIAL PRIMARY KEY,
    username VARCHAR(50) NOT NULL,
    active BOOLEAN() DEFAULT TRUE
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
    ('alex', 'alex@gmail.com', TRUE),
    ('kevin', 'kevin@duck.com', FALSE),
    ('phantom', 'phantom8526@duck.com', TRUE),
    ('shakirah', 'shakirah@duck.com', TRUE);
    ('jane', 'jane@gmail.com', TRUE),

-- INSERT CATEGORIES
INSERT INTO categories (name, discount_percent) VALUES
    ('Electronics', 10.00),
    ('Books', 5.00),
    ('Furniture', 0.00);

-- INSERT ORDERS
INSERT INTO orders (user_id, status) VALUES
    (1, 'pending'),
    (2, 'shipped'),
    (3, 'pending');

-- INSERT ORDER ITEMS
INSERT INTO order_items (order_id, product_name, category_id, quantity, price) VALUES
    (1, 'Bluetooth Speaker', 1, 2, 50.00),
    (1, 'Sci-Fi Novel', 2, 1, 20.00),
    (2, 'Bookshelf', 3, 1, 80.00),
    (3, 'USB Cable', 1, 3, 10.00);
```

**Returning clause**
This is a statement that can be added at the end of any statemnt related to *insert*, *update*, and *delete*

```sql
    -- for returning the whole row
    .returning *
    --for returning specific columns in that row
    .returning column1,column2,...
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
 INSERT INTO users 
 SET(username,email)
 VALUES ("phantom","phantom8526@duck.com")
```

* ### Multiple row

```sql
 INSERT INTO users 
 SET(username,email)
 VALUES ("phantom","phantom8526@duck.com"),
 ("jane","Jane@gmail.com"),
 ("alex","alex@gmail.com")
```

* ### Returning clause(Insert Version)

```sql
--the whole row
 INSERT INTO users 
    SET(username,email)
    VALUES ("kevin","kevin@duck.com").RETURNING *
 --the specific column
  INSERT INTO users 
    SET(username,email)
    VALUES ("shakirah","shakirah@duck.com").RETURNING email,username
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
  
```sql
UPDATE users
SET email = 'jane_updated@gmail.com',
    active = FALSE
WHERE username = 'jane';
```

* ### Returning clause(update version)

```sql
--the whole row
UPDATE users
SET email = 'jane_updated@gmail.com',
    active = FALSE
WHERE username = 'jane'.RETURNING *;
--specific row
UPDATE users
SET email = 'jane_updated@gmail.com',
active = FALSE
WHERE username = 'jane'.RETURNING email,username;
```

* ### update depending on another table

```sql
UPDATE order_items oi
SET price = price * (1 - c.discount_percent / 100.0)
FROM categories c
WHERE oi.category_id = c.category_id
  AND c.discount_percent > 0
RETURNING oi.product_name, oi.price;
```

## 3. DELETE

