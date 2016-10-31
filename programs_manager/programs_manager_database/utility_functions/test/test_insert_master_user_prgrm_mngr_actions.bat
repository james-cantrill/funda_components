REM test_insert_master_user_prgrm_mngr_actions.bat
REM "C:\Program Files\PostgreSQL\9.4\bin\psql.exe" -h localhost -U postgres -d report_manager_database  -p 5432 -f ..\insert_master_user_prgrm_mngr_actions.sql 1> test_insert_master_user_prgrm_mngr_actions.log 2>&1 

"C:\Program Files\PostgreSQL\9.4\bin\psql.exe" -h localhost -U postgres -d report_manager_database  -p 5432 -f test_insert_master_user_prgrm_mngr_actions.sql  1>> test_insert_master_user_prgrm_mngr_actions.log 2>>&1 
