
"C:\Program Files\PostgreSQL\9.6\bin\psql.exe" -h localhost -U postgres -d system_user_demo_db  -p 5432 -f ..\action_user_login.sql 1> test_action_user_login.log 2>&1 

"C:\Program Files\PostgreSQL\9.6\bin\psql.exe" -h localhost -U postgres -d system_user_demo_db  -p 5432 -f test_action_user_login.sql  1>> test_action_user_login.log 2>>&1 

 