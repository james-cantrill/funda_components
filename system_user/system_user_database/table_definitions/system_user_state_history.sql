
DROP TABLE IF EXISTS system_user_schema.system_user_state_history;

CREATE TABLE system_user_schema.system_user_state_history (
	sysuser_id	uuid NOT NULL,
	user_state	text NOT NULL,
	datetime_state_started	timestamp without time zone NOT NULL,
	datetime_state_ended	timestamp without time zone NOT NULL
);
