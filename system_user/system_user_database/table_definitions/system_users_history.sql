--	system_users_history


DROP TABLE IF EXISTS system_user_schema.system_users_history;

CREATE TABLE system_user_schema.system_users_history (
	sysuser_id	uuid NOT NULL,
	login	text NOT NULL,
	password_changed	text NOT NULL,
	firstname	text NOT NULL,
	lastname	text NOT NULL,
	datetime_user_change_started	timestamp without time zone NOT NULL,
	datetime_user_change_ended	timestamp without time zone NOT NULL,    
	changing_user_login	text NOT NULL,
	change_type	text NOT NULL -- the change_type will be either update or delete
);
