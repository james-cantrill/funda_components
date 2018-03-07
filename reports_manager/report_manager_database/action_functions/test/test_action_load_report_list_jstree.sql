--	test_action_load_report_list_jstree
--	_in_data:	{
--					login:
--				}

--	log in the master user
DO $$
DECLARE  _output_json	json;
BEGIN	
	RAISE NOTICE 'Log in the master user - expected result: Success';
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

--	log in the opal user
DO $$
DECLARE  _output_json	json;
BEGIN	
	RAISE NOTICE 'Log in the opal user - expected result: Success';
	_output_json := (SELECT * FROM system_user_schema.action_user_login ('{"login": "opal", "password":"spade"}'));
	RAISE NOTICE 'TEST Result = %', (SELECT _output_json ->> 'result_indicator')::text;
	RAISE NOTICE 'Message = %', (SELECT _output_json ->> 'message')::text;
	RAISE NOTICE '';
END$$;

--	log in the jappl user
DO $$
DECLARE  _output_json	json;
BEGIN	
	RAISE NOTICE 'Log in the jappl user - expected result: Success';
	_output_json := (SELECT * FROM system_user_schema.action_user_login ('{"login": "jappl", "password":"river"}'));
	RAISE NOTICE 'TEST Result = %', (SELECT _output_json ->> 'result_indicator')::text;
	RAISE NOTICE 'Message = %', (SELECT _output_json ->> 'message')::text;
	RAISE NOTICE '';
END$$;

-- good insert root level folder
DO $$
DECLARE  _output_json	json;
BEGIN	
	RAISE NOTICE 'Setup good insert root level folder -  expected result: Success';
	_output_json := (SELECT * FROM report_manager_schema.action_enter_edit_folders ('{"folder_name": "report_root", "folder_display_name": "All Reports", "description":"Root of report tree", "is_root_folder": "TRUE", "changing_user_login": "muser", "enter_or_update": "Enter"}'));
	RAISE NOTICE 'TEST Result = %', (SELECT _output_json ->> 'result_indicator')::text;
	RAISE NOTICE 'Message = %', (SELECT _output_json ->> 'message')::text;
	RAISE NOTICE '';
END$$;

DO $$
DECLARE  _output_json	json;
BEGIN	
	RAISE NOTICE 'Setup good report insert into root folder -  expected result: Success';
	_output_json := (SELECT * FROM report_manager_schema.action_enter_edit_reports ('{"report_name": "Authorizing Psychiatrists with Clients", "description": "This report lists the authorizing psychiatrists for clients enrolled in one or more programs over a defined time period..", "url": "http://192.168.4.10:8080/WebViewerExample/frameset?__report=authorizing_psychiatrists_with_clients.rptdesign", "containing_folder_name": "report_root", "insert_or_update": "insert", "changing_user_login": "muser", "parameters": [{"parameter_name": "ReportStartDate"}, {"parameter_name": "ReportEndDate"}, {"parameter_name": "ProgramIds"}]}'));
	RAISE NOTICE 'TEST Result = %', (SELECT _output_json ->> 'result_indicator')::text;
	RAISE NOTICE 'Message = %', (SELECT _output_json ->> 'message')::text;
	RAISE NOTICE '';
END$$;

DO $$
DECLARE  _output_json	json;
		_report_id	uuid;
		_in_json	json;
BEGIN	
	RAISE NOTICE 'SETUP insert allow jappl to view Authorizing Psychiatrists with Clients report -  expected result: Success';
	_report_id:= 	(SELECT report_id 
					FROM report_manager_schema.reports 
					WHERE report_name = 'Authorizing Psychiatrists with Clients'
					);
	_in_json := '{"target_login": "jappl", "report_id": "' || _report_id::text || '", "viewable": "TRUE",  "changing_user_login": "muser"}';
	_output_json := (SELECT * FROM report_manager_schema.action_enter_edit_allowed_reports (_in_json));
	RAISE NOTICE 'TEST Result = %', (SELECT _output_json ->> 'result_indicator')::text;
	RAISE NOTICE 'Message = %', (SELECT _output_json ->> 'message')::text;
	RAISE NOTICE '';
END$$;

DO $$
DECLARE  _output_json	json;
		_report_id	uuid;
		_in_json	json;
BEGIN	
	RAISE NOTICE 'SETUP allow jappl to load reports -  expected result: Success';
	_output_json := (SELECT * FROM system_user_schema.action_change_user_allowed_actions ('{"login": "jappl", "service":"report_manager", "action":"load_report_list", "task":"allow", "changing_user_login": "muser"}'));
	RAISE NOTICE 'TEST Result = %', (SELECT _output_json ->> 'result_indicator')::text;
	RAISE NOTICE 'Message = %', (SELECT _output_json ->> 'message')::text;
END$$;

DO $$
DECLARE  _output_json	json;
BEGIN	
	RAISE NOTICE 'Test list reports for jappl -  expected result: Success';
	_output_json := (SELECT * FROM report_manager_schema.action_load_report_list_jstree ('{"login": "jappl"}'));
	RAISE NOTICE 'TEST Result = %', (SELECT _output_json ->> 'result_indicator')::text;
	RAISE NOTICE 'Message = %', (SELECT _output_json ->> 'message')::text;
	RAISE NOTICE 'Reports = %', (SELECT _output_json ->> 'data')::text;
	RAISE NOTICE '';
END$$;




