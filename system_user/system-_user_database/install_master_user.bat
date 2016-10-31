REM install_master_user.bat

"C:\Program Files\PostgreSQL\9.4\bin\psql.exe" -h localhost -U postgres -d report_manager_database  -p 5432 -f C:\Reporting_application\system_user\system_user_database\utility_functions\install_master_user.sql 1> install_master_user.log 2>&1

"C:\Program Files\PostgreSQL\9.4\bin\psql.exe" -h localhost -U postgres -d report_manager_database  -p 5432 -f C:\Reporting_application\system_user\system_user_database\utility_functions\run_install_master_user.sql 1>> install_master_user.log 2>>&1
