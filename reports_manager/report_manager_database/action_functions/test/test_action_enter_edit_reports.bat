
"C:\Program Files\PostgreSQL\9.4\bin\psql.exe" -h localhost -U postgres -d report_manager_database  -p 5432 -f ..\action_enter_edit_report_parameters.sql 1> test_action_enter_edit_reports.log 2>&1 

"C:\Program Files\PostgreSQL\9.4\bin\psql.exe" -h localhost -U postgres -d report_manager_database  -p 5432 -f ..\action_enter_edit_reports.sql 1>> test_action_enter_edit_reports.log 2>>&1 

"C:\Program Files\PostgreSQL\9.4\bin\psql.exe" -h localhost -U postgres -d report_manager_database  -p 5432 -f test_action_enter_edit_reports.sql  1>> test_action_enter_edit_reports.log 2>>&1 

 