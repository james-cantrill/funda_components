REM test_action_enter_edit_programs
"C:\Program Files\PostgreSQL\9.4\bin\psql.exe" -h localhost -U postgres -d report_manager_database  -p 5432 -f ..\action_enter_edit_programs.sql 1> test_action_enter_edit_programs.log 2>&1 
REM "C:\Program Files\PostgreSQL\9.4\bin\psql.exe" -h localhost -U postgres -d report_manager_database  -p 5432 -f test_action_enter_edit_program_folders.sql  1>> test_action_enter_edit_programs.log
 
"C:\Program Files\PostgreSQL\9.4\bin\psql.exe" -h localhost -U postgres -d report_manager_database  -p 5432 -f test_action_enter_edit_programs.sql  1>> test_action_enter_edit_programs.log 2>>&1 

 