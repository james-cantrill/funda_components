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

-- Test 1 incomplete data organization_name

DO $$
DECLARE  _output_json	json;
BEGIN	
	RAISE NOTICE 'TEST 1 incomplete data, organization_name, expected result: Failure';
	_output_json := (SELECT * FROM programs_manager_schema.action_enter_edit_organizations ('{ "organization_description": "This is Test Organization 1",  "changing_user_login": "muser", "enter_or_update": "Enter"}'));
	RAISE NOTICE 'TEST Result = %', (SELECT _output_json ->> 'result_indicator')::text;
	RAISE NOTICE 'Message = %', (SELECT _output_json ->> 'message')::text;
	RAISE NOTICE '';
END$$;

-- Test 2 incomplete data organization_description
DO $$
DECLARE  _output_json	json;
BEGIN	
	RAISE NOTICE 'TEST 2 incomplete data, organization_description, expected result: Failure';
	_output_json := (SELECT * FROM programs_manager_schema.action_enter_edit_organizations ('{ "organization_name": "Test Organization  2",   "changing_user_login": "muser", "enter_or_update": "Enter"}'));
	RAISE NOTICE 'TEST Result = %', (SELECT _output_json ->> 'result_indicator')::text;
	RAISE NOTICE 'Message = %', (SELECT _output_json ->> 'message')::text;
	RAISE NOTICE '';
END$$;

-- Test 3 incomplete data changing_user_login
DO $$
DECLARE  _output_json	json;
BEGIN	
	RAISE NOTICE 'TEST incomplete data, changing_user_login, expected result: Failure';
	_output_json := (SELECT * FROM programs_manager_schema.action_enter_edit_organizations ('{"organization_name": "Test Organization  1", "organization_description": "This is Test Organization 1", "enter_or_update": "Enter" }'));
	RAISE NOTICE 'TEST Result = %', (SELECT _output_json ->> 'result_indicator')::text;
	RAISE NOTICE 'Message = %', (SELECT _output_json ->> 'message')::text;
	RAISE NOTICE '';
END$$;

-- Test 4 incomplete data enter_or_update
DO $$
DECLARE  _output_json	json;
BEGIN	
	RAISE NOTICE 'TEST 4 incomplete data, enter_or_update, expected result: Failure';
	_output_json := (SELECT * FROM programs_manager_schema.action_enter_edit_organizations ('{ "organization_name": "Test Organization  2", "organization_description": "This is Test Organization 1",  "changing_user_login": "muser"}'));
	RAISE NOTICE 'TEST Result = %', (SELECT _output_json ->> 'result_indicator')::text;
	RAISE NOTICE 'Message = %', (SELECT _output_json ->> 'message')::text;
	RAISE NOTICE '';
END$$;


-- Test 5 failure user isn't authorized
DO $$
DECLARE  _output_json	json;
BEGIN	
	RAISE NOTICE 'TEST 2 user isn''t authorized expected result: Failure';
	_output_json := (SELECT * FROM programs_manager_schema.action_enter_edit_organizations ('{"organization_name": "Test Organization  1", "organization_description": "Tnis is Test Organization 1",  "changing_user_login": "other",  "enter_or_update": "Enter"}'));
	RAISE NOTICE 'TEST Result = %', (SELECT _output_json ->> 'result_indicator')::text;
	RAISE NOTICE 'Message = %', (SELECT _output_json ->> 'message')::text;
	RAISE NOTICE '';
END$$;

DO $$
DECLARE  _output_json	json;
	_inserted_org_id	uuid;
	_in_json	json;
BEGIN	
	RAISE NOTICE 'PRE-TEST 6 insert fikrstganization expected result: Success';
	_output_json := (SELECT * FROM programs_manager_schema.action_enter_edit_organizations ('{"organization_name": "Orig Test Organization  1", "organization_description": "This is Test Organization 1",  "changing_user_login": "muser", "enter_or_update": "Enter"}'));
		PERFORM  pg_sleep(5);
	RAISE NOTICE 'TEST Result = %', (SELECT _output_json ->> 'result_indicator')::text;
	RAISE NOTICE 'Message = %', (SELECT _output_json ->> 'message')::text;
	RAISE NOTICE '';
END$$;


-- Test 6 successful insert and Test 7 successful update
DO $$
DECLARE  _output_json	json;
	_inserted_org_id	uuid;
	_in_json	json;
BEGIN	
	RAISE NOTICE 'TEST 6 insert expected result: Success';
	_output_json := (SELECT * FROM programs_manager_schema.action_enter_edit_organizations ('{"organization_name": "Test Organization  1", "organization_description": "This is Test Organization 1",  "changing_user_login": "muser", "enter_or_update": "Enter"}'));
	RAISE NOTICE 'TEST Result = %', (SELECT _output_json ->> 'result_indicator')::text;
	RAISE NOTICE 'Message = %', (SELECT _output_json ->> 'message')::text;
	RAISE NOTICE '';
	
	_inserted_org_id := (SELECT _output_json ->> 'organization_id')::uuid;
	RAISE NOTICE '_inserted_org_id = %', _inserted_org_id;
	_in_json := '{"organization_id": "' || _inserted_org_id::text || '", "organization_name": "Test Organization  1", "organization_description": "This is Test Organization 1",  "changing_user_login": "muser", "enter_or_update": "Update"}';
	--RAISE NOTICE '_in_json = %', _in_json;
	
	PERFORM  pg_sleep(5);
	RAISE NOTICE 'Sleep over.';
	
	_output_json := (SELECT * FROM programs_manager_schema.action_enter_edit_organizations ('{"organization_name": "Test Organization  2", "organization_description": "This is Test Organization 2",  "changing_user_login": "muser", "enter_or_update": "Enter"}'));
	
	RAISE NOTICE 'Test 7 successful update expected result: Success';
	_output_json := (SELECT * FROM programs_manager_schema.action_enter_edit_organizations (_in_json));
	RAISE NOTICE 'TEST Result = %', (SELECT _output_json ->> 'result_indicator')::text;
	RAISE NOTICE 'Message = %', (SELECT _output_json ->> 'message')::text;
	RAISE NOTICE '';
END$$;


-- Test 8 insert of already existing organization
DO $$
DECLARE  _output_json	json;
BEGIN	
	RAISE NOTICE 'TEST 8 insert of already existing organization expected result: Failure';
	_output_json := (SELECT * FROM programs_manager_schema.action_enter_edit_organizations ('{"organization_name": "Test Organization  1", "organization_description": "This is a new organization, Test Organization 1",  "changing_user_login": "muser", "enter_or_update": "Enter"}'));
	RAISE NOTICE 'TEST Result = %', (SELECT _output_json ->> 'result_indicator')::text;
	RAISE NOTICE 'Message = %', (SELECT _output_json ->> 'message')::text;
	RAISE NOTICE '';
END$$;

-- Test 9 invalid value of enter_or_update
DO $$
DECLARE  _output_json	json;
BEGIN	
	RAISE NOTICE 'TEST 9 invalid value of enter_or_update expected result: Failure';
	_output_json := (SELECT * FROM programs_manager_schema.action_enter_edit_organizations ('{"organization_name": "Test Organization  3", "organization_description": "This is a new organization, Test Organization 3",  "changing_user_login": "muser", "enter_or_update": "Other"}'));
	RAISE NOTICE 'TEST Result = %', (SELECT _output_json ->> 'result_indicator')::text;
	RAISE NOTICE 'Message = %', (SELECT _output_json ->> 'message')::text;
	RAISE NOTICE '';
END$$;

-- Test 10 missing organization_id for update
DO $$
DECLARE  _output_json	json;
BEGIN	
	RAISE NOTICE 'TEST 10 update with a missing organization_id expected result: Failure';
	_output_json := (SELECT * FROM programs_manager_schema.action_enter_edit_organizations ('{"organization_name": "Test Organization  1", "organization_description": " Test Organization 1 is nogt a new organization",  "changing_user_login": "muser", "enter_or_update": "Update"}'));
	RAISE NOTICE 'TEST Result = %', (SELECT _output_json ->> 'result_indicator')::text;
	RAISE NOTICE 'Message = %', (SELECT _output_json ->> 'message')::text;
	RAISE NOTICE '';
END$$;

-- Test 12 extension of Test 6 and 7 successful update
DO $$
DECLARE  _output_json	json;
		_org_id	uuid;
		_in_json	json;
		
BEGIN	

	_org_id := (SELECT 
					organization_id
				FROM	programs_manager_schema.organizations
				WHERE	organization_name = 'Test Organization  1' );
	RAISE NOTICE '_org_id = %', _org_id;
	
	_in_json := '{"organization_id": "' || _org_id::text || '", "organization_name": "Test Organization  1", "organization_description": "This is UPDATED Test Organization 1",  "changing_user_login": "muser", "enter_or_update": "Update"}';
	RAISE NOTICE 'Test 12 extension of Test 6 and 7 successful update expected result: Success';
	_output_json := (SELECT * FROM programs_manager_schema.action_enter_edit_organizations (_in_json));
	RAISE NOTICE 'TEST Result = %', (SELECT _output_json ->> 'result_indicator')::text;
	RAISE NOTICE 'Message = %', (SELECT _output_json ->> 'message')::text;
	RAISE NOTICE '';
END$$;


SELECT '';
SELECT * FROM programs_manager_schema.organizations;

SELECT '';
SELECT * FROM programs_manager_schema.organizations_history;