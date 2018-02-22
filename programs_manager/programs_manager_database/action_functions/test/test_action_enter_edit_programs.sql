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

(SELECT * FROM programs_manager_schema.action_enter_edit_programs ('{"program_name": "A Good Program", "program_description": "This is a descriptipon","organization_name":"Test Organization 1", "containing_level_name": "program_root", "changed_by_user_login": "muser", "enter_or_update": "Enter"}'));
-- Test 1 incomplete data program_name

-- Test 2 incomplete data program_description

-- Test 3 incomplete data organization_name

-- Test 4 incomplete data containing_level_name

-- Test 5 incomplete data changed_by_user_login

-- Test 6 incomplete data enter_or_update

-- Test 7 incomplete data enter_or_update Update AND program_id IS NULL

-- Test 8 Organization does not exist

-- Test 9 Containing organization level does not exist

-- Test 10 on enter program name is not unique	

-- Test 11 good insert

-- Test 12 the program does not exist

-- Test 13 enter_or_update has an invalid value

-- Test 14 good insert
/*DO $$
DECLARE  _output_json	json;
		_org_lvl_id	uuid;
BEGIN	
	RAISE NOTICE 'Test 14 good insert expected result: Success';
	
		_org_lvl_id := (SELECT 
					organization_level_id
				FROM	programs_manager_schema.organization_level
				WHERE	organization_level_name = 'program_root' );
	RAISE NOTICE '_org_lvl_id = %', _org_lvl_id;

	_output_json := (SELECT * FROM programs_manager_schema.action_enter_edit_programs ('{"program_name": "A Good Program", "program_description": "This is a descriptipon","organization_name":"Test Organization 1", "containing_level_name": "program_root", "changed_by_user_login": "muser", "enter_or_update": "Enter"}'));
	RAISE NOTICE 'TEST Result = %', (SELECT _output_json ->> 'result_indicator')::text;
	RAISE NOTICE 'Message = %', (SELECT _output_json ->> 'message')::text;
	RAISE NOTICE '';
END$$;
*/
-- Test 15 good update


SELECT '';
SELECT * FROM programs_manager_schema.organizations;

SELECT '';
SELECT * FROM programs_manager_schema.organization_level;

SELECT '';
SELECT * FROM programs_manager_schema.programs;

