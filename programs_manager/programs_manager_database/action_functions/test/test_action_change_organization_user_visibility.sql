--	test_action_change_organization_user_visibility.sql

-- SET UP the test users
--	log in tjnhe master user
	SELECT * FROM system_user_schema.action_user_login ('{"login": "muser", "password":"ha_melech!16"}');
	
		SELECT * FROM system_user_schema.action_add_new_user ('{"firstname": "Roger", "lastname": "Fitzroger", "login": "opal", "password":"spade", "changing_user_login": "muser"}');
		SELECT * FROM system_user_schema.action_add_new_user ('{"firstname": "John", "lastname": "Appleton", "login": "jappl", "password":"river", "changing_user_login": "muser"}');
		SELECT * FROM system_user_schema.action_change_user_allowed_actions ('{"login": "jappl", "service":"programs_manager", "action":"change_organization_user_visibility", "task":"allow", "changing_user_login": "muser"}');
		--	log them in
		SELECT * FROM system_user_schema.action_user_login ('{"login": "jappl", "password":"river"}');
		SELECT * FROM system_user_schema.action_user_login ('{"login": "opal", "password":"spade"}'); -- make sure the user is logged in

--------------------------------------------------------------------------------
-- TEST the calling user is not authorized to change program accesiblilty
--	user is logged in and and change_organization_user_visibility is not allowed - Fail
		--	run the test
		SELECT * FROM programs_manager_schema.action_change_organization_user_visibility ('{"login": "jappl", "service":"programs_manager", "organization_name":"Catholic Charities of Steuben County", "task":"visible", "changing_user_login": "opal"}');

-- TEST the user does not have an entry for this organization_name so we add it  - Succeed
		SELECT * FROM programs_manager_schema.action_change_organization_user_visibility ('{"login": "opal", "service":"programs_manager", "organization_name":"Catholic Charities of Steuben County", "task":"visible", "changing_user_login": "jappl"}');
	
-- TEST the user already has an entry for this program and we can change it from TRUE to TRUE - Fail
		SELECT * FROM programs_manager_schema.action_change_organization_user_visibility ('{"login": "opal", "service":"programs_manager", "organization_name":"Catholic Charities of Steuben County", "task":"visible", "changing_user_login": "jappl"}');
		

-- TEST the user already has an entry for this program and we can change it from TRUE to FALSE  - Succeed
		SELECT * FROM programs_manager_schema.action_change_organization_user_visibility ('{"login": "opal", "service":"programs_manager", "organization_name":"Catholic Charities of Steuben County", "task":"not_visible", "changing_user_login": "jappl"}');
		

-- TEST the user already has an entry for this program and we can change it from FALSE to FALSE - Fail
		SELECT * FROM programs_manager_schema.action_change_organization_user_visibility ('{"login": "opal", "service":"programs_manager", "organization_name":"Catholic Charities of Steuben County", "task":"not_visible", "changing_user_login": "jappl"}');
		

-- TEST the user already has an entry for this program and we can change it from FALSE to TRUE  - Succeed
		SELECT * FROM programs_manager_schema.action_change_organization_user_visibility ('{"login": "opal", "service":"programs_manager", "organization_name":"Catholic Charities of Steuben County", "task":"visible", "changing_user_login": "jappl"}');
		
		
------------------------------------------------------------------------------------------------------
		--	clean up
		--DELETE  FROM programs_manager_schema.system_user_allowed_organizations  WHERE login  IN ('opal', 'jappl');
		--DELETE  FROM system_user_schema.system_user_allowed_actions_history WHERE login  IN ('opal', 'jappl');		
		--DELETE  FROM system_user_schema.system_user_allowed_actions WHERE login  IN ('opal', 'jappl');
		--DELETE FROM system_user_schema.system_users WHERE login IN ('opal', 'jappl');
		
