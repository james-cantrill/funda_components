--	add_all_organization_level
--	_in_data:	{								
--					organization_level_id:
--					organization_level_name:
--					organization_level_display_name:
--					organization_level_description:
--					parent_level_name:  
--					is_root_level:	-- boolean
--					changing_user_login:
--				}

--	log in the master user
SELECT * FROM system_user_schema.action_user_login ('{"login": "muser", "password":"ha_melech!16"}');

--	Delete existing folders
DELETE FROM programs_manager_schema.organization_level;

--	add the folders
SELECT * FROM programs_manager_schema.action_enter_edit_organization_level ('{"organization_level_name": "program_root", "organization_level_display_name":"All Programs", "organization_level_description":"List of all programs", "is_root_level": "TRUE", "changing_user_login": "muser"}');

SELECT * FROM programs_manager_schema.action_enter_edit_organization_level ('{"organization_level_name": "accord_corp", "organization_level_display_name":"All ACCORD programs", "organization_level_description":"List of all the ACCORD Corporation programs", "parent_level_name": "program_root", "is_root_level": "FALSE", "changing_user_login": "muser"}');

SELECT * FROM programs_manager_schema.action_enter_edit_organization_level ('{"organization_level_name": "arbor_dev", "organization_level_display_name":"All Arbor programs", "organization_level_description":"List of all the Arbor Housing and Development programs", "parent_level_name": "program_root", "is_root_level": "FALSE", "changing_user_login": "muser"}');

SELECT * FROM programs_manager_schema.action_enter_edit_organization_level ('{"organization_level_name": "cc_cs", "organization_level_display_name":"All CC Chemung/Schuyler programs", "organization_level_description":"List of all the Catholic Charities of Chemung and Schuyler Counties programs", "parent_level_name": "program_root", "is_root_level": "FALSE", "changing_user_login": "muser"}');

SELECT * FROM programs_manager_schema.action_enter_edit_organization_level ('{"organization_level_name": "cc_steuben", "organization_level_display_name":"All CC Steuben programs", "organization_level_description":"List of all the Catholic Charities of Steuben County programs", "parent_level_name": "program_root", "is_root_level": "FALSE", "changing_user_login": "muser"}');

SELECT * FROM programs_manager_schema.action_enter_edit_organization_level ('{"organization_level_name": "steuben_dss", "organization_level_display_name":"All Steuben DSS programs", "organization_level_description":"List of all the Catholic Charities of Tompkins/Tioga programs", "parent_level_name": "program_root", "is_root_level": "FALSE", "changing_user_login": "muser"}');

SELECT * FROM programs_manager_schema.action_enter_edit_organization_level ('{"organization_level_name": "cc_tt", "organization_level_display_name":"All CC Tompkins/Tioga programs", "organization_level_description":"List of all the Steuben County Department of Social Services (DSS) programs", "parent_level_name": "program_root", "is_root_level": "FALSE", "changing_user_login": "muser"}');

--------------------------------------------------------------------------------------
SELECT * FROM programs_manager_schema.action_enter_edit_organization_level ('{"organization_level_name": "accord_hud_transitional", "organization_level_display_name":"ACCORD HUD Transitional", "organization_level_description":"List of the ACCORD HUD Transitional programs", "parent_level_name": "accord_corp", "is_root_level": "FALSE", "changing_user_login": "muser"}');

SELECT * FROM programs_manager_schema.action_enter_edit_organization_level ('{"organization_level_name": "accord_stehp", "organization_level_display_name":"ACCORD STEPH", "organization_level_description":"List of the ACCORD STEHP programs", "parent_level_name": "accord_corp", "is_root_level": "FALSE", "changing_user_login": "muser"}');

------------------------------------------------------------------------------
SELECT * FROM programs_manager_schema.action_enter_edit_organization_level ('{"organization_level_name": "arbor_omh_transitional", "organization_level_display_name":"Arbor OMH Transitional Programs", "organization_level_description":"List of the Arbor OMH Transitional Programs", "parent_level_name": "arbor_dev", "is_root_level": "FALSE", "changing_user_login": "muser"}');

SELECT * FROM programs_manager_schema.action_enter_edit_organization_level ('{"organization_level_name": "arbor_supported", "organization_level_display_name":"Arbor Supported Programs", "organization_level_description":"List of the Arbor Supported Programs", "parent_level_name": "arbor_dev", "is_root_level": "FALSE", "changing_user_login": "muser"}');

------------------------------------------------------------------------------
SELECT * FROM programs_manager_schema.action_enter_edit_organization_level ('{"organization_level_name": "cccs_omh_transitional", "organization_level_display_name":"CC Chemung/Schuyler OMH Transitional Programs", "organization_level_description":"List of the Catholic Charities of Chemung and Schuyler Counties OMH Transitional Programs", "parent_level_name": "cc_cs", "is_root_level": "FALSE", "changing_user_login": "muser"}');

SELECT * FROM programs_manager_schema.action_enter_edit_organization_level ('{"organization_level_name": "cccs_emerg_services", "organization_level_display_name":"CC Chemung/Schuyler Emergency Services Programs", "organization_level_description":"List of the Catholic Charities of Chemung and Schuyler Counties Emergency Services Programs", "parent_level_name": "cc_cs", "is_root_level": "FALSE", "changing_user_login": "muser"}');

SELECT * FROM programs_manager_schema.action_enter_edit_organization_level ('{"organization_level_name": "cccs_steph", "organization_level_display_name":"CC Chemung/Schuyler STEPH Programs", "organization_level_description":"List of the Catholic Charities of Chemung and Schuyler Counties STEHP Programs", "parent_level_name": "cc_cs", "is_root_level": "FALSE", "changing_user_login": "muser"}');

SELECT * FROM programs_manager_schema.action_enter_edit_organization_level ('{"organization_level_name": "cccs_other", "organization_level_display_name":"CC Chemung/Schuyler Other Programs", "organization_level_description":"List of the other Catholic Charities of Chemung and Schuyler Counties Programs", "parent_level_name": "cc_cs", "is_root_level": "FALSE", "changing_user_login": "muser"}');

SELECT * FROM programs_manager_schema.action_enter_edit_organization_level ('{"organization_level_name": "cccs_omh_permanent", "organization_level_display_name":"CC Chemung/Schuyler OMH Permanent Programs", "organization_level_description":"List of the Catholic Charities of Chemung and Schuyler Counties OMH Permanent Programs", "parent_level_name": "cc_cs", "is_root_level": "FALSE", "changing_user_login": "muser"}');

SELECT * FROM programs_manager_schema.action_enter_edit_organization_level ('{"organization_level_name": "cccs_hud_permanent", "organization_level_display_name":"CC Chemung/Schuyler HUD Permanent Programs", "organization_level_description":"List of the Catholic Charities of Chemung and Schuyler Counties HUD Permanent Programs", "parent_level_name": "cc_cs", "is_root_level": "FALSE", "changing_user_login": "muser"}');




SELECT * FROM programs_manager_schema.organization_level;

