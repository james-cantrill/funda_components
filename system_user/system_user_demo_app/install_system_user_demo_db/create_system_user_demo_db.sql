-- create_system_user_demo_db.sql

-- Database: system_user_demo_db

DROP DATABASE system_user_demo_db;

CREATE DATABASE system_user_demo_db
  WITH OWNER = postgres
       ENCODING = 'UTF8'
       TABLESPACE = pg_default
       LC_COLLATE = 'English_United States.1252'
       LC_CTYPE = 'English_United States.1252'
       CONNECTION LIMIT = -1;

