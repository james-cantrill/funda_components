-- test_action_list_user_visible_organizations.sql
		DELETE  FROM programs_manager_schema.system_user_allowed_organizations  WHERE login  IN ('opal', 'jappl');
		DELETE  FROM system_user_schema.system_user_allowed_actions WHERE login  IN ('opal', 'jappl');
		DELETE FROM system_user_schema.system_users WHERE login IN ('opal', 'jappl');
		
-- SET UP the test users
	SELECT * FROM system_user_schema.action_user_login ('{"login": "muser", "password":"ha_melech!16"}');
	SELECT * FROM system_user_schema.action_add_new_user ('{"firstname": "Roger", "lastname": "Fitzroger", "login": "opal", "password":"spade", "changing_user_login": "muser"}');
	SELECT * FROM system_user_schema.action_add_new_user ('{"firstname": "John", "lastname": "Appleton", "login": "jappl", "password":"river", "changing_user_login": "muser"}');
	
		--	log them in
		SELECT * FROM system_user_schema.action_user_login ('{"login": "jappl", "password":"river"}');
		SELECT * FROM system_user_schema.action_user_login ('{"login": "opal", "password":"spade"}'); -- make sure the user is logged in
-- SET UP the organizations allowed
		SELECT * FROM programs_manager_schema.action_change_organization_user_visibility ('{"login": "opal", "service":"programs_manager", "organization_name":"Catholic Charities of Steuben County", "task":"visible", "changing_user_login": "muser"}');
		SELECT * FROM programs_manager_schema.action_change_organization_user_visibility ('{"login": "opal", "service":"programs_manager", "organization_name":"ACCORD Corporation", "task":"visible", "changing_user_login": "muser"}');
		SELECT * FROM programs_manager_schema.action_change_organization_user_visibility ('{"login": "opal", "service":"programs_manager", "organization_name":"Arbor Housing and Development", "task":"visible", "changing_user_login": "muser"}');
		SELECT * FROM programs_manager_schema.action_change_organization_user_visibility ('{"login": "opal", "service":"programs_manager", "organization_name":"Catholic Charities of Livingston County", "task":"visible", "changing_user_login": "muser"}');
		SELECT * FROM programs_manager_schema.action_change_organization_user_visibility ('{"login": "opal", "service":"programs_manager", "organization_name":"Steuben County Department of Social Services (DSS)", "task":"visible", "changing_user_login": "muser"}');

-- TEST the function
	SELECT * FROM programs_manager_schema.action_list_user_visible_organizations ('{"login": "opal"}');
	
	SELECT * FROM programs_manager_schema.action_list_user_visible_organizations ('{"login": "jappl"}');

	------------------------------------------------------------------------------------------------------
	--	CLEAN UP
		DELETE  FROM programs_manager_schema.system_user_allowed_organizations  WHERE login  IN ('opal', 'jappl');
		DELETE  FROM system_user_schema.system_user_allowed_actions WHERE login  IN ('opal', 'jappl');
		DELETE FROM system_user_schema.system_users WHERE login IN ('opal', 'jappl');

/*
"Catholic Charities of Chemung and Schuyler Counties"
"ACCORD Corporation"
"Chances and Changes"
"Steuben County Department of Social Services (DSS)"
"Catholic Charities of Livingston County"
"Catholic Charities of Tompkins/Tioga"
"Arbor Housing and Development"
"Livingston County DSS"
"Catholic Charities of Steuben County"

*/