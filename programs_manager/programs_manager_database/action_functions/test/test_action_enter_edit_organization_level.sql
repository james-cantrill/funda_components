--	test_action_enter_edit_organization_level
/*
	_in_data:	
	{
		organization_level_id:
		organization_level_name:
		organization_level_display_name:
		organization_level_description:
		parent_level_id:  
		is_root_level:	-- boolean
		organization_id:
		changing_user_login:
		enter_or_update:
	}

	_out_json:	
	{
		result_indicator:
		message:
		organization_level_id:
		organization_level_name:
		organization_level_display_name:
		organization_level_description:
		parent_level_id:
		is_root_level:
		organization_id:
		changing_user_login:
		enter_or_update:
	}
*/

--	log in the master user
SELECT * FROM system_user_schema.action_user_login ('{"login": "muser", "password":"master"}');

-- prepare by inserting an organization
SELECT * FROM programs_manager_schema.action_enter_edit_organizations ('{"organization_name": "Test Organization 1", "organization_description": "This is Test Organization 1",  "changing_user_login": "muser", "enter_or_update": "Enter"}');

-- Test 1 incomplete data organization_level_display_name
DO $$
DECLARE  _output_json	json;
BEGIN	
	RAISE NOTICE 'Test 1 incomplete data organization_level_display_name expected result: Failure';
	_output_json := (SELECT * FROM programs_manager_schema.action_enter_edit_organization_level ('{"organization_level_name": "program_root", "organization_level_description":"List of all programs", "is_root_level": "TRUE", "organization_name": "Test Organization 1", "changing_user_login": "muser", "enter_or_update": "Enter"}'));
	RAISE NOTICE 'TEST Result = %', (SELECT _output_json ->> 'result_indicator')::text;
	RAISE NOTICE 'Message = %', (SELECT _output_json ->> 'message')::text;
END$$;

-- Test 2 incomplete data organization_level_description 
DO $$
DECLARE  _output_json	json;
BEGIN	
	RAISE NOTICE 'Test 2 incomplete data organization_level_description expected result: Failure';
	_output_json := (SELECT * FROM programs_manager_schema.action_enter_edit_organization_level ('{"organization_level_name": "program_root", "organization_level_display_name":"All Programs",  "is_root_level": "TRUE", "organization_name": "Test Organization 1", "changing_user_login": "muser", "enter_or_update": "Enter"}'));
	RAISE NOTICE 'TEST Result = %', (SELECT _output_json ->> 'result_indicator')::text;
	RAISE NOTICE 'Message = %', (SELECT _output_json ->> 'message')::text;
END$$;

-- Test 3 incomplete data is_root_level  
DO $$
DECLARE  _output_json	json;
BEGIN	
	RAISE NOTICE 'Test 3 incomplete data is_root_level expected result: Failure';
	_output_json := (SELECT * FROM programs_manager_schema.action_enter_edit_organization_level ('{"organization_level_name": "program_root", "organization_level_display_name":"All Programs", "organization_level_description":"List of all programs", "organization_name": "Test Organization 1", "changing_user_login": "muser", "enter_or_update": "Enter"}'));
	RAISE NOTICE 'TEST Result = %', (SELECT _output_json ->> 'result_indicator')::text;
	RAISE NOTICE 'Message = %', (SELECT _output_json ->> 'message')::text;
END$$;

-- Test 4 incomplete data is_root_level = FALSE AND parent_level_name IS NULL
DO $$
DECLARE  _output_json	json;
BEGIN	
	RAISE NOTICE 'Test 4 incomplete data is_root_level = FALSE AND parent_level_name IS NULL expected result: Failure';
	_output_json := (SELECT * FROM programs_manager_schema.action_enter_edit_organization_level ('{"organization_level_name": "program_root", "organization_level_display_name":"All Programs", "organization_level_description":"List of all programs", "is_root_level": "FALSE", "organization_name": "Test Organization 1", "changing_user_login": "muser", "enter_or_update": "Enter"}'));
	RAISE NOTICE 'TEST Result = %', (SELECT _output_json ->> 'result_indicator')::text;
	RAISE NOTICE 'Message = %', (SELECT _output_json ->> 'message')::text;
END$$;

-- Test 5 incomplete data organization_name
DO $$
DECLARE  _output_json	json;
BEGIN	
	RAISE NOTICE 'Test 5 incomplete data organization_name expected result: Failure';
	_output_json := (SELECT * FROM programs_manager_schema.action_enter_edit_organization_level ('{"organization_level_name": "program_root", "organization_level_display_name":"All Programs", "organization_level_description":"List of all programs", "is_root_level": "TRUE", "changing_user_login": "muser", "enter_or_update": "Enter"}'));
	RAISE NOTICE 'TEST Result = %', (SELECT _output_json ->> 'result_indicator')::text;
	RAISE NOTICE 'Message = %', (SELECT _output_json ->> 'message')::text;
END$$;

-- Test 6 incomplete data changing_user_login 
DO $$
DECLARE  _output_json	json;
BEGIN	
	RAISE NOTICE 'Test 6 incomplete data changing_user_login expected result: Failure';
	_output_json := (SELECT * FROM programs_manager_schema.action_enter_edit_organization_level ('{"organization_level_name": "program_root", "organization_level_display_name":"All Programs", "organization_level_description":"List of all programs", "is_root_level": "TRUE", "organization_name": "Test Organization 1","enter_or_update": "Enter"}'));
	RAISE NOTICE 'TEST Result = %', (SELECT _output_json ->> 'result_indicator')::text;
	RAISE NOTICE 'Message = %', (SELECT _output_json ->> 'message')::text;
END$$;

-- Test 7 incomplete data enter_or_update 
DO $$
DECLARE  _output_json	json;
BEGIN	
	RAISE NOTICE 'Test 7 incomplete data enter_or_update  expected result: Failure';
	_output_json := (SELECT * FROM programs_manager_schema.action_enter_edit_organization_level ('{"organization_level_name": "program_root", "organization_level_display_name":"All Programs", "organization_level_description":"List of all programs", "is_root_level": "TRUE", "organization_name": "Test Organization 1", "changing_user_login": "muser"}'));
	RAISE NOTICE 'TEST Result = %', (SELECT _output_json ->> 'result_indicator')::text;
	RAISE NOTICE 'Message = %', (SELECT _output_json ->> 'message')::text;
END$$;

-- Test 8 user isn't authorized
DO $$
DECLARE  _output_json	json;
BEGIN	
	RAISE NOTICE 'Test 8 user isn''t authorized expected result: Failure';
	_output_json := (SELECT * FROM programs_manager_schema.action_enter_edit_organization_level ('{"organization_level_name": "program_root", "organization_level_display_name":"All Programs", "organization_level_description":"List of all programs", "is_root_level": "TRUE", "organization_name": "Test Organization 1", "changing_user_login": "other", "enter_or_update": "Enter"}'));
	RAISE NOTICE 'TEST Result = %', (SELECT _output_json ->> 'result_indicator')::text;
	RAISE NOTICE 'Message = %', (SELECT _output_json ->> 'message')::text;
END$$;

-- Test 10 update of non-existing organization level
 DO $$
DECLARE  _output_json	json;
BEGIN	
	RAISE NOTICE 'Test 10 update of non-existing organization level expected result: Failure';
	_output_json := (SELECT * FROM programs_manager_schema.action_enter_edit_organization_level ('{"organization_level_id": "e226d15a-9ffb-414e-a6ef-09bba91a9036", "organization_level_name": "program_root", "organization_level_display_name":"All Programs", "organization_level_description":"List of all programs", "is_root_level": "TRUE", "organization_name": "Test Organization 1", "changing_user_login": "muser", "enter_or_update": "Update"}'));
	RAISE NOTICE 'TEST Result = %', (SELECT _output_json ->> 'result_indicator')::text;
	RAISE NOTICE 'Message = %', (SELECT _output_json ->> 'message')::text;
END$$;

-- Test 11 parent level doesn't exist?
 DO $$
DECLARE  _output_json	json;
BEGIN	
	RAISE NOTICE 'Test 11 parent level does not exist expected result: Failure';
	_output_json := (SELECT * FROM programs_manager_schema.action_enter_edit_organization_level ('{"organization_level_name": "program_root", "organization_level_display_name":"All Programs", "organization_level_description":"List of all programs", "parent_level_id": "c4bf4e32-5772-4d63-aa0d-d88b3aaeeb88", "is_root_level": "TRUE", "organization_name": "Test Organization 1", "changing_user_login": "muser", "enter_or_update": "Enter"}'));
	RAISE NOTICE 'TEST Result = %', (SELECT _output_json ->> 'result_indicator')::text;
	RAISE NOTICE 'Message = %', (SELECT _output_json ->> 'message')::text;
END$$;

-- Test 12 organization doesn't exist?
DO $$
DECLARE  _output_json	json;
BEGIN	
	RAISE NOTICE 'Test 12 organization does not exist expected result: Failure';
	_output_json := (SELECT * FROM programs_manager_schema.action_enter_edit_organization_level ('{"organization_level_name": "program_root", "organization_level_display_name":"All Programs", "organization_level_description":"List of all programs", "is_root_level": "TRUE", "organization_name": "Not an Organization", "changing_user_login": "muser", "enter_or_update": "Enter"}'));
	RAISE NOTICE 'TEST Result = %', (SELECT _output_json ->> 'result_indicator')::text;
	RAISE NOTICE 'Message = %', (SELECT _output_json ->> 'message')::text;
END$$;

-- Test 13 Invalid enter_or_update parameter
DO $$
DECLARE  _output_json	json;
BEGIN	
	RAISE NOTICE 'Test 13 Invalid enter_or_update parameter expected result: Failure';
	_output_json := (SELECT * FROM programs_manager_schema.action_enter_edit_organization_level ('{"organization_level_name": "program_root", "organization_level_display_name":"All Programs", "organization_level_description":"List of all programs", "is_root_level": "TRUE", "organization_name": "Test Organization 1", "changing_user_login": "muser", "enter_or_update": "What"}'));
	RAISE NOTICE 'TEST Result = %', (SELECT _output_json ->> 'result_indicator')::text;
	RAISE NOTICE 'Message = %', (SELECT _output_json ->> 'message')::text;
END$$;

-- Test 14 successful insert
DO $$
DECLARE  _output_json	json;
BEGIN	
	RAISE NOTICE 'TEST 14 insert expected result: Success';
	_output_json := (SELECT * FROM programs_manager_schema.action_enter_edit_organization_level ('{"organization_level_name": "program_root", "organization_level_display_name":"All Programs", "organization_level_description":"List of all programs", "is_root_level": "TRUE", "organization_name": "Test Organization 1", "changing_user_login": "muser", "enter_or_update": "Enter"}'));
	RAISE NOTICE 'TEST Result = %', (SELECT _output_json ->> 'result_indicator')::text;
	RAISE NOTICE 'Message = %', (SELECT _output_json ->> 'message')::text;
--	PERFORM pg_sleep (10);
END$$;

-- Test 15 insert of already existing organization level
DO $$
DECLARE  _output_json	json;
BEGIN	
	RAISE NOTICE 'Test 15 insert of already existing organization level expected result: Failure';
	_output_json := (SELECT * FROM programs_manager_schema.action_enter_edit_organization_level ('{"organization_level_name": "program_root", "organization_level_display_name":"All Programs", "organization_level_description":"List of all programs", "is_root_level": "TRUE", "organization_name": "Test Organization 1", "changing_user_login": "muser", "enter_or_update": "Enter"}'));
	RAISE NOTICE 'TEST Result = %', (SELECT _output_json ->> 'result_indicator')::text;
	RAISE NOTICE 'Message = %', (SELECT _output_json ->> 'message')::text;
END$$;

-- Test 16 successful update
DO $$
DECLARE  _output_json	json;
		_org_lvl_id	uuid;
		_in_json	json;
BEGIN	
	RAISE NOTICE 'TEST 16 update expected result: Success';
	
		_org_lvl_id := (SELECT 
					organization_level_id
				FROM	programs_manager_schema.organization_level
				WHERE	organization_level_name = 'program_root' );
	-- RAISE NOTICE '_org_lvl_id = %', _org_lvl_id;
	
	_in_json := '{"organization_level_id": "' || _org_lvl_id::text || '", "organization_level_name": "program_root", "organization_level_display_name":"Almost All Programs", "organization_level_description":"List of all programs", "is_root_level": "TRUE", "organization_name": "Test Organization 1", "changing_user_login": "muser", "enter_or_update": "Update"}';
	
		_output_json := (SELECT * FROM programs_manager_schema.action_enter_edit_organization_level (_in_json));
	RAISE NOTICE 'TEST Result = %', (SELECT _output_json ->> 'result_indicator')::text;
	RAISE NOTICE 'Message = %', (SELECT _output_json ->> 'message')::text;
END$$;



SELECT * FROM programs_manager_schema.organization_level;
SELECT '';
SELECT * FROM programs_manager_schema.organization_level_history;

