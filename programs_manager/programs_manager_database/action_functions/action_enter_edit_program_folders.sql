/* The function action_enter_edit_program_folders inserts or updates a record in the program_folders table


	_in_data:	{								
					program_folder_id:
					program_folder_name:
					program_folder_display_name:
					program_folder_description:
					parent_folder_name:  
					is_root_folder:	-- boolean
					changing_user_login:
				}
			
* The json object returned by the function, _out_json, is defined  below.

	_out_json:	{
					result_indicator:
					message:
					program_folder_id:
					program_folder_name:
					program_folder_display_name:
					program_folder_description:
					parent_folder_name:
					changing_user_login:
				}
				

*/

CREATE OR REPLACE FUNCTION programs_manager_schema.action_enter_edit_program_folders (_in_data json) RETURNS json
AS $$

DECLARE
		
	_out_json json;
	_message	text;
	_program_folder_id	uuid;
	_program_folder_id2	uuid;

	_program_folder_name	text;
	_program_folder_display_name	text;
	_program_folder_description	text;
	_changing_user_login	text;
	

	_parent_folder_id	uuid;
	_parent_folder_name	text;
	_parent_folder_exists	boolean;
	_is_root	boolean ;
	_num_roots	integer;
	_program_folder_id_submitted	boolean;
	
--	for calling the system_user_schema.util_is_user_authorized function to determine if the calling user is authorized to add new users
	_calling_login	text;
	_input_authorized_json	json;	-- input json
	_output_authorized_json	json;	-- output json  
	_authorized_result	boolean;
	
	_insert_update_or_error	text;
	
BEGIN

	-- Determine if the calling user is authorized
	_calling_login := (SELECT _in_data ->> 'changing_user_login')::text;
	
	_input_authorized_json :=	(SELECT json_build_object(
							'login', _calling_login,
							'service', 'programs_manager',
							'action', 'enter_edit_program_folders'
							));
	
	_output_authorized_json := (SELECT * FROM system_user_schema.util_is_user_authorized (_input_authorized_json));
	
	_authorized_result := (SELECT _output_authorized_json ->> 'authorized')::boolean;
	
	IF _authorized_result  THEN
	
		-- check that the parent folder exists
		_parent_folder_name := (SELECT _in_data ->> 'parent_folder_name')::text;
		_is_root := (SELECT _in_data ->> 'is_root_folder')::BOOLEAN;

		IF _parent_folder_name IS NOT NULL AND NOT _is_root THEN

			_parent_folder_id :=	(SELECT
										program_folder_id
									FROM	programs_manager_schema.program_folders
									WHERE	program_folder_name = _parent_folder_name 
									);

			IF _parent_folder_id IS NOT NULL THEN
				_parent_folder_exists := TRUE;
			ELSE
				_parent_folder_exists := FALSE;
			END IF;

		ELSIF _is_root THEN	--  this is a root folder
				_parent_folder_exists := TRUE; 
		ELSE	-- there is no parent folder name
				_parent_folder_exists := FALSE;
		END IF;
--
		--does a folder with that name exist, if it doesn't insert the data
		-- if it does update the record
		-- was a program_folder_id included in the _in_data indicating that this is an update
		_program_folder_id := (SELECT _in_data ->> 'program_folder_id')::uuid;
						
		IF _program_folder_id IS NOT NULL THEN -- a program_folder_id was submitted
			-- does the program_folder_id define an actual record to update
			_program_folder_id_submitted := TRUE;
			_program_folder_name := (	SELECT
									program_folder_name
								FROM	programs_manager_schema.program_folders
								WHERE	program_folder_id = _program_folder_id
								);

			IF _program_folder_name IS NOT NULL THEN -- a record exists update it
				_insert_update_or_error := 'update';
				_program_folder_id2 := _program_folder_id;
			ELSE	-- no existing record corresponds to the submitted program_folder_id so return an error message
				_insert_update_or_error := 'error';			
			END IF;
			
		ELSE	-- a program_folder_id wasn't submitted in the in_data json		
			--	check if a record with the submitted program_folder_name exists, if it does update it
			_program_folder_id_submitted := FALSE;
			_program_folder_id := (	SELECT
								program_folder_id
							FROM	programs_manager_schema.program_folders
							WHERE	program_folder_name = (SELECT _in_data ->> 'program_folder_name')::text
							);
							
			IF _program_folder_id IS NOT NULL THEN	-- a record exists,update it
				_insert_update_or_error := 'update';
				_program_folder_id2 := _program_folder_id;				
			ELSE	-- no record exists, insert one using the in_data
				_insert_update_or_error := 'insert';
			END IF;
						
		END IF;	-- IF _program_folder_id IS NOT NULL
		
		IF _insert_update_or_error = 'update' THEN

			IF _parent_folder_exists THEN

				IF NOT _program_folder_id_submitted THEN
					_program_folder_name := (SELECT _in_data ->> 'program_folder_name')::text;
				END IF;
				
				UPDATE	programs_manager_schema.program_folders
				   SET	parent_folder_name = (SELECT _in_data ->> 'parent_folder_name')::text,
						program_folder_name = _program_folder_name,
						program_folder_display_name = (SELECT _in_data ->> 'program_folder_display_name')::text,
						program_folder_description = (SELECT _in_data ->> 'program_folder_description')::text,
						is_root_folder = (SELECT _in_data ->> 'is_root_folder')::BOOLEAN,
						datetime_folder_changed = LOCALTIMESTAMP (0),
						changing_user_login = (SELECT _in_data ->> 'changing_user_login')::text
				WHERE	program_folder_id = _program_folder_id2
				;
				
				_message := 'The folder named ' || _program_folder_name || ' has been updated.';
				
				_out_json :=  (SELECT json_build_object(
									'result_indicator', 'Succees',
									'message', _message,
									'program_folder_id', _program_folder_id2,
									'program_folder_name', (SELECT _in_data ->> 'program_folder_name')::text,
									'program_folder_display_name', (SELECT _in_data ->> 'program_folder_display_name')::text,
									'program_folder_description',  (SELECT _in_data ->> 'program_folder_description')::text,
									'parent_folder_name', (SELECT _in_data ->> 'parent_folder_name')::text,
									'changing_user_login', _calling_login
									));				

			ELSE

				_message := 'The parent folder of the folder named ' || (SELECT _in_data ->> 'program_folder_name')::text || ' DOES NOT EXIST. Nothing was updated';
				
				_out_json :=  (SELECT json_build_object(
									'result_indicator', 'Failure',
									'message', _message,
									'program_folder_id', _program_folder_id2,
									'program_folder_name', (SELECT _in_data ->> 'program_folder_name')::text,
									'program_folder_display_name', (SELECT _in_data ->> 'program_folder_display_name')::text,
									'program_folder_description',  (SELECT _in_data ->> 'program_folder_description')::text,
									'parent_folder_name', (SELECT _in_data ->> 'parent_folder_name')::text,
									'changing_user_login', _calling_login
									));				
			END IF;

		ELSIF _insert_update_or_error = 'insert' THEN
			IF _parent_folder_exists THEN

				-- if this is an insert for a root folder make sure one doesn't already exist
				_num_roots :=	(SELECT 
									COUNT (program_folder_name) 
								FROM	programs_manager_schema.program_folders
								 WHERE	is_root_folder 
								);

				IF _parent_folder_name IS NULL AND _num_roots > 0 THEN -- a root folder aready exists we can't insert it
									
					_message := 'The folder named ' || (SELECT _in_data ->> 'program_folder_name')::text || ' is a root folder and a root folder already exists. Nothing was inserted';
					
					_out_json :=  (SELECT json_build_object(
										'result_indicator', 'Failure',
										'message', _message,
										'program_folder_id', _program_folder_id,
										'program_folder_name', (SELECT _in_data ->> 'program_folder_name')::text,
										'program_folder_display_name', (SELECT _in_data ->> 'program_folder_display_name')::text,
										'program_folder_description',  (SELECT _in_data ->> 'program_folder_description')::text,
										'parent_folder_name', (SELECT _in_data ->> 'parent_folder_name')::text,
										'changing_user_login', _calling_login
										));				

				ELSE

					INSERT INTO programs_manager_schema.program_folders (
						parent_folder_name,
						program_folder_name,
						program_folder_display_name,
						program_folder_description,
						is_root_folder,
						datetime_folder_changed,
						changing_user_login
						)
					VALUES (
						(SELECT _in_data ->> 'parent_folder_name')::text,
						(SELECT _in_data ->> 'program_folder_name')::text,
						(SELECT _in_data ->> 'program_folder_display_name')::text,
						(SELECT _in_data ->> 'program_folder_description')::text,
						(SELECT _in_data ->> 'is_root_folder')::BOOLEAN,
						LOCALTIMESTAMP (0),
						(SELECT _in_data ->> 'changing_user_login')::text
					);				

					_program_folder_id := (	SELECT
										program_folder_id
									FROM	programs_manager_schema.program_folders
									WHERE	program_folder_name = (SELECT _in_data ->> 'program_folder_name')::text
									);	
									
					_message := 'The folder named ' || (SELECT _in_data ->> 'program_folder_name')::text || ' has been added.';
					
					_out_json :=  (SELECT json_build_object(
										'result_indicator', 'Success',
										'message', _message,
										'program_folder_id', _program_folder_id,
										'program_folder_name', (SELECT _in_data ->> 'program_folder_name')::text,
										'program_folder_display_name', (SELECT _in_data ->> 'program_folder_display_name')::text,
										'program_folder_description',  (SELECT _in_data ->> 'program_folder_description')::text,
										'parent_folder_name', (SELECT _in_data ->> 'parent_folder_name')::text,
										'changing_user_login', _calling_login
										));				
				END IF;

			ELSE	-- the parent folder doesn't exist so we can't insert it
				_message := 'The parent folder of the folder named ' || (SELECT _in_data ->> 'program_folder_name')::text || ' DOES NOT EXIST. Nothing was inserted';
				
				_out_json :=  (SELECT json_build_object(
									'result_indicator', 'Success',
									'message', _message,
									'program_folder_id', _program_folder_id,
									'program_folder_name', (SELECT _in_data ->> 'program_folder_name')::text,
									'program_folder_display_name', (SELECT _in_data ->> 'program_folder_display_name')::text,
									'program_folder_description',  (SELECT _in_data ->> 'program_folder_description')::text,
									'parent_folder_name', (SELECT _in_data ->> 'parent_folder_name')::text,
									'changing_user_login', _calling_login
									));				
			END IF;
		ELSIF	_insert_update_or_error = 'error' THEN
							
		_message := 'No folder with the program_folder_id ' || (SELECT _in_data ->> 'program_folder_id')::text || ' was found. No record was updated';
		
		_out_json :=  (SELECT json_build_object(
							'result_indicator', 'Failure',
							'message', _message,
							'program_folder_id', (SELECT _in_data ->> 'program_folder_id')::text,
							'program_folder_name', (SELECT _in_data ->> 'program_folder_name')::text,
							'program_folder_display_name', (SELECT _in_data ->> 'program_folder_display_name')::text,
							'program_folder_description',  (SELECT _in_data ->> 'program_folder_description')::text,
							'parent_folder_name', (SELECT _in_data ->> 'parent_folder_name')::text,
							'changing_user_login', _calling_login
							));			
		END IF;
		
	ELSE	-- user isn't authorized to enter or edit folders
	
		_message := 'The user ' || _calling_login || ' IS NOT Authorized to en ter or edit report folders. Nothng was changed.';
		
		_out_json :=  (SELECT json_build_object(
							'result_indicator', 'Failure',
							'message', _message,
							'program_folder_name', (SELECT _in_data ->> 'program_folder_name')::text,
							'program_folder_display_name', (SELECT _in_data ->> 'program_folder_display_name')::text,
							'program_folder_description',  (SELECT _in_data ->> 'program_folder_description')::text,
							'parent_folder_name', (SELECT _in_data ->> 'parent_folder_name')::text,
							'changing_user_login', _calling_login
							));	
	END IF;	--IF _authorized_result 
	
	

	RETURN _out_json;
	
	
END;
$$ LANGUAGE plpgsql;		