
REM install db
call C:\funda_components\reports_manager\report_manager_database\reports_manager_test_db\install_reports_manager_test_db.bat

"C:\Program Files\PostgreSQL\9.6\bin\psql.exe" -h localhost -U postgres -d reports_manager_test_db  -p 5432 -f ..\action_enter_edit_report_parameters.sql 1> test_action_enter_edit_reports.log 2>&1 

"C:\Program Files\PostgreSQL\9.6\bin\psql.exe" -h localhost -U postgres -d reports_manager_test_db  -p 5432 -f ..\action_enter_edit_reports.sql 1>> test_action_enter_edit_reports.log 2>>&1 

"C:\Program Files\PostgreSQL\9.6\bin\psql.exe" -h localhost -U postgres -d reports_manager_test_db  -p 5432 -f C:\funda_components\reports_manager\report_manager_database\utility_functions\trig_log_reports_history.sql  1>> test_action_enter_edit_reports.log 2>>&1 

"C:\Program Files\PostgreSQL\9.6\bin\psql.exe" -h localhost -U postgres -d reports_manager_test_db  -p 5432 -f C:\funda_components\reports_manager\report_manager_database\utility_functions\trig_log_report_parameters_history.sql  1>> test_action_enter_edit_reports.log 2>>&1 

"C:\Program Files\PostgreSQL\9.6\bin\psql.exe" -h localhost -U postgres -d reports_manager_test_db  -p 5432 -f C:\funda_components\reports_manager\report_manager_database\utility_functions\insert_parameters_in_parameter_list.sql  1>> test_action_enter_edit_reports.log 2>>&1 

"C:\Program Files\PostgreSQL\9.6\bin\psql.exe" -h localhost -U postgres -d reports_manager_test_db  -p 5432 -f C:\funda_components\reports_manager\report_manager_database\utility_functions\run_insert_parameters_in_parameter_list.sql  1>> test_action_enter_edit_reports.log 2>>&1 

"C:\Program Files\PostgreSQL\9.6\bin\psql.exe" -h localhost -U postgres -d reports_manager_test_db  -p 5432 -f test_action_enter_edit_reports.sql  1>> test_action_enter_edit_reports.log 2>>&1 

 