
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

SELECT
	r.containing_folder_name,
	r.report_id::text,
	json_agg (re.report_entry_json) AS children
FROM	report_manager_schema.reports r,
		report_entries re
WHERE	(re.report_entry_json ->> 'id')::text = r.report_id::text
GROUP BY r.containing_folder_name
;

