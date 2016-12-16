REM install_programs_manager_schema_and_objects.bat

REM install the schema
"C:\Program Files\PostgreSQL\9.4\bin\psql.exe" -h localhost -U postgres -d report_manager_database  -p 5432 -f C:\funda_components\programs_manager\programs_manager_database\create_programs_manager_schema.sql  1> install_programs_manager_schema_and_objects.log 2>&1 

REM -- insert the actions for the programs_manager service that require authorization.
"C:\Program Files\PostgreSQL\9.4\bin\psql.exe" -h localhost -U postgres -d report_manager_database  -p 5432 -f C:\funda_components\programs_manager\programs_manager_database\table_definitions\insert_system_actions_for_prgrm_mngr.sql  1>> install_programs_manager_schema_and_objects.log 2>>&1 

REM install the objects
"C:\Program Files\PostgreSQL\9.4\bin\psql.exe" -h localhost -U postgres -d report_manager_database  -p 5432 -f C:\funda_components\programs_manager\programs_manager_database\table_definitions\organizations.sql  1>> install_programs_manager_schema_and_objects.log 2>>&1 

"C:\Program Files\PostgreSQL\9.4\bin\psql.exe" -h localhost -U postgres -d report_manager_database  -p 5432 -f C:\funda_components\programs_manager\programs_manager_database\table_definitions\program_folders.sql  1>> install_programs_manager_schema_and_objects.log 2>>&1 

"C:\Program Files\PostgreSQL\9.4\bin\psql.exe" -h localhost -U postgres -d report_manager_database  -p 5432 -f C:\funda_components\programs_manager\programs_manager_database\table_definitions\programs.sql  1>> install_programs_manager_schema_and_objects.log 2>>&1 

"C:\Program Files\PostgreSQL\9.4\bin\psql.exe" -h localhost -U postgres -d report_manager_database  -p 5432 -f C:\funda_components\programs_manager\programs_manager_database\table_definitions\system_user_allowed_programs.sql  1>> install_programs_manager_schema_and_objects.log 2>>&1 

"C:\Program Files\PostgreSQL\9.4\bin\psql.exe" -h localhost -U postgres -d report_manager_database  -p 5432 -f C:\funda_components\programs_manager\programs_manager_database\table_definitions\system_user_allowed_programs_history.sql  1>> install_programs_manager_schema_and_objects.log 2>>&1 

"C:\Program Files\PostgreSQL\9.4\bin\psql.exe" -h localhost -U postgres -d report_manager_database  -p 5432 -f C:\funda_components\programs_manager\programs_manager_database\table_definitions\system_user_allowed_organizations.sql  1>> install_programs_manager_schema_and_objects.log 2>>&1 

"C:\Program Files\PostgreSQL\9.4\bin\psql.exe" -h localhost -U postgres -d report_manager_database  -p 5432 -f C:\funda_components\programs_manager\programs_manager_database\table_definitions\system_user_allowed_organizations_history.sql  1>> install_programs_manager_schema_and_objects.log 2>>&1 

"C:\Program Files\PostgreSQL\9.4\bin\psql.exe" -h localhost -U postgres -d report_manager_database  -p 5432 -f C:\funda_components\programs_manager\programs_manager_database\table_definitions\insert_continua.sql  1>> install_programs_manager_schema_and_objects.log 2>>&1 

"C:\Program Files\PostgreSQL\9.4\bin\psql.exe" -h localhost -U postgres -d report_manager_database  -p 5432 -f C:\funda_components\programs_manager\programs_manager_database\table_definitions\insert_organizations.sql  1>> install_programs_manager_schema_and_objects.log 2>>&1 

"C:\Program Files\PostgreSQL\9.4\bin\psql.exe" -h localhost -U postgres -d report_manager_database  -p 5432 -f C:\funda_components\programs_manager\programs_manager_database\table_definitions\insert_programs.sql  1>> install_programs_manager_schema_and_objects.log 2>>&1 

"C:\Program Files\PostgreSQL\9.4\bin\psql.exe" -h localhost -U postgres -d report_manager_database  -p 5432 -f C:\funda_components\programs_manager\programs_manager_database\action_functions\action_change_program_user_visibility.sql  1>> install_programs_manager_schema_and_objects.log 2>>&1 

"C:\Program Files\PostgreSQL\9.4\bin\psql.exe" -h localhost -U postgres -d report_manager_database  -p 5432 -f C:\funda_components\programs_manager\programs_manager_database\action_functions\action_list_user_visible_organizations.sql  1>> install_programs_manager_schema_and_objects.log 2>>&1 

"C:\Program Files\PostgreSQL\9.4\bin\psql.exe" -h localhost -U postgres -d report_manager_database  -p 5432 -f C:\funda_components\programs_manager\programs_manager_database\action_functions\action_list_user_visible_programs.sql  1>> install_programs_manager_schema_and_objects.log 2>>&1 

"C:\Program Files\PostgreSQL\9.4\bin\psql.exe" -h localhost -U postgres -d report_manager_database  -p 5432 -f C:\funda_components\programs_manager\programs_manager_database\action_functions\action_change_organization_user_visibility.sql  1>> install_programs_manager_schema_and_objects.log 2>>&1 

"C:\Program Files\PostgreSQL\9.4\bin\psql.exe" -h localhost -U postgres -d report_manager_database  -p 5432 -f C:\funda_components\programs_manager\programs_manager_database\utility_functions\trig_log_user_allowed_programs_history.sql  1>> install_programs_manager_schema_and_objects.log 2>>&1 

REM add master user
"C:\Program Files\PostgreSQL\9.4\bin\psql.exe" -h localhost -U postgres -d report_manager_database  -p 5432 -f C:\funda_components\programs_manager\programs_manager_database\utility_functions\insert_master_user_report_manager_actions.sql  1>> install_programs_manager_schema_and_objects.log 2>>&1 

"C:\Program Files\PostgreSQL\9.4\bin\psql.exe" -h localhost -U postgres -d report_manager_database  -p 5432 -f C:\funda_components\programs_manager\programs_manager_database\utility_functions\run_insert_master_user_prgrm_mngr_actions.sql  1>> install_programs_manager_schema_and_objects.log 2>>&1 

REM add organizations, folders,and programs
"C:\Program Files\PostgreSQL\9.4\bin\psql.exe" -h localhost -U postgres -d report_manager_database  -p 5432 -f C:\funda_components\programs_manager\programs_manager_database\table_definitions\insert_organizations_program_folders_and_programs.sql  1>> install_programs_manager_schema_and_objects.log 2>>&1 

