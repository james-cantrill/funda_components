
"C:\Program Files\PostgreSQL\9.4\bin\psql.exe" -h localhost -U postgres -d report_manager_database  -p 5432 -f ..\action_list_user_visible_programs.sql 1> test_action_list_user_visible_programs.log 2>&1 

"C:\Program Files\PostgreSQL\9.4\bin\psql.exe" -h localhost -U postgres -d report_manager_database  -p 5432 -f test_action_list_user_visible_programs.sql  1>> test_action_list_user_visible_programs.log 2>>&1 

 