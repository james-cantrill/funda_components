--  system_user_allowed_programs_history


DROP TABLE IF EXISTS programs_manager_schema.system_user_allowed_programs_history;

CREATE TABLE programs_manager_schema.system_user_allowed_programs_history (
	sysuser_id	uuid NOT NULL,
	login	text NOT NULL,
	program_id	uuid NOT NULL,
	program_name	text NOT NULL,
	program_accessible	boolean NOT NULL,
	datetime_program_accessible_started	timestamp without time zone NOT NULL,
	datetime_program_accessible_ended	timestamp without time zone NOT NULL,
	changed_by_user_login	text NOT NULL,
	change_type	text NOT NULL -- the change_type will be either update or delete
);
