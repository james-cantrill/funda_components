-- The function pop_allowed_programs populates the temporary table

-- 	CREATE TEMPORARY TABLE allowed_programs_data (
--		node_type	text,	-- level or program
--		id	text,	-- for folders reportfolders.organization_level_name for programs programs.program_id
--		parent	text,	--for folders report_folders.parent_level_name or "#" for root, for reports reports.containing_level_name
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
		containing_level_name	text	
	);

	DROP TABLE IF EXISTS containing_levels;

	CREATE TEMPORARY TABLE containing_levels (
		organization_level_name	text,
		parent_level_name	text,
		organization_level_display_name	text
	);
	
	INSERT INTO  allowed_programs (
		program_id,
		program_name,
		containing_level_name
		)
	SELECT DISTINCT
		p.program_id,
		p.program_name,
		p.containing_level_name
	FROM	programs_manager_schema.programs p,
			programs_manager_schema.system_user_allowed_programs suap
	WHERE	p.program_id = suap.program_id
	  AND	suap.login = _login
	;
	
/*	INSERT INTO containing_levels (
		organization_level_name,
		parent_level_name,
		organization_level_display_name
		)
	SELECT DISTINCT
		organization_level_name,
		'#',
		organization_level_display_name
	FROM	programs_manager_schema.organization_level
	WHERE	is_root_level = TRUE
	;
*/
	INSERT INTO containing_levels (
		organization_level_name,
		parent_level_name,
		organization_level_display_name
		)
	SELECT DISTINCT
		pf.organization_level_name,
		pf.parent_level_name,
		pf.organization_level_display_name
	FROM	programs_manager_schema.organization_level pf,
			allowed_programs ap
	WHERE	ap.containing_level_name = pf.organization_level_name
	;

	INSERT INTO containing_levels (
		organization_level_name,
		parent_level_name,
		organization_level_display_name
		)
	SELECT DISTINCT
		pf.organization_level_name,
		pf.parent_level_name,
		pf.organization_level_display_name
	FROM	programs_manager_schema.organization_level pf,
			containing_levels cf
	WHERE	cf.parent_level_name = pf.organization_level_name
	;

	INSERT INTO allowed_programs_data (
		node_type,
		id,
		parent,
		text
		)
	SELECT DISTINCT
		'Folder',
		organization_level_name,
		CASE	WHEN parent_level_name IS NULL THEN '#' ELSE parent_level_name END,
		organization_level_display_name
	FROM	containing_levels
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
		containing_level_name,
		program_name
	FROM	allowed_programs
	;
	

	_integer_var := (SELECT COUNT(*) FROM allowed_programs_data);
	RAISE NOTICE 'rows = %', _integer_var;

	RETURN _integer_var;
	
	
END;

$$ LANGUAGE plpgsql;		