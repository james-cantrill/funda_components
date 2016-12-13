--	add_all_program_folders
--	_in_data:	{								
--					program_folder_id:
--					program_folder_name:
--					program_folder_display_name:
--					program_folder_description:
--					parent_folder_name:  
--					is_root_folder:	-- boolean
--					changing_user_login:
--				}

--	log in the master user
SELECT * FROM system_user_schema.action_user_login ('{"login": "muser", "password":"ha_melech!16"}');

--	Delete existing folders
DELETE FROM programs_manager_schema.program_folders;

--	add the folders
SELECT * FROM programs_manager_schema.action_enter_edit_program_folders ('{"program_folder_name": "program_root", "program_folder_display_name":"All Programs", "program_folder_description":"List of all programs", "is_root_folder": "TRUE", "changing_user_login": "muser"}');

SELECT * FROM programs_manager_schema.action_enter_edit_program_folders ('{"program_folder_name": "accord_corp", "program_folder_display_name":"All ACCORD programs", "program_folder_description":"List of all the ACCORD Corporation programs", "parent_folder_name": "program_root", "is_root_folder": "FALSE", "changing_user_login": "muser"}');

SELECT * FROM programs_manager_schema.action_enter_edit_program_folders ('{"program_folder_name": "arbor_dev", "program_folder_display_name":"All Arbor programs", "program_folder_description":"List of all the Arbor Housing and Development programs", "parent_folder_name": "program_root", "is_root_folder": "FALSE", "changing_user_login": "muser"}');

SELECT * FROM programs_manager_schema.action_enter_edit_program_folders ('{"program_folder_name": "cc_cs", "program_folder_display_name":"All CC Chemung/Schuyler programs", "program_folder_description":"List of all the Catholic Charities of Chemung and Schuyler Counties programs", "parent_folder_name": "program_root", "is_root_folder": "FALSE", "changing_user_login": "muser"}');

SELECT * FROM programs_manager_schema.action_enter_edit_program_folders ('{"program_folder_name": "cc_steuben", "program_folder_display_name":"All CC Steuben programs", "program_folder_description":"List of all the Catholic Charities of Steuben County programs", "parent_folder_name": "program_root", "is_root_folder": "FALSE", "changing_user_login": "muser"}');

SELECT * FROM programs_manager_schema.action_enter_edit_program_folders ('{"program_folder_name": "steuben_dss", "program_folder_display_name":"All Steuben DSS programs", "program_folder_description":"List of all the Catholic Charities of Tompkins/Tioga programs", "parent_folder_name": "program_root", "is_root_folder": "FALSE", "changing_user_login": "muser"}');

SELECT * FROM programs_manager_schema.action_enter_edit_program_folders ('{"program_folder_name": "cc_tt", "program_folder_display_name":"All CC Tompkins/Tioga programs", "program_folder_description":"List of all the Steuben County Department of Social Services (DSS) programs", "parent_folder_name": "program_root", "is_root_folder": "FALSE", "changing_user_login": "muser"}');

--------------------------------------------------------------------------------------
SELECT * FROM programs_manager_schema.action_enter_edit_program_folders ('{"program_folder_name": "accord_hud_transitional", "program_folder_display_name":"ACCORD HUD Transitional", "program_folder_description":"List of the ACCORD HUD Transitional programs", "parent_folder_name": "accord_corp", "is_root_folder": "FALSE", "changing_user_login": "muser"}');

SELECT * FROM programs_manager_schema.action_enter_edit_program_folders ('{"program_folder_name": "accord_stehp", "program_folder_display_name":"ACCORD STEPH", "program_folder_description":"List of the ACCORD STEHP programs", "parent_folder_name": "accord_corp", "is_root_folder": "FALSE", "changing_user_login": "muser"}');

------------------------------------------------------------------------------
SELECT * FROM programs_manager_schema.action_enter_edit_program_folders ('{"program_folder_name": "arbor_omh_transitional", "program_folder_display_name":"Arbor OMH Transitional Programs", "program_folder_description":"List of the Arbor OMH Transitional Programs", "parent_folder_name": "arbor_dev", "is_root_folder": "FALSE", "changing_user_login": "muser"}');

SELECT * FROM programs_manager_schema.action_enter_edit_program_folders ('{"program_folder_name": "arbor_supported", "program_folder_display_name":"Arbor Supported Programs", "program_folder_description":"List of the Arbor Supported Programs", "parent_folder_name": "arbor_dev", "is_root_folder": "FALSE", "changing_user_login": "muser"}');

------------------------------------------------------------------------------
SELECT * FROM programs_manager_schema.action_enter_edit_program_folders ('{"program_folder_name": "cccs_omh_transitional", "program_folder_display_name":"CC Chemung/Schuyler OMH Transitional Programs", "program_folder_description":"List of the Catholic Charities of Chemung and Schuyler Counties OMH Transitional Programs", "parent_folder_name": "cc_cs", "is_root_folder": "FALSE", "changing_user_login": "muser"}');

SELECT * FROM programs_manager_schema.action_enter_edit_program_folders ('{"program_folder_name": "cccs_emerg_services", "program_folder_display_name":"CC Chemung/Schuyler Emergency Services Programs", "program_folder_description":"List of the Catholic Charities of Chemung and Schuyler Counties Emergency Services Programs", "parent_folder_name": "cc_cs", "is_root_folder": "FALSE", "changing_user_login": "muser"}');

SELECT * FROM programs_manager_schema.action_enter_edit_program_folders ('{"program_folder_name": "cccs_steph", "program_folder_display_name":"CC Chemung/Schuyler STEPH Programs", "program_folder_description":"List of the Catholic Charities of Chemung and Schuyler Counties STEHP Programs", "parent_folder_name": "cc_cs", "is_root_folder": "FALSE", "changing_user_login": "muser"}');

SELECT * FROM programs_manager_schema.action_enter_edit_program_folders ('{"program_folder_name": "cccs_other", "program_folder_display_name":"CC Chemung/Schuyler Other Programs", "program_folder_description":"List of the other Catholic Charities of Chemung and Schuyler Counties Programs", "parent_folder_name": "cc_cs", "is_root_folder": "FALSE", "changing_user_login": "muser"}');

SELECT * FROM programs_manager_schema.action_enter_edit_program_folders ('{"program_folder_name": "cccs_omh_permanent", "program_folder_display_name":"CC Chemung/Schuyler OMH Permanent Programs", "program_folder_description":"List of the Catholic Charities of Chemung and Schuyler Counties OMH Permanent Programs", "parent_folder_name": "cc_cs", "is_root_folder": "FALSE", "changing_user_login": "muser"}');

SELECT * FROM programs_manager_schema.action_enter_edit_program_folders ('{"program_folder_name": "cccs_hud_permanent", "program_folder_display_name":"CC Chemung/Schuyler HUD Permanent Programs", "program_folder_description":"List of the Catholic Charities of Chemung and Schuyler Counties HUD Permanent Programs", "parent_folder_name": "cc_cs", "is_root_folder": "FALSE", "changing_user_login": "muser"}');




SELECT * FROM programs_manager_schema.program_folders;

