-- create_reports_manager_test_db.sql

-- Database: reports_manager_test_db

DROP DATABASE reports_manager_test_db;

CREATE DATABASE reports_manager_test_db
  WITH OWNER = postgres
       ENCODING = 'UTF8'
       TABLESPACE = pg_default
       LC_COLLATE = 'English_United States.1252'
       LC_CTYPE = 'English_United States.1252'
       CONNECTION LIMIT = -1;

