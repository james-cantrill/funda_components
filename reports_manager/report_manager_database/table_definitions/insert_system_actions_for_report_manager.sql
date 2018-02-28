--	insert_system_actions_for_report_manager.sql

DELETE FROM system_user_schema.system_actions WHERE service = 'report_manager';

-- insert the actions for the programs_manager service that require authorization. The other services will insert their actions as part of their installation
INSERT INTO system_user_schema.system_actions (service, action, action_display_name) VALUES ('report_manager', 'enter_edit_folders', 'Enter/Edit Report Folders');
INSERT INTO system_user_schema.system_actions (service, action, action_display_name) VALUES ('report_manager', 'enter_edit_parameters', 'Enter/Edit Report Parameters');
INSERT INTO system_user_schema.system_actions (service, action, action_display_name) VALUES ('report_manager', 'enter_edit_reports', 'Enter/Edit Reports');
INSERT INTO system_user_schema.system_actions (service, action, action_display_name) VALUES ('report_manager', 'load_report_list', 'Load Report List');
INSERT INTO system_user_schema.system_actions (service, action, action_display_name) VALUES ('report_manager', 'enter_edit_allowed_reports', 'Allowed Reports');
INSERT INTO system_user_schema.system_actions (service, action, action_display_name) VALUES ('report_manager', 'load_run_selected_report', 'Load and Run a Selected Report');

