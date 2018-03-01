-- test_action_enter_edit_report_parameters

----	_in_data:	{
--					report_id:
--					insert_or_update:	// text allowed values, insert, update
--					changing_user_login:
--					parameters:	[	]
--				}
SELECT  
	rp.report_id,
	rp.parameter_id,
	pl.parameter_name
FROM	report_manager_schema.parameter_list pl,
		report_manager_schema.report_parameters rp
WHERE	pl.parameter_id = rp.parameter_id
;

SELECT * FROM system_user_schema.action_user_login ('{"login": "muser", "password":"ha_melech!16"}');
SELECT * FROM system_user_schema.action_add_new_user ('{"firstname": "John", "lastname": "Appleton", "login": "jappl", "password":"river", "changing_user_login": "muser"}');
SELECT * FROM system_user_schema.action_user_login ('{"login": "jappl", "password":"river"}');
--SELECT * FROM report_manager_schema.action_enter_edit_folders ('{"folder_name": "report_root", "folder_display_name":"All Programs", "description":"List of all reports", "is_root_folder": "TRUE",  "changing_user_login": "muser"}');

-- SELECT 'TEST data is complete and correct - Success' AS test_goal;
-- SELECT * FROM report_manager_schema.action_enter_edit_reports ('{"report_name": "Authorizing Psychiatrists with Clients", "description": "This report lists the authorizing psychiatrists for clients enrolled in one or more programs over a defined time period..", "url": "http://192.168.4.10:8080/WebViewerExample/frameset?__report=authorizing_psychiatrists_with_clients.rptdesign", "containing_folder_name": "report_root", "insert_or_update": "insert", "changing_user_login": "muser", "parameters": [{"parameter_name": "ReportStartDate"}, {"parameter_name": "ReportEndDate"}, {"parameter_name": "ProgramIds"}]}');
--	"1634480f-a828-4071-836a-c256d2557b11";"Authorizing Psychiatrists with Clients";"This report lists the authorizing psychiatrists for clients enrolled in one or more programs over a defined time period..";"http://192.168.4.10:8080/WebViewerExample/frameset?__report=authorizing_psychiatrists_with_clients.rptdesign";"report_root";"2016-10-25 10:15:38";"muser"

SELECT * FROM report_manager_schema.action_enter_edit_report_parameters ('{"report_id" : "669d2414-9bd4-4692-b188-430b4e5d4596", "insert_or_update" : "update", "changing_user_login" : "muser", "parameters" : [{"parameter_name": "ReportStartDate"}, {"parameter_name": "ProgramIds"}]}');
 --NOTICE:  _input_report_param_json = {"report_id" : "669d2414-9bd4-4692-b188-430b4e5d4596", "insert_or_update" : "update", "changing_user_login" : "muser", "parameters" : [{"parameter_name": "ReportStartDate"}, {"parameter_name": "ProgramIds"}]}
SELECT  
	rp.report_id,
	rp.parameter_id,
	pl.parameter_name
FROM	report_manager_schema.parameter_list pl,
		report_manager_schema.report_parameters rp
WHERE	pl.parameter_id = rp.parameter_id
;

SELECT * FROM report_manager_schema.action_enter_edit_report_parameters ('{"report_id": "ab6137a4-e7ec-49ea-8357-afeacfa4cbf0", "insert_or_update": "update", "changing_user_login": "muser", "parameters": [{"parameter_name": "ReportStartDate"}, {"parameter_name": "YearStartDate"}, {"parameter_name": "ReportEndDate"}, {"parameter_name": "ProgramIds"}]}');

SELECT  
	rp.report_id,
	rp.parameter_id,
	pl.parameter_name
FROM	report_manager_schema.parameter_list pl,
		report_manager_schema.report_parameters rp
WHERE	pl.parameter_id = rp.parameter_id
;

SELECT * FROM report_manager_schema.action_enter_edit_report_parameters ('{"report_id": "ab6137a4-e7ec-49ea-8357-afeacfa4cbf0", "insert_or_update": "update", "changing_user_login": "muser", "parameters": [{"parameter_name": "ReportStartDate"}, {"parameter_name": "YearStartDate"}, {"parameter_name": "ReportEndDate"}, {"parameter_name": "County"}]}');

SELECT  
	rp.report_id,
	rp.parameter_id,
	pl.parameter_name
FROM	report_manager_schema.parameter_list pl,
		report_manager_schema.report_parameters rp
WHERE	pl.parameter_id = rp.parameter_id
;

SELECT * FROM report_manager_schema.action_enter_edit_report_parameters ('{"report_id": ab6137a4-e7ec-49ea-8357-afeacfa4cbf0", "insert_or_update": "update", "changing_user_login": "muser", "parameters": [{"parameter_name": "ReportStartDate"}, {"parameter_name": "YearStartDate"}, {"parameter_name": "ReportEndDate"}, {"parameter_name": "County"}]}');

SELECT * FROM report_manager_schema.action_enter_edit_report_parameters ('{"report_id": "ab6137a4-e7ec-49ea-8357-afeacfa4cbf0", "insert_or_update": "upsert", "changing_user_login": "muser", "parameters": [{"parameter_name": "ReportStartDate"}, {"parameter_name": "YearStartDate"}, {"parameter_name": "ReportEndDate"}, {"parameter_name": "County"}]}');

SELECT  
	rp.report_id,
	rp.parameter_id,
	pl.parameter_name
FROM	report_manager_schema.parameter_list pl,
		report_manager_schema.report_parameters rp
WHERE	pl.parameter_id = rp.parameter_id
;
