

DROP TABLE IF EXISTS programs_manager_schema.organizations;

CREATE TABLE programs_manager_schema.organizations (
	organization_id	uuid NOT NULL DEFAULT gen_random_uuid() PRIMARY KEY,
	organization_name	text,
	organization_description	text,
	datetime_organization_changed	timestamp without time zone NOT NULL,
	changed_by_user_login	text NOT NULL,
    CONSTRAINT organization_name_duplicate UNIQUE(organization_name),
	CONSTRAINT organizations_changed_by_user_login_fkey FOREIGN KEY (changed_by_user_login)
		REFERENCES system_user_schema.system_users (login) MATCH SIMPLE
		ON UPDATE NO ACTION ON DELETE NO ACTION
);


