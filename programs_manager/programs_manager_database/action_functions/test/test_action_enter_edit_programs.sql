--	test_action_enter_edit_programs

--	_in_data:	{								
--					program_id:
--					program_name:
--					organization_id:
--					coc_code:
--					containing_folder_name:
--					changed_by_user_login:
--				}
			
-- The json object returned by the function, _out_json, is defined  below.

--	_out_json:	{
--					result_indicator:
--					message:
--					program_id:
--					program_name:
--					organization_id:
--					coc_code:
--					containing_folder_name:
--					changed_by_user_login:
--				}

--	Delete all existing programs
DELETE FROM programs_manager_schema.programs;

--	log in the master user
SELECT * FROM system_user_schema.action_user_login ('{"login": "muser", "password":"ha_melech!16"}');

-- Test 1 successful insert
DO $$
DECLARE  _output_json	json;
BEGIN	
	RAISE NOTICE 'TEST 1 insert expected result: Success';
	_output_json := (SELECT * FROM programs_manager_schema.action_enter_edit_programs ('{"program_id": "40009000", "program_name": "CCST Adolescent Transitional - Lasting Success Foster Care", "organization_id":"0A791B9C", "coc_code":"NY-501 - Elmira/Steuben Allegany Livingston Chemung Schuyler Counties CoC", "containing_folder_name": "cccs_other", "changed_by_user_login": "muser"}'));
	RAISE NOTICE 'TEST Result = %', (SELECT _output_json ->> 'result_indicator')::text;
	RAISE NOTICE '_output_json = %', _output_json;
	RAISE NOTICE '';
END$$;

-- Test 2 failure user isn't authorized
DO $$
DECLARE  _output_json	json;
BEGIN	
	RAISE NOTICE 'TEST 2 user isn''t authorized expected result: Failure';
	_output_json := (SELECT * FROM programs_manager_schema.action_enter_edit_programs ('{"program_id": "10013000", "program_name": "CCST Bridger Outreach Services", "organization_id":"0A791B9C", "coc_code":"NY-501 - Elmira/Steuben Allegany Livingston Chemung Schuyler Counties CoC", "containing_folder_name": "cccs_other", "changed_by_user_login": "opal"}'));
	RAISE NOTICE 'TEST Result = %', (SELECT _output_json ->> 'result_indicator')::text;
	RAISE NOTICE '_output_json = %', _output_json;
	RAISE NOTICE '';
END$$;

-- Test 3 failure containing_folder_name doesn't exist
DO $$
DECLARE  _output_json	json;
BEGIN	
	RAISE NOTICE 'TEST 3 containing_folder_name doesn''t exist expected result: Failure';
	_output_json := (SELECT * FROM programs_manager_schema.action_enter_edit_programs ('{"program_id": "10013000", "program_name": "CCST Bridger Outreach Services", "organization_id":"0A791B9C", "coc_code":"NY-501 - Elmira/Steuben Allegany Livingston Chemung Schuyler Counties CoC", "containing_folder_name": "cccs_dev", "changed_by_user_login": "muser"}'));
	RAISE NOTICE 'TEST Result = %', (SELECT _output_json ->> 'result_indicator')::text;
	RAISE NOTICE '_output_json = %', _output_json;
	RAISE NOTICE '';
END$$;

-- Test 4 failure program_name already exists
DO $$
DECLARE  _output_json	json;
BEGIN	
	RAISE NOTICE 'TEST 4 program_name already exists expected result: Failure';
	_output_json := (SELECT * FROM programs_manager_schema.action_enter_edit_programs ('{"program_id": "10013000", "program_name": "CCST Adolescent Transitional - Lasting Success Foster Care", "organization_id":"0A791B9C", "coc_code":"NY-501 - Elmira/Steuben Allegany Livingston Chemung Schuyler Counties CoC", "containing_folder_name": "cccs_other", "changed_by_user_login": "muser"}'));
	RAISE NOTICE 'TEST Result = %', (SELECT _output_json ->> 'result_indicator')::text;
	RAISE NOTICE '_output_json = %', _output_json;
	RAISE NOTICE '';
END$$;

-- Test 5 failure incomplete input
DO $$
DECLARE  _output_json	json;
BEGIN	
	RAISE NOTICE 'TEST 5  incomplete input expected result: Failure';
	_output_json := (SELECT * FROM programs_manager_schema.action_enter_edit_programs ('{"program_id": "10013000", "program_name": "CCST Adolescent Transitional - Lasting Success Foster Care", "organization_id":"0A791B9C", "coc_code":"NY-501 - Elmira/Steuben Allegany Livingston Chemung Schuyler Counties CoC", "changed_by_user_login": "muser"}'));
	RAISE NOTICE 'TEST Result = %', (SELECT _output_json ->> 'result_indicator')::text;
	RAISE NOTICE '_output_json = %', _output_json;
	RAISE NOTICE '';
END$$;

-- Test 6 successful update
DO $$
DECLARE  _output_json	json;
BEGIN	
	RAISE NOTICE 'TEST 6 successful update expected result: Success';
	_output_json := (SELECT * FROM programs_manager_schema.action_enter_edit_programs ('{"program_id": "10013000", "program_name": "CCST Bridger Outreach Services", "organization_id":"0A791B9C", "coc_code":"NY-501 - Elmira/Steuben Allegany Livingston Chemung Schuyler Counties CoC", "containing_folder_name": "cccs_other", "changed_by_user_login": "muser"}'));
	_output_json := (SELECT * FROM programs_manager_schema.action_enter_edit_programs ('{"program_id": "10013000", "program_name": "UPdated CCST Bridger Outreach Services", "organization_id":"0A791B9C", "coc_code":"NY-501 - Elmira/Steuben Allegany Livingston Chemung Schuyler Counties CoC", "containing_folder_name": "cccs_other", "changed_by_user_login": "muser"}'));
	RAISE NOTICE 'TEST Result = %', (SELECT _output_json ->> 'result_indicator')::text;
	RAISE NOTICE '_output_json = %', _output_json;
	RAISE NOTICE '';
END$$;

-- Test 7  update to an existing program name
DO $$
DECLARE  _output_json	json;
BEGIN	
	RAISE NOTICE 'TEST 7  update to an existing program name expected result: Failure';
	_output_json := (SELECT * FROM programs_manager_schema.action_enter_edit_programs ('{"program_id": "10013000", "program_name": "UPdated CCST Bridger Outreach Services", "organization_id":"0A791B9C", "coc_code":"NY-501 - Elmira/Steuben Allegany Livingston Chemung Schuyler Counties CoC", "containing_folder_name": "cccs_error", "changed_by_user_login": "muser"}'));
	RAISE NOTICE 'TEST Result = %', (SELECT _output_json ->> 'result_indicator')::text;
	RAISE NOTICE '_output_json = %', _output_json;
	RAISE NOTICE '';
END$$;

-- Test 8  update to an existing program name
DO $$
DECLARE  _output_json	json;
BEGIN	
	RAISE NOTICE 'TEST 8  update to an existing program name expected result: Failure';
	_output_json := (SELECT * FROM programs_manager_schema.action_enter_edit_programs ('{"program_id": "10013000", "program_name": "CCST Adolescent Transitional - Lasting Success Foster Care", "organization_id":"0A791B9C", "coc_code":"NY-501 - Elmira/Steuben Allegany Livingston Chemung Schuyler Counties CoC", "containing_folder_name": "cccs_other", "changed_by_user_login": "muser"}'));
	RAISE NOTICE 'TEST Result = %', (SELECT _output_json ->> 'result_indicator')::text;
	RAISE NOTICE '_output_json = %', _output_json;
	RAISE NOTICE '';
END$$;

SELECT * FROM programs_manager_schema.programs;

