
 -- organizations_history.sql
DROP TABLE IF EXISTS programs_manager_schema.organizations_history;

CREATE TABLE programs_manager_schema.organizations_history (
	organization_id	uuid NOT NULL,
	organization_name	text NOT NULL,
	organization_description	text NOT NULL,
	datetime_organization_changed	timestamp without time zone NOT NULL,
	changing_user_login	text NOT NULL,
	datetime_organization_change_started	timestamp without time zone NOT NULL,
	datetime_organization_change_ended	timestamp without time zone NOT NULL,   
	change_type	text NOT NULL -- the change_type will be either update or delete
);


