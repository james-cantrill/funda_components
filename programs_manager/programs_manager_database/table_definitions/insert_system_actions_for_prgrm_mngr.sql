--	insert_system_actions_for_prgrm_mngr.sql

-- insert the actions for the programs_manager service that require authorization. The other services will insert their actions as part of their installation

INSERT INTO system_user_schema.system_actions (service, action, action_display_name) VALUES ('programs_manager', 'action_enter_edit_organizations', 'Enter or Edit the Organizations');
INSERT INTO system_user_schema.system_actions (service, action, action_display_name) VALUES ('programs_manager', 'enter_edit_organization_levels', 'Enter or Edit the Organization Levels');
INSERT INTO system_user_schema.system_actions (service, action, action_display_name) VALUES ('programs_manager', 'enter_edit_programs', 'Enter or Edit the Programs');
INSERT INTO system_user_schema.system_actions (service, action, action_display_name) VALUES ('programs_manager', 'change_program_user_visibility', 'Program Visibility');
INSERT INTO system_user_schema.system_actions (service, action, action_display_name) VALUES ('programs_manager', 'change_organization_level_user_visibility', 'Organization Level Visibility');
INSERT INTO system_user_schema.system_actions (service, action, action_display_name) VALUES ('programs_manager', 'list_user_visible_programs', 'List Programs');

