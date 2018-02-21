REM install db
call C:\funda_components\programs_manager\programs_manager_database\program_manager_test_database\install_program_manager_test_db.bat

REM test_action_enter_edit_organization_level


"C:\Program Files\PostgreSQL\9.6\bin\psql.exe" -h localhost -U postgres -d program_manager_test_db  -p 5432 -f ..\action_enter_edit_organization_level.sql 1> test_action_enter_edit_organization_level.log 2>&1 
 
"C:\Program Files\PostgreSQL\9.6\bin\psql.exe" -h localhost -U postgres -d program_manager_test_db  -p 5432 -f C:\funda_components\programs_manager\programs_manager_database\utility_functions\trig_log_organization_level_history.sql 1>> test_action_enter_edit_organizations.log 2>>&1 
 
"C:\Program Files\PostgreSQL\9.6\bin\psql.exe" -h localhost -U postgres -d program_manager_test_db  -p 5432 -f test_action_enter_edit_organization_level.sql  1>> test_action_enter_edit_organization_level.log 2>>&1 

 