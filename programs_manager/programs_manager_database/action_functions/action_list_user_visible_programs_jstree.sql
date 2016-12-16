-- The action_list_user_visible_programs_jstree  produces
-- a list of all programs visible to a user in the json format used by the
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
--					}]
--				};
				

CREATE OR REPLACE FUNCTION programs_manager_schema.action_list_user_visible_programs_jstree (_in_data json) RETURNS json
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

	DROP TABLE IF EXISTS allowed_programs_data;

	CREATE TEMPORARY TABLE allowed_programs_data (
		node_type	text,	
		id	text,
		parent	text,
		text	text,
		icon	text
	);	

	DROP TABLE IF EXISTS json_list_data;

	CREATE TEMPORARY TABLE json_list_data (
		json_entry	text
	);
	
	_requesting_login := ((SELECT _in_data ->> 'login')::text);
	
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
	
		_integer_var := (SELECT * FROM programs_manager_schema.pop_allowed_programs (_requesting_login));
	
		INSERT INTO json_list_data (
			json_entry
			)
		SELECT
			row_to_json (program_row)
		FROM (	SELECT DISTINCT
					id,
					CASE	WHEN parent IS NULL THEN '#'
							ELSE parent
					END,
					text,
					CASE	WHEN icon IS NULL AND node_type = 'Program' THEN 'jstree-file'
							ELSE icon
					END
				FROM	allowed_programs_data
		  ) program_row
		;
		
		_data := (SELECT ARRAY (SELECT json_entry FROM json_list_data ));

 
		_message := 'Here are the programs. ' ;
		
		_out_json :=  (SELECT json_build_object(
							'result_indicator', 'Success',
							'message', _message,
							'data', _data
							));	
	
	ELSE	-- user isn't authorized to enter or edit reports
	
		_message := 'The user ' || _requesting_login || ' IS NOT Authorized to view data from the systems programs.';
		
		_out_json :=  (SELECT json_build_object(
							'result_indicator', 'Failure',
							'message', _message,
							'data', ''
							));	

	END IF;	
	RETURN _out_json;
	
	
END;
$$ LANGUAGE plpgsql;		