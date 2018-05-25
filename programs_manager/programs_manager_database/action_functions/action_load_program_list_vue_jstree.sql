-- The function action_load_program_list_vue_jstree produces a list of all programs visible to a user in the json format used by the vue-jstree npm component.

--	_in_data:	{
--					login:
--				}
			
-- The json object returned by the function, _out_json, is defined  below.

--	_out_json:	{
--					result_indicator:
--					message:
--					data: 
--				};				

CREATE OR REPLACE FUNCTION programs_manager_schema.action_load_program_list_vue_jstree (_in_data json) RETURNS json
AS $$

DECLARE
		
	_integer_var	integer;
	
	_out_json json;
	_message	text;
	
	_requesting_login	text;
	_input_authorized_json	json;
	_output_authorized_json	json;
	_authorized_result	boolean;
	
	_data	json[];
	
BEGIN

	DROP TABLE IF EXISTS allowed_programs;

	CREATE TEMPORARY TABLE allowed_programs (
		id	text,
		text	text,  -- report name
		value	text,
		icon	text
	);

	DROP TABLE IF EXISTS program_entries;
	
	CREATE TEMPORARY TABLE program_entries (
		program_entry_json	json
	);
	
	DROP TABLE IF EXISTS organization_program_list;

	CREATE TEMPORARY TABLE organization_program_list (
		id	text,
		text	text,  -- report name
		value	text,
		icon	text,
		children	json []
	);

	DROP TABLE IF EXISTS organization_entries;
	
	CREATE TEMPORARY TABLE organization_entries (
		organization_entry_json	text
	);
	
	-- Determine if the requesting user is authorized
	_requesting_login := (SELECT _in_data ->> 'login')::text;
	
	_input_authorized_json :=	(SELECT json_build_object(
							'login', _requesting_login,
							'service', 'programs_manager',
							'action', 'list_user_visible_programs'
							));
	
	_output_authorized_json := (SELECT * FROM system_user_schema.util_is_user_authorized (_input_authorized_json));

	_authorized_result := (SELECT _output_authorized_json ->> 'authorized')::boolean;
	
	IF _authorized_result  THEN

		INSERT INTO allowed_programs (
			id,
			text,
			value,
			icon
			)
		SELECT 
			p.other_program_id,
			p.program_name,
			p.program_description,
			'program'
		FROM	programs_manager_schema.programs p,
				programs_manager_schema.system_user_allowed_programs suap
		WHERE	p.program_id = suap.program_id
		  AND	suap.login = _requesting_login
		  AND	suap.program_accessible = TRUE
		;

		INSERT INTO program_entries (
				program_entry_json
				)
				SELECT
				row_to_json (programs_row)
			FROM (	SELECT 
						id,
						text,
						value,
						icon
					FROM	allowed_programs
			  ) programs_row
			; 

		INSERT INTO organization_program_list (
			id,
			text,  
			value,
			icon,
			children
			)
		SELECT
			org.organization_name,
			org.organization_name,
			org.organization_description,
			'organization',
			array_agg (pe.program_entry_json)
		FROM	programs_manager_schema.organizations org,
				programs_manager_schema.programs p,
				program_entries pe
		WHERE	(pe.program_entry_json ->> 'id')::text = p.other_program_id
		  AND	p.organization_id = org.organization_id
		GROUP BY
			org.organization_name,
			org.organization_description
		;

		INSERT INTO organization_entries (
			organization_entry_json
			)
				SELECT
				row_to_json (organizations_row)
			FROM (	SELECT *
					FROM	organization_program_list
			  ) organizations_row
			; 

		 _data := (SELECT ARRAY (SELECT organization_entry_json FROM organization_entries) );
		--_data := (SELECT json_agg (folder_entry_json) FROM folder_entries );
		_message := 'Here are the reports. ' ;
		_out_json :=  (SELECT json_build_object(
							'result_indicator', 'Success',
							'message', _message,
							'data', _data
							));	
	ELSE	-- user isn't authorized to enter or edit reports
		_message := 'The user ' || _requesting_login || ' IS NOT Authorized to view programs.';
		_out_json :=  (SELECT json_build_object(
							'result_indicator', 'Failure',
							'message', _message,
							'data', ''
							));	

	END IF;
	RETURN _out_json;
	
	
END;
$$ LANGUAGE plpgsql;		