REM install_program_manager_test_db.bat

"C:\Program Files\PostgreSQL\9.6\bin\psql.exe" -h localhost -U postgres  -p 5432 -f create_program_manager_test_db.sql 1> install_program_manager_test_db.log 2>&1

"C:\Program Files\PostgreSQL\9.6\bin\psql.exe" -h localhost -U postgres -d program_manager_test_db  -p 5432 -f install_pgcrypto.sql  1>> install_program_manager_test_db.log 2>>&1


REM install the schema
"C:\Program Files\PostgreSQL\9.6\bin\psql.exe" -h localhost -U postgres -d program_manager_test_db  -p 5432 -f C:\funda_components\system_user\system_user_database\create_system_user_schema.sql  1>> install_program_manager_test_db.log 2>>&1

REM install the objects
"C:\Program Files\PostgreSQL\9.6\bin\psql.exe" -h localhost -U postgres -d program_manager_test_db  -p 5432 -f C:\funda_components\system_user\system_user_database\table_definitions\system_users.sql  1>> install_program_manager_test_db.log 2>>&1

"C:\Program Files\PostgreSQL\9.6\bin\psql.exe" -h localhost -U postgres -d program_manager_test_db  -p 5432 -f C:\funda_components\system_user\system_user_database\table_definitions\system_users_history.sql  1>> install_program_manager_test_db.log 2>>&1

"C:\Program Files\PostgreSQL\9.6\bin\psql.exe" -h localhost -U postgres -d program_manager_test_db  -p 5432 -f C:\funda_components\system_user\system_user_database\table_definitions\system_user_state.sql 1>> install_program_manager_test_db.log 2>>&1

"C:\Program Files\PostgreSQL\9.6\bin\psql.exe" -h localhost -U postgres -d program_manager_test_db  -p 5432 -f C:\funda_components\system_user\system_user_database\table_definitions\system_user_state_history.sql 1>> install_program_manager_test_db.log 2>>&1

"C:\Program Files\PostgreSQL\9.6\bin\psql.exe" -h localhost -U postgres -d program_manager_test_db  -p 5432 -f C:\funda_components\system_user\system_user_database\table_definitions\system_actions.sql 1>> install_program_manager_test_db.log 2>>&1

"C:\Program Files\PostgreSQL\9.6\bin\psql.exe" -h localhost -U postgres -d program_manager_test_db  -p 5432 -f C:\funda_components\system_user\system_user_database\table_definitions\system_user_allowed_actions.sql 1>> install_program_manager_test_db.log 2>>&1

"C:\Program Files\PostgreSQL\9.6\bin\psql.exe" -h localhost -U postgres -d program_manager_test_db  -p 5432 -f C:\funda_components\system_user\system_user_database\table_definitions\system_user_allowed_actions_history.sql 1>> install_program_manager_test_db.log 2>>&1

"C:\Program Files\PostgreSQL\9.6\bin\psql.exe" -h localhost -U postgres -d program_manager_test_db  -p 5432 -f C:\funda_components\system_user\system_user_database\action_functions\action_add_new_user.sql 1>> install_program_manager_test_db.log 2>>&1

"C:\Program Files\PostgreSQL\9.6\bin\psql.exe" -h localhost -U postgres -d program_manager_test_db  -p 5432 -f C:\funda_components\system_user\system_user_database\action_functions\action_change_password.sql 1>> install_program_manager_test_db.log 2>>&1

"C:\Program Files\PostgreSQL\9.6\bin\psql.exe" -h localhost -U postgres -d program_manager_test_db  -p 5432 -f C:\funda_components\system_user\system_user_database\action_functions\action_change_user_allowed_actions.sql 1>> install_program_manager_test_db.log 2>>&1

"C:\Program Files\PostgreSQL\9.6\bin\psql.exe" -h localhost -U postgres -d program_manager_test_db  -p 5432 -f C:\funda_components\system_user\system_user_database\action_functions\action_user_login.sql 1>> install_program_manager_test_db.log 2>>&1

"C:\Program Files\PostgreSQL\9.6\bin\psql.exe" -h localhost -U postgres -d program_manager_test_db  -p 5432 -f C:\funda_components\system_user\system_user_database\action_functions\action_user_logout.sql 1>> install_program_manager_test_db.log 2>>&1

"C:\Program Files\PostgreSQL\9.6\bin\psql.exe" -h localhost -U postgres -d program_manager_test_db  -p 5432 -f C:\funda_components\system_user\system_user_database\action_functions\action_list_users.sql 1>> install_program_manager_test_db.log 2>>&1

"C:\Program Files\PostgreSQL\9.6\bin\psql.exe" -h localhost -U postgres -d program_manager_test_db  -p 5432 -f C:\funda_components\system_user\system_user_database\utility_functions\util_get_user_state.sql 1>> install_program_manager_test_db.log 2>>&1

"C:\Program Files\PostgreSQL\9.6\bin\psql.exe" -h localhost -U postgres -d program_manager_test_db  -p 5432 -f C:\funda_components\system_user\system_user_database\utility_functions\util_is_user_authorized.sql 1>> install_program_manager_test_db.log 2>>&1

"C:\Program Files\PostgreSQL\9.6\bin\psql.exe" -h localhost -U postgres -d program_manager_test_db  -p 5432 -f C:\funda_components\system_user\system_user_database\utility_functions\trig_log_state_history.sql 1>> install_program_manager_test_db.log 2>>&1

"C:\Program Files\PostgreSQL\9.6\bin\psql.exe" -h localhost -U postgres -d program_manager_test_db  -p 5432 -f C:\funda_components\system_user\system_user_database\utility_functions\trig_log_allowed_actions_history.sql 1>> install_program_manager_test_db.log 2>>&1

"C:\Program Files\PostgreSQL\9.6\bin\psql.exe" -h localhost -U postgres -d program_manager_test_db  -p 5432 -f C:\funda_components\system_user\system_user_database\utility_functions\trig_log_user_history.sql 1>> install_program_manager_test_db.log 2>>&1

"C:\Program Files\PostgreSQL\9.6\bin\psql.exe" -h localhost -U postgres -d program_manager_test_db  -p 5432 -f C:\funda_components\system_user\system_user_database\utility_functions\insert_master_user_actions_for_a_service.sql 1>> install_program_manager_test_db.log 2>>&1

"C:\Program Files\PostgreSQL\9.6\bin\psql.exe" -h localhost -U postgres -d program_manager_test_db  -p 5432 -f C:\funda_components\system_user\system_user_database\utility_functions\install_master_user.sql 1>> install_program_manager_test_db.log 2>>&1


REM install the programs_manager_schema
"C:\Program Files\PostgreSQL\9.6\bin\psql.exe" -h localhost -U postgres -d program_manager_test_db  -p 5432 -f C:\funda_components\programs_manager\programs_manager_database\create_programs_manager_schema.sql  1>> install_program_manager_test_db.log 2>>&1

"C:\Program Files\PostgreSQL\9.6\bin\psql.exe" -h localhost -U postgres -d program_manager_test_db  -p 5432 -f C:\funda_components\programs_manager\programs_manager_database\table_definitions\insert_system_actions_for_prgrm_mngr.sql  1>> install_program_manager_test_db.log 2>>&1

REM Install the programs_manager_schema objects

REM Install the tables
"C:\Program Files\PostgreSQL\9.6\bin\psql.exe" -h localhost -U postgres -d program_manager_test_db  -p 5432 -f C:\funda_components\programs_manager\programs_manager_database\table_definitions\organizations.sql  1>> install_program_manager_test_db.log 2>>&1 

"C:\Program Files\PostgreSQL\9.6\bin\psql.exe" -h localhost -U postgres -d program_manager_test_db  -p 5432 -f C:\funda_components\programs_manager\programs_manager_database\table_definitions\organizations_history.sql  1>> install_program_manager_test_db.log 2>>&1 

"C:\Program Files\PostgreSQL\9.6\bin\psql.exe" -h localhost -U postgres -d program_manager_test_db  -p 5432 -f C:\funda_components\programs_manager\programs_manager_database\table_definitions\organization_level.sql  1>> install_program_manager_test_db.log 2>>&1 

"C:\Program Files\PostgreSQL\9.6\bin\psql.exe" -h localhost -U postgres -d program_manager_test_db  -p 5432 -f C:\funda_components\programs_manager\programs_manager_database\table_definitions\organization_level_history.sql  1>> install_program_manager_test_db.log 2>>&1 

"C:\Program Files\PostgreSQL\9.6\bin\psql.exe" -h localhost -U postgres -d program_manager_test_db  -p 5432 -f C:\funda_components\programs_manager\programs_manager_database\table_definitions\programs.sql  1>> install_program_manager_test_db.log 2>>&1 

"C:\Program Files\PostgreSQL\9.6\bin\psql.exe" -h localhost -U postgres -d program_manager_test_db  -p 5432 -f C:\funda_components\programs_manager\programs_manager_database\table_definitions\programs_history.sql  1>> install_program_manager_test_db.log 2>>&1 

REM Install action functions
REM "C:\Program Files\PostgreSQL\9.6\bin\psql.exe" -h localhost -U postgres -d program_manager_test_db  -p 5432 -f C:\funda_components\programs_manager\programs_manager_database\action_functions\action_enter_edit_organizations.sql  1>> install_program_manager_test_db.log 2>>&1 

REM Install tnhe master user
"C:\Program Files\PostgreSQL\9.6\bin\psql.exe" -h localhost -U postgres -d program_manager_test_db  -p 5432 -f C:\funda_components\system_user\system_user_database\utility_functions\run_install_master_user.sql 1>> install_program_manager_test_db.log 2>>&1
