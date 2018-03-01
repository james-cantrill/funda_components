/* The function action_change_program_user_visibility changes the visibility
* (whether the data and configuration of a given program is visible to a
* defined user) of a defined program.
*
* The program is defined either by the program_id or program parameters. Only
* one must be non-NULL, but if both are submitted thbey are tested for
* consistency. (Is the name of the program corresponding to the program_id the
* same as that defined by the program parameter)


	_in_data:	{
					target_login:    - the login of the defined user whose visi bility will be changed
					program_id:      - the ID of the defined program
					program: - the name of the defined program
					visible:	-- booloean
					changing_user_login:
				}
			
* The json object returned by the function, _out_json, is defined  below.

	_out_json:	{
				result_indicator:
				message:
				target_login:
				program_id:
				program_name:
				visible:
				changing_user_login:
				}
				

*/

CREATE OR REPLACE FUNCTION programs_manager_schema.action_change_program_user_visibility (_in_data json) RETURNS json
AS $$

DECLARE
		
	_out_json json;
	_message	text;
	
	
	_program_accessible	boolean;	
	
	
	_program_id_from_name	uuid;	
	_program_name_from_id	text;
	_program_id_to_change	uuid;
	_program_name_to_change	text;
	
	_submited_target_login	text;
	_target_sysuser_id	uuid;
	_firstname	text;
	_lastname	text;
	
--	for calling the system_user_schema.util_is_user_authorized function to determine if the calling user is authorized to add new users
	_calling_login	text;
	_input_authorized_json	json;	-- input json
	_output_authorized_json	json;	-- output json  
	_authorized_result	boolean;		
	
BEGIN

-- Determine if the calling user is authorized -------------------------------
	_calling_login := (SELECT _in_data ->> 'changing_user_login')::text;	
	_input_authorized_json :=	(SELECT json_build_object(
							'login', _calling_login,
							'service', 'programs_manager',
							'action', 'change_program_user_visibility'
							));	
	
	_output_authorized_json := (SELECT * FROM system_user_schema.util_is_user_authorized (_input_authorized_json));	
	
	_authorized_result := (SELECT _output_authorized_json ->> 'authorized')::boolean;

------------------------- Does target user exist ------------------------------
	_submited_target_login := (SELECT lower ((SELECT _in_data ->> 'target_login')));	
	_target_sysuser_id :=	(SELECT sysuser_id
								FROM system_user_schema.system_users
								WHERE login = (SELECT _in_data ->> 'target_login')::text
							);							

---------------------------------- does program exist-------------------------
	IF (SELECT _in_data ->> 'program_id')::uuid IS NULL AND (SELECT _in_data ->> 'program')::text IS NOT NULL THEN 
		_program_id_from_name :=	(SELECT program_id
						FROM programs_manager_schema.programs
						WHERE program_name = (SELECT _in_data ->> 'program')::text
						);
		_program_id_to_change := _program_id_from_name;
		_program_name_to_change := (SELECT _in_data ->> 'program')::text;
	ELSIF (SELECT _in_data ->> 'program_id')::uuid IS NOT NULL AND (SELECT _in_data ->> 'program')::text IS NULL THEN 
		_program_name_from_id :=	(SELECT program_name
						FROM programs_manager_schema.programs
						WHERE program_id = (SELECT _in_data ->> 'program_id')::uuid
						);
		_program_id_to_change := (SELECT _in_data ->> 'program_id')::uuid;
		_program_name_to_change := _program_name_from_id;
		
	ELSIF (SELECT _in_data ->> 'program_id')::uuid IS NOT NULL AND (SELECT _in_data ->> 'program')::text IS NOT NULL THEN  
		_program_name_from_id :=	(SELECT program_name
						FROM programs_manager_schema.programs
						WHERE program_id = (SELECT _in_data ->> 'program_id')::uuid
						);
						
		_program_id_from_name :=	(SELECT program_id
						FROM programs_manager_schema.programs
						WHERE program_name = (SELECT _in_data ->> 'program')::text
						);						
		_program_id_to_change := (SELECT _in_data ->> 'program_id')::uuid;
		_program_name_to_change := (SELECT _in_data ->> 'program')::text;
	END IF;
	

------------------------------------------------------------------------------
	IF 	 ((SELECT _in_data ->> 'target_login')::text IS NULL 
			OR (SELECT _in_data ->> 'visible')::text IS NULL 
			OR (SELECT _in_data ->> 'changing_user_login')::text IS NULL 
			OR (	(SELECT _in_data ->> 'program_id')::text IS NULL
					AND (SELECT _in_data ->> 'program')::text IS NULL 
				)
			)	THEN -- input data missing
				
		_message := (SELECT 'The data is incomplete as submitted so the program visibility CAN NOT be changed, please resubmit with complete data.') ;
		
		_out_json :=  (SELECT json_build_object(
							'result_indicator', 'Failure',
							'message', _message,
							'target_login', (SELECT _in_data ->> 'target_login')::text,
							'program_id', (SELECT _in_data ->> 'program_id')::text,
							'program_name',  (SELECT _in_data ->> 'program')::text,
							'visible', (SELECT _in_data ->> 'visible')::text,
							'changing_user_login', (SELECT _in_data ->> 'changing_user_login')::text
							));		
	
	ELSIF  NOT _authorized_result  THEN
		_message := 'The user ' || _calling_login || ' IS NOT Authorized to change users program accesiblilty. Nothng was changed.';
		
		_out_json :=  (SELECT json_build_object(
							'result_indicator', 'Failure',
							'message', _message,
							'target_login', (SELECT _in_data ->> 'target_login')::text,
							'program_id', (SELECT _in_data ->> 'program_id')::text,
							'program_name',  (SELECT _in_data ->> 'program')::text,
							'visible', (SELECT _in_data ->> 'visible')::text,
							'changing_user_login', (SELECT _in_data ->> 'changing_user_login')::text
							));		
	
	ELSIF	((SELECT _in_data ->> 'program_id')::uuid IS NULL AND (SELECT _in_data ->> 'program')::text IS NOT NULL AND _program_id_from_name IS NULL)
			OR ((SELECT _in_data ->> 'program_id')::uuid IS NOT NULL AND (SELECT _in_data ->> 'program')::text IS NULL AND _program_name_from_id IS NULL)  
			OR ((SELECT _in_data ->> 'program_id')::uuid IS NOT NULL AND (SELECT _in_data ->> 'program')::text IS NOT NULL AND (_program_name_from_id IS NULL OR _program_id_from_name IS NULL)) 
			THEN	-- program doesn't exist

			_message := 'The program, ' || _program_name_to_change || ', DOES NOT EXIST so there is nothing to change. Please resubmit with correct data';

		_out_json :=  (SELECT json_build_object(
							'result_indicator', 'Failure',
							'message', _message,
							'target_login', (SELECT _in_data ->> 'target_login')::text,
							'program_id', (SELECT _in_data ->> 'program_id')::text,
							'program_name',  (SELECT _in_data ->> 'program')::text,
							'visible', (SELECT _in_data ->> 'visible')::text,
							'changing_user_login', (SELECT _in_data ->> 'changing_user_login')::text
							));		
							
	ELSIF	((SELECT _in_data ->> 'program_id')::uuid IS NOT NULL AND (SELECT _in_data ->> 'program')::text IS NOT NULL AND (_program_name_from_id != (SELECT _in_data ->> 'program')::text OR _program_id_from_name !=  (SELECT _in_data ->> 'program_id')::uuid) ) 
			THEN	-- program name and ID don't correspond to the same program

		_message := 'The program ID ' || (SELECT _in_data ->> 'program_id')::text || ' DOES NOT correspond to the program name ' || (SELECT _in_data ->> 'program')::text || ' so the visibility WAS NOT CHANGED. Please resubmit with correct data';
		
		_out_json :=  (SELECT json_build_object(
							'result_indicator', 'Failure',
							'message', _message,
							'target_login', (SELECT _in_data ->> 'target_login')::text,
							'program_id', (SELECT _in_data ->> 'program_id')::text,
							'program_name',  (SELECT _in_data ->> 'program')::text,
							'visible', (SELECT _in_data ->> 'visible')::text,
							'changing_user_login', (SELECT _in_data ->> 'changing_user_login')::text
							));		
							
	ELSIF _target_sysuser_id IS NULL THEN	-- target user doesn't exist
	
		_message := 'The user defined by the login ' || (SELECT _in_data ->> 'target_login')::text || ' DOES NOT EXIST so there is nothing to change.';
		
		_out_json :=  (SELECT json_build_object(
							'result_indicator', 'Failure',
							'message', _message,
							'target_login', (SELECT _in_data ->> 'target_login')::text,
							'program_id', (SELECT _in_data ->> 'program_id')::text,
							'program_name',  (SELECT _in_data ->> 'program')::text,
							'visible', (SELECT _in_data ->> 'visible')::text,
							'changing_user_login', (SELECT _in_data ->> 'changing_user_login')::text
							));		
							

	ELSE	-- process request
	
---------------- Does this user already have an entry for this program

		IF (SELECT program_id FROM programs_manager_schema.system_user_allowed_programs
				WHERE login = _submited_target_login  AND  program_name = _program_name_to_change
			) IS NOT NULL THEN -- the user already has an entry for this program and we update it
			
				UPDATE	programs_manager_schema.system_user_allowed_programs
				   SET	program_accessible = (SELECT _in_data ->> 'visible')::boolean,
						datetime_program_accessible_changed = LOCALTIMESTAMP (0),
						changed_by_user_login = (SELECT _in_data ->> 'changing_user_login')::text
				WHERE	login = (SELECT _in_data ->> 'target_login')::text
				  AND	program_id = _program_id_to_change
				;			
				
		_message := 'The data for the program ' || (SELECT _in_data ->> 'program')::text || '  is now ' || (SELECT CASE WHEN (SELECT _in_data ->> 'visible')::BOOLEAN = TRUE THEN 'Visible' ELSE 'Not Visible' END ) ||' to the user defined by the login ' || (SELECT _in_data ->> 'target_login')::text || '.';
		
		_out_json :=  (SELECT json_build_object(
							'result_indicator', 'Failure',
							'message', _message,
							'target_login', (SELECT _in_data ->> 'target_login')::text,
							'program_id', (SELECT _in_data ->> 'program_id')::text,
							'program_name',  (SELECT _in_data ->> 'program')::text,
							'visible', (SELECT _in_data ->> 'visible')::text,
							'changing_user_login', (SELECT _in_data ->> 'changing_user_login')::text
							));		
				
		ELSE    -- the user has no entry for this program so we insert it
			
			INSERT INTO programs_manager_schema.system_user_allowed_programs (
				sysuser_id,
				login,
				program_id,
				program_name,
				program_accessible,
				datetime_program_accessible_changed,
				changed_by_user_login
				)
			SELECT
				_target_sysuser_id,
				(SELECT _in_data ->> 'target_login')::text,
				_program_id_to_change,
				_program_name_to_change,
				(SELECT _in_data ->> 'visible')::boolean,
				LOCALTIMESTAMP (0),
				(SELECT _in_data ->> 'changing_user_login')::text
			;

		END IF;
							
			_message := 'The data for the program ' || (SELECT _in_data ->> 'program')::text || '  is now ' || (SELECT CASE WHEN (SELECT _in_data ->> 'visible')::BOOLEAN = TRUE THEN 'Visible' ELSE 'Not Visible' END ) ||' to the user defined by the login ' || (SELECT _in_data ->> 'target_login')::text || '.';
		
			_out_json :=  (SELECT json_build_object(
								'result_indicator', 'Success',
								'message', _message,
								'target_login', (SELECT _in_data ->> 'target_login')::text,
								'program_id', (SELECT _in_data ->> 'program_id')::text,
								'program_name',  (SELECT _in_data ->> 'program')::text,
								'visible', (SELECT _in_data ->> 'visible')::text,
								'changing_user_login', (SELECT _in_data ->> 'changing_user_login')::text
								)
							);		
					
	END IF;
	
	RETURN _out_json;
	
	
END;
$$ LANGUAGE plpgsql;		