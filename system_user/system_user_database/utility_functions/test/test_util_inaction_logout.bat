REM install db
call C:\funda_components\system_user\system_user_database\system_user_test_db\install_system_user_test_db.bat

"C:\Program Files\PostgreSQL\9.6\bin\psql.exe" -h localhost -U postgres -d system_user_test_db  -p 5432 -f C:\funda_components\system_user\system_user_database\utility_functions\util_inaction_logout.sql 1> test_util_inaction_logout.log 2>&1 

"C:\Program Files\PostgreSQL\9.6\bin\psql.exe" -h localhost -U postgres -d system_user_test_db  -p 5432 -f test_util_inaction_logout.sql  1>> test_util_inaction_logout.log 2>>&1 

 