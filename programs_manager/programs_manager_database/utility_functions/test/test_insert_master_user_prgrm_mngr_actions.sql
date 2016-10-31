-- The function programs_manager_schema.insert_master_user_prgrm_mngr_actions
-- allows the master user to run all programs_manager actions. It is run as
-- the last step in the programs_manager installation

DELETE FROM system_user_schema.system_actions WHERE service = 'programs_manager';
-- insert the actions for the programs_manager service that require authorization. The other services will insert their actions as part of their installation
INSERT INTO system_user_schema.system_actions (service, action, action_display_name) VALUES ('programs_manager', 'change_continuum_user_visibility', 'Continuum Visibility');
INSERT INTO system_user_schema.system_actions (service, action, action_display_name) VALUES ('programs_manager', 'change_agency_user_visibility', 'Agency Visibility');
INSERT INTO system_user_schema.system_actions (service, action, action_display_name) VALUES ('programs_manager', 'change_program_user_visibility', 'Program Visibility');


SELECT * FROM programs_manager_schema.insert_master_user_prgrm_mngr_actions ();


SELECT * FROM system_user_schema.action_user_login ('{"login": "muser", "password":"ha_melech!16"}');

SELECT * FROM system_user_schema.util_is_user_authorized ('{"login": "muser", "service":"programs_manager", "action": "change_continuum_user_visibility"}');
SELECT * FROM system_user_schema.util_is_user_authorized ('{"login": "muser", "service":"programs_manager", "action": "change_agency_user_visibility"}');
SELECT * FROM system_user_schema.util_is_user_authorized ('{"login": "muser", "service":"programs_manager", "action": "change_program_user_visibility"}');


