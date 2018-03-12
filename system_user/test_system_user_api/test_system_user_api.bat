REM test_system_user_api.bat
REM -------------------------------------------

curl http://localhost:3000/  1> test_system_user_api.log 

curl http://localhost:3000/system_user_manager/user_login?"login=muser&password=master"  1>> test_system_user_api.log 

curl http://localhost:3000/system_user_manager/user_logout?"login=muser"  1>> test_system_user_api.log 


