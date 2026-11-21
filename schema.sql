-- The Fitted Joint — schema (PostgreSQL), built from the ER diagram
-- Run this first, then seed.sql.

DROP TABLE IF EXISTS order_item, "order", login_session, cart_item, shopping_cart,
  product_variant, product, size_option, affiliation, customer, category CASCADE;

CREATE TABLE category (
  cat_id      SERIAL PRIMARY KEY,
  cat_name    TEXT NOT NULL,
  cat_desc    TEXT NOT NULL
);

CREATE TABLE affiliation (
  aff_id          SERIAL PRIMARY KEY,
  aff_name        TEXT NOT NULL,
  aff_logo_url    TEXT,
  aff_fee_percent DECIMAL(3,2) NOT NULL          -- stored as a fraction, e.g. 0.12 = 12%
);

CREATE TABLE customer (
  cust_id            SERIAL PRIMARY KEY,
  cust_email_address TEXT NOT NULL UNIQUE,
  cust_fname         TEXT NOT NULL,
  cust_lname         TEXT NOT NULL,
  cust_phone         TEXT NOT NULL,
  cust_address       TEXT NOT NULL
);

CREATE TABLE size_option (
  size_id     SERIAL PRIMARY KEY,
  cat_id      INTEGER NOT NULL REFERENCES category(cat_id),
  size_label  TEXT NOT NULL,                     -- named size_lab0el in the diagram
  size_type   TEXT NOT NULL,
  size_system TEXT NOT NULL
);

CREATE TABLE product (
  prod_id        SERIAL PRIMARY KEY,
  cat_id         INTEGER NOT NULL REFERENCES category(cat_id),
  aff_id         INTEGER REFERENCES affiliation(aff_id),
  prod_name      TEXT NOT NULL,
  prod_desc      TEXT NOT NULL,
  prod_image_url TEXT NOT NULL
);

CREATE TABLE product_variant (
  variant_id       SERIAL PRIMARY KEY,
  prod_id          INTEGER NOT NULL REFERENCES product(prod_id),
  size_id          INTEGER NOT NULL REFERENCES size_option(size_id),
  variant_price    DECIMAL(7,2) NOT NULL,
  variant_quantity INTEGER NOT NULL
);

CREATE TABLE shopping_cart (
  cart_id  SERIAL PRIMARY KEY,
  cust_id  INTEGER REFERENCES customer(cust_id)  -- NULL = guest cart
);

CREATE TABLE cart_item (
  cart_id              INTEGER REFERENCES shopping_cart(cart_id),
  variant_id           INTEGER REFERENCES product_variant(variant_id),
  cart_item_quantity   INTEGER NOT NULL,
  cart_item_time_added TIMESTAMPTZ NOT NULL,
  PRIMARY KEY (cart_id, variant_id)
);

CREATE TABLE login_session (
  session_token_hash BYTEA PRIMARY KEY,
  cust_id            INTEGER NOT NULL REFERENCES customer(cust_id),
  session_created_at TIMESTAMPTZ NOT NULL,
  session_expires_at TIMESTAMPTZ NOT NULL
);

CREATE TABLE "order" (
  order_id               SERIAL PRIMARY KEY,
  cust_id                INTEGER REFERENCES customer(cust_id),  -- NULL = guest checkout
  order_date             TIMESTAMPTZ NOT NULL,
  order_contact_email    TEXT NOT NULL,
  order_method           TEXT,
  order_total_amt        DECIMAL(8,2) NOT NULL,
  order_shipping_address TEXT,
  order_fulfilled        BOOLEAN NOT NULL
);

CREATE TABLE order_item (
  order_id              INTEGER REFERENCES "order"(order_id),
  variant_id            INTEGER REFERENCES product_variant(variant_id),
  order_item_quantity   INTEGER NOT NULL,
  order_item_unit_price DECIMAL(6,2) NOT NULL,
  aff_id                INTEGER REFERENCES affiliation(aff_id),
  order_aff_percent     DECIMAL(3,2),
  PRIMARY KEY (order_id, variant_id)
);
