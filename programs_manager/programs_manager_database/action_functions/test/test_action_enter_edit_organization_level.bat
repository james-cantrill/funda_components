REM test_action_enter_edit_organization_level

"C:\Program Files\PostgreSQL\9.6\bin\psql.exe" -h localhost -U postgres -d program_manager_test_db  -p 5432 -f ..\action_enter_edit_organization_level.sql 1> test_action_enter_edit_organization_level.log 2>&1 
 
 
"C:\Program Files\PostgreSQL\9.6\bin\psql.exe" -h localhost -U postgres -d program_manager_test_db  -p 5432 -f test_action_enter_edit_organization_level.sql  1>> test_action_enter_edit_organization_level.log 2>>&1 

 