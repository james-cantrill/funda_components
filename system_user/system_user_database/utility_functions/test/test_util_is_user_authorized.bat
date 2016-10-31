REM 
"C:\Program Files\PostgreSQL\9.4\bin\psql.exe" -h localhost -U postgres -d report_manager_database  -p 5432 -f ..\util_is_user_authorized.sql 1> test_util_is_user_authorized.log 2>&1 

"C:\Program Files\PostgreSQL\9.4\bin\psql.exe" -h localhost -U postgres -d report_manager_database  -p 5432 -f test_util_is_user_authorized.sql  1>> test_util_is_user_authorized.log 2>>&1 
