--	test_action_enter_edit_program_folders
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


SELECT * FROM programs_manager_schema.action_enter_edit_program_folders ('{"program_folder_name": "program_root", "program_folder_display_name":"All Programs", "program_folder_description":"List of all programs", "is_root_folder": "TRUE", "changing_user_login": "muser"}');

SELECT * FROM programs_manager_schema.action_enter_edit_program_folders ('{"program_folder_id" : "46a53310-141d-458b-b03a-4cf114990c94", "program_folder_display_name":"All ACCORD programs", "program_folder_description":"List of all the ACCORD Corporation programs", "parent_folder_name": "program_root", "is_root_folder": "FALSE", "changing_user_login": "muser"}');

SELECT * FROM programs_manager_schema.action_enter_edit_program_folders ('{"program_folder_name": "accord_hud_transitional", "program_folder_display_name":"ACCORD HUD Transitional", "program_folder_description":"List of the ACCORD HUD Transitional programs", "parent_folder_name": "accord_corp", "is_root_folder": "FALSE", "changing_user_login": "muser"}');

SELECT * FROM programs_manager_schema.action_enter_edit_program_folders ('{"program_folder_name": "accord_stehp", "program_folder_display_name":"ACCORD STEPH", "program_folder_description":"List of the ACCORD STEHP programs", "parent_folder_name": "accord_corp", "is_root_folder": "FALSE", "changing_user_login": "appl"}');

SELECT * FROM programs_manager_schema.action_enter_edit_program_folders ('{"program_folder_name": "accord_stehp", "program_folder_display_name":"ACCORD STEPH", "program_folder_description":"List of the ACCORD STEHP programs", "parent_folder_name": "accord_corp", "is_root_folder": "FALSE", "changing_user_login": "muser"}');

SELECT * FROM programs_manager_schema.program_folders;

