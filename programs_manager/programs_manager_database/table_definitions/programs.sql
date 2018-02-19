
DROP TABLE IF EXISTS programs_manager_schema.programs;

CREATE TABLE programs_manager_schema.programs (
	program_id	uuid NOT NULL DEFAULT gen_random_uuid() PRIMARY KEY,
	program_name	text NOT NULL,
	program_description 	text,
	organization_id	uuid NOT NULL,
	containing_organization_level_id	uuid NOT NULL,
	datetime_program_changed	timestamp without time zone NOT NULL,
	changing_user_login	text NOT NULL,
    CONSTRAINT program_name_duplicate UNIQUE(program_name),
	CONSTRAINT programs_organization_id_fkey FOREIGN KEY (organization_id)
		REFERENCES programs_manager_schema.organizations (organization_id) MATCH SIMPLE
		ON UPDATE NO ACTION ON DELETE CASCADE,
	CONSTRAINT programs_containing_organization_level_id_fkey FOREIGN KEY (containing_organization_level_id)
		REFERENCES programs_manager_schema.organization_level (organization_level_id) MATCH SIMPLE
		ON UPDATE NO ACTION ON DELETE CASCADE,
	CONSTRAINT programs_changing_user_login_fkey FOREIGN KEY (changing_user_login)
		REFERENCES system_user_schema.system_users (login) MATCH SIMPLE
		ON UPDATE NO ACTION ON DELETE NO ACTION
);





