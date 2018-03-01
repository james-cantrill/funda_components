--	test_action_enter_edit_folders.sql
--	_in_data:	{	folder_id:
--					folder_name:
--					folder_display_name:
--					description:
--					parent_folder_name:
--					changing_user_login:
--				}

--DELETE FROM report_manager_schema.system_user_allowed_reports;
DELETE FROM report_manager_schema.report_folders_history;
DELETE  FROM report_manager_schema.report_folders;
DELETE FROM report_manager_schema.report_parameters;
DELETE FROM report_manager_schema.reports_history;
DELETE  FROM report_manager_schema.reports;

DELETE  FROM system_user_schema.system_users WHERE login IN ('jappl', 'opal');
DELETE  FROM system_user_schema.system_users_history WHERE login IN ('jappl', 'opal');
DELETE  FROM system_user_schema.system_user_state WHERE login IN ('jappl', 'opal');
DELETE  FROM system_user_schema.system_user_state_history WHERE login IN ('jappl', 'opal');
DELETE  FROM system_user_schema.system_user_allowed_actions WHERE login IN ('jappl', 'opal');
DELETE  FROM system_user_schema.system_user_allowed_actions_history WHERE login IN ('jappl', 'opal');

--	log in the master user
SELECT * FROM system_user_schema.action_user_login ('{"login": "muser", "password":"ha_melech!16"}');
	
--	add and login the test users
SELECT * FROM system_user_schema.action_add_new_user ('{"firstname": "John", "lastname": "Appleton", "login": "jappl", "password":"river", "changing_user_login": "muser"}');
SELECT * FROM system_user_schema.action_user_login ('{"login": "jappl", "password":"river"}');

SELECT * FROM system_user_schema.action_add_new_user ('{"firstname": "Roger", "lastname": "Fitzroger", "login": "opal", "password":"spade", "changing_user_login": "muser"}');
SELECT * FROM system_user_schema.action_user_login ('{"login": "opal", "password":"spade"}');

--	add the folders
SELECT * FROM report_manager_schema.action_enter_edit_folders ('{"folder_name": "report_root", "folder_display_name":"All Programs", "description":"List of all reports", "is_root_folder": "TRUE",  "changing_user_login": "muser"}');

SELECT * FROM report_manager_schema.action_enter_edit_folders ('{"folder_name": "scheduled_reports", "folder_display_name":"Scheduled Reports", "description":"List of all reports to be run on  a schedule ", "parent_folder_name": "report_root", "is_root_folder": "FALSE", "changing_user_login": "muser"}');

SELECT * FROM report_manager_schema.action_enter_edit_folders ('{"folder_name": "bi_weekly_reports", "folder_display_name":"Bi-Weekly Reports", "description":"Reports to be run every two weeks ", "parent_folder_name": "scheduled_reports", "is_root_folder": "FALSE", "changing_user_login": "muser"}');

SELECT * FROM report_manager_schema.action_enter_edit_folders ('{"folder_name": "monthly_reports", "folder_display_name":"Monthly Reports", "description":"Reports to be once a month", "parent_folder_name": "scheduled_reports", "is_root_folder": "FALSE", "changing_user_login": "muser"}');

SELECT * FROM report_manager_schema.action_enter_edit_folders ('{"folder_name": "generic_program_data", "folder_display_name":"Generic Program Data", "description":"Reports displaying general information about one or more programs", "parent_folder_name": "report_root", "is_root_folder": "FALSE", "changing_user_login": "muser"}');

--	add the reports
SELECT * FROM report_manager_schema.action_enter_edit_reports ('{"report_name": "Gateways Openings - Chemung Programs", "description": "This report shows the number of openings on a selected date for the Gateways programs operating in Chemung county. The openings are calculated as the program''s units less the number of households currently housed. Its selected_dt parameter is the date for which the openings are to be calculated. No programs need be selected since the report looks at all Gateways programs in Chemung county.", "url": "http://192.168.4.10:8080/WebViewerExample/frameset?__report=gateways_vacancies_chemung.rptdesign", "containing_folder_name": "bi_weekly_reports", "insert_or_update": "insert", "changing_user_login": "muser", "parameters": [{"parameter_name": "SelectedDate"}]}');

SELECT * FROM report_manager_schema.action_enter_edit_reports ('{"report_name": "Gateways Openings - Schuyler Programs", "description": "This report shows the number of openings on a selected date for the Gateways programs operating in Schuyler county. The openings are calculated as the program''s units less the number of households currently housed. Its selected_dt parameter is the date for which the openings are to be calculated. No programs need be selected since the report looks at all Gateways programs in Schuyler county.", "url": "http://192.168.4.10:8080/WebViewerExample/frameset?__report=gateways_vacancies_schuyler.rptdesign", "containing_folder_name": "bi_weekly_reports", "insert_or_update": "insert", "changing_user_login": "muser", "parameters": [{"parameter_name": "SelectedDate"}]}');

------------
SELECT * FROM report_manager_schema.action_enter_edit_reports ('{"report_name": "CCST Managment Summary Monthly Report", "description": "This report provides a summary of the performance on all CCST programs over a single month and compares it to that of the year through the previous month. The starting date of the month must be entered when calling the report.", "url": "http://192.168.4.10:8080/WebViewerExample/frameset?__report=CCST_management_summary.rptdesign", "containing_folder_name": "monthly_reports", "insert_or_update": "insert", "changing_user_login": "muser", "parameters": [{"parameter_name": "MonthStart"}]}');

SELECT * FROM report_manager_schema.action_enter_edit_reports ('{"report_name": "Authorizing Psychiatrists with Clients", "description": "This report lists the authorizing psychiatrists for clients enrolled in one or more programs over a defined time period. The starting date and the ending date of the time period, and the program ids for the selected programs must be entered when calling the report..", "url": "http://192.168.4.10:8080/WebViewerExample/frameset?__report=authorizing_psychiatrists_with_clients.rptdesign", "containing_folder_name": "monthly_reports", "insert_or_update": "insert", "changing_user_login": "muser", "parameters": [{"parameter_name": "ReportStartDate"}, {"parameter_name": "ReportEndDate"}, {"parameter_name": "ProgramIds"}]}');

SELECT * FROM report_manager_schema.action_enter_edit_reports ('{"report_name": "General Public Assistance and TANF Income of Adults Participating in the Selected Programs", "description": "This report reports the latest General Public Assistance and TANF income amount for all participants in the selected programs over the chosen time period. When the report is run the starting and ending dates of the time period and a comma delimited ist of the ids of the selected programs must be entered.", "url": "http://192.168.4.10:8080/WebViewerExample/frameset?__report=gpa_and_tanf_incm_rcpnts_by_prgrm.rptdesign", "containing_folder_name": "monthly_reports", "insert_or_update": "insert", "changing_user_login": "muser", "parameters": [{"parameter_name": "ReportStartDate"}, {"parameter_name": "ReportEndDate"}, {"parameter_name": "ProgramIds"}]}');

---------------------------------------------------------
SELECT * FROM report_manager_schema.action_enter_edit_reports ('{"report_name": "Special Populations Served by the Selected Programs", "description": "This report summarizes the special populations served by the selected programs during the defined time period. The special populations summarized are unaccompanied and parenting youth, domestic violence survivors, veterans, chronically homeless, adults with various disabilities, and the elderly.", "url": "http://192.168.4.10:8080/WebViewerExample/frameset?__report=special_populations_by_program.rptdesign", "containing_folder_name": "generic_program_data", "insert_or_update": "insert", "changing_user_login": "muser", "parameters": [{"parameter_name": "ReportStartDate"}, {"parameter_name": "ReportEndDate"}, {"parameter_name": "ProgramIds"}]}');

SELECT * FROM report_manager_schema.action_enter_edit_reports ('{"report_name": "Demographics of People Served by the Selected Programs", "description": "This report summarizes a number of demographic measures over all the clients and households who received services from or were housed by one or more selected programs over defined time period. This function is used to report each discrete demographic variable separately. It reports no interactions among the demographic variables, such as age by gender or race by ethnicity.", "url": "http://192.168.4.10:8080/WebViewerExample/frameset?__report=generic_demographics_all_prgrm_types.rptdesign", "containing_folder_name": "generic_program_data", "insert_or_update": "insert", "changing_user_login": "muser", "parameters": [{"parameter_name": "ReportStartDate"}, {"parameter_name": "ReportEndDate"}, {"parameter_name": "ProgramIds"}]}');

SELECT * FROM report_manager_schema.action_enter_edit_reports ('{"report_name": "NY-501 Housing Summary Report", "description": "This report summarizes by household type, age group, and housing type the number of people and households housed in the NY-501 CoC housing programs over a selected time period. The starting date and the ending date of the time period must be entered when calling the report. ", "url": "http://192.168.4.10:8080/WebViewerExample/frameset?__report=coc_housing_summary.rptdesign", "containing_folder_name": "generic_program_data", "insert_or_update": "insert", "changing_user_login": "muser", "parameters": [{"parameter_name": "ReportStartDate"}, {"parameter_name": "ReportEndDate"}]}');

--	allow users to see reports

--	for jappl
SELECT 'SELECT * FROM report_manager_schema.system_user_allowed_reports WHERE login = jappl';
SELECT * FROM report_manager_schema.system_user_allowed_reports WHERE login = 'jappl';
SELECT * FROM report_manager_schema.action_enter_edit_allowed_reports ('{"login": "jappl", "report_name": "Gateways Openings - Chemung Programs", "task": "viewable",  "changing_user_login": "muser"}');
SELECT * FROM report_manager_schema.action_enter_edit_allowed_reports ('{"login": "jappl", "report_name": "Gateways Openings - Schuyler Programs", "task": "viewable",  "changing_user_login": "muser"}');
SELECT * FROM report_manager_schema.action_enter_edit_allowed_reports ('{"login": "jappl", "report_name": "Authorizing Psychiatrists with Clients", "task": "viewable",  "changing_user_login": "muser"}');
SELECT * FROM report_manager_schema.action_enter_edit_allowed_reports ('{"login": "jappl", "report_name": "General Public Assistance and TANF Income of Adults Participating in the Selected Programs", "task": "viewable",  "changing_user_login": "muser"}');
SELECT * FROM report_manager_schema.action_enter_edit_allowed_reports ('{"login": "jappl", "report_name": "Special Populations Served by the Selected Programs", "task": "viewable",  "changing_user_login": "muser"}');
SELECT * FROM report_manager_schema.action_enter_edit_allowed_reports ('{"login": "jappl", "report_name": "Demographics of People Served by the Selected Programs", "task": "viewable",  "changing_user_login": "muser"}');
SELECT * FROM report_manager_schema.action_enter_edit_allowed_reports ('{"login": "jappl", "report_name": "NY-501 Housing Summary Report", "task": "viewable",  "changing_user_login": "muser"}');

--	for opal
SELECT 'SELECT * FROM report_manager_schema.system_user_allowed_reports WHERE login = opal';
SELECT * FROM report_manager_schema.system_user_allowed_reports WHERE login = 'opal';
SELECT * FROM report_manager_schema.action_enter_edit_allowed_reports ('{"login": "opal", "report_name": "CCST Managment Summary Monthly Report", "task": "viewable",  "changing_user_login": "muser"}');
SELECT * FROM report_manager_schema.action_enter_edit_allowed_reports ('{"login": "opal", "report_name": "Authorizing Psychiatrists with Clients", "task": "viewable",  "changing_user_login": "muser"}');
SELECT * FROM report_manager_schema.action_enter_edit_allowed_reports ('{"login": "opal", "report_name": "General Public Assistance and TANF Income of Adults Participating in the Selected Programs", "task": "viewable",  "changing_user_login": "muser"}');
SELECT * FROM report_manager_schema.action_enter_edit_allowed_reports ('{"login": "opal", "report_name": "Special Populations Served by the Selected Programs", "task": "viewable",  "changing_user_login": "muser"}');
SELECT * FROM report_manager_schema.action_enter_edit_allowed_reports ('{"login": "opal", "report_name": "Demographics of People Served by the Selected Programs", "task": "viewable",  "changing_user_login": "muser"}');
SELECT * FROM report_manager_schema.action_enter_edit_allowed_reports ('{"login": "opal", "report_name": "NY-501 Housing Summary Report", "task": "viewable",  "changing_user_login": "muser"}');
