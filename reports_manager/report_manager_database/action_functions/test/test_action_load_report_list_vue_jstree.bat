
REM install db
call C:\funda_components\reports_manager\report_manager_database\reports_manager_test_db\install_reports_manager_test_db.bat

"C:\Program Files\PostgreSQL\9.6\bin\psql.exe" -h localhost -U postgres -d reports_manager_test_db  -p 5432 -f ..\action_load_report_list_vue_jstree.sql 1> test_action_load_report_list_vue_jstree.log 2>&1 

"C:\Program Files\PostgreSQL\9.6\bin\psql.exe" -h localhost -U postgres -d reports_manager_test_db  -p 5432 -f test_action_load_report_list_vue_jstree.sql  1>> test_action_load_report_list_vue_jstree.log 2>>&1 
