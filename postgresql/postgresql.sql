# brew install postgres@10
brew install postgres

# run postgres server
pg_ctl -D /usr/local/var/postgres start

psql -h localhost -d hasura -U postgres

\l - Display database
\c - Connect to database
\dn - List schemas
\dt - List tables inside public schemas
\dt public. - List tables inside particular schemas. For eg: 'schema1'.
\du - List all user accounts

# view constraints for table
SELECT conname
FROM pg_constraint
WHERE conrelid =
    (SELECT oid 
    FROM pg_class
    WHERE relname LIKE 'order');      
           
SELECT con.*
   FROM pg_catalog.pg_constraint con
        INNER JOIN pg_catalog.pg_class rel
                   ON rel.oid = con.conrelid
        INNER JOIN pg_catalog.pg_namespace nsp
                   ON nsp.oid = connamespace
   WHERE nsp.nspname = 'public'
         AND rel.relname = 'order';

# create db
postgres=# create database mydb;

# create user and grant access
postgres=# create user postgres with encrypted password 'postgres';
postgres=# grant all privileges on database hasura to postgres;

# make user superuser
postgres=# ALTER USER postgres WITH SUPERUSER;

create schema public;

# drops all tables owned by user
drop owned by user;

pg_dump postgresql://postgres@hasuragraphqlapi.rds.amazonaws.com:5432/has -Fc -f "${HOME}/dbdumps/dump.gz" --exclude-table member --exclude-table organization --exclude-table user

pg_restore --dbname=has --format=custom --jobs=4 --host=localhost --username=sen4ik --port=5432 --clean "${HOME}/dbdumps/dump.gz"

pg_dump postgresql://postgres@hasuragraphqlapi.rds.amazonaws.com:5432/has -Fc -f "${HOME}/dbdumps/dump_specific_tables.gz" --table user --table organization --table member

# dump only data from table user
pg_dump postgresql://postgres@hasuragraphqlapi.rds.amazonaws.com:5432/has -Fp -f "${HOME}/dbdumps/user_table_data" --schema=public --data-only --table user

# dump only schema of table user
pg_dump postgresql://postgres@hasuragraphqlapi.rds.amazonaws.com:5432/has -Fp -f "${HOME}/dbdumps/user_table_schema" --schema=public --schema-only --table user

# get functions
cat public_schema | sed -n -e '/CREATE FUNCTION/,/-- Name:/ p' > functions
# get sequences
cat public_schema | sed -n -e '/CREATE SEQUENCE/,/-- Name:/ p' > sequences
# get sequence alters
cat public_schema | awk '/ALTER SEQUENCE/' > sequence_alters

# creating indexes
CREATE INDEX confirmation_number_order_id_idx ON public.confirmation_number USING btree (order_id);
CREATE INDEX confirmation_number_index ON public.confirmation_number USING btree (id);

# view existing indexes
SELECT indexname, indexdef FROM pg_indexes WHERE tablename = 'order';
SELECT tablename, indexname, indexdef FROM pg_indexes WHERE schemaname = 'public' ORDER BY tablename, indexname;


CREATE TABLE IF NOT EXISTS log (
   id SERIAL PRIMARY KEY
);

CREATE TABLE IF NOT EXISTS ogranizations (
   id SERIAL PRIMARY key, 
   add column company_name VARCHAR (150),
   add column settings jsonb
);
ALTER TABLE organizations add column if not exists is_active BOOLEAN DEFAULT false;

CREATE TABLE IF NOT EXISTS members (
   id SERIAL PRIMARY KEY
   --user_id add foreign key (user_id) references users(id),
   --organization_id,
);

alter table users 
	add column IF NOT EXISTS first_name VARCHAR (150), 
	add column IF NOT exists last_name VARCHAR (150),
	add column IF NOT exists email VARCHAR (150),
	add column IF NOT exists email_verified BOOLEAN DEFAULT false,
	add column IF NOT exists phone_number VARCHAR (50),
	add column IF NOT exists title VARCHAR (150),
	add column IF NOT exists created_at TIMESTAMP;	
ALTER TABLE users ALTER COLUMN created_at SET DEFAULT now();
ALTER TABLE users add column if not exists is_deleted BOOLEAN DEFAULT false;
   
-- add foreign key
ALTER TABLE members
	add column if not exists user_id INTEGER REFERENCES users (id),
	add column if not exists organization_id INTEGER REFERENCES organizations (id);
   
CREATE TABLE IF NOT EXISTS vendors (
   id SERIAL PRIMARY key,
   vendor_name varchar(150),
   vendor_description text,
   vendor_phone_number VARCHAR (50),
   vendor_address text,
   is_deleted BOOLEAN DEFAULT false,
   created_at TIMESTAMP DEFAULT now(),
   organization_id INTEGER REFERENCES organizations (id),
   created_by INTEGER REFERENCES users (id),
   logo_url text
);

CREATE TABLE IF NOT EXISTS manufacturers (
   id SERIAL PRIMARY key,
   manufacturer_name varchar(150),
   manufacturer_description text,
   is_deleted BOOLEAN DEFAULT false,
   created_at TIMESTAMP DEFAULT now(),
   organization_id INTEGER REFERENCES organizations (id),
   created_by INTEGER REFERENCES users (id)
);

CREATE TABLE IF NOT EXISTS categories (
   id SERIAL PRIMARY key,
   category_name varchar(150),
   category_description text,
   is_deleted BOOLEAN DEFAULT false,
   created_at TIMESTAMP DEFAULT now(),
   organization_id INTEGER REFERENCES organizations (id),
   created_by INTEGER REFERENCES users (id)
);

CREATE TABLE IF NOT EXISTS locations (
   id SERIAL PRIMARY key,
   location_address varchar(150),
   location_description text,
   is_deleted BOOLEAN DEFAULT false,
   created_at TIMESTAMP DEFAULT now(),
   organization_id INTEGER REFERENCES organizations (id),
   created_by INTEGER REFERENCES users (id)
);

CREATE TABLE IF NOT EXISTS inventory (
   id SERIAL PRIMARY key,
   sku varchar(250),
   inventory_name varchar(150),
   inventory_description text,
   is_deleted BOOLEAN DEFAULT false,
   created_at TIMESTAMP DEFAULT now(),
   created_by INTEGER REFERENCES users (id),
   organization_id INTEGER REFERENCES organizations (id),
   category_id INTEGER REFERENCES categories (id),
   manufacturer_id INTEGER REFERENCES manufacturers (id),
   minimum_quantity INTEGER,
   weight_oz float8,
   length_in float8,
   height_in float8,
   width_inch float8,
   cost_price float4,
   list_price float4
);

CREATE TABLE IF NOT EXISTS inventory_item (
   id SERIAL PRIMARY key,
   inventory_item_description text,
   is_deleted BOOLEAN DEFAULT false,
   created_at TIMESTAMP DEFAULT now(),
   created_by INTEGER REFERENCES users (id),
   inventory_id INTEGER REFERENCES inventory (id),
   location_id INTEGER REFERENCES locations (id),
   assigned_to INTEGER REFERENCES users (id),
   assigned_by INTEGER REFERENCES users (id),
   inventory_item_condition varchar(50),
   is_sold BOOLEAN DEFAULT false,
   sale_price float4,
   is_advertised BOOLEAN DEFAULT false,
   advertised_description text,
   advertised_price float4,
   listed_on_shopify BOOLEAN DEFAULT false,
   shopify_price float4
);

-- restart id column sequence
select pg_get_serial_sequence('public.inventory', 'id');
ALTER SEQUENCE public.inventory_id_seq RESTART WITH 10000;

insert into organizations (company_name) values('Christian Leisure');
select * from organizations o ;

CREATE TABLE IF NOT EXISTS notes (
   id SERIAL PRIMARY key,
   note_body text,
   is_deleted BOOLEAN DEFAULT false,
   created_at TIMESTAMP DEFAULT now(),
   created_by INTEGER REFERENCES users (id),
   inventory_id INTEGER REFERENCES inventory (id),
   inventory_item_id INTEGER REFERENCES inventory (id)
);

CREATE TABLE IF NOT EXISTS files (
   id SERIAL PRIMARY key,
   is_deleted BOOLEAN DEFAULT false,
   created_at TIMESTAMP DEFAULT now(),
   created_by INTEGER REFERENCES users (id),
   inventory_id INTEGER REFERENCES inventory (id),
   inventory_item_id INTEGER REFERENCES inventory (id),
   user_id INTEGER REFERENCES users (id),
   file_location text
);

comment on column files.user_id is 'When set, file is used for user avatar';
comment on column files.inventory_id is 'When set, file is a inventory picture';
comment on column files.inventory_item_id is 'When set, file is a inventory item picture';

alter table logs 
	add column IF NOT EXISTS action_type VARCHAR (150), 
	add column IF NOT EXISTS description VARCHAR (250), 
	add column IF NOT exists created_at TIMESTAMP DEFAULT now(),
	add column IF NOT exists inventory_id INTEGER REFERENCES inventory (id),
    add column IF NOT exists inventory_item_id INTEGER REFERENCES inventory (id),
    add column IF NOT exists user_id INTEGER REFERENCES users (id),
    add column IF NOT exists old_value jsonb,
    add column IF NOT exists new_value jsonb,
    add column IF NOT exists updated_by INTEGER REFERENCES users (id);
    