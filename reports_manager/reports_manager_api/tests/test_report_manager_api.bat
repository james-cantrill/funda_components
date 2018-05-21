REM test_report_manager_api.bat
REM -------------------------------------------
REM install db
call C:\funda_components\reports_manager\report_manager_database\reports_manager_test_db\install_reports_manager_test_db.bat

curl http://localhost:4000/report_manager  1> test_report_manager_api.log 2>&1

curl http://localhost:3000/system_user_manager/user_login?"login=opal&password=spade"  1>> test_report_manager_api.log 2>>&1

curl http://localhost:4000/report_manager/load_report_list?"login=opal"  1>> test_report_manager_api.log 2>>&1

curl http://localhost:4000/report_manager/load_selected_report?"login=opal&report_id=1c102420-bea6-4d56-a338-1fc37bde8221"  1>> test_report_manager_api.log 2>>&1

curl http://localhost:4000/report_manager/load_selected_report?"login=opal&report_id=dd925661-15fa-4118-b113-d0fae6316f03"  1>> test_report_manager_api.log 2>>&1
REM curl http://localhost:4000/report_manager/load_selected_report?login=opal&report_id=e9a34faf-2be2-48d7-a044-9f8ebfc28a85

curl http://localhost:3000/system_user_manager/user_logout?"login=opal"  1>> test_report_manager_api.log 


