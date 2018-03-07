-- test_action_enter_edit_allowed_reports.sql
/* the json object containng the inmput data, _in_data, is defined below.


	_in_data:	
	{
		target_login:      -- can not be NULL
		report_id:       -- can not be NULL
		report_name:
		viewable: BOOLEAN   -- can not be NULL
		changing_user_login:     -- can not be NULL
	}
				
*/

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

-- missing data - target_login
DO $$
DECLARE  _output_json	json;
		_report_id	uuid;
		_in_json	json;
BEGIN	
	RAISE NOTICE 'Test 1 missing data - target_login -  expected result: Failure';
	_report_id:= 	(SELECT report_id 
					FROM report_manager_schema.reports 
					WHERE report_name = 'Authorizing Psychiatrists with Clients'
					);
	_in_json := '{ "report_id": "' || _report_id::text || '", "viewable": "TRUE",  "changing_user_login": "muser"}';
	_output_json := (SELECT * FROM report_manager_schema.action_enter_edit_allowed_reports (_in_json));
	RAISE NOTICE 'TEST Result = %', (SELECT _output_json ->> 'result_indicator')::text;
	RAISE NOTICE 'Message = %', (SELECT _output_json ->> 'message')::text;
	RAISE NOTICE '';
END$$;

-- missing data - viewable
DO $$
DECLARE  _output_json	json;
		_report_id	uuid;
		_in_json	json;
BEGIN	
	RAISE NOTICE 'Test 2 missing data - viewable -  expected result: Failure';
	_report_id:= 	(SELECT report_id 
					FROM report_manager_schema.reports 
					WHERE report_name = 'Authorizing Psychiatrists with Clients'
					);
	_in_json := '{"target_login": "jappl", "report_id": "' || _report_id::text || '",  "changing_user_login": "muser"}';
	_output_json := (SELECT * FROM report_manager_schema.action_enter_edit_allowed_reports (_in_json));
	RAISE NOTICE 'TEST Result = %', (SELECT _output_json ->> 'result_indicator')::text;
	RAISE NOTICE 'Message = %', (SELECT _output_json ->> 'message')::text;
	RAISE NOTICE '';
END$$;

-- missing data - changing_user_login
DO $$
DECLARE  _output_json	json;
		_report_id	uuid;
		_in_json	json;
BEGIN	
	RAISE NOTICE 'Test 3 missing data - changing_user_login -  expected result: Failure';
	_report_id:= 	(SELECT report_id 
					FROM report_manager_schema.reports 
					WHERE report_name = 'Authorizing Psychiatrists with Clients'
					);
	_in_json := '{"target_login": "jappl", "report_id": "' || _report_id::text || '", "viewable": "TRUE"}';
	_output_json := (SELECT * FROM report_manager_schema.action_enter_edit_allowed_reports (_in_json));
	RAISE NOTICE 'TEST Result = %', (SELECT _output_json ->> 'result_indicator')::text;
	RAISE NOTICE 'Message = %', (SELECT _output_json ->> 'message')::text;
	RAISE NOTICE '';
END$$;

-- missing data - report_id
DO $$
DECLARE  _output_json	json;
		_report_id	uuid;
		_in_json	json;
BEGIN	
	RAISE NOTICE 'Test 4 missing data - report_id -  expected result: Failure';
	_report_id:= 	(SELECT report_id 
					FROM report_manager_schema.reports 
					WHERE report_name = 'Authorizing Psychiatrists with Clients'
					);
	_in_json := '{"target_login": "jappl", "viewable": "TRUE",  "changing_user_login": "muser"}';
	_output_json := (SELECT * FROM report_manager_schema.action_enter_edit_allowed_reports (_in_json));
	RAISE NOTICE 'TEST Result = %', (SELECT _output_json ->> 'result_indicator')::text;
	RAISE NOTICE 'Message = %', (SELECT _output_json ->> 'message')::text;
	RAISE NOTICE '';
END$$;

-- user is not authorized
DO $$
DECLARE  _output_json	json;
		_report_id	uuid;
		_in_json	json;
BEGIN	
	RAISE NOTICE 'Test 5 user is not authorized -  expected result: Failure';
	_report_id:= 	(SELECT report_id 
					FROM report_manager_schema.reports 
					WHERE report_name = 'Authorizing Psychiatrists with Clients'
					);
	_in_json := '{"target_login": "jappl", "report_id": "' || _report_id::text || '", "viewable": "TRUE",  "changing_user_login": "other"}';
	_output_json := (SELECT * FROM report_manager_schema.action_enter_edit_allowed_reports (_in_json));
	RAISE NOTICE 'TEST Result = %', (SELECT _output_json ->> 'result_indicator')::text;
	RAISE NOTICE 'Message = %', (SELECT _output_json ->> 'message')::text;
	RAISE NOTICE '';
END$$;

-- report does not exist
DO $$
DECLARE  _output_json	json;
		_report_id	uuid;
		_in_json	json;
BEGIN	
	RAISE NOTICE 'Test 6 report does not exist -  expected result: Failure';
	_report_id:= 	(SELECT report_id 
					FROM report_manager_schema.reports 
					WHERE report_name = 'Authorizing Psychiatrists with Clients'
					);
	_in_json := '{"target_login": "jappl", "report_id": "a2a4641a-07fa-450c-83d0-ba3289e9580c", "viewable": "TRUE",  "changing_user_login": "muser"}';
	_output_json := (SELECT * FROM report_manager_schema.action_enter_edit_allowed_reports (_in_json));
	RAISE NOTICE 'TEST Result = %', (SELECT _output_json ->> 'result_indicator')::text;
	RAISE NOTICE 'Message = %', (SELECT _output_json ->> 'message')::text;
	RAISE NOTICE '';
END$$;

-- target user does not exist
DO $$
DECLARE  _output_json	json;
		_report_id	uuid;
		_in_json	json;
BEGIN	
	RAISE NOTICE 'Test 7 target user does not exist -  expected result: Failure';
	_report_id:= 	(SELECT report_id 
					FROM report_manager_schema.reports 
					WHERE report_name = 'Authorizing Psychiatrists with Clients'
					);
	_in_json := '{"target_login": "other", "report_id": "' || _report_id::text || '", "viewable": "TRUE",  "changing_user_login": "muser"}';
	_output_json := (SELECT * FROM report_manager_schema.action_enter_edit_allowed_reports (_in_json));
	RAISE NOTICE 'TEST Result = %', (SELECT _output_json ->> 'result_indicator')::text;
	RAISE NOTICE 'Message = %', (SELECT _output_json ->> 'message')::text;
	RAISE NOTICE '';
END$$;

-- good insert
DO $$
DECLARE  _output_json	json;
		_report_id	uuid;
		_in_json	json;
BEGIN	
	RAISE NOTICE 'Test 8 insert allow jappl to view Authorizing Psychiatrists with Clients report -  expected result: Success';
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

-- good reset to FALSE
DO $$
DECLARE  _output_json	json;
		_report_id	uuid;
		_in_json	json;
BEGIN	
	RAISE NOTICE 'Test 9 good reset to FALSE for jappl and Authorizing Psychiatrists with Clients report -  expected result: Success';
	_report_id:= 	(SELECT report_id 
					FROM report_manager_schema.reports 
					WHERE report_name = 'Authorizing Psychiatrists with Clients'
					);
	_in_json := '{"target_login": "jappl", "report_id": "' || _report_id::text || '", "viewable": "FALSE",  "changing_user_login": "muser"}';
	_output_json := (SELECT * FROM report_manager_schema.action_enter_edit_allowed_reports (_in_json));
	RAISE NOTICE 'TEST Result = %', (SELECT _output_json ->> 'result_indicator')::text;
	RAISE NOTICE 'Message = %', (SELECT _output_json ->> 'message')::text;
	RAISE NOTICE '';
END$$;

-- good reset to TRUE
DO $$
DECLARE  _output_json	json;
		_report_id	uuid;
		_in_json	json;
BEGIN	
	RAISE NOTICE 'Test 9 good reset to FALSE for jappl and Authorizing Psychiatrists with Clients report -  expected result: Success';
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

SELECT '';
SELECT * FROM report_manager_schema.report_folders;

SELECT '';
SELECT * FROM report_manager_schema.reports;

SELECT '';
SELECT * FROM system_user_schema.system_users;

SELECT '';
SELECT * FROM report_manager_schema.system_user_allowed_reports;

SELECT '';
SELECT * FROM report_manager_schema.system_user_allowed_reports_history;

