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

SELECT * FROM report_manager_schema.action_enter_edit_folders ('{"folder_name": "report_root", "folder_display_name":"All Programs", "description":"List of all reports", "is_root_folder": "TRUE",  "changing_user_login": "muser"}');

SELECT 'TEST insert data is complete and correct - Success' AS test_goal;
SELECT * FROM report_manager_schema.action_enter_edit_reports ('{"report_name": "Authorizing Psychiatrists with Clients", "description": "This report lists the authorizing psychiatrists for clients enrolled in one or more programs over a defined time period..", "url": "http://192.168.4.10:8080/WebViewerExample/frameset?__report=authorizing_psychiatrists_with_clients.rptdesign", "containing_folder_name": "report_root", "insert_or_update": "insert", "changing_user_login": "muser", "parameters": [{"parameter_name": "ReportStartDate"}, {"parameter_name": "ReportEndDate"}, {"parameter_name": "ProgramIds"}]}');


SELECT 'TEST insert second report' AS test_goal;
SELECT * FROM report_manager_schema.action_enter_edit_reports ('{"report_name": "Gateways Openings - Chemung Programs", "description": "This report shows the number of openings on a selected date for the Gateways programs operating in Chemung county.", "url": "http://192.168.4.10:8080/WebViewerExample/frameset?__report=gateways_vacancies_chemung.rptdesign", "containing_folder_name": "report_root", "insert_or_update": "insert", "changing_user_login": "muser", "parameters": [{"parameter_name": "ReportStartDate"}, {"parameter_name": "ReportEndDate"}, {"parameter_name": "ProgramIds"}]}');

SELECT * FROM report_manager_schema.reports;
SELECT * FROM report_manager_schema.reports_history ORDER BY report_name, datetime_report_change_started;

SELECT 'TEST update first report url' AS test_goal;
SELECT * FROM report_manager_schema.action_enter_edit_reports ('{"report_name": "Authorizing Psychiatrists with Clients", "description": "This report lists the authorizing psychiatrists for clients enrolled in one or more programs over a defined time period..", "url": "http://192.168.4.10:8080/WebViewerExample/frameset?__report=admitting_psychiatrists.rptdesign", "containing_folder_name": "report_root", "insert_or_update": "update", "changing_user_login": "muser", "parameters": [{"parameter_name": "ReportStartDate"}, {"parameter_name": "ReportEndDate"}, {"parameter_name": "ProgramIds"}]}');


SELECT 'TEST update second report description' AS test_goal;
SELECT * FROM report_manager_schema.action_enter_edit_reports ('{"report_name": "Gateways Openings - Chemung Programs", "description": "This report shows the number of un its occupied and tne number of openings on a selected date for the Gateways programs operating in Chemung county.", "url": "http://192.168.4.10:8080/WebViewerExample/frameset?__report=gateways_vacancies_chemung.rptdesign", "containing_folder_name": "report_root", "insert_or_update": "update", "changing_user_login": "muser", "parameters": [{"parameter_name": "ReportStartDate"}, {"parameter_name": "ReportEndDate"}, {"parameter_name": "ProgramIds"}]}');

SELECT * FROM report_manager_schema.reports;
DELETE  FROM report_manager_schema.reports;

SELECT * FROM report_manager_schema.reports_history ORDER BY report_name, datetime_report_change_started;


