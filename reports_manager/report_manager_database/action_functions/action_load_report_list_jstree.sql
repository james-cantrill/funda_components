-- The function report_manager_schema.action_load_report_list_jstree produces
-- a list of all reports visible to a user in the json format used by the
-- jQujery widget jsTree
-- Alternative format of the node (id & parent are required)
-- {
--   id          : "string" // required
--   parent      : "string" // required
--   text        : "string" // node text
--   icon        : "string" // string for custom
--   state       : {
--     opened    : boolean  // is the node open
--     disabled  : boolean  // is the node disabled
--     selected  : boolean  // is the node selected
--   },
--   li_attr     : {}  // attributes for the generated LI node
--   a_attr      : {}  // attributes for the generated A node
-- }

-- Alternative format example
-- $('#using_json_2').jstree({ 'core' : {
--     'data' : [
--        { "id" : "ajson1", "parent" : "#", "text" : "Simple root node" },
--        { "id" : "ajson2", "parent" : "#", "text" : "Root node 2" },
--        { "id" : "ajson3", "parent" : "ajson2", "text" : "Child 1" },
--        { "id" : "ajson4", "parent" : "ajson2", "text" : "Child 2" },
--     ]
-- } });

--	_in_data:	{
--					login:
--				}
			
-- The json object returned by the function, _out_json, is defined  below.

--	_out_json:	{
--					result_indicator:
--					message:
--					data: [{
--								id:	for folders reportfolders.folder_name for reports reports.report_id
--								parent:	for folders report_folders.parent_folder_name or "#" for root, for reports reports.containing_folder_name
--								text:	for folders reportfolders.folder_display_name for reports reports.report_name
--								description	-- for folders reportfolders.folder_description for reports reports.description
--					}]
--				};
				

CREATE OR REPLACE FUNCTION report_manager_schema.action_load_report_list_jstree (_in_data json) RETURNS json
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

	DROP TABLE IF EXISTS allowed_reports_out_data;

	CREATE TEMPORARY TABLE allowed_reports_out_data (
		node_type	text,	
		id	text,
		parent	text,
		text	text,
		data	json,
		icon	text
	);	

	DROP TABLE IF EXISTS json_list_data;

	CREATE TEMPORARY TABLE json_list_data (
		json_entry	text
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

		_integer_var := (SELECT * FROM report_manager_schema.pop_allowed_reports_out_data (_requesting_login));
	
		INSERT INTO json_list_data (
			json_entry
			)
		SELECT
			row_to_json (reports_row)
		FROM (	SELECT 
					id,
					CASE	WHEN parent IS NULL THEN '#'
							ELSE parent
					END,
					text,
					data,
					CASE	WHEN icon IS NULL AND node_type = 'Report' THEN 'jstree-file'
							ELSE icon
					END
				FROM	allowed_reports_out_data
		  ) reports_row
		;
		
		_data := (SELECT ARRAY (SELECT json_entry FROM json_list_data ));
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