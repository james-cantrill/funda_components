--	test_action_enter_edit_folders.sql
/*
	_in_data:	
	{								
		folder_id:
		folder_name:
		folder_display_name:
		description:
		parent_folder_name:  
		is_root_folder:	-- boolean
		changing_user_login:
		enter_or_update:
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
	
-- data is incomplete
DO $$
DECLARE  _output_json	json;
BEGIN	
	RAISE NOTICE 'Test 1 data is incomplete - folder_name -  expected result: Failure';
	_output_json := (SELECT * FROM report_manager_schema.action_enter_edit_folders ('{"folder_display_name": "All Reports", "description":"Root of report tree", "is_root_folder": "TRUE", "changing_user_login": "muser", "enter_or_update": "Enter"}'));
	RAISE NOTICE 'TEST Result = %', (SELECT _output_json ->> 'result_indicator')::text;
	RAISE NOTICE 'Message = %', (SELECT _output_json ->> 'message')::text;
	RAISE NOTICE '';
END$$;
	
DO $$
DECLARE  _output_json	json;
BEGIN	
	RAISE NOTICE 'Test 2 data is incomplete - folder_display_name -  expected result: Failure';
		_output_json := (SELECT * FROM report_manager_schema.action_enter_edit_folders ('{"folder_name": "report_root", "description":"Root of report tree", "is_root_folder": "TRUE", "changing_user_login": "muser", "enter_or_update": "Enter"}'));
	RAISE NOTICE 'TEST Result = %', (SELECT _output_json ->> 'result_indicator')::text;
	RAISE NOTICE 'Message = %', (SELECT _output_json ->> 'message')::text;
	RAISE NOTICE '';
END$$;

DO $$
DECLARE  _output_json	json;
BEGIN	
	RAISE NOTICE 'Test 3 data is incomplete - description -  expected result: Failure';
		_output_json := (SELECT * FROM report_manager_schema.action_enter_edit_folders ('{"folder_name": "report_root", "folder_display_name": "All Reports",  "is_root_folder": "TRUE", "changing_user_login": "muser", "enter_or_update": "Enter"}'));
	RAISE NOTICE 'TEST Result = %', (SELECT _output_json ->> 'result_indicator')::text;
	RAISE NOTICE 'Message = %', (SELECT _output_json ->> 'message')::text;
	RAISE NOTICE '';
END$$;

DO $$
DECLARE  _output_json	json;
BEGIN	
	RAISE NOTICE 'Test 4 data is incomplete - is_root_folder -  expected result: Failure';
		_output_json := (SELECT * FROM report_manager_schema.action_enter_edit_folders ('{"folder_name": "report_root", "folder_display_name": "All Reports", "description":"Root of report tree",  "changing_user_login": "muser", "enter_or_update": "Enter"}'));
	RAISE NOTICE 'TEST Result = %', (SELECT _output_json ->> 'result_indicator')::text;
	RAISE NOTICE 'Message = %', (SELECT _output_json ->> 'message')::text;
	RAISE NOTICE '';
END$$;

DO $$
DECLARE  _output_json	json;
BEGIN	
	RAISE NOTICE 'Test 5 data is incomplete - is_root_folder is FALSE but the parent_folder_name is missing -  expected result: Failure';
		_output_json := (SELECT * FROM report_manager_schema.action_enter_edit_folders ('{"folder_name": "report_root", "folder_display_name": "All Reports", "description":"Root of report tree", "is_root_folder": "FALSE", "changing_user_login": "muser", "enter_or_update": "Enter"}'));
	RAISE NOTICE 'TEST Result = %', (SELECT _output_json ->> 'result_indicator')::text;
	RAISE NOTICE 'Message = %', (SELECT _output_json ->> 'message')::text;
	RAISE NOTICE '';
END$$;

DO $$
DECLARE  _output_json	json;
BEGIN	
	RAISE NOTICE 'Test 6 data is incomplete - changing_user_login -  expected result: Failure';
		_output_json := (SELECT * FROM report_manager_schema.action_enter_edit_folders ('{"folder_name": "report_root", "folder_display_name": "All Reports", "description":"Root of report tree", "is_root_folder": "TRUE", "enter_or_update": "Enter"}'));
	RAISE NOTICE 'TEST Result = %', (SELECT _output_json ->> 'result_indicator')::text;
	RAISE NOTICE 'Message = %', (SELECT _output_json ->> 'message')::text;
	RAISE NOTICE '';
END$$;

DO $$
DECLARE  _output_json	json;
BEGIN	
	RAISE NOTICE 'Test 7 data is incomplete - enter_or_update -  expected result: Failure';
		_output_json := (SELECT * FROM report_manager_schema.action_enter_edit_folders ('{"folder_name": "report_root", "folder_display_name": "All Reports", "description":"Root of report tree", "is_root_folder": "TRUE", "changing_user_login": "muser"}'));
	RAISE NOTICE 'TEST Result = %', (SELECT _output_json ->> 'result_indicator')::text;
	RAISE NOTICE 'Message = %', (SELECT _output_json ->> 'message')::text;
	RAISE NOTICE '';
END$$;

DO $$
DECLARE  _output_json	json;
BEGIN	
	RAISE NOTICE 'Test 8 data is incomplete - enter_or_update = Update but folder_id is missing -  expected result: Failure';
		_output_json := (SELECT * FROM report_manager_schema.action_enter_edit_folders ('{"folder_name": "report_root", "folder_display_name": "All Reports", "description":"Root of report tree", "is_root_folder": "TRUE", "changing_user_login": "muser", "enter_or_update": "Update"}'));
	RAISE NOTICE 'TEST Result = %', (SELECT _output_json ->> 'result_indicator')::text;
	RAISE NOTICE 'Message = %', (SELECT _output_json ->> 'message')::text;
	RAISE NOTICE '';
END$$;


-- user is not authorized
DO $$
DECLARE  _output_json	json;
BEGIN	
	RAISE NOTICE 'Test 9 user is not authorized -  expected result: Success';
	_output_json := (SELECT * FROM report_manager_schema.action_enter_edit_folders ('{"folder_name": "report_root", "folder_display_name": "All Reports", "description":"Root of report tree", "is_root_folder": "TRUE", "changing_user_login": "appl", "enter_or_update": "Enter"}'));
	RAISE NOTICE 'TEST Result = %', (SELECT _output_json ->> 'result_indicator')::text;
	RAISE NOTICE 'Message = %', (SELECT _output_json ->> 'message')::text;
	RAISE NOTICE '';
END$$;
	
-- parent folder does not exist
DO $$
DECLARE  _output_json	json;
BEGIN	
	RAISE NOTICE 'Test 10 parent folder does not exist -  expected result: Failure';
	_output_json := (SELECT * FROM report_manager_schema.action_enter_edit_folders ('{"folder_name": "report_root", "folder_display_name": "All Reports", "description":"Root of report tree", "is_root_folder": "FALSE", "parent_folder_name": "NON Existebt Parent", "changing_user_login": "muser", "enter_or_update": "Enter"}'));
	RAISE NOTICE 'TEST Result = %', (SELECT _output_json ->> 'result_indicator')::text;
	RAISE NOTICE 'Message = %', (SELECT _output_json ->> 'message')::text;
	RAISE NOTICE '';
END$$;
	
-- invalid enter_or_update parameter
DO $$
DECLARE  _output_json	json;
BEGIN	
	RAISE NOTICE 'Test 11 invalid enter_or_update parameter -  expected result: Failure';
	_output_json := (SELECT * FROM report_manager_schema.action_enter_edit_folders ('{"folder_name": "report_root", "folder_display_name": "All Reports", "description":"Root of report tree", "is_root_folder": "TRUE", "changing_user_login": "muser", "enter_or_update": "Other"}'));
	RAISE NOTICE 'TEST Result = %', (SELECT _output_json ->> 'result_indicator')::text;
	RAISE NOTICE 'Message = %', (SELECT _output_json ->> 'message')::text;
	RAISE NOTICE '';
END$$;


-- good insert root level folder
DO $$
DECLARE  _output_json	json;
BEGIN	
	RAISE NOTICE 'Test 12 good insert root level folder -  expected result: Success';
	_output_json := (SELECT * FROM report_manager_schema.action_enter_edit_folders ('{"folder_name": "report_root", "folder_display_name": "All Reports", "description":"Root of report tree", "is_root_folder": "TRUE", "changing_user_login": "muser", "enter_or_update": "Enter"}'));
	RAISE NOTICE 'TEST Result = %', (SELECT _output_json ->> 'result_indicator')::text;
	RAISE NOTICE 'Message = %', (SELECT _output_json ->> 'message')::text;
	RAISE NOTICE '';
END$$;
	

-- for Enter folder already exists
DO $$
DECLARE  _output_json	json;
BEGIN	
	RAISE NOTICE 'Test 13 for Enter folder already exists -  expected result: Failure';
	_output_json := (SELECT * FROM report_manager_schema.action_enter_edit_folders ('{"folder_name": "report_root", "folder_display_name": "All Reports", "description":"Root of report tree", "is_root_folder": "TRUE", "changing_user_login": "muser", "enter_or_update": "Enter"}'));
	RAISE NOTICE 'TEST Result = %', (SELECT _output_json ->> 'result_indicator')::text;
	RAISE NOTICE 'Message = %', (SELECT _output_json ->> 'message')::text;
	RAISE NOTICE '';
END$$;

-- good insert child folder
DO $$
DECLARE  _output_json	json;
BEGIN	
	RAISE NOTICE 'Test 14 good insert child folder -  expected result: Success';
	_output_json := (SELECT * FROM report_manager_schema.action_enter_edit_folders ('{"folder_name": "scheduled_reports", "folder_display_name": "Scheduled Reports", "description":"Holds all scheduled reports", "is_root_folder": "FALSE", "parent_folder_name": "report_root", "changing_user_login": "muser", "enter_or_update": "Enter"}'));
	RAISE NOTICE 'TEST Result = %', (SELECT _output_json ->> 'result_indicator')::text;
	RAISE NOTICE 'Message = %', (SELECT _output_json ->> 'message')::text;
	RAISE NOTICE '';
END$$;

-- for Update folder does not exist
DO $$
DECLARE  _output_json	json;
BEGIN	
	RAISE NOTICE 'Test 15 folder to be updated does not exist -  expected result: Failure';
	_output_json := (SELECT * FROM report_manager_schema.action_enter_edit_folders ('{"folder_id": "9e782ca4-c55e-449f-8431-e8b83fcfb1b8","folder_name": "scheduled_reports", "folder_display_name": "All Scheduled Reports", "description":"Holds all scheduled reports", "is_root_folder": "FALSE", "parent_folder_name": "report_root", "changing_user_login": "muser", "enter_or_update": "Update"}'));
	RAISE NOTICE 'TEST Result = %', (SELECT _output_json ->> 'result_indicator')::text;
	RAISE NOTICE 'Message = %', (SELECT _output_json ->> 'message')::text;
	RAISE NOTICE '';
END$$;


-- good update
DO $$
DECLARE  _output_json	json;
		_folder_id	uuid;
		_in_json	json;
BEGIN	
	RAISE NOTICE 'Test 16 good update -  expected result: Success';
	_folder_id := 	(SELECT folder_id
					 FROM report_manager_schema.report_folders
					 WHERE folder_name = 'scheduled_reports'
					);
	_in_json := '{"folder_id": "' || _folder_id::text || '", "folder_name": "scheduled_reports", "folder_display_name": "All Scheduled Reports", "description":"Holds all scheduled reports", "is_root_folder": "FALSE", "parent_folder_name": "report_root", "changing_user_login": "muser", "enter_or_update": "Update"}';				
	_output_json := (SELECT * FROM report_manager_schema.action_enter_edit_folders (_in_json));
	RAISE NOTICE 'TEST Result = %', (SELECT _output_json ->> 'result_indicator')::text;
	RAISE NOTICE 'Message = %', (SELECT _output_json ->> 'message')::text;
	RAISE NOTICE '';
END$$;


SELECT '';
SELECT * FROM report_manager_schema.report_folders;

SELECT '';
SELECT * FROM report_manager_schema.report_folders_history;
