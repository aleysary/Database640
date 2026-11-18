CREATE TABLE customer(
   cust_id SERIAL NOT NULL,
   cust_email_address TEXT NOT NULL UNIQUE,
   cust_fname TEXT NOT NULL,
   cust_lname TEXT NOT NULL,
   cust_address TEXT NOT NULL,
   PRIMARY KEY (cust_id)
);

CREATE TABLE category(
   cat_id SERIAL NOT NULL,
   cat_name TEXT NOT NULL,
   cat_desc TEXT NOT NULL,
   PRIMARY KEY (cat_id)
);

CREATE TABLE size_option(
   size_id SERIAL NOT NULL,
   cat_id INTEGER NOT NULL,
   size_label TEXT NOT NULL, -- EX: 'M', '30x32', '7 1/4'
   size_type TEXT NOT NULL, -- EX: "letter", "waist/inseam", "fitted hat"
   size_system TEXT NOT NULL, -- EX: "General", "US Inches", "US"
   PRIMARY KEY (size_id),
   FOREIGN KEY (cat_id) REFERENCES category(cat_id) ON DELETE CASCADE
);

CREATE TABLE affiliation(
   aff_id SERIAL NOT NULL,
   aff_name TEXT NOT NULL,
   aff_logo_url TEXT, -- link/path to logo
   aff_fee_percent DECIMAL(3,2) NOT NULL, -- percent of purchase to be sent
   PRIMARY KEY (aff_id)
);

CREATE TABLE product(
   prod_id SERIAL NOT NULL,
   cat_id INTEGER NOT NULL,
   aff_id INTEGER, -- null if no affiliation
   prod_name TEXT NOT NULL,
   prod_desc TEXT NOT NULL,
   prod_image_url TEXT NOT NULL, -- link/path to product image
   PRIMARY KEY (prod_id),
   FOREIGN KEY (cat_id) REFERENCES category(cat_id) ON DELETE CASCADE,
   FOREIGN KEY (aff_id) REFERENCES affiliation(aff_id) ON DELETE CASCADE
);

CREATE TABLE product_variant(
   variant_id SERIAL NOT NULL,
   prod_id INTEGER NOT NULL,
   size_id INTEGER NOT NULL,
   variant_price DECIMAL(7,2) NOT NULL,
   variant_quantity INTEGER NOT NULL,
   PRIMARY KEY (variant_id),
   FOREIGN KEY (prod_id) REFERENCES product(prod_id) ON DELETE CASCADE,
   FOREIGN KEY (size_id) REFERENCES size_option(size_id) ON DELETE CASCADE
);

CREATE TABLE shopping_cart(
   cart_id SERIAL NOT NULL,
   cust_id INTEGER, -- FK to customer or NULL if guest
   PRIMARY KEY (cart_id),
   FOREIGN KEY (cust_id) REFERENCES customer(cust_id) ON DELETE CASCADE
);

CREATE TABLE cart_item(
   cart_id INTEGER NOT NULL,
   variant_id INTEGER NOT NULL,
   cart_item_quantity INTEGER NOT NULL,
   cart_item_time_added TIMESTAMPTZ NOT NULL,
   PRIMARY KEY (cart_id, variant_id),
   FOREIGN KEY (cart_id) REFERENCES shopping_cart(cart_id) ON DELETE CASCADE,
   FOREIGN KEY (variant_id) REFERENCES product_variant(variant_id) ON DELETE CASCADE
);

CREATE TABLE purchase(
   purchase_id SERIAL NOT NULL,
   cust_id INTEGER, -- FK or NULL if guest
   purchase_date TIMESTAMPTZ NOT NULL,
   purchase_contact_email TEXT NOT NULL,
   purchase_method TEXT, -- null or online/POS (For now probably always online)
   purchase_total_amt DECIMAL(8,2) NOT NULL, -- can be derived from purchase_item table, but may be easier to keep here for quick access
   purchase_shipping_address TEXT, -- NULL if point of sale (POS) and no shipping is needed
   purchase_fulfilled BOOLEAN NOT NULL,
   PRIMARY KEY (purchase_id),
   FOREIGN KEY (cust_id) REFERENCES customer(cust_id) ON DELETE CASCADE
);

CREATE TABLE purchase_item(
   purchase_id INTEGER NOT NULL,
   variant_id INTEGER NOT NULL,
   purchase_item_quantity INTEGER NOT NULL,
   purchase_item_unit_price DECIMAL(6,2) NOT NULL,
   aff_id INTEGER, -- if affiliated, otherwise NULL if no affiliation
   purchase_aff_percent DECIMAL(3,2), -- % of item price going to the affiliation 
   PRIMARY KEY (purchase_id, variant_id),
   FOREIGN KEY (purchase_id) REFERENCES purchase(purchase_id) ON DELETE CASCADE,
   FOREIGN KEY (variant_id) REFERENCES product_variant(variant_price) ON DELETE CASCADE
);

CREATE TABLE login_session(
   session_token_hash BYTEA NOT NULL,
   cust_id INTEGER NOT NULL,
   session_created_at TIMESTAMPTZ NOT NULL,
   session_expires_at TIMESTAMPTZ NOT NULL,
   PRIMARY KEY (session_token_hash),
   FOREIGN KEY (cust_id) REFERENCES customer(cust_id) ON DELETE CASCADE
);
