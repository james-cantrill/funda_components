REM install_reports_manager_test_db.bat

"C:\Program Files\PostgreSQL\9.6\bin\psql.exe" -h localhost -U postgres  -p 5432 -f C:\funda_components\reports_manager\report_manager_database\reports_manager_test_db\create_reports_manager_test_db.sql 1> install_reports_manager_test_db.log 2>&1

"C:\Program Files\PostgreSQL\9.6\bin\psql.exe" -h localhost -U postgres -d reports_manager_test_db  -p 5432 -f C:\funda_components\reports_manager\report_manager_database\reports_manager_test_db\install_pgcrypto.sql  1>> install_reports_manager_test_db.log 2>>&1

REM ****************************************************************
REM install the schema
"C:\Program Files\PostgreSQL\9.6\bin\psql.exe" -h localhost -U postgres -d reports_manager_test_db  -p 5432 -f C:\funda_components\system_user\system_user_database\create_system_user_schema.sql  1>> install_reports_manager_test_db.log 2>>&1

REM install the objects
"C:\Program Files\PostgreSQL\9.6\bin\psql.exe" -h localhost -U postgres -d reports_manager_test_db  -p 5432 -f C:\funda_components\system_user\system_user_database\table_definitions\system_users.sql  1>> install_reports_manager_test_db.log 2>>&1

"C:\Program Files\PostgreSQL\9.6\bin\psql.exe" -h localhost -U postgres -d reports_manager_test_db  -p 5432 -f C:\funda_components\system_user\system_user_database\table_definitions\system_users_history.sql  1>> install_reports_manager_test_db.log 2>>&1

"C:\Program Files\PostgreSQL\9.6\bin\psql.exe" -h localhost -U postgres -d reports_manager_test_db  -p 5432 -f C:\funda_components\system_user\system_user_database\table_definitions\system_user_state.sql 1>> install_reports_manager_test_db.log 2>>&1

"C:\Program Files\PostgreSQL\9.6\bin\psql.exe" -h localhost -U postgres -d reports_manager_test_db  -p 5432 -f C:\funda_components\system_user\system_user_database\table_definitions\system_user_state_history.sql 1>> install_reports_manager_test_db.log 2>>&1

"C:\Program Files\PostgreSQL\9.6\bin\psql.exe" -h localhost -U postgres -d reports_manager_test_db  -p 5432 -f C:\funda_components\system_user\system_user_database\table_definitions\system_actions.sql 1>> install_reports_manager_test_db.log 2>>&1

"C:\Program Files\PostgreSQL\9.6\bin\psql.exe" -h localhost -U postgres -d reports_manager_test_db  -p 5432 -f C:\funda_components\system_user\system_user_database\table_definitions\system_user_allowed_actions.sql 1>> install_reports_manager_test_db.log 2>>&1

"C:\Program Files\PostgreSQL\9.6\bin\psql.exe" -h localhost -U postgres -d reports_manager_test_db  -p 5432 -f C:\funda_components\system_user\system_user_database\table_definitions\system_user_allowed_actions_history.sql 1>> install_reports_manager_test_db.log 2>>&1

"C:\Program Files\PostgreSQL\9.6\bin\psql.exe" -h localhost -U postgres -d reports_manager_test_db  -p 5432 -f C:\funda_components\system_user\system_user_database\action_functions\action_add_new_user.sql 1>> install_reports_manager_test_db.log 2>>&1

"C:\Program Files\PostgreSQL\9.6\bin\psql.exe" -h localhost -U postgres -d reports_manager_test_db  -p 5432 -f C:\funda_components\system_user\system_user_database\action_functions\action_change_password.sql 1>> install_reports_manager_test_db.log 2>>&1

"C:\Program Files\PostgreSQL\9.6\bin\psql.exe" -h localhost -U postgres -d reports_manager_test_db  -p 5432 -f C:\funda_components\system_user\system_user_database\action_functions\action_change_user_allowed_actions.sql 1>> install_reports_manager_test_db.log 2>>&1

"C:\Program Files\PostgreSQL\9.6\bin\psql.exe" -h localhost -U postgres -d reports_manager_test_db  -p 5432 -f C:\funda_components\system_user\system_user_database\action_functions\action_user_login.sql 1>> install_reports_manager_test_db.log 2>>&1

"C:\Program Files\PostgreSQL\9.6\bin\psql.exe" -h localhost -U postgres -d reports_manager_test_db  -p 5432 -f C:\funda_components\system_user\system_user_database\action_functions\action_user_logout.sql 1>> install_reports_manager_test_db.log 2>>&1

"C:\Program Files\PostgreSQL\9.6\bin\psql.exe" -h localhost -U postgres -d reports_manager_test_db  -p 5432 -f C:\funda_components\system_user\system_user_database\action_functions\action_list_users.sql 1>> install_reports_manager_test_db.log 2>>&1

"C:\Program Files\PostgreSQL\9.6\bin\psql.exe" -h localhost -U postgres -d reports_manager_test_db  -p 5432 -f C:\funda_components\system_user\system_user_database\utility_functions\util_get_user_state.sql 1>> install_reports_manager_test_db.log 2>>&1

"C:\Program Files\PostgreSQL\9.6\bin\psql.exe" -h localhost -U postgres -d reports_manager_test_db  -p 5432 -f C:\funda_components\system_user\system_user_database\utility_functions\util_is_user_authorized.sql 1>> install_reports_manager_test_db.log 2>>&1

"C:\Program Files\PostgreSQL\9.6\bin\psql.exe" -h localhost -U postgres -d reports_manager_test_db  -p 5432 -f C:\funda_components\system_user\system_user_database\utility_functions\trig_log_state_history.sql 1>> install_reports_manager_test_db.log 2>>&1

"C:\Program Files\PostgreSQL\9.6\bin\psql.exe" -h localhost -U postgres -d reports_manager_test_db  -p 5432 -f C:\funda_components\system_user\system_user_database\utility_functions\trig_log_allowed_actions_history.sql 1>> install_reports_manager_test_db.log 2>>&1

"C:\Program Files\PostgreSQL\9.6\bin\psql.exe" -h localhost -U postgres -d reports_manager_test_db  -p 5432 -f C:\funda_components\system_user\system_user_database\utility_functions\trig_log_user_history.sql 1>> install_reports_manager_test_db.log 2>>&1

"C:\Program Files\PostgreSQL\9.6\bin\psql.exe" -h localhost -U postgres -d reports_manager_test_db  -p 5432 -f C:\funda_components\system_user\system_user_database\utility_functions\insert_master_user_actions_for_a_service.sql 1>> install_reports_manager_test_db.log 2>>&1

"C:\Program Files\PostgreSQL\9.6\bin\psql.exe" -h localhost -U postgres -d reports_manager_test_db  -p 5432 -f C:\funda_components\system_user\system_user_database\utility_functions\install_master_user.sql 1>> install_reports_manager_test_db.log 2>>&1

REM ****************************************************************

REM install the programs_manager_schema
"C:\Program Files\PostgreSQL\9.6\bin\psql.exe" -h localhost -U postgres -d reports_manager_test_db  -p 5432 -f C:\funda_components\programs_manager\programs_manager_database\create_programs_manager_schema.sql  1>> install_reports_manager_test_db.log 2>>&1

"C:\Program Files\PostgreSQL\9.6\bin\psql.exe" -h localhost -U postgres -d reports_manager_test_db  -p 5432 -f C:\funda_components\programs_manager\programs_manager_database\table_definitions\insert_system_actions_for_prgrm_mngr.sql  1>> install_reports_manager_test_db.log 2>>&1

REM Install the programs_manager_schema objects

REM Install the tables
"C:\Program Files\PostgreSQL\9.6\bin\psql.exe" -h localhost -U postgres -d reports_manager_test_db  -p 5432 -f C:\funda_components\programs_manager\programs_manager_database\table_definitions\organizations.sql  1>> install_reports_manager_test_db.log 2>>&1 

"C:\Program Files\PostgreSQL\9.6\bin\psql.exe" -h localhost -U postgres -d reports_manager_test_db  -p 5432 -f C:\funda_components\programs_manager\programs_manager_database\table_definitions\organizations_history.sql  1>> install_reports_manager_test_db.log 2>>&1 

"C:\Program Files\PostgreSQL\9.6\bin\psql.exe" -h localhost -U postgres -d reports_manager_test_db  -p 5432 -f C:\funda_components\programs_manager\programs_manager_database\table_definitions\organization_level.sql  1>> install_reports_manager_test_db.log 2>>&1 

"C:\Program Files\PostgreSQL\9.6\bin\psql.exe" -h localhost -U postgres -d reports_manager_test_db  -p 5432 -f C:\funda_components\programs_manager\programs_manager_database\table_definitions\organization_level_history.sql  1>> install_reports_manager_test_db.log 2>>&1 

"C:\Program Files\PostgreSQL\9.6\bin\psql.exe" -h localhost -U postgres -d reports_manager_test_db  -p 5432 -f C:\funda_components\programs_manager\programs_manager_database\table_definitions\programs.sql  1>> install_reports_manager_test_db.log 2>>&1 

"C:\Program Files\PostgreSQL\9.6\bin\psql.exe" -h localhost -U postgres -d reports_manager_test_db  -p 5432 -f C:\funda_components\programs_manager\programs_manager_database\table_definitions\programs_history.sql  1>> install_reports_manager_test_db.log 2>>&1 

"C:\Program Files\PostgreSQL\9.6\bin\psql.exe" -h localhost -U postgres -d reports_manager_test_db  -p 5432 -f C:\funda_components\programs_manager\programs_manager_database\table_definitions\system_user_allowed_programs.sql  1>> install_reports_manager_test_db.log 2>>&1 

"C:\Program Files\PostgreSQL\9.6\bin\psql.exe" -h localhost -U postgres -d reports_manager_test_db  -p 5432 -f C:\funda_components\programs_manager\programs_manager_database\table_definitions\system_user_allowed_programs_history.sql  1>> install_reports_manager_test_db.log 2>>&1 

REM Install action functions
"C:\Program Files\PostgreSQL\9.6\bin\psql.exe" -h localhost -U postgres -d reports_manager_test_db  -p 5432 -f C:\funda_components\programs_manager\programs_manager_database\action_functions\action_enter_edit_organizations.sql  1>> install_reports_manager_test_db.log 2>>&1 

"C:\Program Files\PostgreSQL\9.6\bin\psql.exe" -h localhost -U postgres -d reports_manager_test_db  -p 5432 -f C:\funda_components\programs_manager\programs_manager_database\utility_functions\trig_log_organizations_history.sql 1>> install_reports_manager_test_db.log 2>>&1 

"C:\Program Files\PostgreSQL\9.6\bin\psql.exe" -h localhost -U postgres -d reports_manager_test_db  -p 5432 -f ..\action_enter_edit_organization_level.sql 1>> install_reports_manager_test_db.log 2>>&1 
 
"C:\Program Files\PostgreSQL\9.6\bin\psql.exe" -h localhost -U postgres -d reports_manager_test_db  -p 5432 -f C:\funda_components\programs_manager\programs_manager_database\utility_functions\trig_log_organization_level_history.sql 1>> install_reports_manager_test_db.log 2>>&1 

"C:\Program Files\PostgreSQL\9.6\bin\psql.exe" -h localhost -U postgres -d reports_manager_test_db  -p 5432 -f ..\action_enter_edit_programs.sql 1>> install_reports_manager_test_db.log 2>>&1 

"C:\Program Files\PostgreSQL\9.6\bin\psql.exe" -h localhost -U postgres -d reports_manager_test_db  -p 5432 -f C:\funda_components\programs_manager\programs_manager_database\utility_functions\trig_log_programs_history.sql 1>> install_reports_manager_test_db.log 2>>&1 

"C:\Program Files\PostgreSQL\9.6\bin\psql.exe" -h localhost -U postgres -d reports_manager_test_db  -p 5432 -f ..\action_change_program_user_visibility.sql 1>> install_reports_manager_test_db.log 2>>&1 

"C:\Program Files\PostgreSQL\9.6\bin\psql.exe" -h localhost -U postgres -d reports_manager_test_db  -p 5432 -f C:\funda_components\programs_manager\programs_manager_database\utility_functions\trig_log_user_allowed_programs_history.sql 1>> install_reports_manager_test_db.log 2>>&1 

REM  **************************************************************

REM install the report_manager_schema
"C:\Program Files\PostgreSQL\9.6\bin\psql.exe" -h localhost -U postgres -d reports_manager_test_db  -p 5432 -f C:\funda_components\reports_manager\report_manager_database\reports_manager_test_db\report_manager_schema.sql  1>> install_reports_manager_test_db.log 2>>&1 

REM install the report_manager_schema tables
"C:\Program Files\PostgreSQL\9.6\bin\psql.exe" -h localhost -U postgres -d reports_manager_test_db  -p 5432 -f C:\funda_components\reports_manager\report_manager_database\table_definitions\parameter_list.sql  1>> install_reports_manager_test_db.log 2>>&1 

"C:\Program Files\PostgreSQL\9.6\bin\psql.exe" -h localhost -U postgres -d reports_manager_test_db  -p 5432 -f C:\funda_components\reports_manager\report_manager_database\table_definitions\parameter_list_history.sql  1>> install_reports_manager_test_db.log 2>>&1 

"C:\Program Files\PostgreSQL\9.6\bin\psql.exe" -h localhost -U postgres -d reports_manager_test_db  -p 5432 -f C:\funda_components\reports_manager\report_manager_database\table_definitions\report_folders.sql  1>> install_reports_manager_test_db.log 2>>&1 

"C:\Program Files\PostgreSQL\9.6\bin\psql.exe" -h localhost -U postgres -d reports_manager_test_db  -p 5432 -f C:\funda_components\reports_manager\report_manager_database\table_definitions\report_folders_history.sql  1>> install_reports_manager_test_db.log 2>>&1 

"C:\Program Files\PostgreSQL\9.6\bin\psql.exe" -h localhost -U postgres -d reports_manager_test_db  -p 5432 -f C:\funda_components\reports_manager\report_manager_database\table_definitions\reports.sql  1>> install_reports_manager_test_db.log 2>>&1 

"C:\Program Files\PostgreSQL\9.6\bin\psql.exe" -h localhost -U postgres -d reports_manager_test_db  -p 5432 -f C:\funda_components\reports_manager\report_manager_database\table_definitions\reports_history.sql  1>> install_reports_manager_test_db.log 2>>&1 

"C:\Program Files\PostgreSQL\9.6\bin\psql.exe" -h localhost -U postgres -d reports_manager_test_db  -p 5432 -f C:\funda_components\reports_manager\report_manager_database\table_definitions\report_parameters.sql  1>> install_reports_manager_test_db.log 2>>&1 

"C:\Program Files\PostgreSQL\9.6\bin\psql.exe" -h localhost -U postgres -d reports_manager_test_db  -p 5432 -f C:\funda_components\reports_manager\report_manager_database\table_definitions\report_parameters_history.sql  1>> install_reports_manager_test_db.log 2>>&1 

"C:\Program Files\PostgreSQL\9.6\bin\psql.exe" -h localhost -U postgres -d reports_manager_test_db  -p 5432 -f C:\funda_components\reports_manager\report_manager_database\table_definitions\system_user_allowed_reports.sql  1>> install_reports_manager_test_db.log 2>>&1 

"C:\Program Files\PostgreSQL\9.6\bin\psql.exe" -h localhost -U postgres -d reports_manager_test_db  -p 5432 -f C:\funda_components\reports_manager\report_manager_database\table_definitions\system_user_allowed_reports_history.sql  1>> install_reports_manager_test_db.log 2>>&1 

"C:\Program Files\PostgreSQL\9.6\bin\psql.exe" -h localhost -U postgres -d reports_manager_test_db  -p 5432 -f C:\funda_components\reports_manager\report_manager_database\table_definitions\insert_system_actions_for_report_manager.sql  1>> install_reports_manager_test_db.log 2>>&1 

REM Install the action functions and triggers
"C:\Program Files\PostgreSQL\9.6\bin\psql.exe" -h localhost -U postgres -d reports_manager_test_db  -p 5432 -f C:\funda_components\reports_manager\report_manager_database\action_functions\action_enter_edit_folders.sql 1>> install_reports_manager_test_db.log 2>>&1 

"C:\Program Files\PostgreSQL\9.6\bin\psql.exe" -h localhost -U postgres -d reports_manager_test_db  -p 5432 -f C:\funda_components\reports_manager\report_manager_database\utility_functions\trig_log_folders_history.sql  1>> install_reports_manager_test_db.log 2>>&1 

"C:\Program Files\PostgreSQL\9.6\bin\psql.exe" -h localhost -U postgres -d reports_manager_test_db  -p 5432 -f C:\funda_components\reports_manager\report_manager_database\action_functions\action_enter_edit_report_parameters.sql 1>> install_reports_manager_test_db.log 2>>&1 

"C:\Program Files\PostgreSQL\9.6\bin\psql.exe" -h localhost -U postgres -d reports_manager_test_db  -p 5432 -f C:\funda_components\reports_manager\report_manager_database\action_functions\action_enter_edit_reports.sql 1>> install_reports_manager_test_db.log 2>>&1 

"C:\Program Files\PostgreSQL\9.6\bin\psql.exe" -h localhost -U postgres -d reports_manager_test_db  -p 5432 -f C:\funda_components\reports_manager\report_manager_database\utility_functions\trig_log_reports_history.sql  1>> install_reports_manager_test_db.log 2>>&1 

"C:\Program Files\PostgreSQL\9.6\bin\psql.exe" -h localhost -U postgres -d reports_manager_test_db  -p 5432 -f C:\funda_components\reports_manager\report_manager_database\utility_functions\trig_log_report_parameters_history.sql  1>> install_reports_manager_test_db.log 2>>&1 

"C:\Program Files\PostgreSQL\9.6\bin\psql.exe" -h localhost -U postgres -d reports_manager_test_db  -p 5432 -f C:\funda_components\reports_manager\report_manager_database\utility_functions\insert_parameters_in_parameter_list.sql  1>> install_reports_manager_test_db.log 2>>&1 

"C:\Program Files\PostgreSQL\9.6\bin\psql.exe" -h localhost -U postgres -d reports_manager_test_db  -p 5432 -f C:\funda_components\reports_manager\report_manager_database\action_functions\action_enter_edit_allowed_reports.sql 1>> install_reports_manager_test_db.log 2>>&1 

"C:\Program Files\PostgreSQL\9.6\bin\psql.exe" -h localhost -U postgres -d reports_manager_test_db  -p 5432 -f C:\funda_components\reports_manager\report_manager_database\utility_functions\trig_log_system_user_allowed_reports_history.sql  1>> install_reports_manager_test_db.log 2>>&1 

"C:\Program Files\PostgreSQL\9.6\bin\psql.exe" -h localhost -U postgres -d reports_manager_test_db  -p 5432 -f C:\funda_components\reports_manager\report_manager_database\action_functions\action_load_report_list_jstree.sql 1> install_reports_manager_test_db.log 2>&1 


"C:\Program Files\PostgreSQL\9.6\bin\psql.exe" -h localhost -U postgres -d reports_manager_test_db  -p 5432 -f C:\funda_components\reports_manager\report_manager_database\utility_functions\pop_allowed_reports_out_data.sql  1>> install_reports_manager_test_db.log 2>>&1 


REM  *************************************************************
REM Install the master user
"C:\Program Files\PostgreSQL\9.6\bin\psql.exe" -h localhost -U postgres -d reports_manager_test_db  -p 5432 -f C:\funda_components\system_user\system_user_database\utility_functions\run_install_master_user.sql 1>> install_reports_manager_test_db.log 2>>&1

"C:\Program Files\PostgreSQL\9.6\bin\psql.exe" -h localhost -U postgres -d reports_manager_test_db  -p 5432 -f C:\funda_components\reports_manager\report_manager_database\utility_functions\run_insert_parameters_in_parameter_list.sql  1>> install_reports_manager_test_db.log 2>>&1 

REM **************************************************************************
REM Install the test data
"C:\Program Files\PostgreSQL\9.6\bin\psql.exe" -h localhost -U postgres -d reports_manager_test_db  -p 5432 -f C:\funda_components\reports_manager\report_manager_database\reports_manager_test_db\install_test_data.sql  1> install_reports_manager_test_data.log 2>&1
