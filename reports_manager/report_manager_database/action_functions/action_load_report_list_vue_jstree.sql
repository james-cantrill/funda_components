-- The function action_load_report_list_vue_jstree produces a list of all reports visible to a user in the json format used by the vue-jstree npm component.

--	_in_data:	{
--					login:
--				}
			
-- The json object returned by the function, _out_json, is defined  below.

--	_out_json:	{
--					result_indicator:
--					message:
--					data: 
--				};				

CREATE OR REPLACE FUNCTION report_manager_schema.action_load_report_list_vue_jstree (_in_data json) RETURNS json
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
		folder_entry_json	text
	);
	
	-- Determine if the requesting user is authorized
	_requesting_login := (SELECT _in_data ->> 'login')::text;
	
	_input_authorized_json :=	(SELECT json_build_object(
							'login', _requesting_login,
							'service', 'report_manager',
							'action', 'load_report_list'
							));
	
	_output_authorized_json := (SELECT * FROM system_user_schema.util_is_user_authorized (_input_authorized_json));

	_authorized_result := (SELECT _output_authorized_json ->> 'authorized')::boolean;
	
	IF _authorized_result  THEN

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
			'report'
		FROM	report_manager_schema.reports r,
				report_manager_schema.system_user_allowed_reports suap
		WHERE	r.report_id = suap.report_id
		  AND	suap.login = _requesting_login
		  AND	suap.report_viewable = TRUE
		;

		INSERT INTO report_entries (
				report_entry_json
				)
				SELECT
				row_to_json (reports_row)
			FROM (	SELECT 
						id,
						text,
						value,
						icon
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
			'folder',
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

		INSERT INTO folder_entries (
			folder_entry_json
			)
				SELECT
				row_to_json (folders_row)
			FROM (	SELECT *
					FROM	folder_report_list
			  ) folders_row
			; 

		 _data := (SELECT ARRAY (SELECT folder_entry_json FROM folder_entries) );
		--_data := (SELECT json_agg (folder_entry_json) FROM folder_entries );
		_message := 'Here are the reports. ' ;
		_out_json :=  (SELECT json_build_object(
							'result_indicator', 'Success',
							'message', _message,
							'data', _data
							));	
	ELSE	-- user isn't authorized to enter or edit reports
		_message := 'The user ' || _requesting_login || ' IS NOT Authorized to load or view reports.';
		_out_json :=  (SELECT json_build_object(
							'result_indicator', 'Failure',
							'message', _message,
							'data', ''
							));	

	END IF;
	RETURN _out_json;
	
	
END;
$$ LANGUAGE plpgsql;		