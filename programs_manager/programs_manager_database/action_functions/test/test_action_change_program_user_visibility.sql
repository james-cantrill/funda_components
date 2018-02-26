--	test_action_change_program_user_visibility.sql

/*	_in_data:	{
					target_login:    - the login of the defined user whose visi bility will be changed
					program_id:      - the ID of the defined program
					program: - the name of the defined program
					visible:	-- booloean
					changing_user_login:
				}
			
* The json object returned by the function, _out_json, is defined  below.

	_out_json:	{
				result_indicator:
				message:
				target_login:
				program_id:
				program_name:
				visible:
				changing_user_login:
				}				

*/

--	log in the master user
DO $$
DECLARE  _output_json	json;
BEGIN	
	RAISE NOTICE 'Log in the master userexpected result: Success';
	_output_json := (SELECT * FROM system_user_schema.action_user_login ('{"login": "muser", "password":"master"}'));
	RAISE NOTICE 'TEST Result = %', (SELECT _output_json ->> 'result_indicator')::text;
	RAISE NOTICE 'Message = %', (SELECT _output_json ->> 'message')::text;
	RAISE NOTICE '';
END$$;
	
-- SET UP the test users
DO $$
DECLARE  _output_json	json;
BEGIN	
	RAISE NOTICE 'SET UP the test user opal expected result: Success';
	_output_json := (SELECT * FROM system_user_schema.action_add_new_user ('{"firstname": "Roger", "lastname": "Fitzroger", "login": "opal", "password":"spade", "changing_user_login": "muser"}'));
	RAISE NOTICE 'TEST Result = %', (SELECT _output_json ->> 'result_indicator')::text;
	RAISE NOTICE 'Message = %', (SELECT _output_json ->> 'message')::text;
	RAISE NOTICE '';
END$$;

DO $$
DECLARE  _output_json	json;
BEGIN	
	RAISE NOTICE 'SET UP the test user jappl expected result: Success';
	_output_json := (SELECT * FROM system_user_schema.action_add_new_user ('{"firstname": "John", "lastname": "Appleton", "login": "jappl", "password":"river", "changing_user_login": "muser"}'));
	RAISE NOTICE 'TEST Result = %', (SELECT _output_json ->> 'result_indicator')::text;
	RAISE NOTICE 'Message = %', (SELECT _output_json ->> 'message')::text;
	RAISE NOTICE '';
END$$;

--	insert an organization, an organization level and a program
DO $$
DECLARE  _output_json	json;
BEGIN	
	RAISE NOTICE 'insert an organization expected result: Success';
	_output_json := (SELECT * FROM programs_manager_schema.action_enter_edit_organizations ('{"organization_name": "Test Organization 1", "organization_description": "This is Test Organization 1",  "changing_user_login": "muser", "enter_or_update": "Enter"}'));
	RAISE NOTICE 'TEST Result = %', (SELECT _output_json ->> 'result_indicator')::text;
	RAISE NOTICE 'Message = %', (SELECT _output_json ->> 'message')::text;
	RAISE NOTICE '';
END$$;

DO $$
DECLARE  _output_json	json;
BEGIN	
	RAISE NOTICE 'Insert an organizatipn level expected result: Success';
	_output_json := (SELECT * FROM programs_manager_schema.action_enter_edit_organization_level ('{"organization_level_name": "program_root", "organization_level_display_name":"All Programs", "organization_level_description":"List of all programs", "is_root_level": "TRUE", "organization_name": "Test Organization 1", "changing_user_login": "muser", "enter_or_update": "Enter"}'));
	RAISE NOTICE 'TEST Result = %', (SELECT _output_json ->> 'result_indicator')::text;
	RAISE NOTICE 'Message = %', (SELECT _output_json ->> 'message')::text;
	RAISE NOTICE '';
END$$;		
		
DO $$
DECLARE  _output_json	json;
BEGIN	
	RAISE NOTICE 'Insert a program expected result: Success';
	_output_json := (SELECT * FROM programs_manager_schema.action_enter_edit_programs ('{"program_name": "A Good Program", "program_description": "This is a descriptipon","organization_name":"Test Organization 1", "containing_level_name": "program_root", "changed_by_user_login": "muser", "enter_or_update": "Enter"}'));
	RAISE NOTICE 'TEST Result = %', (SELECT _output_json ->> 'result_indicator')::text;
	RAISE NOTICE 'Message = %', (SELECT _output_json ->> 'message')::text;
	RAISE NOTICE '';
END$$;		
		
DO $$
DECLARE  _output_json	json;
BEGIN	
	RAISE NOTICE 'Insert a program expected result: Success';
	_output_json := (SELECT * FROM programs_manager_schema.action_enter_edit_programs ('{"program_name": "A Very Good Program", "program_description": "This is a descriptipon","organization_name":"Test Organization 1", "containing_level_name": "program_root", "changed_by_user_login": "muser", "enter_or_update": "Enter"}'));
	RAISE NOTICE 'TEST Result = %', (SELECT _output_json ->> 'result_indicator')::text;
	RAISE NOTICE 'Message = %', (SELECT _output_json ->> 'message')::text;
	RAISE NOTICE '';
END$$;		
		
-- Tests of action_change_program_user_visibility

DO $$
DECLARE  _output_json	json;
BEGIN	
	RAISE NOTICE 'Test 1 user is not authorized. expected result: Failure';
	_output_json := (SELECT * FROM programs_manager_schema.action_change_program_user_visibility ('{"target_login": "opal", "program":"A Good Program", "visible":"TRUE", "changing_user_login": "jappl"}'));
	RAISE NOTICE 'TEST Result = %', (SELECT _output_json ->> 'result_indicator')::text;
	RAISE NOTICE 'Message = %', (SELECT _output_json ->> 'message')::text;
	RAISE NOTICE '';
END$$;		


DO $$
DECLARE  _output_json	json;
BEGIN	
	RAISE NOTICE 'Test 2 missing input data target_login expected result: Failure';
	_output_json := (SELECT * FROM programs_manager_schema.action_change_program_user_visibility ('{"program":"A Good Program", "visible":"TRUE", "changing_user_login": "muser"}'));
	RAISE NOTICE 'TEST Result = %', (SELECT _output_json ->> 'result_indicator')::text;
	RAISE NOTICE 'Message = %', (SELECT _output_json ->> 'message')::text;
	RAISE NOTICE '';
END$$;		

DO $$
DECLARE  _output_json	json;
BEGIN	
	RAISE NOTICE 'Test 3 missing input data program expected result: Failure';
	_output_json := (SELECT * FROM programs_manager_schema.action_change_program_user_visibility ('{"target_login": "opal", "visible":"TRUE", "changing_user_login": "muser"}'));
	RAISE NOTICE 'TEST Result = %', (SELECT _output_json ->> 'result_indicator')::text;
	RAISE NOTICE 'Message = %', (SELECT _output_json ->> 'message')::text;
	RAISE NOTICE '';
END$$;		
		
DO $$
DECLARE  _output_json	json;
BEGIN	
	RAISE NOTICE 'Test 4 missing input data visible expected result: Failure';
	_output_json := (SELECT * FROM programs_manager_schema.action_change_program_user_visibility ('{"target_login": "opal", "program":"A Good Program", "changing_user_login": "muser"}'));
	RAISE NOTICE 'TEST Result = %', (SELECT _output_json ->> 'result_indicator')::text;
	RAISE NOTICE 'Message = %', (SELECT _output_json ->> 'message')::text;
	RAISE NOTICE '';
END$$;		
		
DO $$
DECLARE  _output_json	json;
BEGIN	
	RAISE NOTICE 'Test 5 missing input data changing_user_login expected result: Failure';
	_output_json := (SELECT * FROM programs_manager_schema.action_change_program_user_visibility ('{"target_login": "opal", "program":"A Good Program", "visible":"TRUE"}'));
	RAISE NOTICE 'TEST Result = %', (SELECT _output_json ->> 'result_indicator')::text;
	RAISE NOTICE 'Message = %', (SELECT _output_json ->> 'message')::text;
	RAISE NOTICE '';
END$$;		
		
DO $$
DECLARE  _output_json	json;
BEGIN	
	RAISE NOTICE 'Test 6 target user does not exist expected result: Failure';
	_output_json := (SELECT * FROM programs_manager_schema.action_change_program_user_visibility ('{"target_login": "devon", "program":"A Good Program", "visible":"TRUE", "changing_user_login": "muser"}'));
	RAISE NOTICE 'TEST Result = %', (SELECT _output_json ->> 'result_indicator')::text;
	RAISE NOTICE 'Message = %', (SELECT _output_json ->> 'message')::text;
	RAISE NOTICE '';
END$$;		
		
DO $$
DECLARE  _output_json	json;
BEGIN	
	RAISE NOTICE 'Test 7  program does not exist. expected result: Failure';
	_output_json := (SELECT * FROM programs_manager_schema.action_change_program_user_visibility ('{"target_login": "opal", "program":"Non Exist Program", "visible":"TRUE", "changing_user_login": "muser"}'));
	RAISE NOTICE 'TEST Result = %', (SELECT _output_json ->> 'result_indicator')::text;
	RAISE NOTICE 'Message = %', (SELECT _output_json ->> 'message')::text;
	RAISE NOTICE '';
END$$;		
		
DO $$
DECLARE  _output_json	json;
		_program_id	uuid;
		_in_json	json;
BEGIN	
	RAISE NOTICE 'Test 8 name conflict between program from id and name in json expected result: Failure';
	_program_id := (SELECT 
				program_id
			FROM	programs_manager_schema.programs
			WHERE	program_name = 'A Very Good Program' );
	_in_json := '{"target_login": "opal", "program_id": "' || _program_id::text || '", "program":"A Good Program", "visible":"TRUE", "changing_user_login": "muser"}';		
	_output_json := (SELECT * FROM programs_manager_schema.action_change_program_user_visibility (_in_json));
	RAISE NOTICE 'TEST Result = %', (SELECT _output_json ->> 'result_indicator')::text;
	RAISE NOTICE 'Message = %', (SELECT _output_json ->> 'message')::text;
	RAISE NOTICE '';
END$$;		

	
DO $$
DECLARE  _output_json	json;
BEGIN	
	RAISE NOTICE 'Test 9 Make A Good Program visible to opal. expected result: Success';
	_output_json := (SELECT * FROM programs_manager_schema.action_change_program_user_visibility ('{"target_login": "opal", "program":"A Good Program", "visible":"TRUE", "changing_user_login": "muser"}'));
	RAISE NOTICE 'TEST Result = %', (SELECT _output_json ->> 'result_indicator')::text;
	RAISE NOTICE 'Message = %', (SELECT _output_json ->> 'message')::text;
	RAISE NOTICE '';
	PERFORM pg_sleep(3);
END$$;		
		
DO $$
DECLARE  _output_json	json;
BEGIN	
	RAISE NOTICE 'Test 10 Make A Good Program NOT visible to opal. expected result: Success';
	_output_json := (SELECT * FROM programs_manager_schema.action_change_program_user_visibility ('{"target_login": "opal", "program":"A Good Program", "visible":"FALSE", "changing_user_login": "muser"}'));
	RAISE NOTICE 'TEST Result = %', (SELECT _output_json ->> 'result_indicator')::text;
	RAISE NOTICE 'Message = %', (SELECT _output_json ->> 'message')::text;
	RAISE NOTICE '';
	PERFORM pg_sleep(3);
END$$;		
		
DO $$
DECLARE  _output_json	json;
BEGIN	
	RAISE NOTICE 'Test 11 Make A Good Program visible to opal again. expected result: Success';
	_output_json := (SELECT * FROM programs_manager_schema.action_change_program_user_visibility ('{"target_login": "opal", "program":"A Good Program", "visible":"TRUE", "changing_user_login": "muser"}'));
	RAISE NOTICE 'TEST Result = %', (SELECT _output_json ->> 'result_indicator')::text;
	RAISE NOTICE 'Message = %', (SELECT _output_json ->> 'message')::text;
	RAISE NOTICE '';
END$$;		
		
SELECT '';
SELECT * FROM programs_manager_schema.system_user_allowed_programs;

SELECT '';
SELECT * FROM programs_manager_schema.system_user_allowed_programs_history;
