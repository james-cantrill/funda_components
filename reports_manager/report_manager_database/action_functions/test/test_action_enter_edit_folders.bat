
"C:\Program Files\PostgreSQL\9.6\bin\psql.exe" -h localhost -U postgres -d reports_manager_test_db  -p 5432 -f ..\action_enter_edit_folders.sql 1> test_action_enter_edit_folders.log 2>&1 

"C:\Program Files\PostgreSQL\9.6\bin\psql.exe" -h localhost -U postgres -d reports_manager_test_db  -p 5432 -f test_action_enter_edit_folders.sql  1>> test_action_enter_edit_folders.log 2>>&1 

 