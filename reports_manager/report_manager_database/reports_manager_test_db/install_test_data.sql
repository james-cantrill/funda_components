

DO $$
DECLARE  _output_json	json;
BEGIN	
	RAISE NOTICE 'Log in the master user';
	_output_json := (SELECT * FROM system_user_schema.action_user_login ('{"login": "muser", "password":"master"}'));
	RAISE NOTICE 'Result = %', (SELECT _output_json ->> 'result_indicator')::text;
END$$;

-- 1.	Install folders
-- good insert root level folder
DO $$
DECLARE  _output_json	json;
BEGIN	
	RAISE NOTICE 'Setup good insert root level folder';
	_output_json := (SELECT * FROM report_manager_schema.action_enter_edit_folders ('{"folder_name": "report_root", "folder_display_name": "All Reports", "description":"Root of report tree", "is_root_folder": "TRUE", "changing_user_login": "muser", "enter_or_update": "Enter"}'));
	RAISE NOTICE 'Result = %', (SELECT _output_json ->> 'result_indicator')::text;
END$$;

-- insert Generic Program Data folder
DO $$
DECLARE  _output_json	json;
BEGIN	
	RAISE NOTICE 'Insert Generic Program Data folder';
	_output_json := (SELECT * FROM report_manager_schema.action_enter_edit_folders ('{"folder_name": "generic_program_data", "folder_display_name": "Generic Program Data", "description":"These reports provide data that is interesting to most programs", "is_root_folder": "FALSE", "parent_folder_name": "report_root", "changing_user_login": "muser", "enter_or_update": "Enter"}'));
	RAISE NOTICE 'Result = %', (SELECT _output_json ->> 'result_indicator')::text;
END$$;

-- insert CCST Only Reports folder
DO $$
DECLARE  _output_json	json;
BEGIN	
	RAISE NOTICE 'Insert CCST Only Reports folder';
	_output_json := (SELECT * FROM report_manager_schema.action_enter_edit_folders ('{"folder_name": "ccst_only_reports", "folder_display_name": "CCST Only Reports", "description":"These reports are specifically designed to provide data for CCST''s required reports", "is_root_folder": "FALSE", "parent_folder_name": "report_root", "changing_user_login": "muser", "enter_or_update": "Enter"}'));
	RAISE NOTICE 'Result = %', (SELECT _output_json ->> 'result_indicator')::text;
END$$;

-- insert Data Quality folder
DO $$
DECLARE  _output_json	json;
BEGIN	
	RAISE NOTICE 'Insert Data Quality folder';
	_output_json := (SELECT * FROM report_manager_schema.action_enter_edit_folders ('{"folder_name": "data_quality", "folder_display_name": "Data Quality", "description":"Holds the HMIS data quality reports for all levels", "is_root_folder": "FALSE", "parent_folder_name": "report_root", "changing_user_login": "muser", "enter_or_update": "Enter"}'));
	RAISE NOTICE 'Result = %', (SELECT _output_json ->> 'result_indicator')::text;
END$$;

-- insert Data Quality/COC Data Quality Reports folder
DO $$
DECLARE  _output_json	json;
BEGIN	
	RAISE NOTICE 'Insert Data Quality/COC Data Quality Reports folder';
	_output_json := (SELECT * FROM report_manager_schema.action_enter_edit_folders ('{"folder_name": "coc_data_quality_reports", "folder_display_name": "COC Data Quality Reports", "description":"Holds the reports showing the HMIS data quality over the whole Continuum", "is_root_folder": "FALSE", "parent_folder_name": "data_quality", "changing_user_login": "muser", "enter_or_update": "Enter"}'));
	RAISE NOTICE 'Result = %', (SELECT _output_json ->> 'result_indicator')::text;
END$$;

-- insert Data Quality/Data Quality Reports for Selected Programs
DO $$
DECLARE  _output_json	json;
BEGIN	
	RAISE NOTICE 'Insert Data Quality/COC Data Quality Reports folder';
	_output_json := (SELECT * FROM report_manager_schema.action_enter_edit_folders ('{"folder_name": "data_quality_reports_for_selected_programs", "folder_display_name": "Data Quality Reports for Selected Programs", "description":"Holds the reports showing the HMIS data quality over the whole Continuum", "is_root_folder": "FALSE", "parent_folder_name": "data_quality", "changing_user_login": "muser", "enter_or_update": "Enter"}'));
	RAISE NOTICE 'Result = %', (SELECT _output_json ->> 'result_indicator')::text;
END$$;

-- 2.	Install reports

DO $$
DECLARE  _output_json	json;
BEGIN	
	RAISE NOTICE 'insert United Way Demographics Report People Served';
	_output_json := (SELECT * FROM report_manager_schema.action_enter_edit_reports ('{"report_name": "United Way Demographics Report People Served", "description": "This report provides the United Way of the Southern Tier Demographics data about the people who received a service from one or more selected programs over a selected time period. The starting date and the ending date of the time period, and the program ids for the selected programs must be entered when calling the report.", "url": "http://192.168.4.10:8080/WebViewerExample/frameset?__report=uw_demographics.rptdesign", "containing_folder_name": "generic_program_data", "insert_or_update": "insert", "changing_user_login": "muser", "parameters": [{"parameter_name": "ReportStartDate"}, {"parameter_name": "ReportEndDate"}, {"parameter_name": "ProgramIds"}]}'));
	RAISE NOTICE 'Result = %', (SELECT _output_json ->> 'result_indicator')::text;
END$$;

DO $$
DECLARE  _output_json	json;
BEGIN	
	RAISE NOTICE 'insert Special Populations Served by the Selected Programs';
	_output_json := (SELECT * FROM report_manager_schema.action_enter_edit_reports ('{"report_name": "Special Populations Served by the Selected Programs", "description": "This report summarizes the special populations served by the selected programs during the defined time period. The special populations summarized are unaccompanied and parenting youth, domestic violence survivors, veterans, chronically homeless, adults with various disabilities, and the elderly. The starting date and the ending date of the time period, and the program ids for the selected programs must be entered when calling the report. ", "url": "http://192.168.4.10:8080/WebViewerExample/frameset?__report=special_populations_by_program.rptdesign", "containing_folder_name": "generic_program_data", "insert_or_update": "insert", "changing_user_login": "muser", "parameters": [{"parameter_name": "ReportStartDate"}, {"parameter_name": "ReportEndDate"}, {"parameter_name": "ProgramIds"}]}'));
	RAISE NOTICE 'Result = %', (SELECT _output_json ->> 'result_indicator')::text;
END$$;

DO $$
DECLARE  _output_json	json;
BEGIN	
	RAISE NOTICE 'insert Housing Occupancy for Selected Programs';
	_output_json := (SELECT * FROM report_manager_schema.action_enter_edit_reports ('{"report_name": "Housing Occupancy for Selected Programs", "description": "This report presents the total, individual, and family occupancies over a selected time period for one or more selected programs. The starting date and the ending date of the time period, and the program ids for the selected programs must be entered when calling the report.", "url": "http://192.168.4.10:8080/WebViewerExample/frameset?__report=housing_oocupancy_by_programs.rptdesign", "containing_folder_name": "generic_program_data", "insert_or_update": "insert", "changing_user_login": "muser", "parameters": [{"parameter_name": "ReportStartDate"}, {"parameter_name": "ReportEndDate"}, {"parameter_name": "ProgramIds"}]}'));
	RAISE NOTICE 'Result = %', (SELECT _output_json ->> 'result_indicator')::text;
END$$;

DO $$
DECLARE  _output_json	json;
BEGIN	
	RAISE NOTICE 'insert Monthly Housing Unit Occupancy for Selected Programs';
	_output_json := (SELECT * FROM report_manager_schema.action_enter_edit_reports ('{"report_name": "Monthly Housing Unit Occupancy for Selected Programs", "description": "This report presents the total, individual, and family unit occupancies for each month over a selected time period for one or more selected programs. The starting date and the ending date of the time period, and the program ids for the selected programs must be entered when calling the report.", "url": "http://192.168.4.10:8080/WebViewerExample/frameset?__report=housing_monthly_unit_occupancy_by_program.rptdesign", "containing_folder_name": "generic_program_data", "insert_or_update": "insert", "changing_user_login": "muser", "parameters": [{"parameter_name": "ReportStartDate"}, {"parameter_name": "ReportEndDate"}, {"parameter_name": "ProgramIds"}]}'));
	RAISE NOTICE 'Result = %', (SELECT _output_json ->> 'result_indicator')::text;
END$$;

------------------------------------------------------------------------------
-- CCST Only Reports
DO $$
DECLARE  _output_json	json;
BEGIN	
	RAISE NOTICE 'insert CCST Managment Summary Monthly Report';
	_output_json := (SELECT * FROM report_manager_schema.action_enter_edit_reports ('{"report_name": "CCST Managment Summary Monthly Report", "description": "This report provides a summary of the performance on all CCST programs over a single month and compares it to that of the year through the previous month. The starting date of the month must be entered when calling the report.", "url": "http://192.168.4.10:8080/WebViewerExample/frameset?__report=CCST_management_summary.rptdesign", "containing_folder_name": "ccst_only_reports", "insert_or_update": "insert", "changing_user_login": "muser", "parameters": [{"parameter_name": "MonthStart"}]}'));
	RAISE NOTICE 'Result = %', (SELECT _output_json ->> 'result_indicator')::text;
END$$;

DO $$
DECLARE  _output_json	json;
BEGIN	
	RAISE NOTICE 'insert Authorizing Psychiatrists with Clients';
	_output_json := (SELECT * FROM report_manager_schema.action_enter_edit_reports ('{"report_name": "Authorizing Psychiatrists with Clients", "description": "", "url": "This report lists the authorizing psychiatrists for clients enrolled in one or more programs over a defined time period. The starting date and the ending date of the time period, and the program ids for the selected programs must be entered when calling the report.", "containing_folder_name": "ccst_only_reports", "insert_or_update": "insert", "changing_user_login": "muser", "parameters": [{"parameter_name": "ReportStartDate"}, {"parameter_name": "ReportEndDate"}, {"parameter_name": "ProgramIds"}]}'));
	RAISE NOTICE 'Result = %', (SELECT _output_json ->> 'result_indicator')::text;
END$$;

DO $$
DECLARE  _output_json	json;
BEGIN	
	RAISE NOTICE 'insert CCST Community Residence Report to Chemung DSS 2018';
	_output_json := (SELECT * FROM report_manager_schema.action_enter_edit_reports ('{"report_name": "CCST Community Residence Report to Chemung DSS 2018", "description": "This report shows the OMH defined outputs over the selected time period for the Community Residence (Luce Street). The starting date and the ending date of the selected time period must be entered when calling the report. ", "url": "http://192.168.4.10:8080/WebViewerExample/frameset?__report=com_res_chemung_dss_report.rptdesign", "containing_folder_name": "ccst_only_reports", "insert_or_update": "insert", "changing_user_login": "muser", "parameters": [{"parameter_name": "ReportStartDate"}, {"parameter_name": "ReportEndDate"}, {"parameter_name": "ProgramIds"}]}'));
	RAISE NOTICE 'Result = %', (SELECT _output_json ->> 'result_indicator')::text;
END$$;

DO $$
DECLARE  _output_json	json;
BEGIN	
	RAISE NOTICE 'insert CCST Treatment Apartments Report to Chemung DSS 2018';
	_output_json := (SELECT * FROM report_manager_schema.action_enter_edit_reports ('{"report_name": "CCST Treatment Apartments Report to Chemung DSS 2018", "description": "This report shows the OMH defined outputs over the selected time period for the Treatment Apartments (Sunshine). The starting date and the ending date of the selected time period must be entered when calling the report.", "url": "http://192.168.4.10:8080/WebViewerExample/frameset?__report=trtmnt_aprtmnts_chemung_dss_report.rptdesign", "containing_folder_name": "ccst_only_reports", "insert_or_update": "insert", "changing_user_login": "muser", "parameters": [{"parameter_name": "ReportStartDate"}, {"parameter_name": "ReportEndDate"}, {"parameter_name": "ProgramIds"}]}'));
	RAISE NOTICE 'Result = %', (SELECT _output_json ->> 'result_indicator')::text;
END$$;

DO $$
DECLARE  _output_json	json;
BEGIN	
	RAISE NOTICE 'insert Supported Housing Case Management Report to Chemung DSS 2018';
	_output_json := (SELECT * FROM report_manager_schema.action_enter_edit_reports ('{"report_name": "Supported Housing Case Management Report to Chemung DSS 2018", "description": "This report shows the OMH defined outputs over the selected time period for the combined supported housing programs. The starting date and the ending date of the selected time period must be entered when calling the report. ", "url": "http://192.168.4.10:8080/WebViewerExample/frameset?__report=spprtd_hsng_cse_mgmt_chemung_dss_report.rptdesign", "containing_folder_name": "ccst_only_reports", "insert_or_update": "insert", "changing_user_login": "muser", "parameters": [{"parameter_name": "ReportStartDate"}, {"parameter_name": "ReportEndDate"}, {"parameter_name": "ProgramIds"}]}'));
	RAISE NOTICE 'Result = %', (SELECT _output_json ->> 'result_indicator')::text;
END$$;

DO $$
DECLARE  _output_json	json;
BEGIN	
	RAISE NOTICE 'insert Supported Housing Property Report to Chemung DSS 2018';
	_output_json := (SELECT * FROM report_manager_schema.action_enter_edit_reports ('{"report_name": "Supported Housing Property Report to Chemung DSS 2018", "description": "This report shows the OMH defined outputs over the selected time period for the combined supported housing property programs. The starting date and the ending date of the selected time period must be entered when calling the report.", "url": "http://192.168.4.10:8080/WebViewerExample/frameset?__report=spprtd_hsng_property_chemung_dss_report.rptdesign", "containing_folder_name": "ccst_only_reports", "insert_or_update": "insert", "changing_user_login": "muser", "parameters": [{"parameter_name": "ReportStartDate"}, {"parameter_name": "ReportEndDate"}, {"parameter_name": "ProgramIds"}]}'));
	RAISE NOTICE 'Result = %', (SELECT _output_json ->> 'result_indicator')::text;
END$$;

DO $$
DECLARE  _output_json	json;
BEGIN	
	RAISE NOTICE 'insert Long Stay and MRT Supported Housing Report to Chemung DSS 2018';
	_output_json := (SELECT * FROM report_manager_schema.action_enter_edit_reports ('{"report_name": "Long Stay and MRT Supported Housing Report to Chemung DSS 2018", "description": "This report shows the OMH defined outputs over the selected time period for the long term stay and MRT supported housing programs. The starting date and the ending date of the selected time period must be entered when calling the report. ", "url": "http://192.168.4.10:8080/WebViewerExample/frameset?__report=lts_and_mrt_chemung_dss_report.rptdesign", "containing_folder_name": "ccst_only_reports", "insert_or_update": "insert", "changing_user_login": "muser", "parameters": [{"parameter_name": "ReportStartDate"}, {"parameter_name": "ReportEndDate"}, {"parameter_name": "ProgramIds"}]}'));
	RAISE NOTICE 'Result = %', (SELECT _output_json ->> 'result_indicator')::text;
END$$;

DO $$
DECLARE  _output_json	json;
BEGIN	
	RAISE NOTICE 'insert MICA Report to Chemung DSS 2018';
	_output_json := (SELECT * FROM report_manager_schema.action_enter_edit_reports ('{"report_name": "MICA Report to Chemung DSS 2018", "description": "This report shows the OMH defined outputs over the selected time period for the MICA program. The starting date and the ending date of the selected time period must be entered when calling the report.", "url": "http://192.168.4.10:8080/WebViewerExample/frameset?__report=mica_chemung_dss_report.rptdesign", "containing_folder_name": "ccst_only_reports", "insert_or_update": "insert", "changing_user_login": "muser", "parameters": [{"parameter_name": "ReportStartDate"}, {"parameter_name": "ReportEndDate"}, {"parameter_name": "ProgramIds"}]}'));
	RAISE NOTICE 'Result = %', (SELECT _output_json ->> 'result_indicator')::text;
END$$;

------------------------------------------------------------------------------
-- insert Data Quality/COC Data Quality Reports 

DO $$
DECLARE  _output_json	json;
BEGIN	
	RAISE NOTICE 'insert Universal Data Elements Data Quality Summmary for One CoC Version 5.2';
	_output_json := (SELECT * FROM report_manager_schema.action_enter_edit_reports ('{"report_name": "Universal Data Elements Data Quality Summmary for One CoC Version 5.2", "description": "The Universal Data Elements Data Quality Summmary for One CoC Version 5.2 report shows the data quality of the HUD defined Universal Data Elements as specified in the HMIS Data Standards DATA DICTIONARY released June, 2017 for all programs with the selected HMIS Project Types for a single selected continuum over a seleted time period. Its start_dt and end_dt parameters define the selected time period. Its _continuum_name parameter is the name of the single selected Continuum. Its _list_of_hmis_types parameter lists the selected HMIS Project Types as a comma delimited list with no spaces before or after the commas, for example, ''Emergency Shelter,PH - Rapid Re-Housing,Transitional Housing''. The default _list_of_hmis_types are the types used in the HUD Strategic Performance Measures (SPM)", "url": "http://192.168.4.10:8080/WebViewerExample/frameset?__report=ude_dq_ver_5_2_summary_for_one_coc.rptdesign", "containing_folder_name": "coc_data_quality_reports", "insert_or_update": "insert", "changing_user_login": "muser", "parameters": [{"parameter_name": "ReportStartDate"}, {"parameter_name": "ReportEndDate"}, {"parameter_name": "CocName"}, {"parameter_name": "HmisProjectTypes"}]}'));
	RAISE NOTICE 'Result = %', (SELECT _output_json ->> 'result_indicator')::text;
END$$;

DO $$
DECLARE  _output_json	json;
BEGIN	
	RAISE NOTICE 'insert Project Specific Elements Data Quality Summmary for One CoC Version 5.2';
	_output_json := (SELECT * FROM report_manager_schema.action_enter_edit_reports ('{"report_name": "Project Specific Elements Data Quality Summmary for One CoC Version 5.2", "description": "The Project Specific Elements Data Quality Summmary for One CoC Version 5.2 report shows the data quality of the HUD defined project specific data elements required for HUD:CoC and the HUD:ESG funded projects. It reports foe for all programs with the selected HMIS Project Types for a single selected continuum over a seleted time period. Its start_dt and end_dt parameters define the selected time period. Its _continuum_name parameter is the name of the single selected Continuum. Its _list_of_hmis_types parameter lists the selected HMIS Project Types as a comma delimited list with no spaces before or after the commas, for example, ''Emergency Shelter,PH - Rapid Re-Housing,Transitional Housing''. The default _list_of_hmis_types are the types used in the HUD Strategic Performance Measures (SPM) Its _return_coc_funded_only parameter specifies if data only for the CoC funded programs is to be returned or if all data is to be returned. The parameter''s allowed values are Yes (return only CoC funded programs data) and No (return data for all programs)","url": "http://192.168.4.10:8080/WebViewerExample/frameset?__report=coc_esg_project_specific_dq_summary_for_one_coc_ver_5_2.rptdesign", "containing_folder_name": "coc_data_quality_reports", "insert_or_update": "insert", "changing_user_login": "muser", "parameters": [{"parameter_name": "ReportStartDate"}, {"parameter_name": "ReportEndDate"}, {"parameter_name": "CocName"}, {"parameter_name": "HmisProjectTypes"}, {"parameter_name": "IncludeCocFundedPrjctOnly"}]}'));
	RAISE NOTICE 'Result = %', (SELECT _output_json ->> 'result_indicator')::text;
END$$;

DO $$
DECLARE  _output_json	json;
BEGIN	
	RAISE NOTICE 'insert Entry/Exit Timeliness Summmary for One CoC Version 5.2';
	_output_json := (SELECT * FROM report_manager_schema.action_enter_edit_reports ('{"report_name": "Entry/Exit Timeliness Summmary for One CoC Version 5.2", "description": "The Timeliness Entry/Exit Summmary for One CoC Version 5.2 report shows the timeliness of en terkng tnhe admissipon (entry) and discharge (exit) data for all programs with the selected HMIS Project Types for a single selected continuum over a seleted time period. Its start_dt and end_dt parameters define the selected time period. Its _continuum_name parameter is the name of the single selected Continuum. Its _list_of_hmis_types parameter lists the selected HMIS Project Types as a comma delimited list with no spaces before or after the commas, for example, ''Emergency Shelter,PH - Rapid Re-Housing,Transitional Housing''. The default _list_of_hmis_types are the types used in the HUD Strategic Performance Measures (SPM)", "url": "http://192.168.4.10:8080/WebViewerExample/frameset?__report=timeliness_summary_for_one_coc.rptdesign", "containing_folder_name": "coc_data_quality_reports", "insert_or_update": "insert", "changing_user_login": "muser", "parameters": [{"parameter_name": "ReportStartDate"}, {"parameter_name": "ReportEndDate"}, {"parameter_name": "CocName"}, {"parameter_name": "HmisProjectTypes"}]}'));
	RAISE NOTICE 'Result = %', (SELECT _output_json ->> 'result_indicator')::text;
END$$;

------------------------------------------------------------------------------
-- insert Data Quality/Data Quality Reports for Selected Programs 

DO $$
DECLARE  _output_json	json;
BEGIN	
	RAISE NOTICE 'insert Data Quality Summmary for Selected Programs Version 5.2 ';
	_output_json := (SELECT * FROM report_manager_schema.action_enter_edit_reports ('{"report_name": "Data Quality Summmary for Selected Programs Version 5.2", "description": "The Data Quality Summmary for Selected Programs Version 5.2 report shows the data quality of the HUD defined Universal Data Elements as specified in the HMIS Data Standards DATA DICTIONARY released June, 2017 for the selected programs over a seleted time period. Its start_dt and end_dt parameters define the selected time period. Its in_specified_programs parameter is a comma delimited list of the program_ids of the selected programs.", "url": "http://192.168.4.10:8080/WebViewerExample/frameset?__report=ude_dq_ver_5_2_summary_by_project.rptdesign", "containing_folder_name": "data_quality_reports_for_selected_programs", "insert_or_update": "insert", "changing_user_login": "muser", "parameters": [{"parameter_name": "ReportStartDate"}, {"parameter_name": "ReportEndDate"}, {"parameter_name": "ProgramIds"}]}'));
	RAISE NOTICE 'Result = %', (SELECT _output_json ->> 'result_indicator')::text;
END$$;

DO $$
DECLARE  _output_json	json;
BEGIN	
	RAISE NOTICE 'insert Project Entry and Exit Data Entry Timeliness Summary for Selected Projects';
	_output_json := (SELECT * FROM report_manager_schema.action_enter_edit_reports ('{"report_name": "Project Entry and Exit Data Entry Timeliness Summary for Selected Projects", "description": "The Project Entry and Exit Data Entry Timeliness Summary for Selected Projects report shows the timeliness (days lag between an entry or exit event and when the data was recorded) for the selected programs over a seleted time period. It shows the number of people that entered (admitted) or exited (discharged) each selected project, the percent of the admission or discharge records entered within the defined data entry standard, the maximum data entry lag, and the average data entry lag for the admission and discharge records. Its start_dt and end_dt parameters define the selected time period. Its in_specified_programs parameter is a comma delimited list of the program_ids of the selected programs.", "url": "http://192.168.4.10:8080/WebViewerExample/frameset?__report=timeliness_summary_by_program.rptdesign", "containing_folder_name": "coc_data_quality_reports", "insert_or_update": "insert", "changing_user_login": "muser", "parameters": [{"parameter_name": "ReportStartDate"}, {"parameter_name": "ReportEndDate"}, {"parameter_name": "ProgramIds"}]}'));
	RAISE NOTICE 'Result = %', (SELECT _output_json ->> 'result_indicator')::text;
END$$;



DO $$
DECLARE  _output_json	json;
BEGIN	
	RAISE NOTICE 'insert Service Data Entry Timeliness Summary for Selected Projects';
	_output_json := (SELECT * FROM report_manager_schema.action_enter_edit_reports ('{"report_name": "Service Data Entry Timeliness Summary for Selected Projects", "description": "The Service Data Entry Timeliness Summary for Selected Projects report shows the timeliness (days lag between an service event and when the data was recorded) for the selected programs over a seleted time period. It shows the number of services provided by each selected project, the percent of the service records entered within the defined data entry standard, the maximum data entry lag, and the average data entry lag for the service records. Its start_dt and end_dt parameters define the selected time period. Its in_specified_programs parameter is a comma delimited list of the program_ids of the selected programs.", "url": "http://192.168.4.10:8080/WebViewerExample/frameset?__report=service_timeliness_summary_by_program.rptdesign", "containing_folder_name": "coc_data_quality_reports", "insert_or_update": "insert", "changing_user_login": "muser", "parameters": [{"parameter_name": "ReportStartDate"}, {"parameter_name": "ReportEndDate"}, {"parameter_name": "ProgramIds"}]}'));
	RAISE NOTICE 'Result = %', (SELECT _output_json ->> 'result_indicator')::text;
END$$;

DO $$
DECLARE  _output_json	json;
BEGIN	
	RAISE NOTICE 'insert Data Quality Error Details Version 5.2';
	_output_json := (SELECT * FROM report_manager_schema.action_enter_edit_reports ('{"report_name": "Data Quality Error Details Version 5.2", "description": "The Data Quality Error Details Version 5.2 report lists all the clients active in the selected programs during the selected time period with data quality errors in the HUD defined Universal Data Elements (UDE) as specified in the HMIS Data Standards DATA DICTIONARY released June, 2017. It is used to locate and fix specific UDE errors. Its start_dt and end_dt parameters define the selected time period. Its in_specified_programs parameter is a comma delimited list of the program_ids of the selected programs.", "url": "http://192.168.4.10:8080/WebViewerExample/frameset?__report=ude_dq_ver_5_2_error_detail_by_project.rptdesign", "containing_folder_name": "coc_data_quality_reports", "insert_or_update": "insert", "changing_user_login": "muser", "parameters": [{"parameter_name": "ReportStartDate"}, {"parameter_name": "ReportEndDate"}, {"parameter_name": "ProgramIds"}]}'));
	RAISE NOTICE 'Result = %', (SELECT _output_json ->> 'result_indicator')::text;
END$$;

DO $$
DECLARE  _output_json	json;
BEGIN	
	RAISE NOTICE 'insert Project Specific Elements Data Quality Error Details Version 5.2';
	_output_json := (SELECT * FROM report_manager_schema.action_enter_edit_reports ('{"report_name": "Project Specific Elements Data Quality Error Details Version 5.2", "description": "The Project Specific Elements Data Quality Error Details Version 5.2 report lists all the clients active in the selected programs during the selected time period with data quality errors in the HUD defined project specific data elements required for HUD:CoC and the HUD:ESG funded projects as specified in the HMIS Data Standards DATA DICTIONARY released June, 2017. It is used to locate and fix specific data errors. Its start_dt and end_dt parameters define the selected time period. Its in_specified_programs parameter is a comma delimited list of the program_ids of the selected programs.", "url": "http://192.168.4.10:8080/WebViewerExample/frameset?__report=coc_esg_project_specific_dq_5_2_error_detail_by_project.rptdesign", "containing_folder_name": "coc_data_quality_reports", "insert_or_update": "insert", "changing_user_login": "muser", "parameters": [{"parameter_name": "ReportStartDate"}, {"parameter_name": "ReportEndDate"}, {"parameter_name": "ProgramIds"}]}'));
	RAISE NOTICE 'Result = %', (SELECT _output_json ->> 'result_indicator')::text;
END$$;

DO $$
DECLARE  _output_json	json;
BEGIN	
	RAISE NOTICE 'insert Trends in Project Entry and Exit Data Entry Timeliness for Selected Projects';
	_output_json := (SELECT * FROM report_manager_schema.action_enter_edit_reports ('{"report_name": "Trends in Project Entry and Exit Data Entry Timeliness for Selected Projects", "description": "The Trends in Project Entry and Exit Data Entry Timeliness for Selected Projects report shows the monthly trends in the data entry timeliness for the selected programs over a seleted time period. These trends help program managers improve the timeliness of their program''s data entry. The report shows the monthlhy trend in the percent of the admission or discharge records entered within the defined data entry standard, the maximum data entry lag, and the average data entry lag for the admission and discharge records. Its start_dt and end_dt parameters define the selected time period. Its in_specified_programs parameter is a comma delimited list of the program_ids of the selected programs.", "url": "http://192.168.4.10:8080/WebViewerExample/frameset?__report=timeliness_monthly_trend_by_program.rptdesign", "containing_folder_name": "coc_data_quality_reports", "insert_or_update": "insert", "changing_user_login": "muser", "parameters": [{"parameter_name": "ReportStartDate"}, {"parameter_name": "ReportEndDate"}, {"parameter_name": "ProgramIds"}]}'));
	RAISE NOTICE 'Result = %', (SELECT _output_json ->> 'result_indicator')::text;
END$$;

------------------------------------------------------------------------------
-- 3.	install system users

DO $$
DECLARE  _output_json	json;
BEGIN	
	RAISE NOTICE 'SET UP the user opal ';
	_output_json := (SELECT * FROM system_user_schema.action_add_new_user ('{"firstname": "Roger", "lastname": "Fitzroger", "login": "opal", "password":"spade", "changing_user_login": "muser"}'));
	RAISE NOTICE 'Result = %', (SELECT _output_json ->> 'result_indicator')::text;
END$$;

DO $$
DECLARE  _output_json	json;
BEGIN	
	RAISE NOTICE 'SET UP the user jappl';
	_output_json := (SELECT * FROM system_user_schema.action_add_new_user ('{"firstname": "John", "lastname": "Appleton", "login": "jappl", "password":"river", "changing_user_login": "muser"}'));
	RAISE NOTICE 'Result = %', (SELECT _output_json ->> 'result_indicator')::text;
END$$;

------------------------------------------------------------------------------
-- authorize system users to load and run reports
DO $$
DECLARE  _output_json	json;
BEGIN	
	RAISE NOTICE 'Allow load_report_list';
	_output_json := (SELECT * FROM system_user_schema.action_change_user_allowed_actions ('{"login": "opal", "service":"report_manager", "action":"load_report_list", "task":"allow", "changing_user_login": "muser"}'));
	RAISE NOTICE 'Result for opal = %', (SELECT _output_json ->> 'result_indicator')::text;
	_output_json := (SELECT * FROM system_user_schema.action_change_user_allowed_actions ('{"login": "jappl", "service":"report_manager", "action":"load_report_list", "task":"allow", "changing_user_login": "muser"}'));
	RAISE NOTICE 'Result for jappl = %', (SELECT _output_json ->> 'result_indicator')::text;
END$$;

DO $$
DECLARE  _output_json	json;
BEGIN	
	RAISE NOTICE 'Allow load_run_selected_report';
	_output_json := (SELECT * FROM system_user_schema.action_change_user_allowed_actions ('{"login": "opal", "service":"report_manager", "action":"load_run_selected_report", "task":"allow", "changing_user_login": "muser"}'));
	RAISE NOTICE 'Result for opal = %', (SELECT _output_json ->> 'result_indicator')::text;
	_output_json := (SELECT * FROM system_user_schema.action_change_user_allowed_actions ('{"login": "jappl", "service":"report_manager", "action":"load_run_selected_report", "task":"allow", "changing_user_login": "muser"}'));
	RAISE NOTICE 'Result for jappl = %', (SELECT _output_json ->> 'result_indicator')::text;
END$$;

------------------------------------------------------------------------------
-- 4.	give view permissions to users

-- Generic Program Data reports
DO $$
DECLARE  _output_json	json;
		_report_id	uuid;
		_in_json	json;
BEGIN	
	RAISE NOTICE 'Pemission for United Way Demographics Report People Served';
	_report_id:= 	(SELECT report_id 
					FROM report_manager_schema.reports 
					WHERE report_name = 'United Way Demographics Report People Served'
					);
	_in_json := '{"target_login": "muser", "report_id": "' || _report_id::text || '", "viewable": "TRUE",  "changing_user_login": "muser"}';
	_output_json := (SELECT * FROM report_manager_schema.action_enter_edit_allowed_reports (_in_json));
	RAISE NOTICE 'Result for muser = %', (SELECT _output_json ->> 'result_indicator')::text;
	_in_json := '{"target_login": "jappl", "report_id": "' || _report_id::text || '", "viewable": "TRUE",  "changing_user_login": "muser"}';
	_output_json := (SELECT * FROM report_manager_schema.action_enter_edit_allowed_reports (_in_json));
	RAISE NOTICE 'Result for jappl = %', (SELECT _output_json ->> 'result_indicator')::text;
	_in_json := '{"target_login": "opal", "report_id": "' || _report_id::text || '", "viewable": "TRUE",  "changing_user_login": "muser"}';
	_output_json := (SELECT * FROM report_manager_schema.action_enter_edit_allowed_reports (_in_json));
	RAISE NOTICE 'Result for opal = %', (SELECT _output_json ->> 'result_indicator')::text;
END$$;

DO $$
DECLARE  _output_json	json;
		_report_id	uuid;
		_in_json	json;
BEGIN	
	RAISE NOTICE 'Pemission for Special Populations Served by the Selected Programs';
	_report_id:= 	(SELECT report_id 
					FROM report_manager_schema.reports 
					WHERE report_name = 'Special Populations Served by the Selected Programs'
					);
	_in_json := '{"target_login": "muser", "report_id": "' || _report_id::text || '", "viewable": "TRUE",  "changing_user_login": "muser"}';
	_output_json := (SELECT * FROM report_manager_schema.action_enter_edit_allowed_reports (_in_json));
	RAISE NOTICE 'Result for muser = %', (SELECT _output_json ->> 'result_indicator')::text;
	_in_json := '{"target_login": "jappl", "report_id": "' || _report_id::text || '", "viewable": "TRUE",  "changing_user_login": "muser"}';
	_output_json := (SELECT * FROM report_manager_schema.action_enter_edit_allowed_reports (_in_json));
	RAISE NOTICE 'Result for jappl = %', (SELECT _output_json ->> 'result_indicator')::text;
	_in_json := '{"target_login": "opal", "report_id": "' || _report_id::text || '", "viewable": "TRUE",  "changing_user_login": "muser"}';
	_output_json := (SELECT * FROM report_manager_schema.action_enter_edit_allowed_reports (_in_json));
	RAISE NOTICE 'Result for opal = %', (SELECT _output_json ->> 'result_indicator')::text;
END$$;

DO $$
DECLARE  _output_json	json;
		_report_id	uuid;
		_in_json	json;
BEGIN	
	RAISE NOTICE 'Pemission for Housing Occupancy for Selected Programs';
	_report_id:= 	(SELECT report_id 
					FROM report_manager_schema.reports 
					WHERE report_name = 'Housing Occupancy for Selected Programs'
					);
	_in_json := '{"target_login": "muser", "report_id": "' || _report_id::text || '", "viewable": "TRUE",  "changing_user_login": "muser"}';
	_output_json := (SELECT * FROM report_manager_schema.action_enter_edit_allowed_reports (_in_json));
	RAISE NOTICE 'Result for muser = %', (SELECT _output_json ->> 'result_indicator')::text;
	_in_json := '{"target_login": "jappl", "report_id": "' || _report_id::text || '", "viewable": "TRUE",  "changing_user_login": "muser"}';
	_output_json := (SELECT * FROM report_manager_schema.action_enter_edit_allowed_reports (_in_json));
	RAISE NOTICE 'Result for jappl = %', (SELECT _output_json ->> 'result_indicator')::text;
	_in_json := '{"target_login": "opal", "report_id": "' || _report_id::text || '", "viewable": "TRUE",  "changing_user_login": "muser"}';
	_output_json := (SELECT * FROM report_manager_schema.action_enter_edit_allowed_reports (_in_json));
	RAISE NOTICE 'Result for opal = %', (SELECT _output_json ->> 'result_indicator')::text;
END$$;

DO $$
DECLARE  _output_json	json;
		_report_id	uuid;
		_in_json	json;
BEGIN	
	RAISE NOTICE 'Pemission for Monthly Housing Unit Occupancy for Selected Programs';
	_report_id:= 	(SELECT report_id 
					FROM report_manager_schema.reports 
					WHERE report_name = 'Monthly Housing Unit Occupancy for Selected Programs'
					);
	_in_json := '{"target_login": "muser", "report_id": "' || _report_id::text || '", "viewable": "TRUE",  "changing_user_login": "muser"}';
	_output_json := (SELECT * FROM report_manager_schema.action_enter_edit_allowed_reports (_in_json));
	RAISE NOTICE 'Result for muser = %', (SELECT _output_json ->> 'result_indicator')::text;
	_in_json := '{"target_login": "jappl", "report_id": "' || _report_id::text || '", "viewable": "TRUE",  "changing_user_login": "muser"}';
	_output_json := (SELECT * FROM report_manager_schema.action_enter_edit_allowed_reports (_in_json));
	RAISE NOTICE 'Result for jappl = %', (SELECT _output_json ->> 'result_indicator')::text;
	_in_json := '{"target_login": "opal", "report_id": "' || _report_id::text || '", "viewable": "TRUE",  "changing_user_login": "muser"}';
	_output_json := (SELECT * FROM report_manager_schema.action_enter_edit_allowed_reports (_in_json));
	RAISE NOTICE 'Result for opal = %', (SELECT _output_json ->> 'result_indicator')::text;
END$$;

------------------------------------------------------------------------------
-- CCST Only Reports

DO $$
DECLARE  _output_json	json;
		_report_id	uuid;
		_in_json	json;
BEGIN	
	RAISE NOTICE 'Pemission for CCST Managment Summary Monthly Report';
	_report_id:= 	(SELECT report_id 
					FROM report_manager_schema.reports 
					WHERE report_name = 'CCST Managment Summary Monthly Report'
					);
	_in_json := '{"target_login": "muser", "report_id": "' || _report_id::text || '", "viewable": "TRUE",  "changing_user_login": "muser"}';
	_output_json := (SELECT * FROM report_manager_schema.action_enter_edit_allowed_reports (_in_json));
	RAISE NOTICE 'Result for muser = %', (SELECT _output_json ->> 'result_indicator')::text;
	_in_json := '{"target_login": "jappl", "report_id": "' || _report_id::text || '", "viewable": "TRUE",  "changing_user_login": "muser"}';
	_output_json := (SELECT * FROM report_manager_schema.action_enter_edit_allowed_reports (_in_json));
	RAISE NOTICE 'Result for jappl = %', (SELECT _output_json ->> 'result_indicator')::text;
END$$;

DO $$
DECLARE  _output_json	json;
		_report_id	uuid;
		_in_json	json;
BEGIN	
	RAISE NOTICE 'Pemission for Authorizing Psychiatrists with Clients';
	_report_id:= 	(SELECT report_id 
					FROM report_manager_schema.reports 
					WHERE report_name = 'Authorizing Psychiatrists with Clients'
					);
	_in_json := '{"target_login": "muser", "report_id": "' || _report_id::text || '", "viewable": "TRUE",  "changing_user_login": "muser"}';
	_output_json := (SELECT * FROM report_manager_schema.action_enter_edit_allowed_reports (_in_json));
	RAISE NOTICE 'Result for muser = %', (SELECT _output_json ->> 'result_indicator')::text;
	_in_json := '{"target_login": "jappl", "report_id": "' || _report_id::text || '", "viewable": "TRUE",  "changing_user_login": "muser"}';
	_output_json := (SELECT * FROM report_manager_schema.action_enter_edit_allowed_reports (_in_json));
	RAISE NOTICE 'Result for jappl = %', (SELECT _output_json ->> 'result_indicator')::text;
END$$;


DO $$
DECLARE  _output_json	json;
		_report_id	uuid;
		_in_json	json;
BEGIN	
	RAISE NOTICE 'Pemission for CCST Community Residence Report to Chemung DSS 2018';
	_report_id:= 	(SELECT report_id 
					FROM report_manager_schema.reports 
					WHERE report_name = 'CCST Community Residence Report to Chemung DSS 2018'
					);
	_in_json := '{"target_login": "muser", "report_id": "' || _report_id::text || '", "viewable": "TRUE",  "changing_user_login": "muser"}';
	_output_json := (SELECT * FROM report_manager_schema.action_enter_edit_allowed_reports (_in_json));
	RAISE NOTICE 'Result for muser = %', (SELECT _output_json ->> 'result_indicator')::text;
	_in_json := '{"target_login": "jappl", "report_id": "' || _report_id::text || '", "viewable": "TRUE",  "changing_user_login": "muser"}';
	_output_json := (SELECT * FROM report_manager_schema.action_enter_edit_allowed_reports (_in_json));
	RAISE NOTICE 'Result for jappl = %', (SELECT _output_json ->> 'result_indicator')::text;
END$$;


DO $$
DECLARE  _output_json	json;
		_report_id	uuid;
		_in_json	json;
BEGIN	
	RAISE NOTICE 'Pemission for CCST Treatment Apartments Report to Chemung DSS 2018';
	_report_id:= 	(SELECT report_id 
					FROM report_manager_schema.reports 
					WHERE report_name = 'CCST Treatment Apartments Report to Chemung DSS 2018'
					);
	_in_json := '{"target_login": "muser", "report_id": "' || _report_id::text || '", "viewable": "TRUE",  "changing_user_login": "muser"}';
	_output_json := (SELECT * FROM report_manager_schema.action_enter_edit_allowed_reports (_in_json));
	RAISE NOTICE 'Result for muser = %', (SELECT _output_json ->> 'result_indicator')::text;
	_in_json := '{"target_login": "jappl", "report_id": "' || _report_id::text || '", "viewable": "TRUE",  "changing_user_login": "muser"}';
	_output_json := (SELECT * FROM report_manager_schema.action_enter_edit_allowed_reports (_in_json));
	RAISE NOTICE 'Result for jappl = %', (SELECT _output_json ->> 'result_indicator')::text;
END$$;


DO $$
DECLARE  _output_json	json;
		_report_id	uuid;
		_in_json	json;
BEGIN	
	RAISE NOTICE 'Pemission for Supported Housing Case Management Report to Chemung DSS 2018';
	_report_id:= 	(SELECT report_id 
					FROM report_manager_schema.reports 
					WHERE report_name = 'Supported Housing Case Management Report to Chemung DSS 2018'
					);
	_in_json := '{"target_login": "muser", "report_id": "' || _report_id::text || '", "viewable": "TRUE",  "changing_user_login": "muser"}';
	_output_json := (SELECT * FROM report_manager_schema.action_enter_edit_allowed_reports (_in_json));
	RAISE NOTICE 'Result for muser = %', (SELECT _output_json ->> 'result_indicator')::text;
	_in_json := '{"target_login": "jappl", "report_id": "' || _report_id::text || '", "viewable": "TRUE",  "changing_user_login": "muser"}';
	_output_json := (SELECT * FROM report_manager_schema.action_enter_edit_allowed_reports (_in_json));
	RAISE NOTICE 'Result for jappl = %', (SELECT _output_json ->> 'result_indicator')::text;
END$$;


DO $$
DECLARE  _output_json	json;
		_report_id	uuid;
		_in_json	json;
BEGIN	
	RAISE NOTICE 'Pemission for Supported Housing Property Report to Chemung DSS 2018';
	_report_id:= 	(SELECT report_id 
					FROM report_manager_schema.reports 
					WHERE report_name = 'Supported Housing Property Report to Chemung DSS 2018'
					);
	_in_json := '{"target_login": "muser", "report_id": "' || _report_id::text || '", "viewable": "TRUE",  "changing_user_login": "muser"}';
	_output_json := (SELECT * FROM report_manager_schema.action_enter_edit_allowed_reports (_in_json));
	RAISE NOTICE 'Result for muser = %', (SELECT _output_json ->> 'result_indicator')::text;
	_in_json := '{"target_login": "jappl", "report_id": "' || _report_id::text || '", "viewable": "TRUE",  "changing_user_login": "muser"}';
	_output_json := (SELECT * FROM report_manager_schema.action_enter_edit_allowed_reports (_in_json));
	RAISE NOTICE 'Result for jappl = %', (SELECT _output_json ->> 'result_indicator')::text;
END$$;


DO $$
DECLARE  _output_json	json;
		_report_id	uuid;
		_in_json	json;
BEGIN	
	RAISE NOTICE 'Pemission for Long Stay and MRT Supported Housing Report to Chemung DSS 2018';
	_report_id:= 	(SELECT report_id 
					FROM report_manager_schema.reports 
					WHERE report_name = 'Long Stay and MRT Supported Housing Report to Chemung DSS 2018'
					);
	_in_json := '{"target_login": "muser", "report_id": "' || _report_id::text || '", "viewable": "TRUE",  "changing_user_login": "muser"}';
	_output_json := (SELECT * FROM report_manager_schema.action_enter_edit_allowed_reports (_in_json));
	RAISE NOTICE 'Result for muser = %', (SELECT _output_json ->> 'result_indicator')::text;
	_in_json := '{"target_login": "jappl", "report_id": "' || _report_id::text || '", "viewable": "TRUE",  "changing_user_login": "muser"}';
	_output_json := (SELECT * FROM report_manager_schema.action_enter_edit_allowed_reports (_in_json));
	RAISE NOTICE 'Result for jappl = %', (SELECT _output_json ->> 'result_indicator')::text;
END$$;

DO $$
DECLARE  _output_json	json;
		_report_id	uuid;
		_in_json	json;
BEGIN	
	RAISE NOTICE 'Pemission for MICA Report to Chemung DSS 2018';
	_report_id:= 	(SELECT report_id 
					FROM report_manager_schema.reports 
					WHERE report_name = 'MICA Report to Chemung DSS 2018'
					);
	_in_json := '{"target_login": "muser", "report_id": "' || _report_id::text || '", "viewable": "TRUE",  "changing_user_login": "muser"}';
	_output_json := (SELECT * FROM report_manager_schema.action_enter_edit_allowed_reports (_in_json));
	RAISE NOTICE 'Result for muser = %', (SELECT _output_json ->> 'result_indicator')::text;
	_in_json := '{"target_login": "jappl", "report_id": "' || _report_id::text || '", "viewable": "TRUE",  "changing_user_login": "muser"}';
	_output_json := (SELECT * FROM report_manager_schema.action_enter_edit_allowed_reports (_in_json));
	RAISE NOTICE 'Result for jappl = %', (SELECT _output_json ->> 'result_indicator')::text;
END$$;

------------------------------------------------------------------------------
-- Data Quality/COC Data Quality Reports

DO $$
DECLARE  _output_json	json;
		_report_id	uuid;
		_in_json	json;
BEGIN	
	RAISE NOTICE 'Pemission for Universal Data Elements Data Quality Summmary for One CoC Version 5.2';
	_report_id:= 	(SELECT report_id 
					FROM report_manager_schema.reports 
					WHERE report_name = 'Universal Data Elements Data Quality Summmary for One CoC Version 5.2'
					);
	_in_json := '{"target_login": "muser", "report_id": "' || _report_id::text || '", "viewable": "TRUE",  "changing_user_login": "muser"}';
	_output_json := (SELECT * FROM report_manager_schema.action_enter_edit_allowed_reports (_in_json));
	RAISE NOTICE 'Result for muser = %', (SELECT _output_json ->> 'result_indicator')::text;
	END$$;

DO $$
DECLARE  _output_json	json;
		_report_id	uuid;
		_in_json	json;
BEGIN	
	RAISE NOTICE 'Pemission for Project Specific Elements Data Quality Summmary for One CoC Version 5.2';
	_report_id:= 	(SELECT report_id 
					FROM report_manager_schema.reports 
					WHERE report_name = 'Project Specific Elements Data Quality Summmary for One CoC Version 5.2'
					);
	_in_json := '{"target_login": "muser", "report_id": "' || _report_id::text || '", "viewable": "TRUE",  "changing_user_login": "muser"}';
	_output_json := (SELECT * FROM report_manager_schema.action_enter_edit_allowed_reports (_in_json));
	RAISE NOTICE 'Result for muser = %', (SELECT _output_json ->> 'result_indicator')::text;
	END$$;

DO $$
DECLARE  _output_json	json;
		_report_id	uuid;
		_in_json	json;
BEGIN	
	RAISE NOTICE 'Pemission for Entry/Exit Timeliness Summmary for One CoC Version 5.2';
	_report_id:= 	(SELECT report_id 
					FROM report_manager_schema.reports 
					WHERE report_name = 'Entry/Exit Timeliness Summmary for One CoC Version 5.2'
					);
	_in_json := '{"target_login": "muser", "report_id": "' || _report_id::text || '", "viewable": "TRUE",  "changing_user_login": "muser"}';
	_output_json := (SELECT * FROM report_manager_schema.action_enter_edit_allowed_reports (_in_json));
	RAISE NOTICE 'Result for muser = %', (SELECT _output_json ->> 'result_indicator')::text;
	END$$;

------------------------------------------------------------------------------
-- Data Quality/Data Quality Reports for Selected Programs

DO $$
DECLARE  _output_json	json;
		_report_id	uuid;
		_in_json	json;
BEGIN	
	RAISE NOTICE 'Pemission for Data Quality Summmary for Selected Programs Version 5.2';
	_report_id:= 	(SELECT report_id 
					FROM report_manager_schema.reports 
					WHERE report_name = 'Data Quality Summmary for Selected Programs Version 5.2'
					);
	_in_json := '{"target_login": "muser", "report_id": "' || _report_id::text || '", "viewable": "TRUE",  "changing_user_login": "muser"}';
	_output_json := (SELECT * FROM report_manager_schema.action_enter_edit_allowed_reports (_in_json));
	RAISE NOTICE 'Result for muser = %', (SELECT _output_json ->> 'result_indicator')::text;
	_in_json := '{"target_login": "opal", "report_id": "' || _report_id::text || '", "viewable": "TRUE",  "changing_user_login": "muser"}';
	_output_json := (SELECT * FROM report_manager_schema.action_enter_edit_allowed_reports (_in_json));
	RAISE NOTICE 'Result for opal = %', (SELECT _output_json ->> 'result_indicator')::text;
END$$;

DO $$
DECLARE  _output_json	json;
		_report_id	uuid;
		_in_json	json;
BEGIN	
	RAISE NOTICE 'Pemission for Project Entry and Exit Data Entry Timeliness Summary for Selected Projects';
	_report_id:= 	(SELECT report_id 
					FROM report_manager_schema.reports 
					WHERE report_name = 'Project Entry and Exit Data Entry Timeliness Summary for Selected Projects'
					);
	_in_json := '{"target_login": "muser", "report_id": "' || _report_id::text || '", "viewable": "TRUE",  "changing_user_login": "muser"}';
	_output_json := (SELECT * FROM report_manager_schema.action_enter_edit_allowed_reports (_in_json));
	RAISE NOTICE 'Result for muser = %', (SELECT _output_json ->> 'result_indicator')::text;
	_in_json := '{"target_login": "opal", "report_id": "' || _report_id::text || '", "viewable": "TRUE",  "changing_user_login": "muser"}';
	_output_json := (SELECT * FROM report_manager_schema.action_enter_edit_allowed_reports (_in_json));
	RAISE NOTICE 'Result for opal = %', (SELECT _output_json ->> 'result_indicator')::text;
END$$;

DO $$
DECLARE  _output_json	json;
		_report_id	uuid;
		_in_json	json;
BEGIN	
	RAISE NOTICE 'Pemission for Service Data Entry Timeliness Summary for Selected Projects';
	_report_id:= 	(SELECT report_id 
					FROM report_manager_schema.reports 
					WHERE report_name = 'Service Data Entry Timeliness Summary for Selected Projects'
					);
	_in_json := '{"target_login": "muser", "report_id": "' || _report_id::text || '", "viewable": "TRUE",  "changing_user_login": "muser"}';
	_output_json := (SELECT * FROM report_manager_schema.action_enter_edit_allowed_reports (_in_json));
	RAISE NOTICE 'Result for muser = %', (SELECT _output_json ->> 'result_indicator')::text;
	_in_json := '{"target_login": "opal", "report_id": "' || _report_id::text || '", "viewable": "TRUE",  "changing_user_login": "muser"}';
	_output_json := (SELECT * FROM report_manager_schema.action_enter_edit_allowed_reports (_in_json));
	RAISE NOTICE 'Result for opal = %', (SELECT _output_json ->> 'result_indicator')::text;
END$$;

DO $$
DECLARE  _output_json	json;
		_report_id	uuid;
		_in_json	json;
BEGIN	
	RAISE NOTICE 'Pemission for Data Quality Error Details Version 5.2';
	_report_id:= 	(SELECT report_id 
					FROM report_manager_schema.reports 
					WHERE report_name = 'Data Quality Error Details Version 5.2'
					);
	_in_json := '{"target_login": "muser", "report_id": "' || _report_id::text || '", "viewable": "TRUE",  "changing_user_login": "muser"}';
	_output_json := (SELECT * FROM report_manager_schema.action_enter_edit_allowed_reports (_in_json));
	RAISE NOTICE 'Result for muser = %', (SELECT _output_json ->> 'result_indicator')::text;
	_in_json := '{"target_login": "opal", "report_id": "' || _report_id::text || '", "viewable": "TRUE",  "changing_user_login": "muser"}';
	_output_json := (SELECT * FROM report_manager_schema.action_enter_edit_allowed_reports (_in_json));
	RAISE NOTICE 'Result for opal = %', (SELECT _output_json ->> 'result_indicator')::text;
END$$;

DO $$
DECLARE  _output_json	json;
		_report_id	uuid;
		_in_json	json;
BEGIN	
	RAISE NOTICE 'Pemission for Project Specific Elements Data Quality Error Details Version 5.2';
	_report_id:= 	(SELECT report_id 
					FROM report_manager_schema.reports 
					WHERE report_name = 'Project Specific Elements Data Quality Error Details Version 5.2'
					);
	_in_json := '{"target_login": "muser", "report_id": "' || _report_id::text || '", "viewable": "TRUE",  "changing_user_login": "muser"}';
	_output_json := (SELECT * FROM report_manager_schema.action_enter_edit_allowed_reports (_in_json));
	RAISE NOTICE 'Result for muser = %', (SELECT _output_json ->> 'result_indicator')::text;
	_in_json := '{"target_login": "opal", "report_id": "' || _report_id::text || '", "viewable": "TRUE",  "changing_user_login": "muser"}';
	_output_json := (SELECT * FROM report_manager_schema.action_enter_edit_allowed_reports (_in_json));
	RAISE NOTICE 'Result for opal = %', (SELECT _output_json ->> 'result_indicator')::text;
END$$;

DO $$
DECLARE  _output_json	json;
		_report_id	uuid;
		_in_json	json;
BEGIN	
	RAISE NOTICE 'Pemission for Trends in Project Entry and Exit Data Entry Timeliness for Selected Projects';
	_report_id:= 	(SELECT report_id 
					FROM report_manager_schema.reports 
					WHERE report_name = 'Trends in Project Entry and Exit Data Entry Timeliness for Selected Projects'
					);
	_in_json := '{"target_login": "muser", "report_id": "' || _report_id::text || '", "viewable": "TRUE",  "changing_user_login": "muser"}';
	_output_json := (SELECT * FROM report_manager_schema.action_enter_edit_allowed_reports (_in_json));
	RAISE NOTICE 'Result for muser = %', (SELECT _output_json ->> 'result_indicator')::text;
	_in_json := '{"target_login": "opal", "report_id": "' || _report_id::text || '", "viewable": "TRUE",  "changing_user_login": "muser"}';
	_output_json := (SELECT * FROM report_manager_schema.action_enter_edit_allowed_reports (_in_json));
	RAISE NOTICE 'Result for opal = %', (SELECT _output_json ->> 'result_indicator')::text;
END$$;


