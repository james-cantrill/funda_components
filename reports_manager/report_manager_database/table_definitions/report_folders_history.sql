-- report_folders_history

DROP TABLE IF EXISTS report_manager_schema.report_folders_history;

CREATE TABLE report_manager_schema.report_folders_history (
	folder_id	uuid NOT NULL,
	folder_name	text NOT NULL,
	folder_display_name	text NOT NULL,
	folder_description	text NOT NULL,
	parent_folder_name	text NOT NULL,
	datetime_folder_change_started	timestamp without time zone NOT NULL,
	datetime_folder_change_ended	timestamp without time zone NOT NULL,
	changing_user_login	text NOT NULL,
	change_type	text NOT NULL -- the change_type will be either update or delete
);
