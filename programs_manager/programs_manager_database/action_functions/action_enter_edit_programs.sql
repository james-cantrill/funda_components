-- The function action_enter_edit_programs inserts or updates a record in the programs_manager_schema.programs table
--
--	_in_data:	{								
--					program_id:
--					program_name:
--					organization_id:
--					coc_code:
--					containing_level_name:
--					changed_by_user_login:
--				}
			
-- The json object returned by the function, _out_json, is defined  below.

--	_out_json:	{
--					result_indicator:
--					message:
--					program_id:
--					program_name:
--					organization_id:
--					coc_code:
--					containing_level_name:
--					changed_by_user_login:
--				}


CREATE OR REPLACE FUNCTION programs_manager_schema.action_enter_edit_programs (_in_data json) RETURNS json
AS $$

DECLARE
	_integer_var	integer;
	_out_json json;
	_message	text;
	
	_insert_or_update	text;
	_existing_program_name	text;
	_program_name_unique	boolean;
	_program_id	integer;
	_old_program_name	text;
	_program_name_updateable	boolean;
	
	_containing_level_id	uuid;
	_containing_level_exists	boolean;
	_old_containing_level_name	text;
	_containing_level_name_updateable	boolean;
	
	
	
--	for calling the system_user_schema.util_is_user_authorized function to determine if the calling user is authorized to add new users
	_calling_login	text;
	_input_authorized_json	json;	-- input json
	_output_authorized_json	json;	-- output json  
	_authorized_result	boolean;	

BEGIN

	-- Determine if the calling user is authorized
	_calling_login := (SELECT _in_data ->> 'changed_by_user_login')::text;
	
	_input_authorized_json :=	(SELECT json_build_object(
							'login', _calling_login,
							'service', 'programs_manager',
							'action', 'enter_edit_programs'
							));
	
	_output_authorized_json := (SELECT * FROM system_user_schema.util_is_user_authorized (_input_authorized_json));
	
	_authorized_result := (SELECT _output_authorized_json ->> 'authorized')::boolean;
	
	IF _authorized_result  THEN
	
		-- check if the submitted data is complete
		IF (SELECT _in_data ->> 'program_id')::text IS NULL OR (SELECT _in_data ->> 'program_name')::text IS NULL OR (SELECT _in_data ->> 'organization_id')::text IS NULL OR (SELECT _in_data ->> 'coc_code')::text IS NULL OR (SELECT _in_data ->> 'containing_level_name')::text IS NULL OR (SELECT _in_data ->> 'changed_by_user_login')::text IS NULL THEN -- data is incomplete
		
			_message := (SELECT 'The data is incomplete as submitted so the report CAN NOT be entered or edited, please resubmit with complete data.') ;
			_out_json :=  (SELECT json_build_object(
								'result_indicator', 'Failure',
								'message', _message,
								'program_id', (SELECT _in_data ->> 'program_id')::text,
								'program_name', (SELECT _in_data ->> 'program_name')::text,
								'organization_id', (SELECT _in_data ->> 'organization_id')::text,
								'coc_code', (SELECT _in_data ->> 'coc_code')::text,
								'containing_level_name', (SELECT _in_data ->> 'containing_level_name')::text,
								'changed_by_user_login', (SELECT _in_data ->> 'changed_by_user_login')::text
								));		
								
		ELSE	--data is complete so we proceed
		
			-- does the program exist, if so update it or else insert it
			_existing_program_name :=	(SELECT
											program_name
										FROM	programs_manager_schema.programs
										WHERE	program_id = (SELECT _in_data ->> 'program_id')::integer
										);

			IF _existing_program_name IS NULL THEN
				_insert_or_update := 'insert';
			ELSE
				_insert_or_update := 'update';
			END IF;
			
			-- does the containing level exist
			_containing_level_id :=	(SELECT
						organization_level_id
					FROM	programs_manager_schema.organization_level
					WHERE	organization_level_name = (SELECT _in_data ->> 'containing_level_name')::text 
					);
			IF _containing_level_id IS NULL THEN
				_containing_level_exists := FALSE;
			ELSE
				_containing_level_exists := TRUE;
			END IF;
			
			-- is the program name unique
			_program_id	:= (	SELECT 
									program_id 
								FROM programs_manager_schema.programs 
								WHERE program_name = (SELECT _in_data ->> 'program_name')::text
								);
								
			IF _program_id IS NULL THEN
				_program_name_unique := TRUE;
			ELSE
				_program_name_unique := FALSE;
			END IF;
												

			IF lower (_insert_or_update) = 'insert' THEN
				
				IF NOT _containing_level_exists THEN 
					_message := (SELECT 'The program level with the submitted containing level name, ' || (SELECT _in_data ->> 'containing_level_name')::text || ', DOES NOT EXIST so the report CAN NOT be entered, please resubmit with correct data.') ;
					_out_json :=  (SELECT json_build_object(
										'result_indicator', 'Failure',
										'message', _message,
										'program_id', (SELECT _in_data ->> 'program_id')::text,
										'program_name', (SELECT _in_data ->> 'program_name')::text,
										'organization_id', (SELECT _in_data ->> 'organization_id')::text,
										'coc_code', (SELECT _in_data ->> 'coc_code')::text,
										'containing_level_name', (SELECT _in_data ->> 'containing_level_name')::text,
										'changed_by_user_login', (SELECT _in_data ->> 'changed_by_user_login')::text
										));					
				ELSIF NOT _program_name_unique THEN
					_message := (SELECT 'The submitted program name, ' || (SELECT _in_data ->> 'program_name')::text || ', already exists, please choose another.') ;

					_out_json :=  (SELECT json_build_object(
										'result_indicator', 'Failure',
										'message', _message,
										'program_id', (SELECT _in_data ->> 'program_id')::text,
										'program_name', (SELECT _in_data ->> 'program_name')::text,
										'organization_id', (SELECT _in_data ->> 'organization_id')::text,
										'coc_code', (SELECT _in_data ->> 'coc_code')::text,
										'containing_level_name', (SELECT _in_data ->> 'containing_level_name')::text,
										'changed_by_user_login', (SELECT _in_data ->> 'changed_by_user_login')::text
										));	
								
				ELSE	-- there is a containing level and the program name is unique so we insert the program
				
					INSERT INTO programs_manager_schema.programs (
						program_id,
						program_name,
						organization_id,
						coc_code,
						containing_level_name,
						datetime_program_changed,
						changed_by_user_login
						)
					VALUES	(
						(SELECT _in_data ->> 'program_id')::integer,
						(SELECT _in_data ->> 'program_name')::text, 
						(SELECT _in_data ->> 'organization_id')::text,
						(SELECT _in_data ->> 'coc_code')::text, 
						(SELECT _in_data ->> 'containing_level_name')::text,
						LOCALTIMESTAMP (0),
						(SELECT _in_data ->> 'changed_by_user_login')::text
						)
					;
							
						_message := (SELECT 'The program ' || (SELECT _in_data ->> 'program_name')::text || ' has been added to the system.');

						_out_json :=  (SELECT json_build_object(
										'result_indicator', 'Successs',
										'message', _message,
										'program_id', (SELECT _in_data ->> 'program_id')::text,
										'program_name', (SELECT _in_data ->> 'program_name')::text,
										'organization_id', (SELECT _in_data ->> 'organization_id')::text,
										'coc_code', (SELECT _in_data ->> 'coc_code')::text,
										'containing_level_name', (SELECT _in_data ->> 'containing_level_name')::text,
										'changed_by_user_login', (SELECT _in_data ->> 'changed_by_user_login')::text
										));
											
				END IF;	-- iS there a containing level and the program name is unique so we insert the program
				
			ELSE -- update the program

				_program_id := ((SELECT _in_data ->> 'program_id')::integer);
				
				-- is the containing level being changed? if so check that it exists before updating
				_old_containing_level_name := (SELECT 
									containing_level_name 
								FROM programs_manager_schema.programs 
								WHERE program_id = _program_id
								);
								
				IF _old_containing_level_name <> (SELECT _in_data ->> 'containing_level_name')::text THEN
					IF NOT _containing_level_exists THEN 
						_containing_level_name_updateable := FALSE;
					END IF;
				ELSE
					_containing_level_name_updateable := TRUE;
				END IF;
				
				-- is the report name being changed? if so check that it exists before updating
				-- don't update if the report name already exists
				_old_program_name := (SELECT 
									program_name 
								FROM programs_manager_schema.programs
								WHERE program_id = _program_id
								);
								
				IF _old_program_name <> (SELECT _in_data ->> 'program_name')::text THEN 
					IF NOT _program_name_unique THEN 
						_program_name_updateable := FALSE;
					END IF;
				ELSE
					_program_name_updateable := TRUE;
				END IF;
								
				IF NOT _containing_level_name_updateable THEN
					_message := (SELECT 'The level with the submitted containing level name, ' || (SELECT _in_data ->> 'containing_level_name')::text || ', DOES NOT EXIST so the program CAN NOT be updated, please resubmit with correct data.') ;
					_out_json :=  (SELECT json_build_object(
										'result_indicator', 'Failure',
										'message', _message,
										'program_id', (SELECT _in_data ->> 'program_id')::text,
										'program_name', (SELECT _in_data ->> 'program_name')::text,
										'organization_id', (SELECT _in_data ->> 'organization_id')::text,
										'coc_code', (SELECT _in_data ->> 'coc_code')::text,
										'containing_level_name', (SELECT _in_data ->> 'containing_level_name')::text,
										'changed_by_user_login', (SELECT _in_data ->> 'changed_by_user_login')::text
										));			
				
				ELSIF NOT _program_name_updateable THEN
					_message := (SELECT 'The submitted program name, ' || (SELECT _in_data ->> 'program_name')::text || ', already exists and the program CANNOT be updated, please choose another.') ;

					_out_json :=  (SELECT json_build_object(
										'result_indicator', 'Failure',
										'message', _message,
										'program_id', (SELECT _in_data ->> 'program_id')::text,
										'program_name', (SELECT _in_data ->> 'program_name')::text,
										'organization_id', (SELECT _in_data ->> 'organization_id')::text,
										'coc_code', (SELECT _in_data ->> 'coc_code')::text,
										'containing_level_name', (SELECT _in_data ->> 'containing_level_name')::text,
										'changed_by_user_login', (SELECT _in_data ->> 'changed_by_user_login')::text
										));	
				
				ELSE	-- there is a containing level and the program name is unique so we update the program 		
						
					UPDATE  programs_manager_schema.programs 
					SET	program_id = (SELECT _in_data ->> 'program_id')::integer,
						program_name = (SELECT _in_data ->> 'program_name')::text, 
						organization_id = (SELECT _in_data ->> 'organization_id')::text,
						coc_code = (SELECT _in_data ->> 'coc_code')::text, 
						containing_level_name = (SELECT _in_data ->> 'containing_level_name')::text,
						datetime_program_changed = LOCALTIMESTAMP (0),
						changed_by_user_login = (SELECT _in_data ->> 'changed_by_user_login')::text
					WHERE	program_id = _program_id	
					;								
		
					_message := (SELECT 'The program ' || (SELECT _in_data ->> 'program_name')::text || ' has been updated.');

					_out_json :=  (SELECT json_build_object(
									'result_indicator', 'Successs',
									'message', _message,
									'program_id', (SELECT _in_data ->> 'program_id')::text,
									'program_name', (SELECT _in_data ->> 'program_name')::text,
									'organization_id', (SELECT _in_data ->> 'organization_id')::text,
									'coc_code', (SELECT _in_data ->> 'coc_code')::text,
									'containing_level_name', (SELECT _in_data ->> 'containing_level_name')::text,
									'changed_by_user_login', (SELECT _in_data ->> 'changed_by_user_login')::text
									));
					
				END IF;	--IF NOT _containing_level_name_updateable
				
			END IF;	-- IF lower (_insert_or_update)
		
		END IF;	-- check if the submitted data is complete
		
	ELSE	-- user isn't authorized to enter or edit reports
	
		_message := 'The user ' || _calling_login || ' IS NOT Authorized to enter or edit programs. Nothng was changed.';
		
		_out_json :=  (SELECT json_build_object(
							'result_indicator', 'Failure',
							'message', _message,
							'program_id', (SELECT _in_data ->> 'program_id')::text,
							'program_name', (SELECT _in_data ->> 'program_name')::text,
							'organization_id', (SELECT _in_data ->> 'organization_id')::text,
							'coc_code', (SELECT _in_data ->> 'coc_code')::text,
							'containing_level_name', (SELECT _in_data ->> 'containing_level_name')::text,
							'changed_by_user_login', (SELECT _in_data ->> 'changed_by_user_login')::text
							));	

	END IF;

	RETURN _out_json;
	
	
END;
$$ LANGUAGE plpgsql;		