
REM install db
call C:\funda_components\reports_manager\report_manager_database\reports_manager_test_db\install_reports_manager_test_db.bat

"C:\Program Files\PostgreSQL\9.6\bin\psql.exe" -h localhost -U postgres -d reports_manager_test_db  -p 5432 -f ..\action_load_selected_report.sql 1> test_action_load_selected_report.log 2>&1 

"C:\Program Files\PostgreSQL\9.6\bin\psql.exe" -h localhost -U postgres -d reports_manager_test_db  -p 5432 -f C:\steps_reporting\report_manager\report_manager_database\utility_functions\util_is_report_viewable_to_user.sql 1>> test_action_load_selected_report.log 2>>&1 


"C:\Program Files\PostgreSQL\9.6\bin\psql.exe" -h localhost -U postgres -d reports_manager_test_db  -p 5432 -f test_action_load_selected_report.sql  1>> test_action_load_selected_report.log 2>>&1 
