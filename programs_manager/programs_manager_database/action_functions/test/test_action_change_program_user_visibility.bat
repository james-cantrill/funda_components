REM install db
call C:\funda_components\programs_manager\programs_manager_database\program_manager_test_database\install_program_manager_test_db.bat

REM test_action_enter_edit_programs

"C:\Program Files\PostgreSQL\9.6\bin\psql.exe" -h localhost -U postgres -d program_manager_test_db  -p 5432 -f ..\action_change_program_user_visibility.sql 1> test_action_change_program_user_visibility.log 2>&1 

"C:\Program Files\PostgreSQL\9.6\bin\psql.exe" -h localhost -U postgres -d program_manager_test_db  -p 5432 -f C:\funda_components\programs_manager\programs_manager_database\utility_functions\trig_log_user_allowed_programs_history.sql 1>> test_action_change_program_user_visibility.log 2>>&1 

"C:\Program Files\PostgreSQL\9.6\bin\psql.exe" -h localhost -U postgres -d program_manager_test_db  -p 5432 -f test_action_change_program_user_visibility.sql  1>> test_action_change_program_user_visibility.log 2>>&1 

 