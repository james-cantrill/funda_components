REM install db
call C:\funda_components\steps_reports\steps_reports_db\install_steps_reports_db.bat

"C:\Program Files\PostgreSQL\9.6\bin\psql.exe" -h localhost -U postgres -d steps_reports_db  -p 5432 -f C:\funda_components\steps_reports\steps_reports_db\install_test_users_reports.sql  1> install_test_users_reports.log 2>&1
