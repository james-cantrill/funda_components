-- test_action_list_all_programs.sql

/*	_in_data:	{
					login:
				}
			
* The json object returned by the function, _out_json, is defined  below.

	_out_json:	{
				result_indicator:
				message:
				login:
				programs: [
						{
							program_id:
							other_program_id:    -- unique program identifier from outside this system.
							program_name:
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

-- insert 5 programs		
DO $$
DECLARE  _output_json	json;
BEGIN	
	RAISE NOTICE 'Insert A Good Program expected result: Success';
	_output_json := (SELECT * FROM programs_manager_schema.action_enter_edit_programs ('{"program_name": "A Good Program", "program_description": "This is a descriptipon", "other_program_id": "70014021", "organization_name":"Test Organization 1", "containing_level_name": "program_root", "changed_by_user_login": "muser", "enter_or_update": "Enter"}'));
	RAISE NOTICE 'TEST Result = %', (SELECT _output_json ->> 'result_indicator')::text;
	RAISE NOTICE 'Message = %', (SELECT _output_json ->> 'message')::text;
	RAISE NOTICE '';
END$$;		
		
DO $$
DECLARE  _output_json	json;
BEGIN	
	RAISE NOTICE 'Insert A Very Good Program expected result: Success';
	_output_json := (SELECT * FROM programs_manager_schema.action_enter_edit_programs ('{"program_name": "A Very Good Program", "program_description": "This is a descriptipon",  "other_program_id": "20009000", "organization_name":"Test Organization 1", "containing_level_name": "program_root", "changed_by_user_login": "muser", "enter_or_update": "Enter"}'));
	RAISE NOTICE 'TEST Result = %', (SELECT _output_json ->> 'result_indicator')::text;
	RAISE NOTICE 'Message = %', (SELECT _output_json ->> 'message')::text;
	RAISE NOTICE '';
END$$;		
		
DO $$
DECLARE  _output_json	json;
BEGIN	
	RAISE NOTICE 'Insert Program 3 expected result: Success';
	_output_json := (SELECT * FROM programs_manager_schema.action_enter_edit_programs ('{"program_name": "Program 3", "program_description": "This is a descriptipon",  "other_program_id": "50036000", "organization_name":"Test Organization 1", "containing_level_name": "program_root", "changed_by_user_login": "muser", "enter_or_update": "Enter"}'));
	RAISE NOTICE 'TEST Result = %', (SELECT _output_json ->> 'result_indicator')::text;
	RAISE NOTICE 'Message = %', (SELECT _output_json ->> 'message')::text;
	RAISE NOTICE '';
END$$;		
		
DO $$
DECLARE  _output_json	json;
BEGIN	
	RAISE NOTICE 'Insert Program 4 expected result: Success';
	_output_json := (SELECT * FROM programs_manager_schema.action_enter_edit_programs ('{"program_name": "Program 4", "program_description": "This is a descriptipon",  "other_program_id": "50008000", "organization_name":"Test Organization 1", "containing_level_name": "program_root", "changed_by_user_login": "muser", "enter_or_update": "Enter"}'));
	RAISE NOTICE 'TEST Result = %', (SELECT _output_json ->> 'result_indicator')::text;
	RAISE NOTICE 'Message = %', (SELECT _output_json ->> 'message')::text;
	RAISE NOTICE '';
END$$;		
		
DO $$
DECLARE  _output_json	json;
BEGIN	
	RAISE NOTICE 'Insert Program 5 expected result: Success';
	_output_json := (SELECT * FROM programs_manager_schema.action_enter_edit_programs ('{"program_name": "Program 5", "program_description": "This is a descriptipon",  "other_program_id": "40008000", "organization_name":"Test Organization 1", "containing_level_name": "program_root", "changed_by_user_login": "muser", "enter_or_update": "Enter"}'));
	RAISE NOTICE 'TEST Result = %', (SELECT _output_json ->> 'result_indicator')::text;
	RAISE NOTICE 'Message = %', (SELECT _output_json ->> 'message')::text;
	RAISE NOTICE '';
END$$;		
		
--------------- Tests of action_list_user_visible_programs -------------------

DO $$
DECLARE  _output_json	json;
BEGIN	
	RAISE NOTICE 'Test 1 use is not autnhorized to list all programsr. expected result: Failure';
	_output_json := (SELECT * FROM programs_manager_schema.action_list_all_programs ('{"changing_user_login": "opal"}'));
	RAISE NOTICE 'TEST Result = %', (SELECT _output_json ->> 'result_indicator')::text;
	RAISE NOTICE 'Message = %', (SELECT _output_json ->> 'message')::text;
	RAISE NOTICE '_output_json = %', _output_json;
END$$;

DO $$
DECLARE  _output_json	json;
BEGIN	
	RAISE NOTICE 'Test 2 list all programs. expected result: Success';
	_output_json := (SELECT * FROM programs_manager_schema.action_list_all_programs ('{"changing_user_login":  "muser"}'));
	RAISE NOTICE 'TEST Result = %', (SELECT _output_json ->> 'result_indicator')::text;
	RAISE NOTICE 'Message = %', (SELECT _output_json ->> 'message')::text;
	RAISE NOTICE '_output_json = %', _output_json;
END$$;





