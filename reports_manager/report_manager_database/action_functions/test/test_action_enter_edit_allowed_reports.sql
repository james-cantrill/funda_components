-- test_action_enter_edit_allowed_reports.sql
/* the json object containng the inmput data, _in_data, is defined below.

	_in_data:	{
					login:
					report_id:
					report_name:
					task:	// viewable (set system_user_allowed_reports.report_viewable to TRUE) or not_viewable (set system_user_allowed_reports.report_viewable to FALSE)
					changing_user_login:
				}
				
*/

DELETE FROM report_manager_schema.system_user_allowed_reports;

SELECT '--------------------------- Tests ---------------------------';
--	allow users to see reports

--	for jappl
SELECT * FROM report_manager_schema.action_enter_edit_allowed_reports ('{"login": "jappl", "report_name": "Gateways Openings - Chemung Programs", "task": "viewable",  "changing_user_login": "muser"}');
SELECT * FROM report_manager_schema.action_enter_edit_allowed_reports ('{"login": "jappl", "report_name": "Gateways Openings - Schuyler Programs", "task": "viewable",  "changing_user_login": "muser"}');
SELECT * FROM report_manager_schema.action_enter_edit_allowed_reports ('{"login": "jappl", "report_name": "Authorizing Psychiatrists with Clients", "task": "viewable",  "changing_user_login": "muser"}');
SELECT * FROM report_manager_schema.action_enter_edit_allowed_reports ('{"login": "jappl", "report_name": "General Public Assistance and TANF Income of Adults Participating in the Selected Programs", "task": "viewable",  "changing_user_login": "muser"}');
SELECT * FROM report_manager_schema.action_enter_edit_allowed_reports ('{"login": "jappl", "report_name": "Special Populations Served by the Selected Programs", "task": "viewable",  "changing_user_login": "muser"}');
SELECT * FROM report_manager_schema.action_enter_edit_allowed_reports ('{"login": "jappl", "report_name": "Demographics of People Served by the Selected Programs", "task": "viewable",  "changing_user_login": "muser"}');
SELECT * FROM report_manager_schema.action_enter_edit_allowed_reports ('{"login": "jappl", "report_name": "NY-501 Housing Summary Report", "task": "viewable",  "changing_user_login": "muser"}');

--	for opal
SELECT * FROM report_manager_schema.action_enter_edit_allowed_reports ('{"login": "opal", "report_name": "CCST Managment Summary Monthly Report", "task": "viewable",  "changing_user_login": "muser"}');
SELECT * FROM report_manager_schema.action_enter_edit_allowed_reports ('{"login": "opal", "report_name": "Authorizing Psychiatrists with Clients", "task": "viewable",  "changing_user_login": "muser"}');
SELECT * FROM report_manager_schema.action_enter_edit_allowed_reports ('{"login": "opal", "report_name": "General Public Assistance and TANF Income of Adults Participating in the Selected Programs", "task": "viewable",  "changing_user_login": "muser"}');
SELECT * FROM report_manager_schema.action_enter_edit_allowed_reports ('{"login": "opal", "report_name": "Special Populations Served by the Selected Programs", "task": "viewable",  "changing_user_login": "muser"}');
SELECT * FROM report_manager_schema.action_enter_edit_allowed_reports ('{"login": "opal", "report_name": "Demographics of People Served by the Selected Programs", "task": "viewable",  "changing_user_login": "muser"}');
SELECT * FROM report_manager_schema.action_enter_edit_allowed_reports ('{"login": "opal", "report_name": "NY-501 Housing Summary Report", "task": "viewable",  "changing_user_login": "muser"}');

/*
SELECT ' TEST insert user not authorized' AS test_goal;
SELECT * FROM report_manager_schema.action_enter_edit_allowed_reports ('{"login": "jappl", "report_name": "Authorizing Psychiatrists with Clients", "task": "viewable",  "changing_user_login": "jappl"}');

SELECT ' TEST submited data incomplete no login' AS test_goal;
SELECT * FROM report_manager_schema.action_enter_edit_allowed_reports ('{"report_name": "Authorizing Psychiatrists with Clients", "task": "viewable",  "changing_user_login": "muser"}');

SELECT ' TEST submited data incomplete no task' AS test_goal;
SELECT * FROM report_manager_schema.action_enter_edit_allowed_reports ('{"login": "jappl","report_name": "Authorizing Psychiatrists with Clients",  "changing_user_login": "muser"}');

SELECT ' TEST submited data incomplete no report_name or report_id' AS test_goal;
SELECT * FROM report_manager_schema.action_enter_edit_allowed_reports ('{"login": "jappl", "task": "viewable",  "changing_user_login": "muser"}');

SELECT ' TEST submited data incomplete no changing_user_login' AS test_goal;
SELECT * FROM report_manager_schema.action_enter_edit_allowed_reports ('{"login": "jappl","report_name": "Authorizing Psychiatrists with Clients", "task": "viewable"}');

SELECT ' TEST insert new permission report/user combination does not exist identified as report_name' AS test_goal;
SELECT * FROM report_manager_schema.action_enter_edit_allowed_reports ('{"login": "jappl", "report_name": "Authorizing Psychiatrists with Clients", "task": "viewable",  "changing_user_login": "muser"}');

SELECT ' TEST insert new permission report/user combination does not exist identified as report_id' AS test_goal;
SELECT * FROM report_manager_schema.action_enter_edit_allowed_reports ('{"login": "jappl", "report_id": "cde6e879-3592-47df-b455-2a8015fc576c", "task": "viewable",  "changing_user_login": "muser"}');

SELECT ' TEST update to viewable and report is viewable' AS test_goal;
SELECT * FROM report_manager_schema.action_enter_edit_allowed_reports ('{"login": "jappl", "report_id": "cde6e879-3592-47df-b455-2a8015fc576c", "task": "viewable",  "changing_user_login": "muser"}');

SELECT ' TEST update to not viewable and report is viewable' AS test_goal;
SELECT * FROM report_manager_schema.action_enter_edit_allowed_reports ('{"login": "jappl", "report_id": "cde6e879-3592-47df-b455-2a8015fc576c", "task": "not_viewable",  "changing_user_login": "muser"}');

SELECT ' TEST update to not viewable and report is not viewable' AS test_goal;
SELECT * FROM report_manager_schema.action_enter_edit_allowed_reports ('{"login": "jappl", "report_id": "cde6e879-3592-47df-b455-2a8015fc576c", "task": "not_viewable",  "changing_user_login": "muser"}');

SELECT ' TEST update to  viewable and report is not viewable' AS test_goal;
SELECT * FROM report_manager_schema.action_enter_edit_allowed_reports ('{"login": "jappl", "report_id": "cde6e879-3592-47df-b455-2a8015fc576c", "task": "viewable",  "changing_user_login": "muser"}');
*/
SELECT * FROM report_manager_schema.system_user_allowed_reports;

