
DROP TABLE IF EXISTS system_user_schema.system_user_state;

CREATE TABLE system_user_schema.system_user_state (
	sysuser_id	uuid NOT NULL PRIMARY KEY,
	user_state	text NOT NULL,
	datetime_state_started	timestamp without time zone NOT NULL,
	CONSTRAINT system_user_state_sysuser_id_fkey FOREIGN KEY (sysuser_id)
		REFERENCES system_user_schema.system_users (sysuser_id) MATCH SIMPLE
		ON UPDATE NO ACTION ON DELETE CASCADE
);
