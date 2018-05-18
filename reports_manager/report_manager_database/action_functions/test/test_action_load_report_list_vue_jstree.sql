-- test_action_load_report_list_vue_jstree.sql

DO $$
DECLARE  _output_json	json;
BEGIN	
	RAISE NOTICE 'Log in the master user';
	_output_json := (SELECT * FROM system_user_schema.action_user_login ('{"login": "opal", "password":"spade"}'));
	RAISE NOTICE 'Result = %', (SELECT _output_json ->> 'result_indicator')::text;
END$$;

DO $$
DECLARE  _output_json	json;
BEGIN	
	RAISE NOTICE 'Log in the master user';
	_output_json := (SELECT * FROM system_user_schema.action_user_login ('{"login": "jappl", "password":"river"}'));
	RAISE NOTICE 'Result = %', (SELECT _output_json ->> 'result_indicator')::text;
END$$;


DO $$
DECLARE  _output_json	json;
BEGIN	
	RAISE NOTICE 'Test list reports for muser -  expected result: Success';
	_output_json := (SELECT * FROM report_manager_schema.action_load_report_list_vue_jstree ('{"login": "muser"}'));
	RAISE NOTICE 'TEST Result = %', (SELECT _output_json ->> 'result_indicator')::text;
	RAISE NOTICE 'Message = %', (SELECT _output_json ->> 'message')::text;
	RAISE NOTICE 'Reports = %', (SELECT _output_json ->> 'data')::text;
	RAISE NOTICE '';
END$$;

DO $$
DECLARE  _output_json	json;
BEGIN	
	RAISE NOTICE 'Test list reports for opal -  expected result: Success';
	_output_json := (SELECT * FROM report_manager_schema.action_load_report_list_vue_jstree ('{"login": "opal"}'));
	RAISE NOTICE 'TEST Result = %', (SELECT _output_json ->> 'result_indicator')::text;
	RAISE NOTICE 'Message = %', (SELECT _output_json ->> 'message')::text;
	RAISE NOTICE 'Reports = %', (SELECT _output_json ->> 'data')::text;
	RAISE NOTICE '';
END$$;

DO $$
DECLARE  _output_json	json;
BEGIN	
	RAISE NOTICE 'Test list reports for jappl -  expected result: Success';
	_output_json := (SELECT * FROM report_manager_schema.action_load_report_list_vue_jstree ('{"login": "jappl"}'));
	RAISE NOTICE 'TEST Result = %', (SELECT _output_json ->> 'result_indicator')::text;
	RAISE NOTICE 'Message = %', (SELECT _output_json ->> 'message')::text;
	RAISE NOTICE 'Reports = %', (SELECT _output_json ->> 'data')::text;
	RAISE NOTICE '';
END$$;
