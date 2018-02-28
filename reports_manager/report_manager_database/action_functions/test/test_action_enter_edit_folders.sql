--	test_action_enter_edit_folders.sql
--	_in_data:	{	folder_id:
--					folder_name:
--					folder_display_name:
--					description:
--					parent_folder_name:
--					changing_user_login:
--				}

		DELETE  FROM report_manager_schema.report_folders;
		DELETE  FROM system_user_schema.system_user_allowed_actions WHERE login IN ('opal', 'jappl');
		DELETE FROM system_user_schema.system_users WHERE login IN ('opal', 'jappl');

--	log in the master user
	SELECT * FROM system_user_schema.action_user_login ('{"login": "muser", "password":"ha_melech!16"}');
	
		SELECT * FROM system_user_schema.action_add_new_user ('{"firstname": "Roger", "lastname": "Fitzroger", "login": "opal", "password":"spade", "changing_user_login": "muser"}');
		SELECT * FROM system_user_schema.action_add_new_user ('{"firstname": "John", "lastname": "Appleton", "login": "jappl", "password":"river", "changing_user_login": "muser"}');
		SELECT * FROM system_user_schema.action_change_user_allowed_actions ('{"login": "jappl", "service":"report_manager", "action":"enter_edit_folders", "task":"allow", "changing_user_login": "muser"}');
		--	log them in
		SELECT * FROM system_user_schema.action_user_login ('{"login": "jappl", "password":"river"}');
		SELECT * FROM system_user_schema.action_user_login ('{"login": "opal", "password":"spade"}'); -- make sure the user is logged in


--------------------------------------------------------------------------------
-- TEST the calling user is not authorized to enter lor edit report folders
--	user is logged in and and change_organization_user_visibility is not allowed - Fail
		--	run the test
		SELECT * FROM report_manager_schema.action_enter_edit_folders ('{"folder_name": "report_root", "folder_display_name":"All Programs", "description":"List of all reports", "is_root_folder": "TRUE", "changing_user_login": "opal"}');

-- TEST there is no folder with this name so we add it it's root  - Succeed
		SELECT * FROM report_manager_schema.action_enter_edit_folders ('{"folder_name": "report_root", "folder_display_name":"All Programs", "description":"List of all reports", "is_root_folder": "TRUE",  "changing_user_login": "jappl"}');

-- TEST add a second root - Fail
		SELECT * FROM report_manager_schema.action_enter_edit_folders ('{"folder_name": "second_report_root", "folder_display_name":"More Programs", "description":"List of more reports", "is_root_folder": "TRUE", "changing_user_login": "jappl"}');

-- TEST adding a child folder - Succeed
		SELECT * FROM report_manager_schema.action_enter_edit_folders ('{"folder_name": "data_quality", "folder_display_name":"Data Quality Programs", "description":"List of all reports", "parent_folder_name": "report_root", "is_root_folder": "FALSE", "changing_user_login": "jappl"}');

-- TEST updating a folder without entering the folder_id, changin g the description - Succeed
		SELECT * FROM report_manager_schema.action_enter_edit_folders ('{"folder_name": "data_quality", "folder_display_name":"Data Quality Programs", "description":"Reports showing the quality of the en tered data.", "parent_folder_name": "report_root", "is_root_folder": "FALSE", "changing_user_login": "jappl"}');

-- TEST adding a child folder to a non-existing parent - Fail
		SELECT * FROM report_manager_schema.action_enter_edit_folders ('{"folder_name": "dummhy", "folder_display_name":"Error", "description":"this is wrong", "parent_folder_name": "parent_missing", "is_root_folder": "FALSE", "changing_user_login": "jappl"}');

-- TEST updating an existing child folder to a non-existing parent - Fail
		SELECT * FROM report_manager_schema.action_enter_edit_folders ('{"folder_name": "data_quality", "folder_display_name":"Data Quality Programs", "description":"Reports showing the quality of the en tered data.", "parent_folder_name": "parent_missing", "is_root_folder": "FALSE", "changing_user_login": "jappl"}');

-- TEST updating the root folder - Succeed
		SELECT * FROM report_manager_schema.action_enter_edit_folders ('{"folder_name": "report_root", "folder_display_name":"Each and every Programs", "description":"List of all reports", "is_root_folder": "FALSE", "changing_user_login": "jappl"}');

-- See the resuts		
	SELECT * FROM report_manager_schema.report_folders;
------------------------------------------------------------------------------------------------------
		--	clean up
		DELETE  FROM report_manager_schema.report_folders;
		DELETE  FROM system_user_schema.system_user_allowed_actions WHERE login IN ('opal', 'jappl');
		DELETE FROM system_user_schema.system_users WHERE login IN ('opal', 'jappl');
	
