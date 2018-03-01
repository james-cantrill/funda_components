"C:\Program Files\PostgreSQL\9.4\bin\psql.exe" -h localhost -U postgres -d report_manager_database  -p 5432 -f ..\action_load_selected_report.sql 1> test_action_load_selected_report.log 2>&1 
"C:\Program Files\PostgreSQL\9.4\bin\psql.exe" -h localhost -U postgres -d report_manager_database  -p 5432 -f C:\steps_reporting\report_manager\report_manager_database\utility_functions\util_is_report_viewable_to_user.sql 1>> test_action_load_selected_report.log 2>>&1 

REM "C:\Program Files\PostgreSQL\9.4\bin\psql.exe" -h localhost -U postgres -d report_manager_database  -p 5432 -f C:\steps_reporting\report_manager\report_manager_database\utility_functions\test\test_setup_folders_and_reports.sql 1> setup_folders_and_reports.log 2>&1

"C:\Program Files\PostgreSQL\9.4\bin\psql.exe" -h localhost -U postgres -d report_manager_database  -p 5432 -f test_action_load_selected_report.sql  1>> test_action_load_selected_report.log 2>>&1 
