-- The function pop_allowed_programs populates the temporary table

-- 	CREATE TEMPORARY TABLE allowed_programs_data (
--		node_type	text,	-- folder or program
--		id	text,	-- for folders reportfolders.program_folder_name for programs programs.program_id
--		parent	text,	--for folders report_folders.parent_folder_name or "#" for root, for reports reports.containing_folder_name
--		text	text	-- for folders reportfolders.folder_display_name for programs programs.program_name
--	);	

CREATE OR REPLACE FUNCTION programs_manager_schema.pop_allowed_programs (_login text) RETURNS integer
AS $$

DECLARE

	_integer_var integer;
	
	
BEGIN

	DROP TABLE IF EXISTS allowed_programs;

	CREATE TEMPORARY TABLE allowed_programs (
		program_id	integer,
		program_name	text,
		containing_folder_name	text	
	);

	DROP TABLE IF EXISTS containing_folders;

	CREATE TEMPORARY TABLE containing_folders (
		program_folder_name	text,
		parent_folder_name	text,
		program_folder_display_name	text
	);
	
	INSERT INTO  allowed_programs (
		program_id,
		program_name,
		containing_folder_name
		)
	SELECT DISTINCT
		p.program_id,
		p.program_name,
		p.containing_folder_name
	FROM	programs_manager_schema.programs p,
			programs_manager_schema.system_user_allowed_programs suap
	WHERE	p.program_id = suap.program_id
	  AND	suap.login = _login
	;
	
/*	INSERT INTO containing_folders (
		program_folder_name,
		parent_folder_name,
		program_folder_display_name
		)
	SELECT DISTINCT
		program_folder_name,
		'#',
		program_folder_display_name
	FROM	programs_manager_schema.program_folders
	WHERE	is_root_folder = TRUE
	;
*/
	INSERT INTO containing_folders (
		program_folder_name,
		parent_folder_name,
		program_folder_display_name
		)
	SELECT DISTINCT
		pf.program_folder_name,
		pf.parent_folder_name,
		pf.program_folder_display_name
	FROM	programs_manager_schema.program_folders pf,
			allowed_programs ap
	WHERE	ap.containing_folder_name = pf.program_folder_name
	;

	INSERT INTO containing_folders (
		program_folder_name,
		parent_folder_name,
		program_folder_display_name
		)
	SELECT DISTINCT
		pf.program_folder_name,
		pf.parent_folder_name,
		pf.program_folder_display_name
	FROM	programs_manager_schema.program_folders pf,
			containing_folders cf
	WHERE	cf.parent_folder_name = pf.program_folder_name
	;

	INSERT INTO allowed_programs_data (
		node_type,
		id,
		parent,
		text
		)
	SELECT DISTINCT
		'Folder',
		program_folder_name,
		CASE	WHEN parent_folder_name IS NULL THEN '#' ELSE parent_folder_name END,
		program_folder_display_name
	FROM	containing_folders
	;
	
	INSERT INTO allowed_programs_data (
		node_type,
		id,
		parent,
		text
		)
	SELECT DISTINCT
		'Program',
		program_id::text,
		containing_folder_name,
		program_name
	FROM	allowed_programs
	;
	

	_integer_var := (SELECT COUNT(*) FROM allowed_programs_data);
	RAISE NOTICE 'rows = %', _integer_var;

	RETURN _integer_var;
	
	
END;

$$ LANGUAGE plpgsql;		