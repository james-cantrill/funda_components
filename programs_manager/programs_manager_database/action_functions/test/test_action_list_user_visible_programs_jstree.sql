--	test_action_list_user_visible_programs_jstree.sql

-- Test 1 successful list
DO $$
DECLARE  _output_json	json;
BEGIN	
	RAISE NOTICE 'TEST 1 list for Roger Fiktzroger (opal)  expected result: Success';
	_output_json := (SELECT * FROM programs_manager_schema.action_list_user_visible_programs_jstree ('{"login": "opal"}'));
	RAISE NOTICE 'TEST Result = %', (SELECT _output_json ->> 'result_indicator')::text;
	RAISE NOTICE '_output_json = %', _output_json;
	RAISE NOTICE '';
END$$;

-- Test 1 unsucessful user not authorized list
DO $$
DECLARE  _output_json	json;
BEGIN	
	RAISE NOTICE 'TEST 1 list for John Appleton (jappl)  expected result: Failure';
	_output_json := (SELECT * FROM programs_manager_schema.action_list_user_visible_programs_jstree ('{"login": "jappl"}'));
	RAISE NOTICE 'TEST Result = %', (SELECT _output_json ->> 'result_indicator')::text;
	RAISE NOTICE '_output_json = %', _output_json;
	RAISE NOTICE '';
END$$;

