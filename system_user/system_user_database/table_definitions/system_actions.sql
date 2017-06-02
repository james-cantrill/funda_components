
DROP TABLE IF EXISTS system_user_schema.system_actions;

CREATE TABLE system_user_schema.system_actions (
	service	text NOT NULL,
	action	text NOT NULL,
	action_display_name	text,
	UNIQUE (service, action)
);

-- insert the actions for the system_user service that require authorization (login and logout don't). The other services will insert their actions as part of their installation
INSERT INTO system_user_schema.system_actions (service, action, action_display_name) VALUES ('system_user', 'add_new_user', 'Add User');
INSERT INTO system_user_schema.system_actions (service, action, action_display_name) VALUES ('system_user', 'enter_edit_allowed_actions', 'Allowed Actions');
INSERT INTO system_user_schema.system_actions (service, action, action_display_name) VALUES ('system_user', 'change_password', 'Change Password');
INSERT INTO system_user_schema.system_actions (service, action, action_display_name) VALUES ('system_user', 'list_user_actions', 'List Users');
INSERT INTO system_user_schema.system_actions (service, action, action_display_name) VALUES ('system_user', 'user_login', 'User Login');


