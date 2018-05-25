REM install db
call C:\funda_components\reports_manager\report_manager_database\reports_manager_test_db\install_reports_manager_test_db.bat

REM test_action_list_all_programs
"C:\Program Files\PostgreSQL\9.6\bin\psql.exe" -h localhost -U postgres -d reports_manager_test_db  -p 5432 -f C:\funda_components\programs_manager\programs_manager_database\action_functions\action_load_program_list_vue_jstree.sql 1> test_action_load_program_list_vue_jstree.log 2>&1 

"C:\Program Files\PostgreSQL\9.6\bin\psql.exe" -h localhost -U postgres -d reports_manager_test_db  -p 5432 -f test_action_load_program_list_vue_jstree.sql  1>> test_action_load_program_list_vue_jstree.log 2>>&1 

 