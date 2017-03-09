REM test_pop_allowed_programs.bat

"C:\Program Files\PostgreSQL\9.4\bin\psql.exe" -h localhost -U postgres -d report_manager_database  -p 5432 -f ..\pop_allowed_programs.sql 1> test_pop_allowed_programs.log 2>&1 

REM "C:\Program Files\PostgreSQL\9.4\bin\psql.exe" -h localhost -U postgres -d report_manager_database  -p 5432 -f C:\funda_components\programs_manager\programs_manager_database\table_definitions\insert_organizations_program_folders_and_programs.sql  1>> test_pop_allowed_programs.log 2>>&1 

"C:\Program Files\PostgreSQL\9.4\bin\psql.exe" -h localhost -U postgres -d report_manager_database  -p 5432 -f set_up_test_pop_allowed_programs.sql  1>> test_pop_allowed_programs.log 2>>&1 

"C:\Program Files\PostgreSQL\9.4\bin\psql.exe" -h localhost -U postgres -d report_manager_database  -p 5432 -f test_pop_allowed_programs.sql  1>> test_pop_allowed_programs.log 2>>&1 
