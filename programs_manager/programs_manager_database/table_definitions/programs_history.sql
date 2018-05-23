
DROP TABLE  IF EXISTS programs_manager_schema.programs_history;

CREATE TABLE programs_manager_schema.programs_history (
	program_id	uuid NOT NULL,
	program_name	text NOT NULL,
	program_description 	text,
	other_program_id	text,
	organization_id	uuid NOT NULL,
	containing_organization_level_id	uuid,
	datetime_program_changed	timestamp without time zone NOT NULL,
	changing_user_login	text NOT NULL,
	datetime_user_change_started	timestamp without time zone NOT NULL,
	datetime_user_change_ended	timestamp without time zone NOT NULL, 
	change_type	text NOT NULL -- the change_type will be either update or delete
);





