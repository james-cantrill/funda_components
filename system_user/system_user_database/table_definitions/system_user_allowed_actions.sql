
DROP TABLE IF EXISTS system_user_schema.system_user_allowed_actions;

CREATE TABLE system_user_schema.system_user_allowed_actions (
	sysuser_id	uuid NOT NULL,
	login	text NOT NULL,
	service	text NOT NULL,
	action	text NOT NULL,
	action_display_name	text,
	action_allowed	boolean,
	changing_user_login	text NOT NULL,
	datetime_action_allowed_changed	timestamp without time zone NOT NULL,
	UNIQUE (login, service, action)
);
