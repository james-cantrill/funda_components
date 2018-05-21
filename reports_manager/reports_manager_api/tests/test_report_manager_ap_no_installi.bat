REM test_report_manager_api.bat
REM -------------------------------------------
REM install db
REM call C:\funda_components\reports_manager\report_manager_database\reports_manager_test_db\install_reports_manager_test_db.bat

curl http://localhost:4000/report_manager  1> test_report_manager_api.log 2>&1

curl http://localhost:3000/system_user_manager/user_login?"login=opal&password=spade"  1>> test_report_manager_api.log 2>>&1

REM curl http://localhost:4000/report_manager/load_report_list?"login=opal"  1>> test_report_manager_api.log 2>>&1

curl http://localhost::4000/report_manager/load_selected_report?"login=opal&report_id=0a852797-b958-4322-af88-64ff07c3d529"

curl http://localhost:4000/report_manager/load_selected_report?"login=opal&report_id=adcadc2f-3b8d-4b2b-b550-c7f2116c30e9"  1>> test_report_manager_api.log 2>>&1

REM curl http://localhost::4000/report_manager/load_selected_report?login=opal&report_id=0263704a-6779-4b8c-a4f3-6e6303fbf785  1>> test_report_manager_api.log 2>>&1

curl http://localhost:3000/system_user_manager/user_logout?"login=opal"  1>> test_report_manager_api.log 


