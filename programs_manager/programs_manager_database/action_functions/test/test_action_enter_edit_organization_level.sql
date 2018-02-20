--	test_action_enter_edit_organization_level
/*	_in_data:	
	{
		organization_level_name:
		organization_level_display_name:
		organization_level_description:
		parent_level_name:  
		is_root_level:	-- boolean
		organization_name:
		changing_user_login:
		enter_or_update:
	}*/

--	log in the master user
SELECT * FROM system_user_schema.action_user_login ('{"login": "muser", "password":"ha_melech!16"}');


SELECT * FROM programs_manager_schema.action_enter_edit_organization_level ('{"organization_level_name": "program_root", "organization_level_display_name":"All Programs", "organization_level_description":"List of all programs", "is_root_level": "TRUE", "organization_name": "Test Organization  1", "changing_user_login": "muser", "enter_or_update": "Enter"}');

/*SELECT * FROM programs_manager_schema.action_enter_edit_organization_level ('{"organization_level_id" : "46a53310-141d-458b-b03a-4cf114990c94", "organization_level_display_name":"All ACCORD programs", "organization_level_description":"List of all the ACCORD Corporation programs", "parent_level_name": "program_root", "is_root_level": "FALSE", "changing_user_login": "muser"}');

SELECT * FROM programs_manager_schema.action_enter_edit_organization_level ('{"organization_level_name": "accord_hud_transitional", "organization_level_display_name":"ACCORD HUD Transitional", "organization_level_description":"List of the ACCORD HUD Transitional programs", "parent_level_name": "accord_corp", "is_root_level": "FALSE", "changing_user_login": "muser"}');

SELECT * FROM programs_manager_schema.action_enter_edit_organization_level ('{"organization_level_name": "accord_stehp", "organization_level_display_name":"ACCORD STEPH", "organization_level_description":"List of the ACCORD STEHP programs", "parent_level_name": "accord_corp", "is_root_level": "FALSE", "changing_user_login": "appl"}');

SELECT * FROM programs_manager_schema.action_enter_edit_organization_level ('{"organization_level_name": "accord_stehp", "organization_level_display_name":"ACCORD STEPH", "organization_level_description":"List of the ACCORD STEHP programs", "parent_level_name": "accord_corp", "is_root_level": "FALSE", "changing_user_login": "muser"}');
*/

SELECT * FROM programs_manager_schema.organization_level;

