-- test_trig_log_system_user_allowed_reports_history.sql


SELECT * FROM system_user_schema.action_user_login ('{"login": "muser", "password":"ha_melech!16"}');
SELECT * FROM system_user_schema.action_add_new_user ('{"firstname": "John", "lastname": "Appleton", "login": "jappl", "password":"river", "changing_user_login": "muser"}');
SELECT * FROM system_user_schema.action_user_login ('{"login": "jappl", "password":"river"}');
SELECT * FROM report_manager_schema.action_enter_edit_folders ('{"folder_name": "report_root", "folder_display_name":"All Programs", "description":"List of all reports", "is_root_folder": "TRUE",  "changing_user_login": "muser"}');

SELECT 'Set Up - Insert reports' AS test_goal;
SELECT * FROM report_manager_schema.action_enter_edit_reports ('{"report_name": "Authorizing Psychiatrists with Clients", "description": "This report lists the authorizing psychiatrists for clients enrolled in one or more programs over a defined time period..", "url": "http://192.168.4.10:8080/WebViewerExample/frameset?__report=authorizing_psychiatrists_with_clients.rptdesign", "containing_folder_name": "report_root", "insert_or_update": "insert", "changing_user_login": "muser", "parameters": [{"parameter_name": "ReportStartDate"}, {"parameter_name": "ReportEndDate"}, {"parameter_name": "ProgramIds"}]}');

SELECT * FROM report_manager_schema.action_enter_edit_reports ('{"report_name": "Gateways Openings - Chemung Programs", "description": "This report shows the number of openings on a selected date for the Gateways programs operating in Chemung county.", "url": "http://192.168.4.10:8080/WebViewerExample/frameset?__report=gateways_vacancies_chemung.rptdesign", "containing_folder_name": "report_root", "insert_or_update": "insert", "changing_user_login": "muser", "parameters": [{"parameter_name": "ReportStartDate"}, {"parameter_name": "ReportEndDate"}, {"parameter_name": "ProgramIds"}]}');


SELECT * FROM report_manager_schema.reports;

SELECT '**********************************************';
DELETE  FROM report_manager_schema.system_user_allowed_reports;
DELETE  FROM report_manager_schema.system_user_allowed_reports_history;

SELECT ' TEST insert new permission report/user combination does not exist identified as report_name' AS test_goal;
SELECT * FROM report_manager_schema.action_enter_edit_allowed_reports ('{"login": "jappl", "report_name": "Authorizing Psychiatrists with Clients", "task": "viewable",  "changing_user_login": "muser"}');
SELECT pg_sleep(10);
SELECT ' TEST update permission to' AS test_goal;
SELECT * FROM report_manager_schema.action_enter_edit_allowed_reports ('{"login": "jappl", "report_name": "Authorizing Psychiatrists with Clients", "task": "not_viewable",  "changing_user_login": "muser"}');



SELECT ' TEST insert new permission report/user combination does not exist ' AS test_goal;
SELECT * FROM report_manager_schema.action_enter_edit_allowed_reports ('{"login": "jappl", "report_name": "Gateways Openings - Chemung Programs", "task": "viewable",  "changing_user_login": "muser"}');
SELECT pg_sleep(10);
SELECT ' TEST update to not viewable and report is viewable' AS test_goal;
SELECT * FROM report_manager_schema.action_enter_edit_allowed_reports ('{"login": "jappl", "report_name": "Gateways Openings - Chemung Programs", "task": "not_viewable",  "changing_user_login": "muser"}');
SELECT pg_sleep(10);
SELECT ' TEST update to  viewable and report is not viewable' AS test_goal;
SELECT * FROM report_manager_schema.action_enter_edit_allowed_reports ('{"login": "jappl", "report_name": "Gateways Openings - Chemung Programs", "task": "viewable",  "changing_user_login": "muser"}');

SELECT * FROM report_manager_schema.system_user_allowed_reports;
SELECT * FROM report_manager_schema.system_user_allowed_reports_history;
SELECT pg_sleep(10);
DELETE  FROM report_manager_schema.system_user_allowed_reports;
SELECT * FROM report_manager_schema.system_user_allowed_reports;
SELECT * FROM report_manager_schema.system_user_allowed_reports_history;

