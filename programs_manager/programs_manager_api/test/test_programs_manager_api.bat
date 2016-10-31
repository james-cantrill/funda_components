REM test_programs_manager_api.bat
REM -------------------------------------------

curl http://localhost:4000/programs_manager/test  1> test_programs_manager_api.log 2>&1

curl http://localhost:4000/programs_manager/get_one_row  1>> test_programs_manager_api.log 2>>&1




