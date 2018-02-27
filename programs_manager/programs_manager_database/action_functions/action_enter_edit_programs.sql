-- The function action_enter_edit_programs inserts or updates a record in the programs_manager_schema.programs table
/*
--	_in_data:	
	{								
		program_id:
		program_name:
		program_description:
		other_program_id:   -- unique program identifier from outside this system. It can't be NULL but it can be an empty string
		organization_name:
		containing_level_name:
		changed_by_user_login:
		enter_or_update:
	}
			
-- The json object returned by the function, _out_json, is defined  below.

	_out_json:	
	{
		result_indicator:
		message:
		program_id:
		program_name:
		program_description:
		other_program_id:
		organization_name:
		coc_code:
		containing_level_name:
		changed_by_user_login:
		enter_or_update:
	}

*/


CREATE OR REPLACE FUNCTION programs_manager_schema.action_enter_edit_programs (_in_data json) RETURNS json
AS $$

DECLARE
	_integer_var	integer;
	_out_json json;
	_message	text;
	
	_program_name	text;	
	_program_id	uuid;
	_program_description	text;
	
	_containing_level_id	uuid;
	_organization_id	uuid;
	_organization_name	text;
	
	_enter_update	text;
	
--	for calling the system_user_schema.util_is_user_authorized function to determine if the calling user is authorized to add new users
	_calling_login	text;
	_input_authorized_json	json;	-- input json
	_output_authorized_json	json;	-- output json  
	_authorized_result	boolean;	

BEGIN

	-- Determine if the calling user is authorized ---------------------------
	_calling_login := (SELECT _in_data ->> 'changed_by_user_login')::text;
	
	_input_authorized_json :=	(SELECT json_build_object(
							'login', _calling_login,
							'service', 'programs_manager',
							'action', 'enter_edit_programs'
							));
	
	_output_authorized_json := (SELECT * FROM system_user_schema.util_is_user_authorized (_input_authorized_json));
	
	_authorized_result := (SELECT _output_authorized_json ->> 'authorized')::boolean;

-------- Does organization exist? --------------------------------------------
	_organization_id := (	SELECT
						organization_id
					FROM	programs_manager_schema.organizations
					WHERE	organization_name = (SELECT _in_data ->> 'organization_name')::text
					);
	
-------- Does containing organization level exist? --------------------------------------------
	_containing_level_id := (	SELECT
						organization_level_id
					FROM	programs_manager_schema.organization_level
					WHERE	organization_level_name = (SELECT _in_data ->> 'containing_level_name')::text
					);
	
------------------------------------------------------------------------------


	IF NOT _authorized_result  THEN	-- user isn't authorized to enter or edit reports
	
		_message := 'The user ' || _calling_login || ' IS NOT Authorized to enter or edit programs. Nothng was changed.';		
		_out_json :=  (SELECT json_build_object(
							'result_indicator', 'Failure',
							'message', _message,
							'program_id', (SELECT _in_data ->> 'program_id')::text,
							'program_name', (SELECT _in_data ->> 'program_name')::text,
							'program_description', (SELECT _in_data ->> 'program_description')::text,
							'other_program_id', (SELECT _in_data ->> 'other_program_id')::text,
							'organization_name', (SELECT _in_data ->> 'organization_name')::text,
							'containing_level_name', (SELECT _in_data ->> 'containing_level_name')::text,
							'changed_by_user_login', (SELECT _in_data ->> 'changed_by_user_login')::text,
							'enter_or_update', (SELECT _in_data ->> 'enter_or_update')::text
							));	
	
	ELSIF (SELECT (SELECT _in_data ->> 'program_name')::text IS NULL 
			OR (SELECT _in_data ->> 'program_description')::text IS NULL 
			OR (SELECT _in_data ->> 'other_program_id')::text IS NULL
			OR (SELECT _in_data ->> 'organization_name')::text IS NULL 
			OR (SELECT _in_data ->> 'containing_level_name')::text IS NULL 
			OR (SELECT _in_data ->> 'changed_by_user_login')::text IS NULL  
			OR (SELECT _in_data ->> 'enter_or_update')::text IS NULL  
			OR (	(SELECT _in_data ->> 'enter_or_update')::text = 'Update'
					AND (SELECT _in_data ->> 'program_id')::text IS NULL 
				))
		THEN -- data is incomplete
		
		_message := (SELECT 'The data is incomplete as submitted so the report CAN NOT be entered or edited, please resubmit with complete data.') ;
		_out_json :=  (SELECT json_build_object(
							'result_indicator', 'Failure',
							'message', _message,
							'program_id', (SELECT _in_data ->> 'program_id')::text,
							'program_name', (SELECT _in_data ->> 'program_name')::text,
							'program_description', (SELECT _in_data ->> 'program_description')::text,
							'other_program_id', (SELECT _in_data ->> 'other_program_id')::text,
							'organization_name', (SELECT _in_data ->> 'organization_name')::text,
							'containing_level_name', (SELECT _in_data ->> 'containing_level_name')::text,
							'changed_by_user_login', (SELECT _in_data ->> 'changed_by_user_login')::text,
							'enter_or_update', (SELECT _in_data ->> 'enter_or_update')::text
							));	
	
	ELSIF _organization_id IS NULL THEN	-- Organization does not exist
	
		_message := (SELECT 'The specified organization, ' || (SELECT _in_data ->> 'organization_name')::text || ', does not exist so the Program CAN NOT be entered.');
		_out_json :=  (SELECT json_build_object(
							'result_indicator', 'Failure',
							'message', _message,
							'program_id', (SELECT _in_data ->> 'program_id')::text,
							'program_name', (SELECT _in_data ->> 'program_name')::text,
							'program_description', (SELECT _in_data ->> 'program_description')::text,
							'other_program_id', (SELECT _in_data ->> 'other_program_id')::text,
							'organization_name', (SELECT _in_data ->> 'organization_name')::text,
							'containing_level_name', (SELECT _in_data ->> 'containing_level_name')::text,
							'changed_by_user_login', (SELECT _in_data ->> 'changed_by_user_login')::text,
							'enter_or_update', (SELECT _in_data ->> 'enter_or_update')::text
							));		
							
	ELSIF _containing_level_id IS NULL THEN -- Containing organization level does not exist
	
		_message := (SELECT 'The specified containing organizational level ' || (SELECT _in_data ->> 'containing_level_name')::text|| ' does not exist so the Program CAN NOT be entered.') ;
		_out_json :=  (SELECT json_build_object(
							'result_indicator', 'Failure',
							'message', _message,
							'program_id', (SELECT _in_data ->> 'program_id')::text,
							'program_name', (SELECT _in_data ->> 'program_name')::text,
							'program_description', (SELECT _in_data ->> 'program_description')::text,
							'other_program_id', (SELECT _in_data ->> 'other_program_id')::text,
							'organization_name', (SELECT _in_data ->> 'organization_name')::text,
							'containing_level_name', (SELECT _in_data ->> 'containing_level_name')::text,
							'changed_by_user_login', (SELECT _in_data ->> 'changed_by_user_login')::text,
							'enter_or_update', (SELECT _in_data ->> 'enter_or_update')::text
							));		
								
	ELSE
	
		_enter_update := (SELECT _in_data ->> 'enter_or_update')::text;
		
		IF _enter_update = 'Enter' THEN 
		
			-- is the program name unique
			_program_id	:= (	SELECT 
									program_id 
								FROM programs_manager_schema.programs 
								WHERE program_name = (SELECT _in_data ->> 'program_name')::text
								);
								
			IF _program_id IS NOT NULL THEN	-- program name is not unique	
					
				_message := (SELECT 'The submitted program name, ' || (SELECT _in_data ->> 'program_name')::text || ', already exists, please choose another.') ;
				_out_json :=  (SELECT json_build_object (
							'result_indicator', 'Failure',
							'message', _message,
							'program_id', (SELECT _in_data ->> 'program_id')::text,
							'program_name', (SELECT _in_data ->> 'program_name')::text,
							'program_description', (SELECT _in_data ->> 'program_description')::text,
							'other_program_id', (SELECT _in_data ->> 'other_program_id')::text,
							'organization_name', (SELECT _in_data ->> 'organization_name')::text,
							'containing_level_name', (SELECT _in_data ->> 'containing_level_name')::text,
							'changed_by_user_login', (SELECT _in_data ->> 'changed_by_user_login')::text,
							'enter_or_update', (SELECT _in_data ->> 'enter_or_update')::text
							));		
								
			ELSE
			
				INSERT INTO programs_manager_schema.programs (
					program_name,
					program_description,
					other_program_id,
					organization_id,
					containing_organization_level_id,
					datetime_program_changed,
					changing_user_login
					)
				VALUES	(
					(SELECT _in_data ->> 'program_name')::text, 
					(SELECT _in_data ->> 'program_description')::text, 
					(SELECT _in_data ->> 'other_program_id')::text, 
					_organization_id,
					_containing_level_id,
					LOCALTIMESTAMP (0),
					(SELECT _in_data ->> 'changed_by_user_login')::text
					)
				;
						
				_program_id := (	SELECT
									program_id
								FROM	programs_manager_schema.programs
								WHERE	program_name = (SELECT _in_data ->> 'program_name')::text
								);	

				_message := (SELECT 'The program ' || (SELECT _in_data ->> 'program_name')::text || ' has been added to the system.');

				_out_json :=  (SELECT json_build_object(
								'result_indicator', 'Successs',
								'message', _message,
								'program_id', _program_id,
								'program_name', (SELECT _in_data ->> 'program_name')::text,
								'program_description', (SELECT _in_data ->> 'program_description')::text,
								'other_program_id', (SELECT _in_data ->> 'other_program_id')::text,
								'organization_name', (SELECT _in_data ->> 'organization_name')::text,
								'containing_level_name', (SELECT _in_data ->> 'containing_level_name')::text,
								'changed_by_user_login', (SELECT _in_data ->> 'changed_by_user_login')::text,
								'enter_or_update', (SELECT _in_data ->> 'enter_or_update')::text
								));
										
		
			END IF;
			
		ELSIF _enter_update = 'Update' THEN 
		
			-- does the program indicated  by the submitted program_id exist
			_program_name	:= (	SELECT 
									program_name 
								FROM programs_manager_schema.programs 
								WHERE program_id = (SELECT _in_data ->> 'program_id')::uuid
								);
								
			IF _program_name IS NULL THEN   -- the program doesn't exist
			
				_message := (SELECT  'No program with the program_id ' || (SELECT _in_data ->> 'program_id')::text || ' exists  so this update CAN NOT be completed, please resubmit with different data.') ;
				_out_json :=  (SELECT json_build_object(
								'result_indicator', 'Failure',
								'message', _message,
								'program_id', (SELECT _in_data ->> 'program_id')::text,
								'program_name', (SELECT _in_data ->> 'program_name')::text,
								'program_description', (SELECT _in_data ->> 'program_description')::text,
								'other_program_id', (SELECT _in_data ->> 'other_program_id')::text,
								'organization_name', (SELECT _in_data ->> 'organization_name')::text,
								'containing_level_name', (SELECT _in_data ->> 'containing_level_name')::text,
								'changed_by_user_login', (SELECT _in_data ->> 'changed_by_user_login')::text,
								'enter_or_update', (SELECT _in_data ->> 'enter_or_update')::text
								));
										
				
			ELSE
			
				UPDATE  programs_manager_schema.programs 
					SET	program_id = (SELECT _in_data ->> 'program_id')::uuid,
						program_name = (SELECT _in_data ->> 'program_name')::text, 
						program_description = (SELECT _in_data ->> 'program_description')::text,
						other_program_id = (SELECT _in_data ->> 'other_program_id')::text,
						organization_id = _organization_id,
						containing_organization_level_id = _containing_level_id,
						datetime_program_changed = LOCALTIMESTAMP (0),
						changing_user_login = (SELECT _in_data ->> 'changed_by_user_login')::text
					WHERE	program_id = (SELECT _in_data ->> 'program_id')::uuid	
					;								
				
					_message := (SELECT 'The program ' || (SELECT _in_data ->> 'program_name')::text || ' has been updated.');
					_out_json :=  (SELECT json_build_object(
									'result_indicator', 'Success',
									'message', _message,
									'program_id', (SELECT _in_data ->> 'program_id')::text,
									'program_name', (SELECT _in_data ->> 'program_name')::text,
									'program_description', (SELECT _in_data ->> 'program_description')::text,
									'other_program_id', (SELECT _in_data ->> 'other_program_id')::text,
									'organization_name', (SELECT _in_data ->> 'organization_name')::text,
									'containing_level_name', (SELECT _in_data ->> 'containing_level_name')::text,
									'changed_by_user_login', (SELECT _in_data ->> 'changed_by_user_login')::text,
									'enter_or_update', (SELECT _in_data ->> 'enter_or_update')::text
									));		

			END IF;
		
		ELSE --  enter_or_update has an invalid value log an error
		
			_message := (SELECT 'The input parameter enter_or_update has an invalid value, ' || (SELECT _in_data ->> 'enter_or_update')::text || ', nothing can be done.');
			_out_json :=  (SELECT json_build_object(
							'result_indicator', 'Failure',
							'message', _message,
							'program_id', (SELECT _in_data ->> 'program_id')::text,
							'program_name', (SELECT _in_data ->> 'program_name')::text,
							'program_description', (SELECT _in_data ->> 'program_description')::text,
							'other_program_id', (SELECT _in_data ->> 'other_program_id')::text,
							'organization_name', (SELECT _in_data ->> 'organization_name')::text,
							'containing_level_name', (SELECT _in_data ->> 'containing_level_name')::text,
							'changed_by_user_login', (SELECT _in_data ->> 'changed_by_user_login')::text,
							'enter_or_update', (SELECT _in_data ->> 'enter_or_update')::text
							));		
								
		END IF;	-- IF _enter_update = 'Enter'
		
	END IF;

	RETURN _out_json;
	
END;
$$ LANGUAGE plpgsql;		