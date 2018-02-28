-- test_action_enter_edit_reports.sql
/* the json object containng the inmput data, _in_data, is defined below.

	_in_data:	{
					report_id:
					report_name:
					description:
					url:
					containing_folder_name:
					insert_or_update:	// text allowed values, insert, update
					changing_user_login:
					parameters:	[	]
				}
*/
-- Set the system up
DELETE FROM report_manager_schema.report_parameters;
DELETE FROM report_manager_schema.reports_history;
DELETE  FROM report_manager_schema.reports;
SELECT * FROM system_user_schema.action_user_login ('{"login": "muser", "password":"ha_melech!16"}');
SELECT * FROM system_user_schema.action_add_new_user ('{"firstname": "John", "lastname": "Appleton", "login": "jappl", "password":"river", "changing_user_login": "muser"}');
SELECT * FROM system_user_schema.action_user_login ('{"login": "jappl", "password":"river"}');
SELECT * FROM report_manager_schema.action_enter_edit_folders ('{"folder_name": "report_root", "folder_display_name":"All Programs", "description":"List of all reports", "is_root_folder": "TRUE",  "changing_user_login": "muser"}');

SELECT 'TEST insert data is complete and correct - Success' AS test_goal;
SELECT * FROM report_manager_schema.action_enter_edit_reports ('{"report_name": "Authorizing Psychiatrists with Clients", "description": "This report lists the authorizing psychiatrists for clients enrolled in one or more programs over a defined time period..", "url": "http://192.168.4.10:8080/WebViewerExample/frameset?__report=authorizing_psychiatrists_with_clients.rptdesign", "containing_folder_name": "report_root", "insert_or_update": "insert", "changing_user_login": "muser", "parameters": [{"parameter_name": "ReportStartDate"}, {"parameter_name": "ReportEndDate"}, {"parameter_name": "ProgramIds"}]}');

SELECT ' TEST insert or update not specified correctly' AS test_goal;
SELECT * FROM report_manager_schema.action_enter_edit_reports ('{"report_name": "New Authorizing Psychiatrists with Clients", "description": "This report lists the authorizing psychiatrists for clients enrolled in one or more programs over a defined time period..", "url": "http://192.168.4.10:8080/WebViewerExample/frameset?__report=new_authorizing_psychiatrists_with_clients.rptdesign", "containing_folder_name": "report_root", "insert_or_update": "wrong", "changing_user_login": "muser", "parameters": [{"parameter_name": "ReportStartDate"}, {"parameter_name": "ReportEndDate"}, {"parameter_name": "ProgramIds"}]}');

SELECT ' TEST insert user not authorized' AS test_goal;
SELECT * FROM report_manager_schema.action_enter_edit_reports ('{"report_name": "Authorizing Psychiatrists with Clients", "description": "This report lists the authorizing psychiatrists for clients enrolled in one or more programs over a defined time period..", "url": "http://192.168.4.10:8080/WebViewerExample/frameset?__report=authorizing_psychiatrists_with_clients.rptdesign", "containing_folder_name": "report_root", "insert_or_update": "insert", "changing_user_login": "jappl", "parameters": [{"parameter_name": "ReportStartDate"}, {"parameter_name": "ReportEndDate"}, {"parameter_name": "ProgramIds"}]}');

SELECT ' TEST insert submited data incomplete' AS test_goal;
SELECT * FROM report_manager_schema.action_enter_edit_reports ('{"report_name": "Authorizing Psychiatrists with Clients2",  "url": "http://192.168.4.10:8080/WebViewerExample/frameset?__report=authorizing_psychiatrists_with_client2s.rptdesign", "containing_folder_name": "report_root", "insert_or_update": "insert", "changing_user_login": "muser", "parameters": [{"parameter_name": "ReportStartDate"}, {"parameter_name": "ReportEndDate"}, {"parameter_name": "ProgramIds"}]}');

SELECT '	TEST insert containing folder doesn''t exits' AS test_goal;
SELECT * FROM report_manager_schema.action_enter_edit_reports ('{"report_name": "New Authorizing Psychiatrists with Clients", "description": "This report lists the authorizing psychiatrists for clients enrolled in one or more programs over a defined time period..", "url": "http://192.168.4.10:8080/WebViewerExample/frameset?__report=new_authorizing_psychiatrists_with_clients.rptdesign", "containing_folder_name": "new_reports", "insert_or_update": "insert", "changing_user_login": "muser", "parameters": [{"parameter_name": "ReportStartDate"}, {"parameter_name": "ReportEndDate"}, {"parameter_name": "ProgramIds"}]}');

SELECT ' TEST insert report name already exists' AS test_goal;
SELECT * FROM report_manager_schema.action_enter_edit_reports ('{"report_name": "Authorizing Psychiatrists with Clients", "description": "This report lists the authorizing psychiatrists for clients enrolled in one or more programs over a defined time period..", "url": "http://192.168.4.10:8080/WebViewerExample/frameset?__report=new_authorizing_psychiatrists_with_clients.rptdesign", "containing_folder_name": "report_root", "insert_or_update": "insert", "changing_user_login": "muser", "parameters": [{"parameter_name": "ReportStartDate"}, {"parameter_name": "ReportEndDate"}, {"parameter_name": "ProgramIds"}]}');

SELECT 'TEST insert URL already exists' AS test_goal;
SELECT * FROM report_manager_schema.action_enter_edit_reports ('{"report_name": "NEW Authorizing Psychiatrists with Clients", "description": "This report lists the authorizing psychiatrists for clients enrolled in one or more programs over a defined time period..", "url": "http://192.168.4.10:8080/WebViewerExample/frameset?__report=authorizing_psychiatrists_with_clients.rptdesign", "containing_folder_name": "report_root", "insert_or_update": "insert", "changing_user_login": "muser", "parameters": [{"parameter_name": "ReportStartDate"}, {"parameter_name": "ReportEndDate"}, {"parameter_name": "ProgramIds"}]}');

SELECT 
	r.report_name, 
	rp.report_id, 
	rp.parameter_id, 
	pl.parameter_name
FROM 
	report_manager_schema.parameter_list pl, 
	report_manager_schema.report_parameters rp, 
	report_manager_schema.reports r
WHERE	pl.parameter_id = rp.parameter_id 
  AND	r.report_id = rp.report_id;
  
-----------------------------------------------------------------------
SELECT '------------------------- TESTing action_enter_edit_report_parameters ------------' AS test_goal;


SELECT 'TEST insert parameters are all in the system' AS test_goal;

SELECT * FROM report_manager_schema.action_enter_edit_reports ('{"report_name": "Gateways Openings - Chemung Programs", "description": "This report shows the number of openings on a selected date for the Gateways programs operating in Chemung county.", "url": "http://192.168.4.10:8080/WebViewerExample/frameset?__report=gateways_vacancies_chemung.rptdesign", "containing_folder_name": "report_root", "insert_or_update": "insert", "changing_user_login": "muser", "parameters": [{"parameter_name": "ReportStartDate"}, {"parameter_name": "ReportEndDate"}, {"parameter_name": "ProgramIds"}]}');

SELECT ' TEST insert one parameter isn''t in the system' AS test_goal;
SELECT * FROM report_manager_schema.action_enter_edit_reports ('{"report_name": "New Authorizing Psychiatrists with Clients", "description": "This report lists the authorizing psychiatrists for clients enrolled in one or more programs over a defined time period..", "url": "http://192.168.4.10:8080/WebViewerExample/frameset?__report=new_authorizing_psychiatrists_with_clients.rptdesign", "containing_folder_name": "report_root", "insert_or_update": "insert", "changing_user_login": "muser", "parameters": [{"parameter_name": "ReportStartDate"}, {"parameter_name": "NonExistentParam"}, {"parameter_name": "ProgramIds"}]}');

SELECT 'TEST update delete a parameter'  AS test_goal;
SELECT * FROM report_manager_schema.action_enter_edit_reports ('{"report_name": "Authorizing Psychiatrists with Clients", "description": "This report lists the authorizing psychiatrists for clients enrolled in one or more programs over a defined time period..", "url": "http://192.168.4.10:8080/WebViewerExample/frameset?__report=authorizing_psychiatrists_with_clients.rptdesign", "containing_folder_name": "report_root", "insert_or_update": "update", "changing_user_login": "muser", "parameters": [{"parameter_name": "ReportStartDate"}, {"parameter_name": "ProgramIds"}]}');
SELECT 
	r.report_name, 
	rp.report_id, 
	rp.parameter_id, 
	pl.parameter_name
FROM 
	report_manager_schema.parameter_list pl, 
	report_manager_schema.report_parameters rp, 
	report_manager_schema.reports r
WHERE	pl.parameter_id = rp.parameter_id 
  AND	r.report_id = rp.report_id;

SELECT 'TEST update add a parameter'  AS test_goal;
SELECT * FROM report_manager_schema.action_enter_edit_reports ('{"report_name": "Gateways Openings - Chemung Programs", "description": "This report shows the number of openings on a selected date for the Gateways programs operating in Chemung county.", "url": "http://192.168.4.10:8080/WebViewerExample/frameset?__report=gateways_vacancies_chemung.rptdesign", "containing_folder_name": "report_root", "insert_or_update": "update", "changing_user_login": "muser", "parameters": [{"parameter_name": "ReportStartDate"}, {"parameter_name": "ReportEndDate"}, {"parameter_name": "ProgramIds"},  {"parameter_name": "County"}]}');

SELECT 'TEST update add a non-existent parameter'  AS test_goal;
SELECT * FROM report_manager_schema.action_enter_edit_reports ('{"report_name": "Gateways Openings - Chemung Programs", "description": "This report shows the number of openings on a selected date for the Gateways programs operating in Chemung county.", "url": "http://192.168.4.10:8080/WebViewerExample/frameset?__report=gateways_vacancies_chemung.rptdesign", "containing_folder_name": "report_root", "insert_or_update": "update", "changing_user_login": "muser", "parameters": [{"parameter_name": "ReportStartDate"}, {"parameter_name": "ReportEndDate"}, {"parameter_name": "ProgramIds"},  {"parameter_name": "County"},  {"parameter_name": "NonExistentParam"}]}');

SELECT 'TEST update change a parameter'  AS test_goal;
SELECT * FROM report_manager_schema.action_enter_edit_reports ('{"report_name": "Authorizing Psychiatrists with Clients", "description": "This report lists the authorizing psychiatrists for clients enrolled in one or more programs over a defined time period..", "url": "http://192.168.4.10:8080/WebViewerExample/frameset?__report=authorizing_psychiatrists_with_clients.rptdesign", "containing_folder_name": "report_root", "insert_or_update": "update", "changing_user_login": "muser", "parameters": [{"parameter_name": "AgencyName"}, {"parameter_name": "ProgramIds"}]}');

SELECT 'TEST update with no parameter changes'  AS test_goal;
SELECT * FROM report_manager_schema.action_enter_edit_reports ('{"report_name": "Authorizing Psychiatrists with Clients", "description": "This report lists the authorizing psychiatrists for clients enrolled in one or more programs over a defined time period..", "url": "http://192.168.4.10:8080/WebViewerExample/frameset?__report=authorizing_psychiatrists_with_clients.rptdesign", "containing_folder_name": "report_root", "insert_or_update": "update", "changing_user_login": "muser", "parameters": [{"parameter_name": "AgencyName"}, {"parameter_name": "ProgramIds"}]}');

SELECT 
	r.report_name, 
	rp.report_id, 
	rp.parameter_id, 
	pl.parameter_name
FROM 
	report_manager_schema.parameter_list pl, 
	report_manager_schema.report_parameters rp, 
	report_manager_schema.reports r
WHERE	pl.parameter_id = rp.parameter_id 
  AND	r.report_id = rp.report_id;

SELECT 'TEST update change a parameter to a non-existing one'  AS test_goal;
SELECT * FROM report_manager_schema.action_enter_edit_reports ('{"report_name": "Authorizing Psychiatrists with Clients", "description": "This report lists the authorizing psychiatrists for clients enrolled in one or more programs over a defined time period..", "url": "http://192.168.4.10:8080/WebViewerExample/frameset?__report=authorizing_psychiatrists_with_clients.rptdesign", "containing_folder_name": "report_root", "insert_or_update": "update", "changing_user_login": "muser", "parameters": [{"parameter_name": "AgencyName"}, {"parameter_name": "NonExistentParam"}]}');

SELECT 
	r.report_name, 
	rp.report_id, 
	rp.parameter_id, 
	pl.parameter_name
FROM 
	report_manager_schema.parameter_list pl, 
	report_manager_schema.report_parameters rp, 
	report_manager_schema.reports r
WHERE	pl.parameter_id = rp.parameter_id 
  AND	r.report_id = rp.report_id;

SELECT *  FROM report_manager_schema.reports;

