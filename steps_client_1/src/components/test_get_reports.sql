
	DROP TABLE IF EXISTS allowed_enities;

	CREATE TEMPORARY TABLE allowed_enities
		entity_id	text,  -- report_id for reports and folder_name for folders
		parent_id	text,
		entity_json	json
	);

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
		children	json
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
	  AND	suap.login = 'opal'
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

--SELECT report_entry_json FROM report_entries;

--SELECT json_agg (SELECT ROW (report_entry_json) FROM report_entries);

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
		json_agg (re.report_entry_json)
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
		
	SELECT * FROM folder_entries;