REM install db
call C:\funda_components\programs_manager\programs_manager_database\program_manager_test_database\install_program_manager_test_db.bat

REM test_action_list_all_programs
"C:\Program Files\PostgreSQL\9.6\bin\psql.exe" -h localhost -U postgres -d program_manager_test_db  -p 5432 -f ..\action_list_all_programs.sql 1> test_action_list_all_programs.log 2>&1 

"C:\Program Files\PostgreSQL\9.6\bin\psql.exe" -h localhost -U postgres -d program_manager_test_db  -p 5432 -f test_action_list_all_programs.sql  1>> test_action_list_all_programs.log 2>>&1 

 