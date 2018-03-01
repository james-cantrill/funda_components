REM "C:\Program Files\PostgreSQL\9.4\bin\psql.exe" -h localhost -U postgres -d report_manager_database  -p 5432 -f C:\steps_reporting\report_manager\report_manager_database\action_functions\action_enter_edit_allowed_reports.sql 1> test_pop_allowed_reports_out_data.log 2>&1 

"C:\Program Files\PostgreSQL\9.4\bin\psql.exe" -h localhost -U postgres -d report_manager_database  -p 5432 -f ..\pop_allowed_reports_out_data.sql 1> test_pop_allowed_reports_out_data.log 2>&1 

REM "C:\Program Files\PostgreSQL\9.4\bin\psql.exe" -h localhost -U postgres -d report_manager_database  -p 5432 -f C:\steps_reporting\report_manager\report_manager_database\utility_functions\test\test_setup_folders_and_reports.sql REM 1> test_pop_allowed_reports.log 2>&1

"C:\Program Files\PostgreSQL\9.4\bin\psql.exe" -h localhost -U postgres -d report_manager_database  -p 5432 -f test_pop_allowed_reports_out_data.sql  1>> test_pop_allowed_reports_out_data.log 2>>&1 
