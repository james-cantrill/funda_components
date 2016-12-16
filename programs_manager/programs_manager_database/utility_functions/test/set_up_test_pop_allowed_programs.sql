--	set_up_test_action_list_user_visible_programs_jstree.sql

-- SET UP the test users
--	log in the master user
SELECT * FROM system_user_schema.action_user_login ('{"login": "muser", "password":"ha_melech!16"}');

SELECT * FROM system_user_schema.action_add_new_user ('{"firstname": "Roger", "lastname": "Fitzroger", "login": "opal", "password":"spade", "changing_user_login": "muser"}');
--SELECT * FROM system_user_schema.action_add_new_user ('{"firstname": "John", "lastname": "Appleton", "login": "jappl", "password":"river", "changing_user_login": "muser"}');

SELECT * FROM system_user_schema.action_change_user_allowed_actions ('{"login": "opal", "service":"programs_manager", "action":"list_user_visible_programs", "task":"allow", "changing_user_login": "muser"}');

--	Make programs visible to Roger Fitzroger
SELECT * FROM programs_manager_schema.action_change_program_user_visibility ('{"login": "opal", "service":"programs_manager", "program":"CCST Emergency Services Food/Clothing", "task":"visible", "changing_user_login": "muser"}');
SELECT * FROM programs_manager_schema.action_change_program_user_visibility ('{"login": "opal", "service":"programs_manager", "program":"CCST Emergency Services Prescription Drug", "task":"visible", "changing_user_login": "muser"}');
SELECT * FROM programs_manager_schema.action_change_program_user_visibility ('{"login": "opal", "service":"programs_manager", "program":"CCST Supported Housing Chemung - OMH Permanent", "task":"visible", "changing_user_login": "muser"}');
SELECT * FROM programs_manager_schema.action_change_program_user_visibility ('{"login": "opal", "service":"programs_manager", "program":"CCST Supported Housing Generic", "task":"visible", "changing_user_login": "muser"}');
SELECT * FROM programs_manager_schema.action_change_program_user_visibility ('{"login": "opal", "service":"programs_manager", "program":"CCST Supported Housing High Need OMH Permanent", "task":"visible", "changing_user_login": "muser"}');
SELECT * FROM programs_manager_schema.action_change_program_user_visibility ('{"login": "opal", "service":"programs_manager", "program":"CCST Homeless Supportive Housing - HUD Permanent", "task":"visible", "changing_user_login": "muser"}');
SELECT * FROM programs_manager_schema.action_change_program_user_visibility ('{"login": "opal", "service":"programs_manager", "program":"CCST Homeless Supportive Housing Expansion", "task":"visible", "changing_user_login": "muser"}');
SELECT * FROM programs_manager_schema.action_change_program_user_visibility ('{"login": "opal", "service":"programs_manager", "program":"CCST NY083 Bonus Homeless Supportive Housing", "task":"visible", "changing_user_login": "muser"}');
SELECT * FROM programs_manager_schema.action_change_program_user_visibility ('{"login": "opal", "service":"programs_manager", "program":"CCST Adolescent Transitional - Lasting Success Foster Care", "task":"visible", "changing_user_login": "muser"}');
SELECT * FROM programs_manager_schema.action_change_program_user_visibility ('{"login": "opal", "service":"programs_manager", "program":"CCST Bridger Outreach Services", "task":"visible", "changing_user_login": "muser"}');
SELECT * FROM programs_manager_schema.action_change_program_user_visibility ('{"login": "opal", "service":"programs_manager", "program":"CCST Emergency Services Homeless Shelter", "task":"visible", "changing_user_login": "muser"}');
SELECT * FROM programs_manager_schema.action_change_program_user_visibility ('{"login": "opal", "service":"programs_manager", "program":"CCSTEUBEN Emergency Assistance", "task":"visible", "changing_user_login": "muser"}');
SELECT * FROM programs_manager_schema.action_change_program_user_visibility ('{"login": "opal", "service":"programs_manager", "program":"CCSTEUBEN STEHP Street Outreach", "task":"visible", "changing_user_login": "muser"}');

