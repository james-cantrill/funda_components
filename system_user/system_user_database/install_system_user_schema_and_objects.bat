REM this script installs the application's database and then the system_user_schema and its objects


REM install the schema
"C:\Program Files\PostgreSQL\9.4\bin\psql.exe" -h localhost -U postgres -d report_manager_database  -p 5432 -f C:\funda_components\system_user\system_user_database\create_system_user_schema.sql  1> install_system_user_schema_and_objects.log 2>&1 

REM install the objects
"C:\Program Files\PostgreSQL\9.4\bin\psql.exe" -h localhost -U postgres -d report_manager_database  -p 5432 -f C:\funda_components\system_user\system_user_database\table_definitions\system_users.sql  1>> install_system_user_schema_and_objects.log 2>>&1 

"C:\Program Files\PostgreSQL\9.4\bin\psql.exe" -h localhost -U postgres -d report_manager_database  -p 5432 -f C:\funda_components\system_user\system_user_database\table_definitions\system_users_history.sql  1>> install_system_user_schema_and_objects.log 2>>&1 

"C:\Program Files\PostgreSQL\9.4\bin\psql.exe" -h localhost -U postgres -d report_manager_database  -p 5432 -f C:\funda_components\system_user\system_user_database\table_definitions\system_user_state.sql 1>> install_system_user_schema_and_objects.log 2>>&1 

"C:\Program Files\PostgreSQL\9.4\bin\psql.exe" -h localhost -U postgres -d report_manager_database  -p 5432 -f C:\funda_components\system_user\system_user_database\table_definitions\system_user_state_history.sql 1>> install_system_user_schema_and_objects.log 2>>&1 

"C:\Program Files\PostgreSQL\9.4\bin\psql.exe" -h localhost -U postgres -d report_manager_database  -p 5432 -f C:\funda_components\system_user\system_user_database\table_definitions\system_actions.sql 1>> install_system_user_schema_and_objects.log 2>>&1 

"C:\Program Files\PostgreSQL\9.4\bin\psql.exe" -h localhost -U postgres -d report_manager_database  -p 5432 -f C:\funda_components\system_user\system_user_database\table_definitions\system_user_allowed_actions.sql 1>> install_system_user_schema_and_objects.log 2>>&1 

"C:\Program Files\PostgreSQL\9.4\bin\psql.exe" -h localhost -U postgres -d report_manager_database  -p 5432 -f C:\funda_components\system_user\system_user_database\table_definitions\system_user_allowed_actions_history.sql 1>> install_system_user_schema_and_objects.log 2>>&1 

"C:\Program Files\PostgreSQL\9.4\bin\psql.exe" -h localhost -U postgres -d report_manager_database  -p 5432 -f C:\funda_components\system_user\system_user_database\action_functions\action_add_new_user.sql 1>> install_system_user_schema_and_objects.log 2>>&1

"C:\Program Files\PostgreSQL\9.4\bin\psql.exe" -h localhost -U postgres -d report_manager_database  -p 5432 -f C:\funda_components\system_user\system_user_database\action_functions\action_change_password.sql 1>> install_system_user_schema_and_objects.log 2>>&1

"C:\Program Files\PostgreSQL\9.4\bin\psql.exe" -h localhost -U postgres -d report_manager_database  -p 5432 -f C:\funda_components\system_user\system_user_database\action_functions\action_change_user_allowed_actions.sql 1>> install_system_user_schema_and_objects.log 2>>&1

"C:\Program Files\PostgreSQL\9.4\bin\psql.exe" -h localhost -U postgres -d report_manager_database  -p 5432 -f C:\funda_components\system_user\system_user_database\action_functions\action_user_login.sql 1>> install_system_user_schema_and_objects.log 2>>&1

"C:\Program Files\PostgreSQL\9.4\bin\psql.exe" -h localhost -U postgres -d report_manager_database  -p 5432 -f C:\funda_components\system_user\system_user_database\action_functions\action_user_logout.sql 1>> install_system_user_schema_and_objects.log 2>>&1

"C:\Program Files\PostgreSQL\9.4\bin\psql.exe" -h localhost -U postgres -d report_manager_database  -p 5432 -f C:\funda_components\system_user\system_user_database\utility_functions\util_get_user_state.sql 1>> install_system_user_schema_and_objects.log 2>>&1

"C:\Program Files\PostgreSQL\9.4\bin\psql.exe" -h localhost -U postgres -d report_manager_database  -p 5432 -f C:\funda_components\system_user\system_user_database\utility_functions\util_is_user_authorized.sql 1>> install_system_user_schema_and_objects.log 2>>&1 

"C:\Program Files\PostgreSQL\9.4\bin\psql.exe" -h localhost -U postgres -d report_manager_database  -p 5432 -f C:\funda_components\system_user\system_user_database\utility_functions\trig_log_state_history.sql 1>> install_system_user_schema_and_objects.log 2>>&1

"C:\Program Files\PostgreSQL\9.4\bin\psql.exe" -h localhost -U postgres -d report_manager_database  -p 5432 -f C:\funda_components\system_user\system_user_database\utility_functions\trig_log_allowed_actions_history.sql 1>> install_system_user_schema_and_objects.log 2>>&1

"C:\Program Files\PostgreSQL\9.4\bin\psql.exe" -h localhost -U postgres -d report_manager_database  -p 5432 -f C:\funda_components\system_user\system_user_database\utility_functions\trig_log_user_history.sql 1>> install_system_user_schema_and_objects.log 2>>&1

"C:\Program Files\PostgreSQL\9.4\bin\psql.exe" -h localhost -U postgres -d report_manager_database  -p 5432 -f C:\funda_components\system_user\system_user_database\utility_functions\install_master_user.sql 1> install_master_user.log 2>&1

"C:\Program Files\PostgreSQL\9.4\bin\psql.exe" -h localhost -U postgres -d report_manager_database  -p 5432 -f C:\funda_components\system_user\system_user_database\utility_functions\run_install_master_user.sql 1>> install_master_user.log 2>>&1

