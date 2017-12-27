/* The function action_enter_edit_organization_level inserts or updates a record in the organization_level table


	_in_data:	{								
					organization_level_id:
					organization_level_name:
					organization_level_display_name:
					organization_level_description:
					parent_level_name:  
					is_root_level:	-- boolean
					changing_user_login:
				}
			
* The json object returned by the function, _out_json, is defined  below.

	_out_json:	{
					result_indicator:
					message:
					organization_level_id:
					organization_level_name:
					organization_level_display_name:
					organization_level_description:
					parent_level_name:
					changing_user_login:
				}
				

*/

CREATE OR REPLACE FUNCTION programs_manager_schema.action_enter_edit_organization_level (_in_data json) RETURNS json
AS $$

DECLARE
		
	_out_json json;
	_message	text;
	_organization_level_id	uuid;
	_organization_level_id2	uuid;

	_organization_level_name	text;
	_organization_level_display_name	text;
	_organization_level_description	text;
	_changing_user_login	text;
	

	_parent_level_id	uuid;
	_parent_level_name	text;
	_parent_level_exists	boolean;
	_is_root	boolean ;
	_num_roots	integer;
	_organization_level_id_submitted	boolean;
	
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
							'action', 'enter_edit_organization_level'
							));
	
	_output_authorized_json := (SELECT * FROM system_user_schema.util_is_user_authorized (_input_authorized_json));
	
	_authorized_result := (SELECT _output_authorized_json ->> 'authorized')::boolean;
	
	IF _authorized_result  THEN
	
		-- check that the parent level exists
		_parent_level_name := (SELECT _in_data ->> 'parent_level_name')::text;
		_is_root := (SELECT _in_data ->> 'is_root_level')::BOOLEAN;

		IF _parent_level_name IS NOT NULL AND NOT _is_root THEN

			_parent_level_id :=	(SELECT
										organization_level_id
									FROM	programs_manager_schema.organization_level
									WHERE	organization_level_name = _parent_level_name 
									);

			IF _parent_level_id IS NOT NULL THEN
				_parent_level_exists := TRUE;
			ELSE
				_parent_level_exists := FALSE;
			END IF;

		ELSIF _is_root THEN	--  this is a root folder
				_parent_level_exists := TRUE; 
		ELSE	-- there is no parent level name
				_parent_level_exists := FALSE;
		END IF;
--
		--does a level with that name exist, if it doesn't insert the data
		-- if it does update the record
		-- was a organization_level_id included in the _in_data indicating that this is an update
		_organization_level_id := (SELECT _in_data ->> 'organization_level_id')::uuid;
						
		IF _organization_level_id IS NOT NULL THEN -- a organization_level_id was submitted
			-- does the organization_level_id define an actual record to update
			_organization_level_id_submitted := TRUE;
			_organization_level_name := (	SELECT
									organization_level_name
								FROM	programs_manager_schema.organization_level
								WHERE	organization_level_id = _organization_level_id
								);

			IF _organization_level_name IS NOT NULL THEN -- a record exists update it
				_insert_update_or_error := 'update';
				_organization_level_id2 := _organization_level_id;
			ELSE	-- no existing record corresponds to the submitted organization_level_id so return an error message
				_insert_update_or_error := 'error';			
			END IF;
			
		ELSE	-- a organization_level_id wasn't submitted in the in_data json		
			--	check if a record with the submitted organization_level_name exists, if it does update it
			_organization_level_id_submitted := FALSE;
			_organization_level_id := (	SELECT
								organization_level_id
							FROM	programs_manager_schema.organization_level
							WHERE	organization_level_name = (SELECT _in_data ->> 'organization_level_name')::text
							);
							
			IF _organization_level_id IS NOT NULL THEN	-- a record exists,update it
				_insert_update_or_error := 'update';
				_organization_level_id2 := _organization_level_id;				
			ELSE	-- no record exists, insert one using the in_data
				_insert_update_or_error := 'insert';
			END IF;
						
		END IF;	-- IF _organization_level_id IS NOT NULL
		
		IF _insert_update_or_error = 'update' THEN

			IF _parent_level_exists THEN

				IF NOT _organization_level_id_submitted THEN
					_organization_level_name := (SELECT _in_data ->> 'organization_level_name')::text;
				END IF;
				
				UPDATE	programs_manager_schema.organization_level
				   SET	parent_level_name = (SELECT _in_data ->> 'parent_level_name')::text,
						organization_level_name = _organization_level_name,
						organization_level_display_name = (SELECT _in_data ->> 'organization_level_display_name')::text,
						organization_level_description = (SELECT _in_data ->> 'organization_level_description')::text,
						is_root_level = (SELECT _in_data ->> 'is_root_level')::BOOLEAN,
						datetime_level_changed  = LOCALTIMESTAMP (0),
						changing_user_login = (SELECT _in_data ->> 'changing_user_login')::text
				WHERE	organization_level_id = _organization_level_id2
				;
				
				_message := 'The level named ' || _organization_level_name || ' has been updated.';
				
				_out_json :=  (SELECT json_build_object(
									'result_indicator', 'Succees',
									'message', _message,
									'organization_level_id', _organization_level_id2,
									'organization_level_name', (SELECT _in_data ->> 'organization_level_name')::text,
									'organization_level_display_name', (SELECT _in_data ->> 'organization_level_display_name')::text,
									'organization_level_description',  (SELECT _in_data ->> 'organization_level_description')::text,
									'parent_level_name', (SELECT _in_data ->> 'parent_level_name')::text,
									'changing_user_login', _calling_login
									));				

			ELSE

				_message := 'The parent level of the level named ' || (SELECT _in_data ->> 'organization_level_name')::text || ' DOES NOT EXIST. Nothing was updated';
				
				_out_json :=  (SELECT json_build_object(
									'result_indicator', 'Failure',
									'message', _message,
									'organization_level_id', _organization_level_id2,
									'organization_level_name', (SELECT _in_data ->> 'organization_level_name')::text,
									'organization_level_display_name', (SELECT _in_data ->> 'organization_level_display_name')::text,
									'organization_level_description',  (SELECT _in_data ->> 'organization_level_description')::text,
									'parent_level_name', (SELECT _in_data ->> 'parent_level_name')::text,
									'changing_user_login', _calling_login
									));				
			END IF;

		ELSIF _insert_update_or_error = 'insert' THEN
			IF _parent_level_exists THEN

				-- if this is an insert for a root level make sure one doesn't already exist
				_num_roots :=	(SELECT 
									COUNT (organization_level_name) 
								FROM	programs_manager_schema.organization_level
								 WHERE	is_root_level 
								);

				IF _parent_level_name IS NULL AND _num_roots > 0 THEN -- a root level aready exists we can't insert it
									
					_message := 'The level named ' || (SELECT _in_data ->> 'organization_level_name')::text || ' is a root level and a root level already exists. Nothing was inserted';
					
					_out_json :=  (SELECT json_build_object(
										'result_indicator', 'Failure',
										'message', _message,
										'organization_level_id', _organization_level_id,
										'organization_level_name', (SELECT _in_data ->> 'organization_level_name')::text,
										'organization_level_display_name', (SELECT _in_data ->> 'organization_level_display_name')::text,
										'organization_level_description',  (SELECT _in_data ->> 'organization_level_description')::text,
										'parent_level_name', (SELECT _in_data ->> 'parent_level_name')::text,
										'changing_user_login', _calling_login
										));				

				ELSE

					INSERT INTO programs_manager_schema.organization_level (
						parent_level_name,
						organization_level_name,
						organization_level_display_name,
						organization_level_description,
						is_root_level,
						datetime_level_changed ,
						changing_user_login
						)
					VALUES (
						(SELECT _in_data ->> 'parent_level_name')::text,
						(SELECT _in_data ->> 'organization_level_name')::text,
						(SELECT _in_data ->> 'organization_level_display_name')::text,
						(SELECT _in_data ->> 'organization_level_description')::text,
						(SELECT _in_data ->> 'is_root_level')::BOOLEAN,
						LOCALTIMESTAMP (0),
						(SELECT _in_data ->> 'changing_user_login')::text
					);				

					_organization_level_id := (	SELECT
										organization_level_id
									FROM	programs_manager_schema.organization_level
									WHERE	organization_level_name = (SELECT _in_data ->> 'organization_level_name')::text
									);	
									
					_message := 'The level named ' || (SELECT _in_data ->> 'organization_level_name')::text || ' has been added.';
					
					_out_json :=  (SELECT json_build_object(
										'result_indicator', 'Success',
										'message', _message,
										'organization_level_id', _organization_level_id,
										'organization_level_name', (SELECT _in_data ->> 'organization_level_name')::text,
										'organization_level_display_name', (SELECT _in_data ->> 'organization_level_display_name')::text,
										'organization_level_description',  (SELECT _in_data ->> 'organization_level_description')::text,
										'parent_level_name', (SELECT _in_data ->> 'parent_level_name')::text,
										'changing_user_login', _calling_login
										));				
				END IF;

			ELSE	-- the parent level doesn't exist so we can't insert it
				_message := 'The parent level of the level named ' || (SELECT _in_data ->> 'organization_level_name')::text || ' DOES NOT EXIST. Nothing was inserted';
				
				_out_json :=  (SELECT json_build_object(
									'result_indicator', 'Success',
									'message', _message,
									'organization_level_id', _organization_level_id,
									'organization_level_name', (SELECT _in_data ->> 'organization_level_name')::text,
									'organization_level_display_name', (SELECT _in_data ->> 'organization_level_display_name')::text,
									'organization_level_description',  (SELECT _in_data ->> 'organization_level_description')::text,
									'parent_level_name', (SELECT _in_data ->> 'parent_level_name')::text,
									'changing_user_login', _calling_login
									));				
			END IF;
		ELSIF	_insert_update_or_error = 'error' THEN
							
		_message := 'No level with the organization_level_id ' || (SELECT _in_data ->> 'organization_level_id')::text || ' was found. No record was updated';
		
		_out_json :=  (SELECT json_build_object(
							'result_indicator', 'Failure',
							'message', _message,
							'organization_level_id', (SELECT _in_data ->> 'organization_level_id')::text,
							'organization_level_name', (SELECT _in_data ->> 'organization_level_name')::text,
							'organization_level_display_name', (SELECT _in_data ->> 'organization_level_display_name')::text,
							'organization_level_description',  (SELECT _in_data ->> 'organization_level_description')::text,
							'parent_level_name', (SELECT _in_data ->> 'parent_level_name')::text,
							'changing_user_login', _calling_login
							));			
		END IF;
		
	ELSE	-- user isn't authorized to enter or edit folders
	
		_message := 'The user ' || _calling_login || ' IS NOT Authorized to en ter or edit report folders. Nothng was changed.';
		
		_out_json :=  (SELECT json_build_object(
							'result_indicator', 'Failure',
							'message', _message,
							'organization_level_name', (SELECT _in_data ->> 'organization_level_name')::text,
							'organization_level_display_name', (SELECT _in_data ->> 'organization_level_display_name')::text,
							'organization_level_description',  (SELECT _in_data ->> 'organization_level_description')::text,
							'parent_level_name', (SELECT _in_data ->> 'parent_level_name')::text,
							'changing_user_login', _calling_login
							));	
	END IF;	--IF _authorized_result 
	
	

	RETURN _out_json;
	
	
END;
$$ LANGUAGE plpgsql;		