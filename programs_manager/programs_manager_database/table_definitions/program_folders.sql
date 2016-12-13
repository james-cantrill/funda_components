
DROP TABLE IF EXISTS programs_manager_schema.program_folders CASCADE;

CREATE TABLE programs_manager_schema.program_folders (
	program_folder_id	uuid NOT NULL DEFAULT gen_random_uuid() PRIMARY KEY,
	program_folder_name	text NOT NULL UNIQUE,
	program_folder_display_name	text NOT NULL UNIQUE,
	program_folder_description	text,
	parent_folder_name	text,
	is_root_folder	boolean,
	datetime_folder_changed	timestamp without time zone NOT NULL,
	changing_user_login	text NOT NULL,
	CONSTRAINT program_folders_parent_folder_name_fkey FOREIGN KEY (parent_folder_name)
		REFERENCES programs_manager_schema.program_folders (program_folder_name) MATCH SIMPLE
		ON UPDATE NO ACTION ON DELETE CASCADE,
	CONSTRAINT program_folders_changing_user_login_fkey FOREIGN KEY (changing_user_login)
		REFERENCES system_user_schema.system_users (login) MATCH SIMPLE
		ON UPDATE NO ACTION ON DELETE NO ACTION
);
