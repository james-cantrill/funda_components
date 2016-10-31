
DROP TABLE programs_manager_schema.programs;

CREATE TABLE programs_manager_schema.programs (
	program_id	integer NOT NULL PRIMARY KEY,
	program_name	text,
	organization_id	text,
	coc_code	text  NOT NULL,
	datetime_program_changed	timestamp without time zone NOT NULL,
	changed_by_user_login	text NOT NULL,
    CONSTRAINT program_name_duplicate UNIQUE(program_name),
	CONSTRAINT programs_organization_id_fkey FOREIGN KEY (organization_id)
		REFERENCES programs_manager_schema.organizations (organization_id) MATCH SIMPLE
		ON UPDATE NO ACTION ON DELETE CASCADE,
	CONSTRAINT programs_coc_code_fkey FOREIGN KEY (coc_code)
		REFERENCES programs_manager_schema.continua (coc_code) MATCH SIMPLE
		ON UPDATE NO ACTION ON DELETE NO ACTION,
	CONSTRAINT programs_changed_by_user_login_fkey FOREIGN KEY (changed_by_user_login)
		REFERENCES system_user_schema.system_users (login) MATCH SIMPLE
		ON UPDATE NO ACTION ON DELETE NO ACTION
);





