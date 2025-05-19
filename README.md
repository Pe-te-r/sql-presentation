# Modification

Under this topic we study four different types of statements which are **insert**, **update**, **delete** and **upsert**

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
 INSERT INTO table_name
  VALUES(column1,column2,...) 
  VALUES (value1,value2,...)
```

### Single row

In this only one row is inserted.

```sql
 INSERT INTO users 
 VALUES(username,email)
 VALUES ("phantom","phantom8526@duck.com")
```

### Multiple row

```sql
 INSERT INTO users 
 VALUES(username,email)
 VALUES ("phantom","phantom8526@duck.com"),
 ("jane","Jane@gmail.com"),
 ("alex","alex@gmail.com")
```

### Returning clause

```sql
--the whole row
 INSERT INTO users 
 VALUES(username,email)
 VALUES ("phantom","phantom8526@duck.com").RETURNING *
 --the specific column
  INSERT INTO users 
 VALUES(username,email)
 VALUES ("phantom","phantom8526@duck.com").RETURNING email,username
```

## 2. Update
