-- install_test_users_reports.sql
/* This script installs the users and reports to be used in testing tnhe STEPS Reports application
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

-- INSERT all folders
-- insert root level folder
DO $$
DECLARE  _output_json	json;
BEGIN	
	RAISE NOTICE 'Setup insert root level folder -  expected result: Success';
	_output_json := (SELECT * FROM report_manager_schema.action_enter_edit_folders ('{"folder_name": "report_root", "folder_display_name": "All Reports", "description":"Root of report tree", "is_root_folder": "TRUE", "changing_user_login": "muser", "enter_or_update": "Enter"}'));
	RAISE NOTICE 'TEST Result = %', (SELECT _output_json ->> 'result_indicator')::text;
	RAISE NOTICE 'Message = %', (SELECT _output_json ->> 'message')::text;
	RAISE NOTICE '';
END$$;

--insert second level folders
--	Scheduled Reports
DO $$
DECLARE  _output_json	json;
BEGIN	
	_output_json := (SELECT * FROM report_manager_schema.action_enter_edit_folders ('{"folder_name": "scheduled_reports", "folder_display_name": "Scheduled Reports", "description":"Holds all scheduled reports", "is_root_folder": "FALSE", "parent_folder_name": "report_root", "changing_user_login": "muser", "enter_or_update": "Enter"}'));
	RAISE NOTICE 'TEST Result = %', (SELECT _output_json ->> 'result_indicator')::text;
	RAISE NOTICE 'Message = %', (SELECT _output_json ->> 'message')::text;
END$$;

--	Data Quality
DO $$
DECLARE  _output_json	json;
BEGIN	
	_output_json := (SELECT * FROM report_manager_schema.action_enter_edit_folders ('{"folder_name": "data_quality", "folder_display_name": "Data Quality", "description":"Lists all data quality reports", "is_root_folder": "FALSE", "parent_folder_name": "report_root", "changing_user_login": "muser", "enter_or_update": "Enter"}'));
	RAISE NOTICE 'TEST Result = %', (SELECT _output_json ->> 'result_indicator')::text;
	RAISE NOTICE 'Message = %', (SELECT _output_json ->> 'message')::text;
END$$;

--	Generic Program Data
DO $$
DECLARE  _output_json	json;
BEGIN	
	_output_json := (SELECT * FROM report_manager_schema.action_enter_edit_folders ('{"folder_name": "generic_program_data", "folder_display_name": "Generic Program Data", "description":"Lists the general reports", "is_root_folder": "FALSE", "parent_folder_name": "report_root", "changing_user_login": "muser", "enter_or_update": "Enter"}'));
	RAISE NOTICE 'TEST Result = %', (SELECT _output_json ->> 'result_indicator')::text;
	RAISE NOTICE 'Message = %', (SELECT _output_json ->> 'message')::text;
END$$;

-- insert third levle folders
--	Monthly Reports under Scheduled Reports
DO $$
DECLARE  _output_json	json;
BEGIN	
	_output_json := (SELECT * FROM report_manager_schema.action_enter_edit_folders ('{"folder_name": "monthly_reports", "folder_display_name": "Monthly Reports", "description":"Lists the reports scheduled to be run monthly", "is_root_folder": "FALSE", "parent_folder_name": "scheduled_reports", "changing_user_login": "muser", "enter_or_update": "Enter"}'));
	RAISE NOTICE 'TEST Result = %', (SELECT _output_json ->> 'result_indicator')::text;
	RAISE NOTICE 'Message = %', (SELECT _output_json ->> 'message')::text;
END$$;

--	COC Data Quality Reports under Data Quality
DO $$
DECLARE  _output_json	json;
BEGIN	
	_output_json := (SELECT * FROM report_manager_schema.action_enter_edit_folders ('{"folder_name": "coc_dq_reports", "folder_display_name": "COC Data Quality Reports", "description":"Lists the CoC level data quality reports", "is_root_folder": "FALSE", "parent_folder_name": "data_quality", "changing_user_login": "muser", "enter_or_update": "Enter"}'));
	RAISE NOTICE 'TEST Result = %', (SELECT _output_json ->> 'result_indicator')::text;
	RAISE NOTICE 'Message = %', (SELECT _output_json ->> 'message')::text;
END$$;

--	Data Quality Reports for Selected Programs  under Data Quality
DO $$
DECLARE  _output_json	json;
BEGIN	
	_output_json := (SELECT * FROM report_manager_schema.action_enter_edit_folders ('{"folder_name": "prgm_dq_reports", "folder_display_name": "Data Quality Reports for Selected Programs", "description":"Lists the data quality reports to be run for selected programs", "is_root_folder": "FALSE", "parent_folder_name": "data_quality", "changing_user_login": "muser", "enter_or_update": "Enter"}'));
	RAISE NOTICE 'TEST Result = %', (SELECT _output_json ->> 'result_indicator')::text;
	RAISE NOTICE 'Message = %', (SELECT _output_json ->> 'message')::text;
END$$;


-- INSERT all reports

--	insert the reports in Monthly Reports under Scheduled Reports

DO $$
DECLARE  _output_json	json;
BEGIN	
	_output_json := (SELECT * FROM report_manager_schema.action_enter_edit_reports ('{"report_name": "CCST Managment Summary Monthly Report", "description": "This report provides a summary of the performance on all CCST programs over a single  month and compares it to that of the year through the previous month. The starting date of the month must be entered when calling the report.", "url": "http://192.168.4.10:8080/WebViewerExample/frameset?__report=CCST_management_summary.rptdesign", "containing_folder_name": "monthly_reports", "insert_or_update": "insert", "changing_user_login": "muser", "parameters": [{"parameter_name": "ReportStartDate"}, {"parameter_name": "ReportEndDate"}, {"parameter_name": "ProgramIds"}]}'));
	RAISE NOTICE 'TEST Result = %', (SELECT _output_json ->> 'result_indicator')::text;
	RAISE NOTICE 'Message = %', (SELECT _output_json ->> 'message')::text;
END$$;

DO $$
DECLARE  _output_json	json;
BEGIN	
	_output_json := (SELECT * FROM report_manager_schema.action_enter_edit_reports ('{"report_name": "OMH and Chemung County Outputs By Month", "description": "This report shows the OMH defined outputs over the selected time period for each selected program. The starting date and the ending date of the selected time period and a comma delimited list of the program_ids of the selected programs must be entered when calling the report.", "url": "http://192.168.4.10:8080/WebViewerExample/frameset?__report=OMH_Chemung_outputs.rptdesign", "containing_folder_name": "monthly_reports", "insert_or_update": "insert", "changing_user_login": "muser", "parameters": [{"parameter_name": "ReportStartDate"}, {"parameter_name": "ReportEndDate"}, {"parameter_name": "ProgramIds"}]}'));
	RAISE NOTICE 'TEST Result = %', (SELECT _output_json ->> 'result_indicator')::text;
	RAISE NOTICE 'Message = %', (SELECT _output_json ->> 'message')::text;
END$$;

DO $$
DECLARE  _output_json	json;
BEGIN	
	_output_json := (SELECT * FROM report_manager_schema.action_enter_edit_reports ('{"report_name": "Second Place East Shelter Monthly Report to Chemung DSS", "description": "This report shows the OMH defined outputs over the selected time period for the CCC/S emergency shelter program. The starting date and the ending date of the selected time period must be entered when calling the report.", "url": "http://192.168.4.10:8080/WebViewerExample/frameset?__report=county_dss_spe_monthly_revised.rptdesign", "containing_folder_name": "monthly_reports", "insert_or_update": "insert", "changing_user_login": "muser", "parameters": [{"parameter_name": "ReportStartDate"}, {"parameter_name": "ReportEndDate"}, {"parameter_name": "ProgramIds"}]}'));
	RAISE NOTICE 'TEST Result = %', (SELECT _output_json ->> 'result_indicator')::text;
	RAISE NOTICE 'Message = %', (SELECT _output_json ->> 'message')::text;
END$$;

DO $$
DECLARE  _output_json	json;
BEGIN	
	_output_json := (SELECT * FROM report_manager_schema.action_enter_edit_reports ('{"report_name": "CC Steuben DSS Report", "description": "This report shows the number of households and people in those households who received services from one or more programs over defined time period and whethewr they were eligible for TANF or not.  The starting date and the ending date of the time period, and a comma delimited list of the program ids for the selected program must be entered when calling the report.", "url": "http://192.168.4.10:8080/WebViewerExample/frameset?__report=CCSTEUBEN_DSS_report.rptdesign", "containing_folder_name": "monthly_reports", "insert_or_update": "insert", "changing_user_login": "muser", "parameters": [{"parameter_name": "ReportStartDate"}, {"parameter_name": "ReportEndDate"}, {"parameter_name": "ProgramIds"}]}'));
	RAISE NOTICE 'TEST Result = %', (SELECT _output_json ->> 'result_indicator')::text;
	RAISE NOTICE 'Message = %', (SELECT _output_json ->> 'message')::text;
END$$;

-- Insert the reports in COC Data Quality Reports under Data Quality
DO $$
DECLARE  _output_json	json;
BEGIN	
	_output_json := (SELECT * FROM report_manager_schema.action_enter_edit_reports ('{"report_name": "Universal Data Elements Data Quality Summmary for One CoC Version 5.2", "description": "The Universal Data Elements Data Quality Summmary for One CoC Version 5.2 report shows the data quality of the HUD defined Universal Data Elements as specified in the HMIS Data Standards DATA DICTIONARY released June, 2017 for all programs with the selected HMIS Project Types for a single selected continuum over a seleted time period. Its start_dt and end_dt parameters define the selected time period. Its _continuum_name parameter is the name of the single selected Continuum. Its _list_of_hmis_types parameter  lists the selected HMIS Project Types as a comma delimited list with no spaces before or after the commas. The default _list_of_hmis_types are the types used in the HUD Strategic Performance Measures (SPM)", "url": "http://192.168.4.10:8080/WebViewerExample/frameset?__report=ude_dq_ver_5_2_summary_for_one_coc.rptdesign", "containing_folder_name": "coc_dq_reports", "insert_or_update": "insert", "changing_user_login": "muser", "parameters": [{"parameter_name": "ReportStartDate"}, {"parameter_name": "ReportEndDate"}, {"parameter_name": "ProgramIds"}]}'));
	RAISE NOTICE 'TEST Result = %', (SELECT _output_json ->> 'result_indicator')::text;
	RAISE NOTICE 'Message = %', (SELECT _output_json ->> 'message')::text;
END$$;

DO $$
DECLARE  _output_json	json;
BEGIN	
	_output_json := (SELECT * FROM report_manager_schema.action_enter_edit_reports ('{"report_name": "Project Specific Elements Data Quality Summmary for One CoC Version 5.2", "description": "The Project Specific Elements Data Quality Summmary for One CoC Version 5.2 report shows the data quality of the HUD defined project specific data elements required for HUD:CoC and the HUD:ESG funded projects. It reports foe for all programs with the selected HMIS Project Types for a single selected continuum over a seleted time period. Its start_dt and end_dt parameters define the selected time period. Its _continuum_name parameter is the name of the single selected Continuum. Its _list_of_hmis_types parameter  lists the selected HMIS Project Types as a comma delimited list with no spaces before or after the commas. The default _list_of_hmis_types are the types used in the HUD Strategic Performance Measures (SPM). Its _return_coc_funded_only parameter specifies if data only for the CoC funded programs is to be returned or if all data is to be returned. The parameter''s allowed values are Yes (return only CoC funded programs) and No (return data for all programs)", "url": "http://192.168.4.10:8080/WebViewerExample/frameset?__report=coc_esg_project_specific_dq_summary_for_one_coc_ver_5_2.rptdesign", "containing_folder_name": "coc_dq_reports", "insert_or_update": "insert", "changing_user_login": "muser", "parameters": [{"parameter_name": "ReportStartDate"}, {"parameter_name": "ReportEndDate"}, {"parameter_name": "ProgramIds"}]}'));
	RAISE NOTICE 'TEST Result = %', (SELECT _output_json ->> 'result_indicator')::text;
	RAISE NOTICE 'Message = %', (SELECT _output_json ->> 'message')::text;
END$$;

-- Insert the reports in Data Quality Reports for Selected Programs  under Data Quality

DO $$
DECLARE  _output_json	json;
BEGIN	
	_output_json := (SELECT * FROM report_manager_schema.action_enter_edit_reports ('{"report_name": "Data Quality Error Details Version 5.2", "description": "The Data Quality Error Details Version 5.2 report lists all the clients active in the selected programs during the selected time period with data quality errors in the HUD defined Universal Data Elements (UDE) as specified in the HMIS Data Standards DATA DICTIONARY released June, 2017. It is used to locate and fix specific UDE errors. Its start_dt and end_dt parameters define the selected time period. Its in_specified_programs parameter is a comma delimited list of the program_ids of the selected programs.", "url": "http://192.168.4.10:8080/WebViewerExample/frameset?__report=ude_dq_ver_5_2_error_detail_by_project.rptdesign", "containing_folder_name": "prgm_dq_reports", "insert_or_update": "insert", "changing_user_login": "muser", "parameters": [{"parameter_name": "ReportStartDate"}, {"parameter_name": "ReportEndDate"}, {"parameter_name": "ProgramIds"}]}'));
	RAISE NOTICE 'TEST Result = %', (SELECT _output_json ->> 'result_indicator')::text;
	RAISE NOTICE 'Message = %', (SELECT _output_json ->> 'message')::text;
END$$;

DO $$
DECLARE  _output_json	json;
BEGIN	
	_output_json := (SELECT * FROM report_manager_schema.action_enter_edit_reports ('{"report_name": "Project Specific Elements Data Quality Error Details Version 5.2", "description": "The Project Specific Elements Data Quality Error Details Version 5.2 report lists all the clients active in the selected programs during the selected time period with data quality errors in the HUD defined project specific data elements required for HUD:CoC and the HUD:ESG funded projects as specified in the HMIS Data Standards DATA DICTIONARY released June, 2017. It is used to locate and fix specific data errors.  Its start_dt and end_dt parameters define the selected time period. Its in_specified_programs parameter is a comma delimited list of the program_ids of the selected programs.", "url": "http://192.168.4.10:8080/WebViewerExample/frameset?__report=coc_esg_project_specific_dq_5_2_error_detail_by_project.rptdesign", "containing_folder_name": "prgm_dq_reports", "insert_or_update": "insert", "changing_user_login": "muser", "parameters": [{"parameter_name": "ReportStartDate"}, {"parameter_name": "ReportEndDate"}, {"parameter_name": "ProgramIds"}]}'));
	RAISE NOTICE 'TEST Result = %', (SELECT _output_json ->> 'result_indicator')::text;
	RAISE NOTICE 'Message = %', (SELECT _output_json ->> 'message')::text;
END$$;

-- Insert reports in Generic Program Data

DO $$
DECLARE  _output_json	json;
BEGIN	
	_output_json := (SELECT * FROM report_manager_schema.action_enter_edit_reports ('{"report_name": "United Way Demographics Report People Served", "description": "This report provides the  United Way of the Southern Tier Demographics data about the people who received a service from one or more selected programs over a selected time period. The starting date and the ending date of the time period, and the program ids for the selected programs must be entered when calling the report.", "url": "http://192.168.4.10:8080/WebViewerExample/frameset?__report=uw_demographics.rptdesign", "containing_folder_name": "generic_program_data", "insert_or_update": "insert", "changing_user_login": "muser", "parameters": [{"parameter_name": "ReportStartDate"}, {"parameter_name": "ReportEndDate"}, {"parameter_name": "ProgramIds"}]}'));
	RAISE NOTICE 'TEST Result = %', (SELECT _output_json ->> 'result_indicator')::text;
	RAISE NOTICE 'Message = %', (SELECT _output_json ->> 'message')::text;
END$$;

DO $$
DECLARE  _output_json	json;
BEGIN	
	_output_json := (SELECT * FROM report_manager_schema.action_enter_edit_reports ('{"report_name": "Number of Services provided and people and Households Served", "description": "This report shows the number of servies provided, by type, and the number of people and households served by one or more selected programs during the selected time period. The starting date and the ending date of the time period, and the program ids for the selected programs must be entered when calling the report.", "url": "http://192.168.4.10:8080/WebViewerExample/frameset?__report=srvcs_ppl_hshlds_by_prgrm.rptdesign", "containing_folder_name": "generic_program_data", "insert_or_update": "insert", "changing_user_login": "muser", "parameters": [{"parameter_name": "ReportStartDate"}, {"parameter_name": "ReportEndDate"}, {"parameter_name": "ProgramIds"}]}'));
	RAISE NOTICE 'TEST Result = %', (SELECT _output_json ->> 'result_indicator')::text;
	RAISE NOTICE 'Message = %', (SELECT _output_json ->> 'message')::text;
END$$;

DO $$
DECLARE  _output_json	json;
BEGIN	
	_output_json := (SELECT * FROM report_manager_schema.action_enter_edit_reports ('{"report_name": "Defined Performance Measures for the Selected Housing Programs", "description": "This report provides the data for HUD''s System Performance measures for one or more selected programs during the selected time period. The starting date and the ending date of the time period, and the program ids for the selected programs must be entered when calling the report.", "url": "http://192.168.4.10:8080/WebViewerExample/frameset?__report=slctd_prfrmnc_msrs_by_prgrm.rptdesign", "containing_folder_name": "generic_program_data", "insert_or_update": "insert", "changing_user_login": "muser", "parameters": [{"parameter_name": "ReportStartDate"}, {"parameter_name": "ReportEndDate"}, {"parameter_name": "ProgramIds"}]}'));
	RAISE NOTICE 'TEST Result = %', (SELECT _output_json ->> 'result_indicator')::text;
	RAISE NOTICE 'Message = %', (SELECT _output_json ->> 'message')::text;
END$$;

DO $$
DECLARE  _output_json	json;
BEGIN	
	_output_json := (SELECT * FROM report_manager_schema.action_enter_edit_reports ('{"report_name": "Special Populations Served by the Selected Programs", "description": "This report summarizes the special populations served by the selected programs during the defined time period. The special populations summarized are unaccompanied and parenting youth, domestic violence survivors, veterans, chronically homeless, adults with various disabilities, and the elderly. The starting date and the ending date of the time period, and the program ids for the selected programs must be entered when calling the report.", "url": "http://192.168.4.10:8080/WebViewerExample/frameset?__report=special_populations_by_program.rptdesign", "containing_folder_name": "generic_program_data", "insert_or_update": "insert", "changing_user_login": "muser", "parameters": [{"parameter_name": "ReportStartDate"}, {"parameter_name": "ReportEndDate"}, {"parameter_name": "ProgramIds"}]}'));
	RAISE NOTICE 'TEST Result = %', (SELECT _output_json ->> 'result_indicator')::text;
	RAISE NOTICE 'Message = %', (SELECT _output_json ->> 'message')::text;
END$$;



-- Authorize users to view reports
-- reports for muser
DO $$
DECLARE  _output_json	json;
		_report_id	uuid;
		_in_json	json;
BEGIN	
	_report_id:= 	(SELECT report_id 
					FROM report_manager_schema.reports 
					WHERE report_name = 'CCST Managment Summary Monthly Report'
					);
	_in_json := '{"target_login": "muser", "report_id": "' || _report_id::text || '", "viewable": "TRUE",  "changing_user_login": "muser"}';
	_output_json := (SELECT * FROM report_manager_schema.action_enter_edit_allowed_reports (_in_json));
	RAISE NOTICE 'TEST Result = %', (SELECT _output_json ->> 'result_indicator')::text;
	RAISE NOTICE 'Message = %', (SELECT _output_json ->> 'message')::text;
END$$;

DO $$
DECLARE  _output_json	json;
		_report_id	uuid;
		_in_json	json;
BEGIN	
	_report_id:= 	(SELECT report_id 
					FROM report_manager_schema.reports 
					WHERE report_name = 'OMH and Chemung County Outputs By Month'
					);
	_in_json := '{"target_login": "muser", "report_id": "' || _report_id::text || '", "viewable": "TRUE",  "changing_user_login": "muser"}';
	_output_json := (SELECT * FROM report_manager_schema.action_enter_edit_allowed_reports (_in_json));
	RAISE NOTICE 'TEST Result = %', (SELECT _output_json ->> 'result_indicator')::text;
	RAISE NOTICE 'Message = %', (SELECT _output_json ->> 'message')::text;
END$$;

DO $$
DECLARE  _output_json	json;
		_report_id	uuid;
		_in_json	json;
BEGIN	
	_report_id:= 	(SELECT report_id 
					FROM report_manager_schema.reports 
					WHERE report_name = 'Universal Data Elements Data Quality Summmary for One CoC Version 5.2'
					);
	_in_json := '{"target_login": "muser", "report_id": "' || _report_id::text || '", "viewable": "TRUE",  "changing_user_login": "muser"}';
	_output_json := (SELECT * FROM report_manager_schema.action_enter_edit_allowed_reports (_in_json));
	RAISE NOTICE 'TEST Result = %', (SELECT _output_json ->> 'result_indicator')::text;
	RAISE NOTICE 'Message = %', (SELECT _output_json ->> 'message')::text;
END$$;

DO $$
DECLARE  _output_json	json;
		_report_id	uuid;
		_in_json	json;
BEGIN	
	_report_id:= 	(SELECT report_id 
					FROM report_manager_schema.reports 
					WHERE report_name = 'Project Specific Elements Data Quality Summmary for One CoC Version 5.2'
					);
	_in_json := '{"target_login": "muser", "report_id": "' || _report_id::text || '", "viewable": "TRUE",  "changing_user_login": "muser"}';
	_output_json := (SELECT * FROM report_manager_schema.action_enter_edit_allowed_reports (_in_json));
	RAISE NOTICE 'TEST Result = %', (SELECT _output_json ->> 'result_indicator')::text;
	RAISE NOTICE 'Message = %', (SELECT _output_json ->> 'message')::text;
END$$;

-- reports for opal
DO $$
DECLARE  _output_json	json;
		_report_id	uuid;
		_in_json	json;
BEGIN	
	_report_id:= 	(SELECT report_id 
					FROM report_manager_schema.reports 
					WHERE report_name = 'Second Place East Shelter Monthly Report to Chemung DSS'
					);
	_in_json := '{"target_login": "opal", "report_id": "' || _report_id::text || '", "viewable": "TRUE",  "changing_user_login": "muser"}';
	_output_json := (SELECT * FROM report_manager_schema.action_enter_edit_allowed_reports (_in_json));
	RAISE NOTICE 'TEST Result = %', (SELECT _output_json ->> 'result_indicator')::text;
	RAISE NOTICE 'Message = %', (SELECT _output_json ->> 'message')::text;
END$$;

DO $$
DECLARE  _output_json	json;
		_report_id	uuid;
		_in_json	json;
BEGIN	
	_report_id:= 	(SELECT report_id 
					FROM report_manager_schema.reports 
					WHERE report_name = ''
					);
	_in_json := '{"target_login": "opal", "report_id": "' || _report_id::text || '", "viewable": "TRUE",  "changing_user_login": "muser"}';
	_output_json := (SELECT * FROM report_manager_schema.action_enter_edit_allowed_reports (_in_json));
	RAISE NOTICE 'TEST Result = %', (SELECT _output_json ->> 'result_indicator')::text;
	RAISE NOTICE 'Message = %', (SELECT _output_json ->> 'message')::text;
END$$;

DO $$
DECLARE  _output_json	json;
		_report_id	uuid;
		_in_json	json;
BEGIN	
	_report_id:= 	(SELECT report_id 
					FROM report_manager_schema.reports 
					WHERE report_name = 'Data Quality Error Details Version 5.2'
					);
	_in_json := '{"target_login": "opal", "report_id": "' || _report_id::text || '", "viewable": "TRUE",  "changing_user_login": "muser"}';
	_output_json := (SELECT * FROM report_manager_schema.action_enter_edit_allowed_reports (_in_json));
	RAISE NOTICE 'TEST Result = %', (SELECT _output_json ->> 'result_indicator')::text;
	RAISE NOTICE 'Message = %', (SELECT _output_json ->> 'message')::text;
END$$;

DO $$
DECLARE  _output_json	json;
		_report_id	uuid;
		_in_json	json;
BEGIN	
	_report_id:= 	(SELECT report_id 
					FROM report_manager_schema.reports 
					WHERE report_name = 'Project Specific Elements Data Quality Error Details Version 5.2'
					);
	_in_json := '{"target_login": "opal", "report_id": "' || _report_id::text || '", "viewable": "TRUE",  "changing_user_login": "muser"}';
	_output_json := (SELECT * FROM report_manager_schema.action_enter_edit_allowed_reports (_in_json));
	RAISE NOTICE 'TEST Result = %', (SELECT _output_json ->> 'result_indicator')::text;
	RAISE NOTICE 'Message = %', (SELECT _output_json ->> 'message')::text;
END$$;

DO $$
DECLARE  _output_json	json;
		_report_id	uuid;
		_in_json	json;
BEGIN	
	_report_id:= 	(SELECT report_id 
					FROM report_manager_schema.reports 
					WHERE report_name = 'United Way Demographics Report People Served'
					);
	_in_json := '{"target_login": "opal", "report_id": "' || _report_id::text || '", "viewable": "TRUE",  "changing_user_login": "muser"}';
	_output_json := (SELECT * FROM report_manager_schema.action_enter_edit_allowed_reports (_in_json));
	RAISE NOTICE 'TEST Result = %', (SELECT _output_json ->> 'result_indicator')::text;
	RAISE NOTICE 'Message = %', (SELECT _output_json ->> 'message')::text;
END$$;

-- reports for jappl

DO $$
DECLARE  _output_json	json;
		_report_id	uuid;
		_in_json	json;
BEGIN	
	_report_id:= 	(SELECT report_id 
					FROM report_manager_schema.reports 
					WHERE report_name = 'CC Steuben DSS Report'
					);
	_in_json := '{"target_login": "jappl", "report_id": "' || _report_id::text || '", "viewable": "TRUE",  "changing_user_login": "muser"}';
	_output_json := (SELECT * FROM report_manager_schema.action_enter_edit_allowed_reports (_in_json));
	RAISE NOTICE 'TEST Result = %', (SELECT _output_json ->> 'result_indicator')::text;
	RAISE NOTICE 'Message = %', (SELECT _output_json ->> 'message')::text;
END$$;

DO $$
DECLARE  _output_json	json;
		_report_id	uuid;
		_in_json	json;
BEGIN	
	_report_id:= 	(SELECT report_id 
					FROM report_manager_schema.reports 
					WHERE report_name = 'United Way Demographics Report People Served'
					);
	_in_json := '{"target_login": "jappl", "report_id": "' || _report_id::text || '", "viewable": "TRUE",  "changing_user_login": "muser"}';
	_output_json := (SELECT * FROM report_manager_schema.action_enter_edit_allowed_reports (_in_json));
	RAISE NOTICE 'TEST Result = %', (SELECT _output_json ->> 'result_indicator')::text;
	RAISE NOTICE 'Message = %', (SELECT _output_json ->> 'message')::text;
END$$;

DO $$
DECLARE  _output_json	json;
		_report_id	uuid;
		_in_json	json;
BEGIN	
	_report_id:= 	(SELECT report_id 
					FROM report_manager_schema.reports 
					WHERE report_name = 'Number of Services provided and people and Households Served'
					);
	_in_json := '{"target_login": "jappl", "report_id": "' || _report_id::text || '", "viewable": "TRUE",  "changing_user_login": "muser"}';
	_output_json := (SELECT * FROM report_manager_schema.action_enter_edit_allowed_reports (_in_json));
	RAISE NOTICE 'TEST Result = %', (SELECT _output_json ->> 'result_indicator')::text;
	RAISE NOTICE 'Message = %', (SELECT _output_json ->> 'message')::text;
END$$;

DO $$
DECLARE  _output_json	json;
		_report_id	uuid;
		_in_json	json;
BEGIN	
	_report_id:= 	(SELECT report_id 
					FROM report_manager_schema.reports 
					WHERE report_name = 'Defined Performance Measures for the Selected Housing Programs'
					);
	_in_json := '{"target_login": "jappl", "report_id": "' || _report_id::text || '", "viewable": "TRUE",  "changing_user_login": "muser"}';
	_output_json := (SELECT * FROM report_manager_schema.action_enter_edit_allowed_reports (_in_json));
	RAISE NOTICE 'TEST Result = %', (SELECT _output_json ->> 'result_indicator')::text;
	RAISE NOTICE 'Message = %', (SELECT _output_json ->> 'message')::text;
END$$;

DO $$
DECLARE  _output_json	json;
		_report_id	uuid;
		_in_json	json;
BEGIN	
	_report_id:= 	(SELECT report_id 
					FROM report_manager_schema.reports 
					WHERE report_name = 'Special Populations Served by the Selected Programs'
					);
	_in_json := '{"target_login": "jappl", "report_id": "' || _report_id::text || '", "viewable": "TRUE",  "changing_user_login": "muser"}';
	_output_json := (SELECT * FROM report_manager_schema.action_enter_edit_allowed_reports (_in_json));
	RAISE NOTICE 'TEST Result = %', (SELECT _output_json ->> 'result_indicator')::text;
	RAISE NOTICE 'Message = %', (SELECT _output_json ->> 'message')::text;
END$$;

DO $$
DECLARE  _output_json	json;
		_report_id	uuid;
		_in_json	json;
BEGIN	
	_report_id:= 	(SELECT report_id 
					FROM report_manager_schema.reports 
					WHERE report_name = 'Data Quality Error Details Version 5.2'
					);
	_in_json := '{"target_login": "jappl", "report_id": "' || _report_id::text || '", "viewable": "TRUE",  "changing_user_login": "muser"}';
	_output_json := (SELECT * FROM report_manager_schema.action_enter_edit_allowed_reports (_in_json));
	RAISE NOTICE 'TEST Result = %', (SELECT _output_json ->> 'result_indicator')::text;
	RAISE NOTICE 'Message = %', (SELECT _output_json ->> 'message')::text;
END$$;

DO $$
DECLARE  _output_json	json;
		_report_id	uuid;
		_in_json	json;
BEGIN	
	_report_id:= 	(SELECT report_id 
					FROM report_manager_schema.reports 
					WHERE report_name = 'Project Specific Elements Data Quality Error Details Version 5.2'
					);
	_in_json := '{"target_login": "jappl", "report_id": "' || _report_id::text || '", "viewable": "TRUE",  "changing_user_login": "muser"}';
	_output_json := (SELECT * FROM report_manager_schema.action_enter_edit_allowed_reports (_in_json));
	RAISE NOTICE 'TEST Result = %', (SELECT _output_json ->> 'result_indicator')::text;
	RAISE NOTICE 'Message = %', (SELECT _output_json ->> 'message')::text;
END$$;

------------------------------------------------------------------------------
SELECT '';
SELECT * FROM report_manager_schema.report_folders;

SELECT '';
SELECT report_id, report_name, containing_folder_name FROM report_manager_schema.reports;

SELECT '';
SELECT * FROM system_user_schema.system_users;

SELECT '';
SELECT login, report_name, report_viewable  FROM report_manager_schema.system_user_allowed_reports;


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


DO $$
DECLARE  _output_json	json;
BEGIN	
	_output_json := (SELECT * FROM system_user_schema.action_change_user_allowed_actions ('{"login": "opal", "service":"report_manager", "action":"load_report_list", "task":"allow", "changing_user_login": "muser"}'));
	RAISE NOTICE 'TEST Result = %', (SELECT _output_json ->> 'result_indicator')::text;
	RAISE NOTICE 'Message = %', (SELECT _output_json ->> 'message')::text;
END$$;

DO $$
DECLARE  _output_json	json;
BEGIN	
	_output_json := (SELECT * FROM report_manager_schema.action_load_report_list_jstree ('{"login": "opal"}'));
	RAISE NOTICE 'TEST Result = %', (SELECT _output_json ->> 'result_indicator')::text;
	RAISE NOTICE 'Message = %', (SELECT _output_json ->> 'message')::text;
	RAISE NOTICE 'Reports for opal = %', (SELECT _output_json ->> 'data')::text;
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

DO $$
DECLARE  _output_json	json;
BEGIN	
	_output_json := (SELECT * FROM system_user_schema.action_change_user_allowed_actions ('{"login": "jappl", "service":"report_manager", "action":"load_report_list", "task":"allow", "changing_user_login": "muser"}'));
	RAISE NOTICE 'TEST Result = %', (SELECT _output_json ->> 'result_indicator')::text;
	RAISE NOTICE 'Message = %', (SELECT _output_json ->> 'message')::text;
END$$;

DO $$
DECLARE  _output_json	json;
BEGIN	
	_output_json := (SELECT * FROM report_manager_schema.action_load_report_list_jstree ('{"login": "jappl"}'));
	RAISE NOTICE 'TEST Result = %', (SELECT _output_json ->> 'result_indicator')::text;
	RAISE NOTICE 'Message = %', (SELECT _output_json ->> 'message')::text;
	RAISE NOTICE 'Reports for jappl = %', (SELECT _output_json ->> 'data')::text;
END$$;

DO $$
DECLARE  _output_json	json;
BEGIN	
	_output_json := (SELECT * FROM report_manager_schema.action_load_report_list_jstree ('{"login": "muser"}'));
	RAISE NOTICE 'TEST Result = %', (SELECT _output_json ->> 'result_indicator')::text;
	RAISE NOTICE 'Message = %', (SELECT _output_json ->> 'message')::text;
	RAISE NOTICE 'Reports for muser = %', (SELECT _output_json ->> 'data')::text;
END$$;


