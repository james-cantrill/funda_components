
DROP TABLE IF EXISTS programs_manager_schema.organization_level CASCADE;

CREATE TABLE programs_manager_schema.organization_level (
	organization_level_id	uuid NOT NULL DEFAULT gen_random_uuid() PRIMARY KEY,
	organization_level_name	text NOT NULL UNIQUE,
	organization_level_display_name	text NOT NULL UNIQUE,
	organization_level_description	text,
	parent_level_name	text,
	is_root_level	boolean,
	datetime_level_changed 	timestamp without time zone NOT NULL,
	changing_user_login	text NOT NULL,
	CONSTRAINT organization_level_parent_level_name_fkey FOREIGN KEY (parent_level_name)
		REFERENCES programs_manager_schema.organization_level (organization_level_name) MATCH SIMPLE
		ON UPDATE NO ACTION ON DELETE CASCADE,
	CONSTRAINT organization_level_changing_user_login_fkey FOREIGN KEY (changing_user_login)
		REFERENCES system_user_schema.system_users (login) MATCH SIMPLE
		ON UPDATE NO ACTION ON DELETE NO ACTION
);
