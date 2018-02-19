-- organization_level_history.sql
DROP TABLE IF EXISTS programs_manager_schema.organization_level_history;

CREATE TABLE programs_manager_schema.organization_level_history (
	organization_level_id	uuid NOT NULL DEFAULT gen_random_uuid() PRIMARY KEY,
	organization_level_name	text NOT NULL UNIQUE,
	organization_level_display_name	text NOT NULL UNIQUE,
	organization_level_description	text,
	parent_level_id	uuid,
	is_root_level	boolean,
	organization_id	uuid, 
	datetime_level_changed 	timestamp without time zone NOT NULL,
	changing_user_login	text NOT NULL,
	datetime_user_change_started	timestamp without time zone NOT NULL,
	datetime_user_change_ended	timestamp without time zone NOT NULL,  
	change_type	text NOT NULL, -- the change_type will be either update or delete
	UNIQUE (organization_level_id, datetime_level_changed, changing_user_login)
);
