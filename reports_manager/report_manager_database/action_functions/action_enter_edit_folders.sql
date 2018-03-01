/* The function action_enter_edit_folders inserts or updates a record in the report_folders table


	_in_data:	
	{								
		folder_id:
		folder_name:
		folder_display_name:
		description:
		parent_folder_name:  
		is_root_folder:	-- boolean
		changing_user_login:
		enter_or_update:
	}
			
* The json object returned by the function, _out_json, is defined  below.

	_out_json:	{
					result_indicator:
					message:
					folder_id:
					folder_name:
					folder_display_name:
					description:
					parent_folder_name:
					changing_user_login:
				}
				
Refactor plans:

missing input data
		folder_id: can be null for enter, but can't be null for update
		folder_name: can't be NULL
		folder_display_name:	can't be NULL
		description:	can't be NULL
		parent_folder_name:	can't be NULL if is_root_folder is FALSE
		is_root_folder:	-- boolean	can't be NULL
		changing_user_login:	can't be NULL
		enter_or_update:	can't be NULL
		
		
Is the calling user authorized?

Does the parent folder exist?

For enter is folder name unique

For update 
	does folder exist
	name conflict between folder name from id and name in json
	
*/

CREATE OR REPLACE FUNCTION report_manager_schema.action_enter_edit_folders (_in_data json) RETURNS json
AS $$

DECLARE
		
	_out_json json;
	_message	text;
	
	_folder_id	uuid;
	_parent_folder_id	uuid;

	_folder_name_from_id	text;
	_folder_display_name	text;
	_description	text;
	_changing_user_login	text;

	
--	for calling the system_user_schema.util_is_user_authorized function to determine if the calling user is authorized to add new users
	_calling_login	text;
	_input_authorized_json	json;	-- input json
	_output_authorized_json	json;	-- output json  
	_authorized_result	boolean;
	
	_insert_update_or_error	text;
	
BEGIN

---------- Determine if the calling user is authorized -----------------------
	_calling_login := (SELECT _in_data ->> 'changing_user_login')::text;
	
	_input_authorized_json :=	(SELECT json_build_object(
							'login', _calling_login,
							'service', 'report_manager',
							'action', 'enter_edit_folders'
							));
	
	_output_authorized_json := (SELECT * FROM system_user_schema.util_is_user_authorized (_input_authorized_json));
	
	_authorized_result := (SELECT _output_authorized_json ->> 'authorized')::boolean;
	
--------- Does the parent folder exist? --------------------------------------
	_parent_folder_id :=	(SELECT
								folder_id
							FROM	report_manager_schema.report_folders
							WHERE	folder_name = (SELECT _in_data ->> 'parent_folder_name')::text 
							);

------------------------------------------------------------------------------
	IF (SELECT (SELECT _in_data ->> 'folder_name')::text IS NULL 
			OR (SELECT _in_data ->> 'folder_display_name')::text IS NULL 
			OR (SELECT _in_data ->> 'description')::text IS NULL
			OR (SELECT _in_data ->> 'is_root_folder')::text IS NULL 
			OR (  (SELECT _in_data ->> 'is_root_folder')::BOOLEAN = FALSE
			      AND (SELECT _in_data ->> 'parent_folder_name')::text IS NULL 
			    )
			OR (SELECT _in_data ->> 'changed_by_user_login')::text IS NULL  
			OR (SELECT _in_data ->> 'enter_or_update')::text IS NULL  
			OR (	(SELECT _in_data ->> 'enter_or_update')::text = 'Update'
					AND (SELECT _in_data ->> 'folder_id')::text IS NULL 
				))
		THEN -- data is incomplete
		
			_message := (SELECT 'The data is incomplete as submitted so the folder CAN NOT be entered or edited, please resubmit with complete data.');
			
			_out_json :=  (SELECT json_build_object(
								'result_indicator', 'Failure',
								'message', _message,
								'folder_id', (SELECT _in_data ->> 'folder_id')::text,
								'folder_name', (SELECT _in_data ->> 'folder_name')::text,
								'folder_display_name', (SELECT _in_data ->> 'folder_display_name')::text,
								'description',  (SELECT _in_data ->> 'description')::text,
								'parent_folder_name', (SELECT _in_data ->> 'parent_folder_name')::text,
								'changing_user_login', (SELECT _in_data ->> 'changing_user_login')::text,
								'enter_or_update', (SELECT _in_data ->> 'enter_or_update')::text
								));		
							
	ELSIF  NOT _authorized_result  THEN
		_message := 'The user ' || _calling_login || ' IS NOT Authorized to enter or edit report folders. Nothng was changed.';
		
		_out_json :=  (SELECT json_build_object(
							'result_indicator', 'Failure',
							'message', _message,
							'folder_id', (SELECT _in_data ->> 'folder_id')::text,
							'folder_name', (SELECT _in_data ->> 'folder_name')::text,
							'folder_display_name', (SELECT _in_data ->> 'folder_display_name')::text,
							'description',  (SELECT _in_data ->> 'description')::text,
							'parent_folder_name', (SELECT _in_data ->> 'parent_folder_name')::text,
							'changing_user_login', (SELECT _in_data ->> 'changing_user_login')::text,
							'enter_or_update', (SELECT _in_data ->> 'enter_or_update')::text
							));		
							
	ELSIF	(SELECT _in_data ->> 'is_root_folder')::BOOLEAN = FALSE AND _parent_folder_id IS NULL THEN    -- parent folder does not exist
	
		_message := (SELECT 'The specified parent folder, ' || (SELECT _in_data ->> 'folder_name')::text || ', does not exist so the folder CAN NOT be entered.');
		_out_json :=  (SELECT json_build_object(
							'result_indicator', 'Failure',
							'message', _message,
							'folder_id', (SELECT _in_data ->> 'folder_id')::text,
							'folder_name', (SELECT _in_data ->> 'folder_name')::text,
							'folder_display_name', (SELECT _in_data ->> 'folder_display_name')::text,
							'description',  (SELECT _in_data ->> 'description')::text,
							'parent_folder_name', (SELECT _in_data ->> 'parent_folder_name')::text,
							'changing_user_login', (SELECT _in_data ->> 'changing_user_login')::text,
							'enter_or_update', (SELECT _in_data ->> 'enter_or_update')::text
							));		
							
	ELSE	-- proceed with enter or update
	
		IF (SELECT _in_data ->> 'enter_or_update')::text = 'Enter' THEN
		
			-- For enter is folder name unique--------------------------------
			_folder_id :=	(SELECT
								folder_id
							FROM	report_manager_schema.report_folders
							WHERE	folder_name = (SELECT _in_data ->> 'folder_name')::text 
							);
			
			IF _folder_id IS NOT NULL THEN    -- folder already exists
			
				_message := (SELECT 'The submitted folder name, ' || (SELECT _in_data ->> 'folder_name')::text || ', already exists, please choose another.') ;
				_out_json :=  (SELECT json_build_object(
							'result_indicator', 'Failure',
							'message', _message,
							'folder_id', (SELECT _in_data ->> 'folder_id')::text,
							'folder_name', (SELECT _in_data ->> 'folder_name')::text,
							'folder_display_name', (SELECT _in_data ->> 'folder_display_name')::text,
							'description',  (SELECT _in_data ->> 'description')::text,
							'parent_folder_name', (SELECT _in_data ->> 'parent_folder_name')::text,
							'changing_user_login', (SELECT _in_data ->> 'changing_user_login')::text,
							'enter_or_update', (SELECT _in_data ->> 'enter_or_update')::text
							));		
			ELSE
			
				INSERT INTO report_manager_schema.report_folders (
					folder_name,
					folder_display_name,
					folder_description,
					parent_folder_name,
					is_root_folder,
					datetime_folder_changed,
					changing_user_login
					)
				VALUES (
					(SELECT _in_data ->> 'folder_name')::text,
					(SELECT _in_data ->> 'folder_display_name')::text,
					(SELECT _in_data ->> 'description')::text,
					(SELECT _in_data ->> 'parent_folder_name')::text,
					(SELECT _in_data ->> 'is_root_folder')::BOOLEAN,
					LOCALTIMESTAMP (0),
					(SELECT _in_data ->> 'changing_user_login')::text
				);				

				_folder_id := (	SELECT
									folder_id
								FROM	report_manager_schema.report_folders
								WHERE	folder_name = (SELECT _in_data ->> 'folder_name')::text
								);	
								
				_message := 'The folder named ' || (SELECT _in_data ->> 'folder_name')::text || ' has been added.';
				_out_json :=  (SELECT json_build_object(
							'result_indicator', 'Failure',
							'message', _message,
							'folder_id', (SELECT _in_data ->> 'folder_id')::text,
							'folder_name', (SELECT _in_data ->> 'folder_name')::text,
							'folder_display_name', (SELECT _in_data ->> 'folder_display_name')::text,
							'description',  (SELECT _in_data ->> 'description')::text,
							'parent_folder_name', (SELECT _in_data ->> 'parent_folder_name')::text,
							'changing_user_login', (SELECT _in_data ->> 'changing_user_login')::text,
							'enter_or_update', (SELECT _in_data ->> 'enter_or_update')::text
							));						
			
			END IF;
			
		ELSIF (SELECT _in_data ->> 'enter_or_update')::text = 'Update' 
		
			_folder_name_from_id := (	SELECT
									folder_name 
								FROM	report_manager_schema.report_folders
								WHERE	folder_id = (SELECT _in_data ->> 'folder_id')::text
								);	

			IF _folder_name_from_id IS NULL THEN	-- folder does not exist
			
				_message := (SELECT  'No folder with the folder_id ' || (SELECT _in_data ->> 'folder_id')::text || ' exists  so this update CAN NOT be completed, please resubmit with different data.') ;
				_out_json :=  (SELECT json_build_object(
							'result_indicator', 'Failure',
							'message', _message,
							'folder_id', (SELECT _in_data ->> 'folder_id')::text,
							'folder_name', (SELECT _in_data ->> 'folder_name')::text,
							'folder_display_name', (SELECT _in_data ->> 'folder_display_name')::text,
							'description',  (SELECT _in_data ->> 'description')::text,
							'parent_folder_name', (SELECT _in_data ->> 'parent_folder_name')::text,
							'changing_user_login', (SELECT _in_data ->> 'changing_user_login')::text,
							'enter_or_update', (SELECT _in_data ->> 'enter_or_update')::text
							));	
							
			ELSE
			
				UPDATE	report_manager_schema.report_folders
				   SET	parent_folder_name = (SELECT _in_data ->> 'parent_folder_name')::text,
						folder_name = (SELECT _in_data ->> 'folder_name')::text,
						folder_display_name = (SELECT _in_data ->> 'folder_display_name')::text,
						folder_description = (SELECT _in_data ->> 'description')::text,
						is_root_folder = (SELECT _in_data ->> 'is_root_folder')::BOOLEAN,
						datetime_folder_changed = LOCALTIMESTAMP (0),
						changing_user_login = (SELECT _in_data ->> 'changing_user_login')::text
				WHERE	folder_id = (SELECT _in_data ->> 'folder_id')::uuid
				;
				
			END IF;

		ELSE    --  enter_or_update has an invalid value
		
			_message := (SELECT 'The input parameter enter_or_update has an invalid value, ' || (SELECT _in_data ->> 'enter_or_update')::text || ', nothing can be done.');

			_out_json :=  (SELECT json_build_object(
								'result_indicator', 'Failure',
								'message', _message,
								'folder_id', (SELECT _in_data ->> 'folder_id')::text,
								'folder_name', (SELECT _in_data ->> 'folder_name')::text,
								'folder_display_name', (SELECT _in_data ->> 'folder_display_name')::text,
								'description',  (SELECT _in_data ->> 'description')::text,
								'parent_folder_name', (SELECT _in_data ->> 'parent_folder_name')::text,
								'changing_user_login', (SELECT _in_data ->> 'changing_user_login')::text,
								'enter_or_update', (SELECT _in_data ->> 'enter_or_update')::text
								));		
							
		END IF;
	END IF;

	RETURN _out_json;
	
	
END;
$$ LANGUAGE plpgsql;		