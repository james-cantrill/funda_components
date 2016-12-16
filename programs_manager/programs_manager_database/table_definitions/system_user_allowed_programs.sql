--  system_user_allowed_programs


DROP TABLE IF EXISTS programs_manager_schema.system_user_allowed_programs;

CREATE TABLE programs_manager_schema.system_user_allowed_programs (
	sysuser_id	uuid NOT NULL,
	login	text NOT NULL,
	program_id	integer NOT NULL,
	program_name	text NOT NULL,
	program_accessible	boolean NOT NULL,
	datetime_program_accessible_changed	timestamp without time zone NOT NULL,
	changed_by_user_login	text NOT NULL,
	CONSTRAINT system_user_allowed_programs_pkey PRIMARY KEY ( sysuser_id, program_id),
	CONSTRAINT system_user_allowed_programs_program_id_fkey FOREIGN KEY (program_id)
		REFERENCES programs_manager_schema.programs (program_id) MATCH SIMPLE
		ON UPDATE NO ACTION ON DELETE CASCADE,
	CONSTRAINT system_user_allowed_programs_sysuser_id_fkey FOREIGN KEY (sysuser_id)
		REFERENCES system_user_schema.system_users (sysuser_id) MATCH SIMPLE
		ON UPDATE NO ACTION ON DELETE CASCADE,
	CONSTRAINT system_user_allowed_programs_changed_by_user_login_fkey FOREIGN KEY (changed_by_user_login)
		REFERENCES system_user_schema.system_users (login) MATCH SIMPLE
		ON UPDATE NO ACTION ON DELETE NO ACTION
);
