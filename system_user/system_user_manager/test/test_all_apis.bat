
REM  off
REM Install the database
REM C:\Reporting_application\system_user\system_user_database\install_system_user_schema_and_objects.bat
REM -------------------------------------------

curl http://localhost:3000/system_user_manager/user_login?"login=muser&password=ha_melech!16"  1> test_all_apis.log 2>&1


REM add users to use in testing
curl http://localhost:3000/system_user_manager/add_one_user?"firstname=John&lastname=Jones&login=jjones&password=alfalfa&changing_user_login=muser"  1>> test_all_apis.log 2>>&1
TIMEOUT 10
curl http://localhost:3000/system_user_manager/add_one_user?"firstname=John&lastname=Smith&login=jsmith&password=grain&changing_user_login=muser"  1>> test_all_apis.log 2>>&1
TIMEOUT 10
curl http://localhost:3000/system_user_manager/add_one_user?"firstname=Barbara&lastname=McKinley&login=mmckinly&password=whoknows&changing_user_login=muser"  1>> test_all_apis.log 2>>&1
TIMEOUT 10
curl http://localhost:3000/system_user_manager/add_one_user?"firstname=Emmet&lastname=Abbot&login=eabot&password=alfalfa&changing_user_login=muser"  1>> test_all_apis.log 2>>&1
TIMEOUT 10
curl http://localhost:3000/system_user_manager/add_one_user?"firstname=Roger&lastname=Walters&login=rwalters&password=office&changing_user_login=muser"  1>> test_all_apis.log 2>>&1
TIMEOUT 10
REM  --------------------------------------------
REM test login and logout
REM  login - Succeed
curl http://localhost:3000/system_user_manager/user_login?"login=jjones&password=alfalfa"  1>> test_all_apis.log 2>>&1
REM login when already logged in - Fail
curl http://localhost:3000/system_user_manager/user_login?"login=jjones&password=alfalfa"  1>> test_all_apis.log 2>>&1
REM logout - Succeed
curl http://localhost:3000/system_user_manager/user_logout?"login=jjones"  1>> test_all_apis.log 2>>&1
REM logout when alreafdy logged out - Fail
curl http://localhost:3000/system_user_manager/user_logout?"login=jjones"  1>> test_all_apis.log 2>>&1

REM log users in an d out to generate history to test the triggers
REM "log them in"
curl http://localhost:3000/system_user_manager/user_login?"login=jjones&password=alfalfa"  1>> test_all_apis.log 2>>&1
TIMEOUT 10
curl http://localhost:3000/system_user_manager/user_login?"login=jsmith&password=grain"  1>> test_all_apis.log 2>>&1
TIMEOUT 10
curl http://localhost:3000/system_user_manager/user_login?"login=mmckinly&password=whoknows"  1>> test_all_apis.log 2>>&1
TIMEOUT 10
curl http://localhost:3000/system_user_manager/user_login?"login=eabot&password=alfalfa"  1>> test_all_apis.log 2>>&1
TIMEOUT 10
curl http://localhost:3000/system_user_manager/user_login?"login=rwalters&password=office"  1>> test_all_apis.log 2>>&1
TIMEOUT 60
REM log them out
curl http://localhost:3000/system_user_manager/user_logout?"login=jjones"  1>> test_all_apis.log 2>>&1
TIMEOUT 10
curl http://localhost:3000/system_user_manager/user_logout?"login=jsmith"  1>> test_all_apis.log 2>>&1
TIMEOUT 10
curl http://localhost:3000/system_user_manager/user_logout?"login=mmckinly"  1>> test_all_apis.log 2>>&1
TIMEOUT 10
curl http://localhost:3000/system_user_manager/user_logout?"login=eabot"  1>> test_all_apis.log 2>>&1
TIMEOUT 10
curl http://localhost:3000/system_user_manager/user_logout?"login=rwalters"  1>> test_all_apis.log 2>>&1

REM Test add_new_user
REM with authorized user not logged in -fail
curl http://localhost:3000/system_user_manager/change_user_allowed_actions?"login=jjones&service=system_user&action=add_new_user&task=allow&changing_user_login=muser"  1>> test_all_apis.log 2>>&1
curl http://localhost:3000/system_user_manager/add_one_user?"firstname=Goody&lastname=Scags&login=gscags&password=office&changing_user_login=jjones"  1>> test_all_apis.log 2>>&1
REM with logged in but unauthorized user - fail
curl http://localhost:3000/system_user_manager/user_login?"login=rwalters&password=office"  1>> test_all_apis.log 2>>&1
curl http://localhost:3000/system_user_manager/add_one_user?"firstname=Goody&lastname=Scags&login=gscags&password=office&changing_user_login=rwalters"  1>> test_all_apis.log 2>>&1
REM with authorized and logged in  user
curl http://localhost:3000/system_user_manager/user_login?"login=jjones&password=alfalfa"  1>> test_all_apis.log 2>>&1
curl http://localhost:3000/system_user_manager/add_one_user?"firstname=Goody&lastname=Scags&login=gscags&password=office&changing_user_login=jjones"  1>> test_all_apis.log 2>>&1
REM undo all changes
curl http://localhost:3000/system_user_manager/change_user_allowed_actions?"login=jjones&service=system_user&action=add_new_user&task=disallow&changing_user_login=muser"  1>> test_all_apis.log 2>>&1
curl http://localhost:3000/system_user_manager/user_logout?"login=rwalters"  1>> test_all_apis.log 2>>&1
curl http://localhost:3000/system_user_manager/user_logout?"login=jjones"  1>> test_all_apis.log 2>>&1

REM test change other users passwords
REM unauthorized user changing another user's password - Fail
curl http://localhost:3000/system_user_manager/user_login?"login=jjones&password=alfalfa"  1>> test_all_apis.log 2>>&1
curl http://localhost:3000/system_user_manager/change_password?"login=jsmith&password=corn&changing_user_login=jjones"  1>> test_all_apis.log 2>>&1
REM authorized but logged out user changing another user's password - Fail
curl http://localhost:3000/system_user_manager/change_user_allowed_actions?"login=rwalters&service=system_user&action=change_password&task=allow&changing_user_login=muser"  1>> test_all_apis.log 2>>&1
curl http://localhost:3000/system_user_manager/change_password?"login=jsmith&password=corn&changing_user_login=rwalters"  1>> test_all_apis.log 2>>&1
REM logged in and authorized user  changing another user's password - Succeed
curl http://localhost:3000/system_user_manager/change_user_allowed_actions?"login=jjones&service=system_user&action=change_password&task=allow&changing_user_login=muser"  1>> test_all_apis.log 2>>&1
curl http://localhost:3000/system_user_manager/change_password?"login=jsmith&password=corn&changing_user_login=jjones"  1>> test_all_apis.log 2>>&1
REM undo all changes
curl http://localhost:3000/system_user_manager/change_password?"login=jsmith&password=grain&changing_user_login=jjones"  1>> test_all_apis.log 2>>&1
curl http://localhost:3000/system_user_manager/user_logout?"login=jjones"  1>> test_all_apis.log 2>>&1
curl http://localhost:3000/system_user_manager/change_user_allowed_actions?"login=rwalters&service=system_user&action=change_password&task=disallow&changing_user_login=muser"  1>> test_all_apis.log 2>>&1
curl http://localhost:3000/system_user_manager/change_user_allowed_actions?"login=jjones&service=system_user&action=change_password&task=disallow&changing_user_login=muser"  1>> test_all_apis.log 2>>&1

REM user changing their own passwords
REM user not logged in - Fail
curl http://localhost:3000/system_user_manager/change_password?"login=mmckinly&password=whereAmI&changing_user_login=mmckinly"  1>> test_all_apis.log 2>>&1
REM user is loggerd in - Succeed
curl http://localhost:3000/system_user_manager/user_login?"login=eabot&password=alfalfa"  1>> test_all_apis.log 2>>&1
curl http://localhost:3000/system_user_manager/change_password?"login=eabot&password=hersemmy&changing_user_login=eabot"  1>> test_all_apis.log 2>>&1
REM undo all changes
curl http://localhost:3000/system_user_manager/change_password?"login=eabot&password=alfalfa&changing_user_login=eabot"  1>> test_all_apis.log 2>>&1
curl http://localhost:3000/system_user_manager/user_logout?"login=eabot"  1>> test_all_apis.log 2>>&1

REM ---------------------------------------------------------------------------
REM Testing change_user_allowed_actions
REM unauthorized but logged in user  - Fail
curl http://localhost:3000/system_user_manager/user_login?"login=eabot&password=alfalfa"  1>> test_all_apis.log 2>>&1
curl http://localhost:3000/system_user_manager/change_user_allowed_actions?"login=jjones&service=system_user&action=add_new_user&task=allow&changing_user_login=eabot"  1>> test_all_apis.log 2>>&1
REM authorized but logged out user  - Fail
curl http://localhost:3000/system_user_manager/change_user_allowed_actions?"login=jsmith&service=system_user&action=enter_edit_allowed_actions&task=allow&changing_user_login=muser"  1>> test_all_apis.log 2>>&1
curl http://localhost:3000/system_user_manager/change_user_allowed_actions?"login=jjones&service=system_user&action=add_new_user&task=allow&changing_user_login=jsmith"  1>> test_all_apis.log 2>>&1
REM authorized and logged in user  - Succeed
curl http://localhost:3000/system_user_manager/user_login?"login=jsmith&password=grain"  1>> test_all_apis.log 2>>&1
curl http://localhost:3000/system_user_manager/change_user_allowed_actions?"login=jjones&service=system_user&action=add_new_user&task=allow&changing_user_login=jsmith"  1>> test_all_apis.log 2>>&1
REM undo all changes
curl http://localhost:3000/system_user_manager/change_user_allowed_actions?"login=jjones&service=system_user&action=add_new_user&task=disallow&changing_user_login=jsmith"  1>> test_all_apis.log 2>>&1
curl http://localhost:3000/system_user_manager/user_logout?"login=jsmith"  1>> test_all_apis.log 2>>&1
curl http://localhost:3000/system_user_manager/change_user_allowed_actions?"login=jsmith&service=system_user&action=enter_edit_allowed_actions&task=disallow&changing_user_login=muser"  1>> test_all_apis.log 2>>&1
curl http://localhost:3000/system_user_manager/user_logout?"login=eabot"  1>> test_all_apis.log 2>>&1

REM -----------------------------------------------------------------

REM  See the results
"C:\Program Files\PostgreSQL\9.4\bin\psql.exe" -h localhost -U postgres -d report_manager_database  -p 5432 -f get_system_users.sql 1>> test_all_apis.log 2>>&1 
"C:\Program Files\PostgreSQL\9.4\bin\psql.exe" -h localhost -U postgres -d report_manager_database  -p 5432 -f get_system_users.sql -o get_system_users.txt

"C:\Program Files\PostgreSQL\9.4\bin\psql.exe" -h localhost -U postgres -d report_manager_database  -p 5432 -f get_system_user_state.sql 1>> test_all_apis.log 2>>&1 
"C:\Program Files\PostgreSQL\9.4\bin\psql.exe" -h localhost -U postgres -d report_manager_database  -p 5432 -f get_system_user_state.sql -o get_system_user_state.txt

"C:\Program Files\PostgreSQL\9.4\bin\psql.exe" -h localhost -U postgres -d report_manager_database  -p 5432 -f get_system_user_state_history.sql 1>> test_all_apis.log 2>>&1 
"C:\Program Files\PostgreSQL\9.4\bin\psql.exe" -h localhost -U postgres -d report_manager_database  -p 5432 -f get_system_user_state_history.sql -o get_system_user_state_history.txt

"C:\Program Files\PostgreSQL\9.4\bin\psql.exe" -h localhost -U postgres -d report_manager_database  -p 5432 -f get_system_user_allowed_actions.sql 1>> test_all_apis.log 2>>&1 
"C:\Program Files\PostgreSQL\9.4\bin\psql.exe" -h localhost -U postgres -d report_manager_database  -p 5432 -f get_system_user_allowed_actions.sql -o get_system_user_allowed_actions.txt

"C:\Program Files\PostgreSQL\9.4\bin\psql.exe" -h localhost -U postgres -d report_manager_database  -p 5432 -f get_system_user_allowed_actions_history.sql 1>> test_all_apis.log 2>>&1 
"C:\Program Files\PostgreSQL\9.4\bin\psql.exe" -h localhost -U postgres -d report_manager_database  -p 5432 -f get_system_user_allowed_actions_history.sql -o get_system_user_allowed_actions_history.txt

