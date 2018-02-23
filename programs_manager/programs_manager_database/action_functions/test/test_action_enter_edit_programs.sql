--	test_action_enter_edit_programs

/*
--	_in_data:	
	{								
		program_id:
		program_name:
		program_description:
		organization_name:
		containing_level_name:
		changed_by_user_login:
		enter_or_update:
	}
			
-- The json object returned by the function, _out_json, is defined  below.

	_out_json:	
	{
		result_indicator:
		message:
		program_id:
		program_name:
		program_description:
		organization_name:
		containing_level_name:
		changed_by_user_login:
		enter_or_update:
	}

*/


--	log in the master user
SELECT * FROM system_user_schema.action_user_login ('{"login": "muser", "password":"master"}');

--	insert an organization and an organization level
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
-------------------------------------------------------------------------------

-- Test 1 incomplete data program_name
DO $$
DECLARE  _output_json	json;
BEGIN	
	RAISE NOTICE 'Test 1 incomplete data program_name expected result: Failure';
	_output_json := (SELECT * FROM programs_manager_schema.action_enter_edit_programs ('{ "program_description": "This is a descriptipon","organization_name":"Test Organization 1", "containing_level_name": "program_root", "changed_by_user_login": "muser", "enter_or_update": "Enter"}'));
	RAISE NOTICE 'TEST Result = %', (SELECT _output_json ->> 'result_indicator')::text;
	RAISE NOTICE 'Message = %', (SELECT _output_json ->> 'message')::text;
	RAISE NOTICE '';
END$$;

-- Test 2 incomplete data program_description
DO $$
DECLARE  _output_json	json;
BEGIN	
	RAISE NOTICE 'Test 2 incomplete data program_description expected result: Failure';
	_output_json := (SELECT * FROM programs_manager_schema.action_enter_edit_programs ('{"program_name": "A Good Program", "organization_name":"Test Organization 1", "containing_level_name": "program_root", "changed_by_user_login": "muser", "enter_or_update": "Enter"}'));
	RAISE NOTICE 'TEST Result = %', (SELECT _output_json ->> 'result_indicator')::text;
	RAISE NOTICE 'Message = %', (SELECT _output_json ->> 'message')::text;
	RAISE NOTICE '';
END$$;

-- Test 3 incomplete data organization_name
DO $$
DECLARE  _output_json	json;
BEGIN	
	RAISE NOTICE 'Test 3 incomplete data organization_name expected result: Failure';
	_output_json := (SELECT * FROM programs_manager_schema.action_enter_edit_programs ('{"program_name": "A Good Program", "program_description": "This is a descriptipon", "containing_level_name": "program_root", "changed_by_user_login": "muser", "enter_or_update": "Enter"}'));
	RAISE NOTICE 'TEST Result = %', (SELECT _output_json ->> 'result_indicator')::text;
	RAISE NOTICE 'Message = %', (SELECT _output_json ->> 'message')::text;
	RAISE NOTICE '';
END$$;

-- Test 4 incomplete data containing_level_name
DO $$
DECLARE  _output_json	json;
BEGIN	
	RAISE NOTICE 'Test 4 incomplete data containing_level_name expected result: Failure';
	_output_json := (SELECT * FROM programs_manager_schema.action_enter_edit_programs ('{"program_name": "A Good Program", "program_description": "This is a descriptipon","organization_name":"Test Organization 1", "changed_by_user_login": "muser", "enter_or_update": "Enter"}'));
	RAISE NOTICE 'TEST Result = %', (SELECT _output_json ->> 'result_indicator')::text;
	RAISE NOTICE 'Message = %', (SELECT _output_json ->> 'message')::text;
	RAISE NOTICE '';
END$$;

-- Test 5 incomplete data changed_by_user_login
DO $$
DECLARE  _output_json	json;
BEGIN	
	RAISE NOTICE 'Test 5 incomplete data changed_by_user_login expected result: Failure';
	_output_json := (SELECT * FROM programs_manager_schema.action_enter_edit_programs ('{"program_name": "A Good Program", "program_description": "This is a descriptipon","organization_name":"Test Organization 1", "containing_level_name": "program_root", "enter_or_update": "Enter"}'));
	RAISE NOTICE 'TEST Result = %', (SELECT _output_json ->> 'result_indicator')::text;
	RAISE NOTICE 'Message = %', (SELECT _output_json ->> 'message')::text;
	RAISE NOTICE '';
END$$;

-- Test 6 incomplete data enter_or_update
DO $$
DECLARE  _output_json	json;
BEGIN	
	RAISE NOTICE 'Test 6 incomplete data enter_or_update expected result: Failure';
	_output_json := (SELECT * FROM programs_manager_schema.action_enter_edit_programs ('{"program_name": "A Good Program", "program_description": "This is a descriptipon","organization_name":"Test Organization 1", "containing_level_name": "program_root", "changed_by_user_login": "muser"}'));
	RAISE NOTICE 'TEST Result = %', (SELECT _output_json ->> 'result_indicator')::text;
	RAISE NOTICE 'Message = %', (SELECT _output_json ->> 'message')::text;
	RAISE NOTICE '';
END$$;

-- Test 7 incomplete data enter_or_update Update AND program_id IS NULL
DO $$
DECLARE  _output_json	json;
BEGIN	
	RAISE NOTICE 'Test 7 incomplete data enter_or_update Update AND program_id IS NULL expected result: Failure';
	_output_json := (SELECT * FROM programs_manager_schema.action_enter_edit_programs ('{"program_name": "A Good Program", "program_description": "This is a descriptipon","organization_name":"Test Organization 1", "containing_level_name": "program_root", "changed_by_user_login": "muser", "enter_or_update": "Update"}'));
	RAISE NOTICE 'TEST Result = %', (SELECT _output_json ->> 'result_indicator')::text;
	RAISE NOTICE 'Message = %', (SELECT _output_json ->> 'message')::text;
	RAISE NOTICE '';
END$$;

-- Test 8 Organization does not exist
DO $$
DECLARE  _output_json	json;
BEGIN	
	RAISE NOTICE 'Test 8 Organization does not exist expected result: Failure';
	_output_json := (SELECT * FROM programs_manager_schema.action_enter_edit_programs ('{"program_name": "A Good Program", "program_description": "This is a descriptipon","organization_name":"Non-existent Organization", "containing_level_name": "program_root", "changed_by_user_login": "muser", "enter_or_update": "Enter"}'));
	RAISE NOTICE 'TEST Result = %', (SELECT _output_json ->> 'result_indicator')::text;
	RAISE NOTICE 'Message = %', (SELECT _output_json ->> 'message')::text;
	RAISE NOTICE '';
END$$;

-- Test 9 Containing organization level does not exist
DO $$
DECLARE  _output_json	json;
BEGIN	
	RAISE NOTICE 'Test 9 Containing organization level does not exist expected result: Failure';
	_output_json := (SELECT * FROM programs_manager_schema.action_enter_edit_programs ('{"program_name": "A Good Program", "program_description": "This is a descriptipon","organization_name":"Test Organization 1", "containing_level_name": "non_existent_level", "changed_by_user_login": "muser", "enter_or_update": "Enter"}'));
	RAISE NOTICE 'TEST Result = %', (SELECT _output_json ->> 'result_indicator')::text;
	RAISE NOTICE 'Message = %', (SELECT _output_json ->> 'message')::text;
	RAISE NOTICE '';
END$$;

-- Test 10 on enter program name is not unique	
DO $$
DECLARE  _output_json	json;
BEGIN	
	RAISE NOTICE 'Test 10 on enter program name is not unique expected result: Failure';
	_output_json := (SELECT * FROM programs_manager_schema.action_enter_edit_programs ('{"program_name": "Program 1", "program_description": "This is a dummy program","organization_name":"Test Organization 1", "containing_level_name": "program_root", "changed_by_user_login": "muser", "enter_or_update": "Enter"}'));
	_output_json := (SELECT * FROM programs_manager_schema.action_enter_edit_programs ('{"program_name": "Program 1", "program_description": "This is a dummy program","organization_name":"Test Organization 1", "containing_level_name": "program_root", "changed_by_user_login": "muser", "enter_or_update": "Enter"}'));
	RAISE NOTICE 'TEST Result = %', (SELECT _output_json ->> 'result_indicator')::text;
	RAISE NOTICE 'Message = %', (SELECT _output_json ->> 'message')::text;
	RAISE NOTICE '';
END$$;

-- Test 11 user is not authorized
DO $$
DECLARE  _output_json	json;
BEGIN	
	RAISE NOTICE 'Test 11 user is not authorized expected result: Failure';
	_output_json := (SELECT * FROM programs_manager_schema.action_enter_edit_programs ('{"program_name": "A Good Program", "program_description": "This is a descriptipon","organization_name":"Test Organization 1", "containing_level_name": "program_root", "changed_by_user_login": "not_authorized", "enter_or_update": "Enter"}'));
	RAISE NOTICE 'TEST Result = %', (SELECT _output_json ->> 'result_indicator')::text;
	RAISE NOTICE 'Message = %', (SELECT _output_json ->> 'message')::text;
	RAISE NOTICE '';
END$$;

-- Test 12 the program does not exist
DO $$
DECLARE  _output_json	json;
BEGIN	
	RAISE NOTICE 'Test 12 the program does not exist expected result: Failure';
	_output_json := (SELECT * FROM programs_manager_schema.action_enter_edit_programs ('{"program_id": "524a26dd-5076-4f84-860c-179edf886fc4", "program_name": "A Good Program", "program_description": "This is a descriptipon","organization_name":"Test Organization 1", "containing_level_name": "program_root", "changed_by_user_login": "muser", "enter_or_update": "Update"}'));
	RAISE NOTICE 'TEST Result = %', (SELECT _output_json ->> 'result_indicator')::text;
	RAISE NOTICE 'Message = %', (SELECT _output_json ->> 'message')::text;
	RAISE NOTICE '';
	PERFORM pg_sleep(5);
END$$;

-- Test 13 enter_or_update has an invalid value
DO $$
DECLARE  _output_json	json;
BEGIN	
	RAISE NOTICE 'Test 13 enter_or_update has an invalid value expected result: Failure';
	_output_json := (SELECT * FROM programs_manager_schema.action_enter_edit_programs ('{"program_name": "A New Program", "program_description": "This is an attempt","organization_name":"Test Organization 1", "containing_level_name": "program_root", "changed_by_user_login": "muser", "enter_or_update": "Invalid"}'));
	RAISE NOTICE 'TEST Result = %', (SELECT _output_json ->> 'result_indicator')::text;
	RAISE NOTICE 'Message = %', (SELECT _output_json ->> 'message')::text;
	RAISE NOTICE '';
END$$;

-- Test 14 good insert
DO $$
DECLARE  _output_json	json;
BEGIN	
	RAISE NOTICE 'Test 14 good insert expected result: Success';
	_output_json := (SELECT * FROM programs_manager_schema.action_enter_edit_programs ('{"program_name": "A Good Program", "program_description": "This is a descriptipon","organization_name":"Test Organization 1", "containing_level_name": "program_root", "changed_by_user_login": "muser", "enter_or_update": "Enter"}'));
	RAISE NOTICE 'TEST Result = %', (SELECT _output_json ->> 'result_indicator')::text;
	RAISE NOTICE 'Message = %', (SELECT _output_json ->> 'message')::text;
	RAISE NOTICE '';
	PERFORM pg_sleep(5);
END$$;

-- Test 15 good update
DO $$
DECLARE  _output_json	json;
		_program_id	uuid;
		_in_json	json;
BEGIN	
	RAISE NOTICE 'Test 15 good update expected result: Success';
	_program_id := (SELECT 
				program_id
			FROM	programs_manager_schema.programs
			WHERE	program_name = 'A Good Program' );
	_in_json := '{"program_id": "' || _program_id::text || '", "program_name": "A Good Program", "program_description": "This is a CHANGED  descriptipon","organization_name":"Test Organization 1", "containing_level_name": "program_root", "changed_by_user_login": "muser", "enter_or_update": "Update"}';		
	_output_json := (SELECT * FROM programs_manager_schema.action_enter_edit_programs (_in_json));
	RAISE NOTICE 'TEST Result = %', (SELECT _output_json ->> 'result_indicator')::text;
	RAISE NOTICE 'Message = %', (SELECT _output_json ->> 'message')::text;
	RAISE NOTICE '';
END$$;


SELECT '';
SELECT * FROM programs_manager_schema.organizations;

SELECT '';
SELECT * FROM programs_manager_schema.organization_level;

SELECT '';
SELECT * FROM programs_manager_schema.programs;

SELECT '';
SELECT * FROM programs_manager_schema.programs_history;
