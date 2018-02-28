
DROP TABLE IF EXISTS report_manager_schema.report_parameters_history;

CREATE TABLE report_manager_schema.report_parameters_history (
	report_id uuid,
	report_name	text,
	parameter_id uuid,
	parameter_name	text,
	datetime_parameter_change_started	timestamp without time zone NOT NULL,
	datetime_parameter_change_ended	timestamp without time zone NOT NULL,
	changing_user_login	text NOT NULL,
	change_type	text NOT NULL -- the change_type will be either update or delete
);

