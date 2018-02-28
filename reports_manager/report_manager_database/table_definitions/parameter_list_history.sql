DROP TABLE IF EXISTS report_manager_schema.parameter_list_history;

CREATE TABLE report_manager_schema.parameter_list_history (
	parameter_id	uuid NOT NULL,
	parameter_name	text NOT NULL,
	parameter_type	text NOT NULL,
	parameter_load_method	text NOT NULL,
	parameter_description	text NOT NULL,
	datetime_parameter_change_started	timestamp without time zone NOT NULL,
	datetime_parameter_change_ended	timestamp without time zone NOT NULL,
	changing_user_login	text NOT NULL,
	change_type	text NOT NULL -- the change_type will be either update or delete
);

