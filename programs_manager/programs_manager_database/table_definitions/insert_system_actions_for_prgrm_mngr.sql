--	insert_system_actions_for_prgrm_mngr.sql

-- insert the actions for the programs_manager service that require authorization. The other services will insert their actions as part of their installation
INSERT INTO system_user_schema.system_actions (service, action, action_display_name) VALUES ('programs_manager', 'change_continuum_user_visibility', 'Continuum Visibility');
INSERT INTO system_user_schema.system_actions (service, action, action_display_name) VALUES ('programs_manager', 'change_organization_user_visibility', 'Organization Visibility');
INSERT INTO system_user_schema.system_actions (service, action, action_display_name) VALUES ('programs_manager', 'change_program_user_visibility', 'Program Visibility');
INSERT INTO system_user_schema.system_actions (service, action, action_display_name) VALUES ('programs_manager', 'list_user_visible_programs', 'Program Visibility');
INSERT INTO system_user_schema.system_actions (service, action, action_display_name) VALUES ('programs_manager', 'list_user_visible_organizations', 'Program Visibility');
INSERT INTO system_user_schema.system_actions (service, action, action_display_name) VALUES ('programs_manager', 'enter_edit_program_folders', 'Program Visibility');
INSERT INTO system_user_schema.system_actions (service, action, action_display_name) VALUES ('programs_manager', 'enter_edit_programs', 'Program Visibility');

