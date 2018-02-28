DROP TABLE IF EXISTS report_manager_schema.parameter_list CASCADE;

CREATE TABLE report_manager_schema.parameter_list (
	parameter_id	uuid NOT NULL DEFAULT gen_random_uuid() PRIMARY KEY,
	parameter_name	text NOT NULL UNIQUE,
	parameter_type	text NOT NULL,
	parameter_load_method	text NOT NULL,
	parameter_description	text NOT NULL,
	datetime_parameter_changed	timestamp without time zone NOT NULL,
	changing_user_login	text NOT NULL,
	CONSTRAINT parameter_list_changing_user_login_fkey FOREIGN KEY (changing_user_login)
		REFERENCES system_user_schema.system_users (login) MATCH SIMPLE
		ON UPDATE NO ACTION ON DELETE NO ACTION
);

