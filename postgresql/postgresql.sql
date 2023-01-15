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
    
ALTER SEQUENCE schemaname.project_numeric_id_seq RESTART WITH 1000;

-- drop function if exists schemaname.now_utc();
create or replace function schemaname.now_utc() returns timestamp as '
    select now() at time zone ''utc'';
' language sql;

-- # AUDIT TRIGGERS
-- ## Audit for authentication.USERS ##
-- drop function if exists audit.user_change_trigger();
create or replace function audit.user_change_trigger() RETURNS trigger as '
begin
    if TG_OP = ''UPDATE'' then
        insert into audit.auth_user_history (id, operation, new_val, old_val) values (uuid_generate_v4(), TG_OP, row_to_json(new), row_to_json(old));
        return new;
    elsif TG_OP = ''DELETE'' then
        insert into audit.auth_user_history (id, operation, old_val) values (uuid_generate_v4(), TG_OP, row_to_json(old));
        return old;
    elsif TG_OP = ''INSERT'' then
        insert into audit.auth_user_history (id, operation, new_val) values (uuid_generate_v4(), TG_OP, row_to_json(new));
        return new;
    end if;
end;
' language plpgsql;;
drop trigger if exists user_audit_trigger ON authentication.users;
create trigger user_audit_trigger after insert or update or delete on authentication.users for each row
    execute procedure audit.user_change_trigger();
-- ## Audit for authentication.USERS END ##

-- ## Audit for schemaname.PROJECT ##
drop table if exists  audit.project_history cascade;
create table audit.project_history (
    id uuid DEFAULT uuid_generate_v4(),
    tstamp timestamp default now(),
    operation text,
    by_user text,
    new_val json,
    old_val json
);

-- drop function if exists audit.project_change_trigger();
create or replace function audit.project_change_trigger() returns trigger as '
begin
    if TG_OP = ''UPDATE'' then
        insert into audit.project_history (operation, new_val, old_val) values (TG_OP, row_to_json(new), row_to_json(old));
        return new;
    elsif TG_OP = ''DELETE'' then
        insert into audit.project_history (operation, old_val) values (TG_OP, row_to_json(old));
        return old;
    elsif TG_OP = ''INSERT'' then
        insert into audit.project_history (operation, new_val) values (TG_OP, row_to_json(new));
        return new;
    end if;
end;
' language plpgsql security definer;

drop trigger if exists project_audit_trigger ON schemaname.project;
create trigger project_audit_trigger after insert or update or delete on schemaname.project for each row
    execute procedure audit.project_change_trigger();
-- ## Audit for schemaname.PROJECT END ##

-- ## Audit for schemaname.COMMENT ##
drop table if exists  audit.comment_history cascade;
create table audit.comment_history (
    id uuid DEFAULT uuid_generate_v4(),
    tstamp timestamp default now(),
    operation text,
    by_user text,
    new_val json,
    old_val json
);

-- drop function if exists audit.comment_change_trigger();
create or replace function audit.comment_change_trigger() returns trigger as '
    begin
        if TG_OP = ''UPDATE'' then
            insert into audit.comment_history (operation, new_val, old_val) values (TG_OP, row_to_json(new), row_to_json(old));
            return new;
        elsif TG_OP = ''DELETE'' then
            insert into audit.comment_history (operation, old_val) values (TG_OP, row_to_json(old));
            return old;
        elsif TG_OP = ''INSERT'' then
            insert into audit.comment_history (operation, new_val) values (TG_OP, row_to_json(new));
            return new;
        end if;
    end;
' language plpgsql security definer;

drop trigger if exists comment_audit_trigger ON schemaname.comment;
create trigger comment_audit_trigger after insert or update or delete on schemaname.comment for each row
    execute procedure audit.comment_change_trigger();
-- ## Audit for schemaname.COMMENT END ##

-- ## Audit for schemaname.TIME_CLOCK ##
drop table if exists  audit.time_clock_history cascade;
create table audit.time_clock_history (
    id uuid DEFAULT uuid_generate_v4(),
    tstamp timestamp default now(),
    operation text,
    by_user text,
    new_val json,
    old_val json
);

-- drop function if exists audit.time_clock_change_trigger();
create or replace function audit.time_clock_change_trigger() returns trigger as '
    begin
        if TG_OP = ''UPDATE'' then
            insert into audit.time_clock_history (operation, new_val, old_val) values (TG_OP, row_to_json(new), row_to_json(old));
            return new;
        elsif TG_OP = ''DELETE'' then
            insert into audit.time_clock_history (operation, old_val) values (TG_OP, row_to_json(old));
            return old;
        elsif TG_OP = ''INSERT'' then
            insert into audit.time_clock_history (operation, new_val) values (TG_OP, row_to_json(new));
            return new;
        end if;
    end;
' language plpgsql security definer;

drop trigger if exists time_clock_audit_trigger ON schemaname.time_clock;
create trigger time_clock_audit_trigger after insert or update or delete on schemaname.time_clock for each row
    execute procedure audit.time_clock_change_trigger();
-- ## Audit for schemaname.TIME_CLOCK END ##

drop table if exists  audit.t_history cascade;
create table audit.t_history (
    id uuid DEFAULT uuid_generate_v4(),
    tstamp timestamp default now(),
    schemaname text,
    tabname text,
    operation text,
    -- who text default current_user,
    by_user text,
    new_val json,
    old_val json
);

-- drop function if exists audit.change_trigger();
create or replace function audit.change_trigger() returns trigger as '
begin
    if TG_OP = ''UPDATE'' then
        insert into audit.t_history (tabname, schemaname, operation, new_val, old_val) values (TG_RELNAME, TG_TABLE_SCHEMA, TG_OP, row_to_json(new), row_to_json(old));
        return new;
    elsif TG_OP = ''DELETE'' then
        insert into audit.t_history (tabname, schemaname, operation, old_val) values (TG_RELNAME, TG_TABLE_SCHEMA, TG_OP, row_to_json(old));
        return old;
    elsif TG_OP = ''INSERT'' then
        insert into audit.t_history (tabname, schemaname, operation, new_val) values (TG_RELNAME, TG_TABLE_SCHEMA, TG_OP, row_to_json(new));
        return new;
    end if;
end;
' language plpgsql security definer;

drop trigger if exists address_audit_trigger ON schemaname.address;
create trigger address_audit_trigger after insert or update or delete on schemaname.address for each row
    execute procedure audit.change_trigger();
drop trigger if exists attachment_audit_trigger ON schemaname.attachment;
create trigger attachment_audit_trigger after insert or update or delete on schemaname.attachment for each row
    execute procedure audit.change_trigger();
drop trigger if exists organization_audit_trigger ON schemaname.organization;
create trigger organization_audit_trigger after insert or update or delete on schemaname.organization for each row
    execute procedure audit.change_trigger();
--- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---

create or replace function schemaname.remove_dupes(p_array jsonb) returns jsonb as '
    select jsonb_agg(distinct e) from jsonb_array_elements(p_array) as t(e);
' language sql;

CREATE or replace VIEW schemaname.daily_report_v AS (
    select uuid_generate_v4() as id, date(t.start_time) reportday, sum(t.time_worked) as totalworked, t.users_id,
           (select uu.first_name from authentication.users uu where uu.id = t.users_id) as first_name,
           (select uu.last_name from authentication.users uu where uu.id = t.users_id) as last_name,
           schemaname.remove_dupes(
                jsonb_agg(
                    json_build_object('id', t.project_id, 'projectName', p.project_name, 'numericId', p.numeric_id)
                ) filter (where t.project_id is not null)
           ) as projects
    from schemaname.time_clock t left outer join schemaname.project p on p.id = t.project_id
    group by t.users_id, date(t.start_time)
);

CREATE or replace VIEW schemaname.project_count_v AS (
    select uuid_generate_v4() as id, p.id as project_id,
           (select count(pr) from schemaname.project pr where pr.parent_id = p.id) as sub_project_count,
           (select count(c) from schemaname.comment c where c.project_id = p.id) as comments_count
    from schemaname.project p left outer join schemaname.comment c on p.id = c.project_id
    group by p.id
);

CREATE or replace VIEW schemaname.projects_breakdown_v AS (
     select uuid_generate_v4() as id, date(t.start_time) reportday, sum(t.time_worked) as totalworked, t.project_id as project_id,
            (select pp.organization_id from schemaname.project pp where pp.id = t.project_id) as organization_id
     from schemaname.time_clock t
     where t.project_id is not NULL
     group by t.project_id, date(t.start_time)
 );

create or replace function schemaname.hourly_rate_trigger() returns trigger as '
    declare
        users_hourly_rate float8;
    begin
        if TG_OP = ''INSERT'' then
            select au.hourly_rate INTO users_hourly_rate from authentication.users au where au.id = new.users_id;
            if (users_hourly_rate is not null) AND (users_hourly_rate <> 0) then
                update schemaname.time_clock tt set hourly_rate = users_hourly_rate where id = new.id;
            end if;
            return new;
        end if;
    end;
' language plpgsql security definer;
drop trigger if exists hourly_rate_trigger ON schemaname.time_clock;
create trigger hourly_rate_trigger after insert on schemaname.time_clock for each row
execute procedure schemaname.hourly_rate_trigger();

create or replace function authentication.user_hourly_rate_update_trigger() returns trigger as '
    begin
        if TG_OP = ''INSERT'' then
            if (new.hourly_rate is not null) AND (new.hourly_rate <> 0) then
                insert into authentication.hourly_rate_log (id, users_id, hourly_rate) values (uuid_generate_v4(), new.id, new.hourly_rate);
            end if;
            return new;
        elsif TG_OP = ''UPDATE'' then
            if (new.hourly_rate <> old.hourly_rate) then
                insert into authentication.hourly_rate_log (id, users_id, hourly_rate) values (uuid_generate_v4(), new.id, new.hourly_rate);
            end if;
            return new;
        end if;
    end;
' language plpgsql security definer;
drop trigger if exists user_hourly_rate_update_trigger ON authentication.users;
create trigger user_hourly_rate_update_trigger after insert or update on authentication.users for each row
execute procedure authentication.user_hourly_rate_update_trigger();


do
'
declare
    usr text;
    usersarr text[] := array [''6ecd8c99-4036-403d-bf84-cf8400f67836'',''3f333df6-90a4-4fda-8dd3-9485d27cee36'',''bc386758-17b8-11ed-861d-0242ac120002''];
    starttime timestamp;
begin
    foreach usr in array usersarr loop
        starttime = now() - interval ''3 hours 10 minutes'';
        insert into schemaname.time_clock (id, created_at, start_time, end_time, created_by_users_id, users_id, day)
        values (uuid_generate_v4(), now(), starttime, (now() - interval ''1 hours 10 minutes''), usr::uuid, usr::uuid, date(starttime));

        starttime = now() - interval ''9 hours 20 minutes'';
        insert into schemaname.time_clock (id, created_at, start_time, end_time, created_by_users_id, users_id, day)
        values (uuid_generate_v4(), now(), starttime, (now() - interval ''5 hours 20 minutes''), usr::uuid, usr::uuid, date(starttime));
    end loop;
end;
'  language plpgsql;