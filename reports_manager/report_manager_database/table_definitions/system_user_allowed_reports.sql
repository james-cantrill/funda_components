--  system_user_allowed_reports


DROP TABLE IF EXISTS report_manager_schema.system_user_allowed_reports;

CREATE TABLE report_manager_schema.system_user_allowed_reports (
	sysuser_id	uuid NOT NULL,
	login	text NOT NULL,
	report_id	uuid NOT NULL,
	report_name	text NOT NULL,
	report_viewable	boolean NOT NULL,
	datetime_report_viewable_changed	timestamp without time zone NOT NULL,
	changing_user_login	text NOT NULL,
	CONSTRAINT system_user_allowed_reports_pkey PRIMARY KEY (report_id, login, sysuser_id),
	CONSTRAINT system_user_allowed_reports_report_id_fkey FOREIGN KEY (report_id)
		REFERENCES report_manager_schema.reports (report_id) MATCH SIMPLE
		ON UPDATE NO ACTION ON DELETE CASCADE,
	CONSTRAINT system_user_allowed_reports_sysuser_id_fkey FOREIGN KEY (sysuser_id)
		REFERENCES system_user_schema.system_users (sysuser_id) MATCH SIMPLE
		ON UPDATE NO ACTION ON DELETE CASCADE
);
