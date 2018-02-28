
DROP TABLE IF EXISTS report_manager_schema.reports_history;

CREATE TABLE report_manager_schema.reports_history (
	report_id	uuid NOT NULL,
	report_name	text NOT NULL,
	description	text NOT NULL,
	url	text NOT NULL,
	containing_folder_name	text NOT NULL,
	datetime_report_change_started	timestamp without time zone NOT NULL,
	datetime_report_change_ended	timestamp without time zone NOT NULL,
	changing_user_login	text NOT NULL,
	change_type	text NOT NULL -- the change_type will be either update or delete
);
