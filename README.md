# Database640

[Google Doc](https://docs.google.com/document/d/1SjoJoBoz8AGFVWCXA68KRHIdC0CBDnnwGJ3dgsWKoJ0/edit?usp=sharing)

# SQL Notes
The database we are using is Postgresql, which is SQL with a few differences from 
what we learned at class.

## SERIAL
the data type SERIAL is used as the primary key type for most tables, and
this is bascially an integer that automatically increments with out us having to 
do anything. This means two things: 
    1) Tables which have a foreign key referencing a primary key of another table that is 
    SERIAL use INTEGER. Example: the category table's PK is cat_id which is a SERIAL type.
    The table size_option references cat_id as a FK and declares that datatype for cat_id in
    size_option as INTEGER
    2) When you insert into the table you don't have to add a value for the PK because serial
    automatically updates. As an example for the shopping_cart table, normally we would have 
    to do something like: 
    ```
    INSERT INTO shopping_cart(cart_id, cust_id)
    VALUES(0, 1);
    ```
    as a result, we would need some way to know what cart_id is for a new cart. Instead, 
    we can only specify the non-PK fields and the database will automatically increment 
    a new PK value:
    ```
    INSERT INTO shopping_cart(cust_id)
    VALUES(1);
    ```

# TIMESTAMPTZ
This is essentially a way to track date/time and it tracks time in UTC, and includes
the date as well as the time down to the seconds/milliseconds. This (link)[https://www.datacamp.com/doc/postgresql/timestamptz]
shows a little bit of how to use/input into it
