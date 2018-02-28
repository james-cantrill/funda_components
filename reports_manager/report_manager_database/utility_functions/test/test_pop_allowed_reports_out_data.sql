-- test_pop_allowed_reports_out_data


CREATE TEMPORARY TABLE allowed_reports_out_data (
	node_type	text,	-- folder or report
	id	text,	-- for folders reportfolders.folder_name for reports reports.report_id
	parent	text,	--for folders report_folders.parent_folder_name or "#" for root, for reports reports.containing_folder_name
	text	text,	-- for folders reportfolders.folder_display_name for reports reports.report_name
	data	text,
	icon	text
);	

SELECT * FROM report_manager_schema.pop_allowed_reports_out_data ('jappl');

SELECT * FROM allowed_reports_out_data;

TRUNCATE TABLE allowed_reports_out_data;

SELECT * FROM report_manager_schema.pop_allowed_reports_out_data ('opal');

SELECT * FROM allowed_reports_out_data;

TRUNCATE TABLE allowed_reports_out_data;

