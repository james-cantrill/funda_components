
DROP TABLE IF EXISTS report_manager_schema.report_folders CASCADE;

CREATE TABLE report_manager_schema.report_folders (
	folder_id	uuid NOT NULL DEFAULT gen_random_uuid() PRIMARY KEY,
	folder_name	text NOT NULL UNIQUE,
	folder_display_name	text NOT NULL UNIQUE,
	folder_description	text NOT NULL,
	parent_folder_name	text,
	is_root_folder	boolean,
	datetime_folder_changed	timestamp without time zone NOT NULL,
	changing_user_login	text NOT NULL,
	CONSTRAINT report_folders_parent_folder_name_fkey FOREIGN KEY (parent_folder_name)
		REFERENCES report_manager_schema.report_folders (folder_name) MATCH SIMPLE
		ON UPDATE NO ACTION ON DELETE CASCADE,
	CONSTRAINT report_folders_changing_user_login_fkey FOREIGN KEY (changing_user_login)
		REFERENCES system_user_schema.system_users (login) MATCH SIMPLE
		ON UPDATE NO ACTION ON DELETE NO ACTION
);
