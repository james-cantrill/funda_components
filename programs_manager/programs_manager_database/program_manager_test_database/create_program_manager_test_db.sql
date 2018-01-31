-- create_program_manager_test_db.sql

-- Database: program_manager_test_db

DROP DATABASE program_manager_test_db;

CREATE DATABASE program_manager_test_db
  WITH OWNER = postgres
       ENCODING = 'UTF8'
       TABLESPACE = pg_default
       LC_COLLATE = 'English_United States.1252'
       LC_CTYPE = 'English_United States.1252'
       CONNECTION LIMIT = -1;

