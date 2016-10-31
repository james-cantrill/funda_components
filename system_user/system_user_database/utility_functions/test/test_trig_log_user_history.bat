
"C:\Program Files\PostgreSQL\9.4\bin\psql.exe" -h localhost -U postgres -d report_manager_database  -p 5432 -f ..\trig_log_user_history.sql 1> test_trig_log_user_history.log 2>&1 

REM "C:\Program Files\PostgreSQL\9.4\bin\psql.exe" -h localhost -U postgres -d report_manager_database  -p 5432 -f ..\trig_delete_user_history.sql 1>> test_trig_log_user_history.log 2>>&1 

"C:\Program Files\PostgreSQL\9.4\bin\psql.exe" -h localhost -U postgres -d report_manager_database  -p 5432 -f test_trig_log_user_history.sql  1>> test_trig_log_user_history.log 2>>&1 
