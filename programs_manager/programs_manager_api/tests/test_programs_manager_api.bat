REM test_report_manager_api.bat
REM -------------------------------------------
REM install db
call C:\funda_components\reports_manager\report_manager_database\reports_manager_test_db\install_reports_manager_test_db.bat

curl http://localhost:5000/programs_manager  1> test_report_manager_api.log 2>&1

curl http://localhost:3000/system_user_manager/user_login?"login=opal&password=spade"  1>> test_report_manager_api.log 2>>&1

curl http://localhost:5000/programs_manager/load_program_list?"login=opal"  1>> test_report_manager_api.log 2>>&1

curl http://localhost:3000/system_user_manager/user_logout?"login=opal"  1>> test_report_manager_api.log 

curl http://localhost:3000/system_user_manager/user_login?"login=muser&password=master"  1>> test_report_manager_api.log 2>>&1

curl http://localhost:5000/programs_manager/load_program_list?"login=muser"  1>> test_report_manager_api.log 2>>&1

curl http://localhost:3000/system_user_manager/user_logout?"login=muser"  1>> test_report_manager_api.log 

