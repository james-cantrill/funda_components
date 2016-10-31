--  system_user_allowed_organizations_history


DROP TABLE IF EXISTS programs_manager_schema.system_user_allowed_organizations_history;

CREATE TABLE programs_manager_schema.system_user_allowed_organizations_history (
	sysuser_id	uuid NOT NULL,
	login	text NOT NULL,
	organization_id	text NOT NULL,
	organization_name	text NOT NULL,
	organization_visible	boolean NOT NULL,
	datetime_organization_visibility_started	timestamp without time zone NOT NULL,
	datetime_organization_visibility_ended	timestamp without time zone NOT NULL,
	changed_by_user_login	text NOT NULL,
	change_type	text NOT NULL -- the change_type will be either update or delete
);
