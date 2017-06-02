REM 
"C:\Program Files\PostgreSQL\9.6\bin\psql.exe" -h localhost -U postgres -d system_user_demo_db  -p 5432 -f ..\util_is_user_authorized.sql 1> test_util_is_user_authorized.log 2>&1 

"C:\Program Files\PostgreSQL\9.6\bin\psql.exe" -h localhost -U postgres -d system_user_demo_db  -p 5432 -f test_util_is_user_authorized.sql  1>> test_util_is_user_authorized.log 2>>&1 
