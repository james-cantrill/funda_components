--  system_user_allowed_reports_history


DROP TABLE IF EXISTS report_manager_schema.system_user_allowed_reports_history;

CREATE TABLE report_manager_schema.system_user_allowed_reports_history (
	sysuser_id	uuid NOT NULL,
	login	text NOT NULL,
	report_id	uuid NOT NULL,
	report_name	text NOT NULL,
	report_viewable	boolean NOT NULL,
	datetime_report_viewable_change_started	timestamp without time zone NOT NULL,
	datetime_report_viewable_change_ended	timestamp without time zone NOT NULL,
	changing_user_login	text NOT NULL,
	change_type	text NOT NULL -- the change_type will be either update or delete
);
