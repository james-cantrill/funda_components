
"C:\Program Files\PostgreSQL\9.4\bin\psql.exe" -h localhost -U postgres -d report_manager_database  -p 5432 -f ..\action_change_organization_user_visibility.sql 1> test_action_change_organization_user_visibility.log 2>&1 

"C:\Program Files\PostgreSQL\9.4\bin\psql.exe" -h localhost -U postgres -d report_manager_database  -p 5432 -f test_action_change_organization_user_visibility.sql  1>> test_action_change_organization_user_visibility.log 2>>&1 

 