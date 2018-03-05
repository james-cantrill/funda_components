-- test_action_enter_edit_reports.sql
/* the json object containng the inmput data, _in_data, is defined below.

--	_in_data:	
--	{
--		report_id:	required for update NULL for insert
--		report_name:	-- NOT NULL
--		description:	-- NOT NULL
--		url:	-- NOT NULL
--		containing_folder_name:	-- NOT NULL
--		changing_user_login:	-- NOT NULL
--		parameters:	[	]	
--		insert_or_update:	// text allowed values, insert, update
--	}
			
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
	
-- good insert child folder
DO $$
DECLARE  _output_json	json;
BEGIN	
	RAISE NOTICE 'Setup good insert child folder -  expected result: Success';
	_output_json := (SELECT * FROM report_manager_schema.action_enter_edit_folders ('{"folder_name": "scheduled_reports", "folder_display_name": "Scheduled Reports", "description":"Holds all scheduled reports", "is_root_folder": "FALSE", "parent_folder_name": "report_root", "changing_user_login": "muser", "enter_or_update": "Enter"}'));
	RAISE NOTICE 'TEST Result = %', (SELECT _output_json ->> 'result_indicator')::text;
	RAISE NOTICE 'Message = %', (SELECT _output_json ->> 'message')::text;
	RAISE NOTICE '';
END$$;

	
	
-- data is incomplete
DO $$
DECLARE  _output_json	json;
BEGIN	
	RAISE NOTICE 'TEST 1 data is incomplete - report_name -  expected result: Failure';
	_output_json := (SELECT * FROM report_manager_schema.action_enter_edit_reports ('{"description": "This report lists the authorizing psychiatrists for clients enrolled in one or more programs over a defined time period..", "url": "http://192.168.4.10:8080/WebViewerExample/frameset?__report=authorizing_psychiatrists_with_clients.rptdesign", "containing_folder_name": "report_root", "insert_or_update": "insert", "changing_user_login": "muser", "parameters": [{"parameter_name": "ReportStartDate"}, {"parameter_name": "ReportEndDate"}, {"parameter_name": "ProgramIds"}]}'));
	RAISE NOTICE 'TEST Result = %', (SELECT _output_json ->> 'result_indicator')::text;
	RAISE NOTICE 'Message = %', (SELECT _output_json ->> 'message')::text;
	RAISE NOTICE '';
END$$;

DO $$
DECLARE  _output_json	json;
BEGIN	
	RAISE NOTICE 'TEST 2 data is incomplete - description -  expected result: Failure';
	_output_json := (SELECT * FROM report_manager_schema.action_enter_edit_reports ('{"report_name": "Authorizing Psychiatrists with Clients", "url": "http://192.168.4.10:8080/WebViewerExample/frameset?__report=authorizing_psychiatrists_with_clients.rptdesign", "containing_folder_name": "report_root", "insert_or_update": "insert", "changing_user_login": "muser", "parameters": [{"parameter_name": "ReportStartDate"}, {"parameter_name": "ReportEndDate"}, {"parameter_name": "ProgramIds"}]}'));
	RAISE NOTICE 'TEST Result = %', (SELECT _output_json ->> 'result_indicator')::text;
	RAISE NOTICE 'Message = %', (SELECT _output_json ->> 'message')::text;
	RAISE NOTICE '';
END$$;

DO $$
DECLARE  _output_json	json;
BEGIN	
	RAISE NOTICE 'TEST 3 data is incomplete - url -  expected result: Failure';
	_output_json := (SELECT * FROM report_manager_schema.action_enter_edit_reports ('{"report_name": "Authorizing Psychiatrists with Clients", "description": "This report lists the authorizing psychiatrists for clients enrolled in one or more programs over a defined time period..",  "containing_folder_name": "report_root", "insert_or_update": "insert", "changing_user_login": "muser", "parameters": [{"parameter_name": "ReportStartDate"}, {"parameter_name": "ReportEndDate"}, {"parameter_name": "ProgramIds"}]}'));
	RAISE NOTICE 'TEST Result = %', (SELECT _output_json ->> 'result_indicator')::text;
	RAISE NOTICE 'Message = %', (SELECT _output_json ->> 'message')::text;
	RAISE NOTICE '';
END$$;

DO $$
DECLARE  _output_json	json;
BEGIN	
	RAISE NOTICE 'TEST 4 data is incomplete - containing_folder_name -  expected result: Failure';
	_output_json := (SELECT * FROM report_manager_schema.action_enter_edit_reports ('{"report_name": "Authorizing Psychiatrists with Clients", "description": "This report lists the authorizing psychiatrists for clients enrolled in one or more programs over a defined time period..", "url": "http://192.168.4.10:8080/WebViewerExample/frameset?__report=authorizing_psychiatrists_with_clients.rptdesign", "insert_or_update": "insert", "changing_user_login": "muser", "parameters": [{"parameter_name": "ReportStartDate"}, {"parameter_name": "ReportEndDate"}, {"parameter_name": "ProgramIds"}]}'));
	RAISE NOTICE 'TEST Result = %', (SELECT _output_json ->> 'result_indicator')::text;
	RAISE NOTICE 'Message = %', (SELECT _output_json ->> 'message')::text;
	RAISE NOTICE '';
END$$;

DO $$
DECLARE  _output_json	json;
BEGIN	
	RAISE NOTICE 'TEST 5 data is incomplete - insert_or_update -  expected result: Failure';
	_output_json := (SELECT * FROM report_manager_schema.action_enter_edit_reports ('{"report_name": "Authorizing Psychiatrists with Clients", "description": "This report lists the authorizing psychiatrists for clients enrolled in one or more programs over a defined time period..", "url": "http://192.168.4.10:8080/WebViewerExample/frameset?__report=authorizing_psychiatrists_with_clients.rptdesign", "containing_folder_name": "report_root",  "changing_user_login": "muser", "parameters": [{"parameter_name": "ReportStartDate"}, {"parameter_name": "ReportEndDate"}, {"parameter_name": "ProgramIds"}]}'));
	RAISE NOTICE 'TEST Result = %', (SELECT _output_json ->> 'result_indicator')::text;
	RAISE NOTICE 'Message = %', (SELECT _output_json ->> 'message')::text;
	RAISE NOTICE '';
END$$;

DO $$
DECLARE  _output_json	json;
BEGIN	
	RAISE NOTICE 'TEST 6 data is incomplete - changing_user_login -  expected result: Failure';
	_output_json := (SELECT * FROM report_manager_schema.action_enter_edit_reports ('{"report_name": "Authorizing Psychiatrists with Clients", "description": "This report lists the authorizing psychiatrists for clients enrolled in one or more programs over a defined time period..", "url": "http://192.168.4.10:8080/WebViewerExample/frameset?__report=authorizing_psychiatrists_with_clients.rptdesign", "containing_folder_name": "report_root", "insert_or_update": "insert",  "parameters": [{"parameter_name": "ReportStartDate"}, {"parameter_name": "ReportEndDate"}, {"parameter_name": "ProgramIds"}]}'));
	RAISE NOTICE 'TEST Result = %', (SELECT _output_json ->> 'result_indicator')::text;
	RAISE NOTICE 'Message = %', (SELECT _output_json ->> 'message')::text;
	RAISE NOTICE '';
END$$;

DO $$
DECLARE  _output_json	json;
BEGIN	
	RAISE NOTICE 'TEST 7 data is incomplete - insert_or_update = update and folder_id is missing -  expected result: Failure';
	_output_json := (SELECT * FROM report_manager_schema.action_enter_edit_reports ('{"report_name": "Authorizing Psychiatrists with Clients", "description": "This report lists the authorizing psychiatrists for clients enrolled in one or more programs over a defined time period..", "url": "http://192.168.4.10:8080/WebViewerExample/frameset?__report=authorizing_psychiatrists_with_clients.rptdesign", "containing_folder_name": "report_root", "insert_or_update": "update", "changing_user_login": "muser", "parameters": [{"parameter_name": "ReportStartDate"}, {"parameter_name": "ReportEndDate"}, {"parameter_name": "ProgramIds"}]}'));
	RAISE NOTICE 'TEST Result = %', (SELECT _output_json ->> 'result_indicator')::text;
	RAISE NOTICE 'Message = %', (SELECT _output_json ->> 'message')::text;
	RAISE NOTICE '';
END$$;

--  user isn't authorized to enter or edit reports
DO $$
DECLARE  _output_json	json;
BEGIN	
	RAISE NOTICE 'TEST 8 user is not authorized to enter or edit reports -  expected result: Failure';
	_output_json := (SELECT * FROM report_manager_schema.action_enter_edit_reports ('{"report_name": "Authorizing Psychiatrists with Clients", "description": "This report lists the authorizing psychiatrists for clients enrolled in one or more programs over a defined time period..", "url": "http://192.168.4.10:8080/WebViewerExample/frameset?__report=authorizing_psychiatrists_with_clients.rptdesign", "containing_folder_name": "report_root", "insert_or_update": "insert", "changing_user_login": "other", "parameters": [{"parameter_name": "ReportStartDate"}, {"parameter_name": "ReportEndDate"}, {"parameter_name": "ProgramIds"}]}'));
	RAISE NOTICE 'TEST Result = %', (SELECT _output_json ->> 'result_indicator')::text;
	RAISE NOTICE 'Message = %', (SELECT _output_json ->> 'message')::text;
	RAISE NOTICE '';
END$$;

-- containng folder does not exist
DO $$
DECLARE  _output_json	json;
BEGIN	
	RAISE NOTICE 'TEST 9 containng folder does not exist -  expected result: Failure';
	_output_json := (SELECT * FROM report_manager_schema.action_enter_edit_reports ('{"report_name": "Authorizing Psychiatrists with Clients", "description": "This report lists the authorizing psychiatrists for clients enrolled in one or more programs over a defined time period..", "url": "http://192.168.4.10:8080/WebViewerExample/frameset?__report=authorizing_psychiatrists_with_clients.rptdesign", "containing_folder_name": "non_existant_folder", "insert_or_update": "insert", "changing_user_login": "muser", "parameters": [{"parameter_name": "ReportStartDate"}, {"parameter_name": "ReportEndDate"}, {"parameter_name": "ProgramIds"}]}'));
	RAISE NOTICE 'TEST Result = %', (SELECT _output_json ->> 'result_indicator')::text;
	RAISE NOTICE 'Message = %', (SELECT _output_json ->> 'message')::text;
	RAISE NOTICE '';
END$$;



-- parameter is not in parameter list
DO $$
DECLARE  _output_json	json;
BEGIN	
	RAISE NOTICE 'TEST 10 parameter is not in parameter list -  expected result: Failure';
	 _output_json := (SELECT * FROM report_manager_schema.action_enter_edit_reports ('{"report_name": "Test Parameter Report", "description": "This report tests parameter errors.", "url": "http://192.168.4.10:8080/WebViewerExample/frameset?__report=test_parame.rptdesign", "containing_folder_name": "report_root", "insert_or_update": "insert", "changing_user_login": "muser", "parameters": [{"parameter_name": "ReportGoDate"}, {"parameter_name": "ReportEndDate"}, {"parameter_name": "ProgramIds"}]}'));
	RAISE NOTICE 'TEST Result = %', (SELECT _output_json ->> 'result_indicator')::text;
	RAISE NOTICE 'Message = %', (SELECT _output_json ->> 'message')::text;
	RAISE NOTICE '';
END$$;


-- good insert into root folder
DO $$
DECLARE  _output_json	json;
BEGIN	
	RAISE NOTICE 'TEST 11 good insert into root folder -  expected result: Success';
	_output_json := (SELECT * FROM report_manager_schema.action_enter_edit_reports ('{"report_name": "Authorizing Psychiatrists with Clients", "description": "This report lists the authorizing psychiatrists for clients enrolled in one or more programs over a defined time period..", "url": "http://192.168.4.10:8080/WebViewerExample/frameset?__report=authorizing_psychiatrists_with_clients.rptdesign", "containing_folder_name": "report_root", "insert_or_update": "insert", "changing_user_login": "muser", "parameters": [{"parameter_name": "ReportStartDate"}, {"parameter_name": "ReportEndDate"}, {"parameter_name": "ProgramIds"}]}'));
	RAISE NOTICE 'TEST Result = %', (SELECT _output_json ->> 'result_indicator')::text;
	RAISE NOTICE 'Message = %', (SELECT _output_json ->> 'message')::text;
	RAISE NOTICE '';
END$$;

-- good insert into child folder
DO $$
DECLARE  _output_json	json;
BEGIN	
	RAISE NOTICE 'TEST 12 good insert into root folder -  expected result: Success';
	_output_json := (SELECT * FROM report_manager_schema.action_enter_edit_reports ('{"report_name": "Gateways Openings - Chemung Programs", "description": "This report shows the number of openings on a selected date for the Gateways programs operating in Chemung county.", "url": "http://192.168.4.10:8080/WebViewerExample/frameset?__report=gateways_vacancies_chemung.rptdesign", "containing_folder_name": "scheduled_reports", "insert_or_update": "insert", "changing_user_login": "muser", "parameters": [{"parameter_name": "ReportStartDate"}, {"parameter_name": "ReportEndDate"}, {"parameter_name": "ProgramIds"}]}'));
	RAISE NOTICE 'TEST Result = %', (SELECT _output_json ->> 'result_indicator')::text;
	RAISE NOTICE 'Message = %', (SELECT _output_json ->> 'message')::text;
	RAISE NOTICE '';
END$$;

-- insert but report name isn't unique
DO $$
DECLARE  _output_json	json;
BEGIN	
	RAISE NOTICE 'TEST 13 insert but report name is not unique -  expected result: Failure';
	_output_json := (SELECT * FROM report_manager_schema.action_enter_edit_reports ('{"report_name": "Authorizing Psychiatrists with Clients", "description": "This report lists the authorizing psychiatrists for clients enrolled in one or more programs over a defined time period..", "url": "http://192.168.4.10:8080/WebViewerExample/frameset?__report=authorizing_psychiatrists_with_clients.rptdesign", "containing_folder_name": "report_root", "insert_or_update": "insert", "changing_user_login": "muser", "parameters": [{"parameter_name": "ReportStartDate"}, {"parameter_name": "ReportEndDate"}, {"parameter_name": "ProgramIds"}]}'));
	RAISE NOTICE 'TEST Result = %', (SELECT _output_json ->> 'result_indicator')::text;
	RAISE NOTICE 'Message = %', (SELECT _output_json ->> 'message')::text;
	RAISE NOTICE '';
END$$;

-- insert but URL isn't unique
DO $$
DECLARE  _output_json	json;
BEGIN	
	RAISE NOTICE 'TEST 14 insert but URL is not unique -  expected result: Failure';
	_output_json := (SELECT * FROM report_manager_schema.action_enter_edit_reports ('{"report_name": "Gateways Openings - Schuyler Programs", "description": "This report shows the number of openings on a selected date for the Gateways programs operating in Schuyler county.", "url": "http://192.168.4.10:8080/WebViewerExample/frameset?__report=gateways_vacancies_chemung.rptdesign", "containing_folder_name": "scheduled_reports", "insert_or_update": "insert", "changing_user_login": "muser", "parameters": [{"parameter_name": "ReportStartDate"}, {"parameter_name": "ReportEndDate"}, {"parameter_name": "ProgramIds"}]}'));
	RAISE NOTICE 'TEST Result = %', (SELECT _output_json ->> 'result_indicator')::text;
	RAISE NOTICE 'Message = %', (SELECT _output_json ->> 'message')::text;
	RAISE NOTICE '';
END$$;

-- on update report does not exist
DO $$
DECLARE  _output_json	json;
BEGIN	
	RAISE NOTICE 'TEST 15 on update report does not exist -  expected result: Failure';
	_output_json := (SELECT * FROM report_manager_schema.action_enter_edit_reports ('{"report_id": "85faca05-7d90-41b0-ac9e-e893deba820d", "report_name": "Authorizing Psychiatrists with Clients", "description": "This CHANGED report lists the authorizing psychiatrists for clients enrolled in one or more programs over a defined time period..", "url": "http://192.168.4.10:8080/WebViewerExample/frameset?__report=authorizing_psychiatrists_with_clients.rptdesign", "containing_folder_name": "report_root", "insert_or_update": "update", "changing_user_login": "muser", "parameters": [{"parameter_name": "ReportStartDate"}, {"parameter_name": "ReportEndDate"}, {"parameter_name": "ProgramIds"}]}'));
	RAISE NOTICE 'TEST Result = %', (SELECT _output_json ->> 'result_indicator')::text;
	RAISE NOTICE 'Message = %', (SELECT _output_json ->> 'message')::text;
	RAISE NOTICE '';
END$$;

-- on update new report name is not unique
DO $$
DECLARE  _output_json	json;
		_report_id	uuid;
		_in_json	json;
BEGIN	
	RAISE NOTICE 'TEST 16 on update new report name is not unique -  expected result: Failure';
	_report_id:= 	(SELECT report_id 
					FROM report_manager_schema.reports 
					WHERE report_name = 'Gateways Openings - Chemung Programs'
					);
	_in_json := '{"report_id": "' || _report_id::text || '", "report_name": "Authorizing Psychiatrists with Clients", "description": "This report shows the number of openings on a selected date for the Gateways programs operating in Chemung county.", "url": "http://192.168.4.10:8080/WebViewerExample/frameset?__report=gateways_vacancies_chemung.rptdesign", "containing_folder_name": "scheduled_reports", "insert_or_update": "update", "changing_user_login": "muser", "parameters": [{"parameter_name": "ReportStartDate"}, {"parameter_name": "ReportEndDate"}, {"parameter_name": "ProgramIds"}]}';
	
	_output_json := (SELECT * FROM report_manager_schema.action_enter_edit_reports (_in_json));
	RAISE NOTICE 'TEST Result = %', (SELECT _output_json ->> 'result_indicator')::text;
	RAISE NOTICE 'Message = %', (SELECT _output_json ->> 'message')::text;
	RAISE NOTICE '';
END$$;


-- on update new URL is not unique
DO $$
DECLARE  _output_json	json;
		_report_id	uuid;
		_in_json	json;
BEGIN	
	RAISE NOTICE 'TEST 17 on update new URL is not unique -  expected result: Success';
	_report_id:= 	(SELECT report_id 
					FROM report_manager_schema.reports 
					WHERE report_name = 'Gateways Openings - Chemung Programs'
					);
	_in_json := '{"report_id": "' || _report_id::text || '", "report_name": "Gateways Openings - All Chemung Programs", "description": "This report shows the number of openings on a selected date for the Gateways programs operating in Chemung county.", "url": "http://192.168.4.10:8080/WebViewerExample/frameset?__report=authorizing_psychiatrists_with_clients.rptdesign", "containing_folder_name": "scheduled_reports", "insert_or_update": "update", "changing_user_login": "muser", "parameters": [{"parameter_name": "ReportStartDate"}, {"parameter_name": "ReportEndDate"}, {"parameter_name": "ProgramIds"}]}';
	
	_output_json := (SELECT * FROM report_manager_schema.action_enter_edit_reports (_in_json));
	RAISE NOTICE 'TEST Result = %', (SELECT _output_json ->> 'result_indicator')::text;
	RAISE NOTICE 'Message = %', (SELECT _output_json ->> 'message')::text;
	RAISE NOTICE '';
END$$;

-- good update
DO $$
DECLARE  _output_json	json;
		_report_id	uuid;
		_in_json	json;
BEGIN	
	RAISE NOTICE 'TEST 18 good update -  expected result: Success';
	_report_id:= 	(SELECT report_id 
					FROM report_manager_schema.reports 
					WHERE report_name = 'Gateways Openings - Chemung Programs'
					);
	_in_json := '{"report_id": "' || _report_id::text || '", "report_name": "Gateways Openings - All Chemung Programs", "description": "This report shows the number of openings on a selected date for the Gateways programs operating in Chemung county.", "url": "http://192.168.4.10:8080/WebViewerExample/frameset?__report=gateways_vacancies_chemung.rptdesign", "containing_folder_name": "scheduled_reports", "insert_or_update": "update", "changing_user_login": "muser", "parameters": [{"parameter_name": "ReportStartDate"}, {"parameter_name": "ReportEndDate"}, {"parameter_name": "ProgramIds"}]}';
	
	_output_json := (SELECT * FROM report_manager_schema.action_enter_edit_reports (_in_json));
	RAISE NOTICE 'TEST Result = %', (SELECT _output_json ->> 'result_indicator')::text;
	RAISE NOTICE 'Message = %', (SELECT _output_json ->> 'message')::text;
	RAISE NOTICE '';
END$$;

-- bad update parameter does not exist
DO $$
DECLARE  _output_json	json;
		_report_id	uuid;
		_in_json	json;
BEGIN	
	RAISE NOTICE 'TEST 19 bad update parameter does not exist -  expected result: Failure';
	_report_id:= 	(SELECT report_id 
					FROM report_manager_schema.reports 
					WHERE report_name = 'Gateways Openings - All Chemung Programs'
					);
	_in_json := '{"report_id": "' || _report_id::text || '", "report_name": "Gateways Openings - All Chemung Programs", "description": "This report shows the number of openings on a selected date for the Gateways programs operating in Chemung county.", "url": "http://192.168.4.10:8080/WebViewerExample/frameset?__report=gateways_vacancies_chemung.rptdesign", "containing_folder_name": "scheduled_reports", "insert_or_update": "update", "changing_user_login": "muser", "parameters": [{"parameter_name": "ReportGoDate"}, {"parameter_name": "ReportEndDate"}, {"parameter_name": "ProgramIds"}]}';
	
	_output_json := (SELECT * FROM report_manager_schema.action_enter_edit_reports (_in_json));
	RAISE NOTICE 'TEST Result = %', (SELECT _output_json ->> 'result_indicator')::text;
	RAISE NOTICE 'Message = %', (SELECT _output_json ->> 'message')::text;
	RAISE NOTICE '';
END$$;

-- update one parameter
DO $$
DECLARE  _output_json	json;
		_report_id	uuid;
		_in_json	json;
BEGIN	
	RAISE NOTICE 'TEST 20 update one parameter -  expected result: Success';
	_report_id:= 	(SELECT report_id 
					FROM report_manager_schema.reports 
					WHERE report_name = 'Gateways Openings - All Chemung Programs'
					);
	_in_json := '{"report_id": "' || _report_id::text || '", "report_name": "Gateways Openings - All Chemung Programs", "description": "This report shows the number of openings on a selected date for the Gateways programs operating in Chemung county.", "url": "http://192.168.4.10:8080/WebViewerExample/frameset?__report=gateways_vacancies_chemung.rptdesign", "containing_folder_name": "scheduled_reports", "insert_or_update": "update", "changing_user_login": "muser", "parameters": [{"parameter_name": "YearStartDate"}, {"parameter_name": "ReportEndDate"}, {"parameter_name": "ProgramIds"}]}';
	
	_output_json := (SELECT * FROM report_manager_schema.action_enter_edit_reports (_in_json));
	RAISE NOTICE 'TEST Result = %', (SELECT _output_json ->> 'result_indicator')::text;
	RAISE NOTICE 'Message = %', (SELECT _output_json ->> 'message')::text;
	RAISE NOTICE '';
END$$;


SELECT '';
SELECT * FROM report_manager_schema.report_folders;

SELECT '';
SELECT * FROM report_manager_schema.reports;

SELECT '';
SELECT * FROM report_manager_schema.reports_history;

SELECT '';
SELECT * FROM report_manager_schema.report_parameters;

SELECT '';
SELECT * FROM report_manager_schema.report_parameters_history;

