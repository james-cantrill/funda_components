--	test_action_enter_edit_organizations.sql

/*	_in_data:	
	{
		organization_name:
		organization_description:
		changing_user_login:
	}
			
* The json object returned by the function, _out_json, is defined  below.

	_out_json:	
	{
		result_indicator:
		message:
		organization_name:
		organization_description:
		changing_user_login:
	}
*/				


--	log in the master user
SELECT * FROM system_user_schema.action_user_login ('{"login": "muser", "password":"master"}');

-- Test 1 successful insert
DO $$
DECLARE  _output_json	json;
BEGIN	
	RAISE NOTICE 'TEST 1 insert expected result: Success';
	_output_json := (SELECT * FROM programs_manager_schema.action_enter_edit_organizations ('{"organization_name": "Test Organization  1", "organization_description": "This is Test Organization 1",  "changing_user_login": "muser"}'));
	RAISE NOTICE 'TEST Result = %', (SELECT _output_json ->> 'result_indicator')::text;
	RAISE NOTICE '_output_json = %', _output_json;
	RAISE NOTICE '';
END$$;

-- Test 2 failure user isn't authorized
DO $$
DECLARE  _output_json	json;
BEGIN	
	RAISE NOTICE 'TEST 2 user isn''t authorized expected result: Failure';
	_output_json := (SELECT * FROM programs_manager_schema.action_enter_edit_organizations ('{"organization_name": "Test Organization  2", "organization_description": "Tnis is Test Organization 2",  "changing_user_login": "other"}'));
	RAISE NOTICE 'TEST Result = %', (SELECT _output_json ->> 'result_indicator')::text;
	RAISE NOTICE '_output_json = %', _output_json;
	RAISE NOTICE '';
END$$;

-- Test 3 successful update
DO $$
DECLARE  _output_json	json;
BEGIN	
	RAISE NOTICE 'TEST 1 insert expected result: Success';
	_output_json := (SELECT * FROM programs_manager_schema.action_enter_edit_organizations ('{"organization_name": "Test Organization  1", "organization_description": "This is NOT Test Organization 1",  "changing_user_login": "muser"}'));
	RAISE NOTICE 'TEST Result = %', (SELECT _output_json ->> 'result_indicator')::text;
	RAISE NOTICE '_output_json = %', _output_json;
	RAISE NOTICE '';
END$$;
