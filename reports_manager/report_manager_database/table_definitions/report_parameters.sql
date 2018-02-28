
DROP TABLE IF EXISTS report_manager_schema.report_parameters;

CREATE TABLE report_manager_schema.report_parameters (
	report_id uuid,
	parameter_id uuid,
	datetime_parameter_added	timestamp without time zone NOT NULL,
	changing_user_login	text NOT NULL,
	CONSTRAINT report_parameters_pkey PRIMARY KEY (report_id, parameter_id),
	CONSTRAINT report_parameters_parameter_id_fkey FOREIGN KEY (parameter_id)
		REFERENCES report_manager_schema.parameter_list (parameter_id) MATCH SIMPLE
		ON UPDATE NO ACTION ON DELETE CASCADE,
	CONSTRAINT report_parameters_report_id_fkey FOREIGN KEY (report_id)
		REFERENCES report_manager_schema.reports (report_id) MATCH SIMPLE
		ON UPDATE NO ACTION ON DELETE CASCADE
);

