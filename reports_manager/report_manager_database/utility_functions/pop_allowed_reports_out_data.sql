-- The function pop_allowed_reports_out_data populates the temporary table

-- 	CREATE TEMPORARY TABLE allowed_reports_out_data (
--		node_type	text,	-- folder or report
--		id	text,	-- for folders reportfolders.folder_name for reports reports.report_id
--		parent	text,	--for folders report_folders.parent_folder_name or "#" for root, for reports reports.containing_folder_name
--		text	text, 	-- for folders reportfolders.folder_display_name for reports reports.report_name
--		data	json	-- for folders reportfolders.folder_description for reports reports.description
--	);	


CREATE OR REPLACE FUNCTION report_manager_schema.pop_allowed_reports_out_data (_login text) RETURNS integer
AS $$

DECLARE

	_integer_var integer;
	
	
BEGIN

	DROP TABLE IF EXISTS report_descriptions;

	CREATE TEMPORARY TABLE report_descriptions (
		description_json	json
	);

	DROP TABLE IF EXISTS folder_descriptions;

	CREATE TEMPORARY TABLE folder_descriptions (
		description_json	json
	);

	DROP TABLE IF EXISTS allowed_reports;

	CREATE TEMPORARY TABLE allowed_reports (
		report_id	uuid,
		report_name	text,
		containing_folder_name	text,
		adntnl_data	text	
	);

	DROP TABLE IF EXISTS containing_folders;

	CREATE TEMPORARY TABLE containing_folders (
		folder_name	text,
		parent_folder_name	text,
		folder_display_name	text,
		adntnl_data	text
	);

	INSERT INTO report_descriptions (
		description_json
		)
	SELECT
		row_to_json (description_row)
	FROM	(SELECT 
				description
			FROM	report_manager_schema.reports
			) description_row
	;
	
	INSERT INTO  allowed_reports (
		report_id,
		report_name,
		containing_folder_name,
		adntnl_data
		)
	SELECT DISTINCT
		r.report_id,
		r.report_name,
		r.containing_folder_name,
		rd.description_json::text
	FROM	report_manager_schema.reports r,
			report_manager_schema.system_user_allowed_reports suap,
			report_descriptions rd
	WHERE	r.report_id = suap.report_id
	  AND	suap.login = _login
	  AND	(rd.description_json ->> 'description')::text = r.description
	;
	
	INSERT INTO folder_descriptions (
		description_json
		)
	SELECT
		row_to_json (description_row)
	FROM	(SELECT 
				folder_description AS description
			FROM	report_manager_schema.report_folders
			) description_row
	;		
		
	INSERT INTO containing_folders (
		folder_name,
		parent_folder_name,
		folder_display_name,
		adntnl_data
		)
	SELECT DISTINCT
		rf.folder_name,
		rf.parent_folder_name,
		rf.folder_display_name,
		fd.description_json::text
	FROM	report_manager_schema.report_folders rf,
			allowed_reports ar,
			folder_descriptions fd
	WHERE	ar.containing_folder_name = rf.folder_name
	  AND	(fd.description_json ->> 'description')::text = rf.folder_description
	;
		
	
	INSERT INTO containing_folders (
		folder_name,
		parent_folder_name,
		folder_display_name,
		adntnl_data
		)
	SELECT DISTINCT
		rf.folder_name,
		rf.parent_folder_name,
		rf.folder_display_name,
		fd.description_json::text
	FROM	report_manager_schema.report_folders rf,
			containing_folders cf,
			folder_descriptions fd
	WHERE	cf.parent_folder_name = rf.folder_name
	  AND	(fd.description_json ->> 'description')::text = rf.folder_description
	;

	INSERT INTO allowed_reports_out_data (
		node_type,
		id,
		parent,
		text,
		data
		)
	SELECT 
		'Folder',
		folder_name,
		parent_folder_name,
		folder_display_name,
		CAST (adntnl_data AS json)
	FROM	containing_folders
	;

	INSERT INTO allowed_reports_out_data (
		node_type,
		id,
		parent,
		text,
		data
		)
	SELECT 
		'Report',
		report_id::text,
		containing_folder_name,
		report_name,
		CAST (adntnl_data AS json)
	FROM	allowed_reports
	;
	
	_integer_var := (SELECT COUNT(*) FROM allowed_reports_out_data);
	RAISE NOTICE 'rows = %', _integer_var;

	RETURN _integer_var;
	
	
END;

$$ LANGUAGE plpgsql;		