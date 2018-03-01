
DROP TABLE IF EXISTS report_manager_schema.reports CASCADE;

CREATE TABLE report_manager_schema.reports (
	report_id	uuid NOT NULL DEFAULT gen_random_uuid() PRIMARY KEY,
	report_name	text NOT NULL UNIQUE,
	description	text NOT NULL,
	url	text NOT NULL UNIQUE,
	containing_folder_name	text NOT NULL,
	datetime_report_added	timestamp without time zone NOT NULL,
	changing_user_login	text NOT NULL,
	CONSTRAINT reports_containing_folder_name_fkey FOREIGN KEY (containing_folder_name)
		REFERENCES report_manager_schema.report_folders (folder_name) MATCH SIMPLE
		ON UPDATE NO ACTION ON DELETE CASCADE,
	CONSTRAINT reports_changing_user_login_fkey FOREIGN KEY (changing_user_login)
		REFERENCES system_user_schema.system_users (login) MATCH SIMPLE
		ON UPDATE NO ACTION ON DELETE NO ACTION
);
