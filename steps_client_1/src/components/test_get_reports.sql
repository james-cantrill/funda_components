

	DROP TABLE IF EXISTS allowed_reports;

	CREATE TEMPORARY TABLE allowed_reports (
		id	text,
		text	text,  -- report name
		value	text,
		icon	text
	);

	DROP TABLE IF EXISTS report_entries;
	
	CREATE TEMPORARY TABLE report_entries (
		report_entry_json	json
	);
	
	DROP TABLE IF EXISTS folder_report_list;

	CREATE TEMPORARY TABLE folder_report_list (
		id	text,
		text	text,  -- report name
		value	text,
		icon	text,
		children	json []
	);

	DROP TABLE IF EXISTS folder_entries;
	
	CREATE TEMPORARY TABLE folder_entries (
		folder_entry_json	json
	);
	
	INSERT INTO allowed_reports (
		id,
		text,
		value,
		icon
		)
	SELECT 
		r.report_id::text,
		r.report_name,
		r.description,
		'jstree-file'
	FROM	report_manager_schema.reports r,
			report_manager_schema.system_user_allowed_reports suap
	WHERE	r.report_id = suap.report_id
	  AND	suap.login = 'muser'
	  AND	suap.report_viewable = TRUE
	;


	INSERT INTO report_entries (
			report_entry_json
			)
			SELECT
			row_to_json (reports_row)
		FROM (	SELECT *
				FROM	allowed_reports
		  ) reports_row
		; 

	INSERT INTO folder_report_list (
		id,
		text,  
		value,
		icon,
		children
		)
	SELECT
		rf.folder_name,
		rf.folder_display_name,
		rf.folder_description,
		'',
		array_agg (re.report_entry_json)
	FROM	report_manager_schema.report_folders rf,
			report_manager_schema.reports r,
			report_entries re
	WHERE	(re.report_entry_json ->> 'id')::text = r.report_id::text
	  AND	r.containing_folder_name = rf.folder_name
	GROUP BY
		rf.folder_name,
		rf.folder_display_name,
		rf.folder_description
	;

--	SELECT * FROM folder_report_list;
	
	INSERT INTO folder_entries (
		folder_entry_json
		)
			SELECT
			row_to_json (folders_row)
		FROM (	SELECT *
				FROM	folder_report_list
		  ) folders_row
		; 
		
	SELECT json_agg (folder_entry_json) FROM folder_entries;

/*	SELECT DISTINCT
		rf.parent_folder_name,
		rf.folder_name AS child_folder
	FROM	allowed_reports ar,
			report_manager_schema.reports r,
			report_manager_schema.report_folders rf
	WHERE	ar.id = r.report_id::text
	  AND	r.containing_folder_name = rf.folder_name
	;

	SELECT DISTINCT
		parent_folder_name,
		folder_name AS child_folder
	FROM	report_manager_schema.report_folders 
	WHERE	folder_name IN (SELECT parent_folder_name 
								FROM report_manager_schema.report_folders rf,
									allowed_reports ar,
									report_manager_schema.reports r
								WHERE	ar.id = r.report_id::text
								  AND	r.containing_folder_name = rf.folder_name
								)
	  AND	parent_folder_name IS NOT NULL
	;
*/