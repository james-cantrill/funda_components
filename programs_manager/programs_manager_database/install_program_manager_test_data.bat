

REM install db
call C:\funda_components\reports_manager\report_manager_database\reports_manager_test_db\install_reports_manager_test_db.bat

"C:\Program Files\PostgreSQL\9.6\bin\psql.exe" -h localhost -U postgres -d reports_manager_test_db  -p 5432 -f C:\funda_components\programs_manager\programs_manager_database\install_program_manager_test_data.sql 1> install_program_manager_test_data.log 2>&1 

