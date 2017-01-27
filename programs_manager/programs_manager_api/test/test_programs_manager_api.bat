REM test_programs_manager_api.bat
REM -------------------------------------------

curl http://localhost:4000/programs_manager/get_one_row  1> test_programs_manager_api.log 2>&1

curl http://localhost:4000/programs_manager/change_organization_user_visibility?"login=opal&service=programs_manager&organization_name=ACCORD Corporation&task=visible&changing_user_login=muser" 1>> test_programs_manager_api.log 2>>&1

curl http://localhost:4000/programs_manager/change_program_user_visibility?"login=opal&service=programs_manager&program=CCST Emergency Services Food/Clothing&task=visible&changing_user_login=muser"  1>> test_programs_manager_api.log 2>>&1


REM curl http://localhost:4000/programs_manager/list_user_visible_organizations?"login=opal"  1>> test_programs_manager_api.log 2>>&1

REM curl http://localhost:4000/programs_manager/list_user_visible_programs?"login=opal"  1>> test_programs_manager_api.log 2>>&1



