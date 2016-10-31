--  system_user_allowed_organizations


DROP TABLE IF EXISTS programs_manager_schema.system_user_allowed_organizations;

CREATE TABLE programs_manager_schema.system_user_allowed_organizations (
	sysuser_id	uuid NOT NULL,
	login	text NOT NULL,
	organization_id	text NOT NULL,
	organization_name	text NOT NULL,
	organization_visible	boolean NOT NULL,
	datetime_organization_visibility_changed	timestamp without time zone NOT NULL,
	changed_by_user_login	text NOT NULL,
	CONSTRAINT system_user_allowed_organizations_pkey PRIMARY KEY ( sysuser_id, organization_id),
	CONSTRAINT system_user_allowed_organizations_organization_id_fkey FOREIGN KEY (organization_id)
		REFERENCES programs_manager_schema.organizations (organization_id) MATCH SIMPLE
		ON UPDATE NO ACTION ON DELETE CASCADE,
	CONSTRAINT system_user_allowed_organizations_sysuser_id_fkey FOREIGN KEY (sysuser_id)
		REFERENCES system_user_schema.system_users (sysuser_id) MATCH SIMPLE
		ON UPDATE NO ACTION ON DELETE CASCADE,
	CONSTRAINT system_user_allowed_organizations_changed_by_user_login_fkey FOREIGN KEY (changed_by_user_login)
		REFERENCES system_user_schema.system_users (login) MATCH SIMPLE
		ON UPDATE NO ACTION ON DELETE NO ACTION
);
