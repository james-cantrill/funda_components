-- test_action_list_user_visible_programs.sql

		
-- SET UP the test users
	SELECT * FROM system_user_schema.action_user_login ('{"login": "muser", "password":"ha_melech!16"}');
	SELECT * FROM system_user_schema.action_add_new_user ('{"firstname": "Roger", "lastname": "Fitzroger", "login": "opal", "password":"spade", "changing_user_login": "muser"}');
	SELECT * FROM system_user_schema.action_add_new_user ('{"firstname": "John", "lastname": "Appleton", "login": "jappl", "password":"river", "changing_user_login": "muser"}');
	
-- SET UP the reports allowed
	SELECT * FROM programs_manager_schema.action_change_program_user_visibility ('{"login": "jappl", "service":"programs_manager", "program":"CCST Emergency Services Food/Clothing", "task":"visible", "changing_user_login": "muser"}');
	SELECT * FROM programs_manager_schema.action_change_program_user_visibility ('{"login": "jappl", "service":"programs_manager", "program":"ACCORD SHP Transitional Housing", "task":"visible", "changing_user_login": "muser"}');
	SELECT * FROM programs_manager_schema.action_change_program_user_visibility ('{"login": "jappl", "service":"programs_manager", "program":"Arbor Hospital Diversion 212", "task":"visible", "changing_user_login": "muser"}');
	SELECT * FROM programs_manager_schema.action_change_program_user_visibility ('{"login": "jappl", "service":"programs_manager", "program":"CCST Supported Housing LTS", "task":"visible", "changing_user_login": "muser"}');
	SELECT * FROM programs_manager_schema.action_change_program_user_visibility ('{"login": "jappl", "service":"programs_manager", "program":"CCST Shelter Plus Care - HUD Permanent", "task":"visible", "changing_user_login": "muser"}');
	SELECT * FROM programs_manager_schema.action_change_program_user_visibility ('{"login": "jappl", "service":"programs_manager", "program":"CCST Supported Housing MICA", "task":"visible", "changing_user_login": "muser"}');

-- TEST the function
	SELECT * FROM programs_manager_schema.action_list_user_visible_programs ('{"login": "jappl"}');
	
	SELECT * FROM programs_manager_schema.action_list_user_visible_programs ('{"login": "opal"}');
------------------------------------------------------------------------------------------------------
	--	CLEAN UP
		DELETE  FROM programs_manager_schema.system_user_allowed_programs  WHERE login  IN ('opal', 'jappl');
		DELETE  FROM system_user_schema.system_user_allowed_actions_history WHERE login  IN ('opal', 'jappl');		
		DELETE  FROM system_user_schema.system_user_allowed_actions WHERE login  IN ('opal', 'jappl');
		DELETE FROM system_user_schema.system_users WHERE login IN ('opal', 'jappl');

/*
"ACCORD SHP Transitional Housing"
"ACCORD Kalthoff House"
"Arbor Transitional Housing 339"
"Arbor Hospital Diversion 212"
"Arbor Supported Housing - OMH Permanent"
"Arbor Shelter Plus Care HUD Permanent"
"ACCORD Homeless Housing Program"
"CCST Homeless Supportive Housing - HUD Permanent"
"CCST Shelter Plus Care - HUD Permanent"
"CCST Supported Housing Chemung - OMH Permanent"
"CCST Supported Housing Schuyler - OMH Permanent"
"CCST Supported Housing HUD 811 Miller Manor"
"CCST Supported Housing LTS"
"CCST Supported Housing MICA"
"CCST Supported Housing RIV I"
"CCST Supported Housing RIV II"
"CCST Supported Housing Schuyler County II"
"Arbor Allegany Supported Housing - 227"
"Arbor Allegany OMH Supported Housing - 221"
"Arbor Shelter Plus Care - Allegany 224/254"
"Arbor Allegany Special Supported Housing - 251"
"Arbor PC Long term Supported Housing - 231"
*/