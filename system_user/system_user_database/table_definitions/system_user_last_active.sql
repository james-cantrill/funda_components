
DROP TABLE IF EXISTS system_user_schema.system_user_last_active;

CREATE TABLE system_user_schema.system_user_last_active (
	sysuser_id	uuid NOT NULL PRIMARY KEY,
	login	text NOT NULL,
	datetime_last_active	timestamp without time zone NOT NULL,
	CONSTRAINT system_user_last_active_sysuser_id_fkey FOREIGN KEY (sysuser_id)
		REFERENCES system_user_schema.system_users (sysuser_id) MATCH SIMPLE
		ON UPDATE NO ACTION ON DELETE CASCADE
);
