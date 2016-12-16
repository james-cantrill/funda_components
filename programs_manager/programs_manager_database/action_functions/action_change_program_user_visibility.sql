/* The function action_change_program_user_visibility


	_in_data:	{
					login:
					service:
					program:
					task:	//visible (set programs_manager_schema.system_user_allowed_programs.program_accessible to TRUE) or not_visible (set programs_manager_schema.system_user_allowed_programs.program_accessible to FALSE)
					changing_user_login:
				}
			
* The json object returned by the function, _out_json, is defined  below.

	_out_json:	{
				result_indicator:
				message:
				login:
				service:
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
	_program_id	integer;	
	_message	text;
	_program_accessible	boolean;	
	_service	text;
	_program	text;
	_submited_login	text;
	_sysuser_id	uuid;
	
	_firstname	text;
	_lastname	text;
	
--	for calling the system_user_schema.util_is_user_authorized function to determine if the calling user is authorized to add new users
	_calling_login	text;
	_input_authorized_json	json;	-- input json
	_output_authorized_json	json;	-- output json  
	_authorized_result	boolean;		
	
BEGIN

	-- Determine if the calling user is authorized
	_calling_login := (SELECT _in_data ->> 'changing_user_login')::text;
	
	_input_authorized_json :=	(SELECT json_build_object(
							'login', _calling_login,
							'service', 'programs_manager',
							'action', 'change_program_user_visibility'
							));
	
	_output_authorized_json := (SELECT * FROM system_user_schema.util_is_user_authorized (_input_authorized_json));
	
	_authorized_result := (SELECT _output_authorized_json ->> 'authorized')::boolean;
	
	_submited_login := (SELECT lower ((SELECT _in_data ->> 'login')));
		
	_firstname := (SELECT firstname FROM system_user_schema.system_users WHERE login = _submited_login);
	_lastname := (SELECT lastname FROM system_user_schema.system_users WHERE login = _submited_login);
			
	IF _authorized_result  THEN
	
		_service := (SELECT _in_data ->> 'service')::text;
		_program := (SELECT _in_data ->> 'program')::text;
		
		_program_id := (	SELECT 
								program_id 
							FROM programs_manager_schema.system_user_allowed_programs
							WHERE login = _submited_login
							  AND  program_name = _program
							);
							
		IF _program_id IS NOT NULL THEN	-- the user already has an entry for this program and we can change it
		
			_program_accessible := (SELECT
										program_accessible
									FROM	programs_manager_schema.system_user_allowed_programs
									WHERE	 login = _submited_login
									  AND	program_id = _program_id
								);
								
			IF (SELECT _in_data ->> 'task')::text = 'visible'  AND _program_accessible = FALSE THEN
			
				_program_accessible := TRUE;
				
				UPDATE	programs_manager_schema.system_user_allowed_programs
				   SET	program_accessible = TRUE,
						datetime_program_accessible_changed = LOCALTIMESTAMP (0)
				WHERE	login = _submited_login
				  AND	program_id = _program_id
				;
			
				_message := (SELECT 'The program ' || _program || ' is now accessible to ' ||  _firstname || ' ' || _lastname );
			
			
			_out_json :=  (SELECT json_build_object(
								'result_indicator', 'Success',
								'message', _message,
								'login', _submited_login,
								'service', _service,
								'program_id', _program_id,
								'program_name', _program,
								'visible', _program_accessible,
								'changing_user_login', _calling_login
								));
								
			ELSIF (SELECT _in_data ->> 'task')::text = 'visible'  AND _program_accessible = TRUE THEN
			
				_message := (SELECT 'The program ' || _program || ' is already accessible to ' ||  _firstname || ' ' || _lastname || '. Nothing will be done.' );
			
				 _out_json :=  (SELECT json_build_object(
								'result_indicator', 'Failure',
								'message', _message,
								'login', _submited_login,
								'service', _service,
								'program_id', _program_id,
								'program_name', _program,
								'visible', _program_accessible,
								'changing_user_login', _calling_login
									));
										
			ELSIF (SELECT _in_data ->> 'task')::text = 'not_visible'  AND _program_accessible = TRUE THEN
			
				_program_accessible := FALSE;
				
				UPDATE	programs_manager_schema.system_user_allowed_programs
				   SET	program_accessible = FALSE,
						datetime_program_accessible_changed = LOCALTIMESTAMP (0)
				WHERE	login = _submited_login
				  AND	program_id = _program_id
				;
			
				_message := (SELECT 'The program ' || _program || ' is no longer accessible to ' ||  _firstname || ' ' || _lastname );
			
				_out_json :=  (SELECT json_build_object(
									'result_indicator', 'Success',
									'message', _message,
									'login', _submited_login,
									'service', _service,
									'program_id', _program_id,
									'program_name', _program,
									'visible', _program_accessible,
									'changing_user_login', _calling_login
									));
			
			ELSE
			
				_message := (SELECT 'The program ' || _program || ' is already inaccessible to ' ||  _firstname || ' ' || _lastname || '. Nothing will be done.' );
			
				 _out_json :=  (SELECT json_build_object(
								'result_indicator', 'Failure',
								'message', _message,
								'login', _submited_login,
								'service', _service,
								'program_id', _program_id,
								'program_name', _program,
								'visible', _program_accessible,
								'changing_user_login', _calling_login
									));
			END IF;

		ELSE	-- IF _program_id IS NOT NULL THEN	-- the user does not have an entry for this program so we add it
		
			_sysuser_id := (	SELECT 
									sysuser_id 
								FROM system_user_schema.system_users 
								WHERE login = lower ((SELECT _in_data ->> 'login'))
								);
							
			_program_id := (	SELECT 
									program_id 
								FROM programs_manager_schema.programs
								WHERE program_name = _program
								);

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
				_sysuser_id,
				_submited_login,
				_program_id,
				_program,
				TRUE,
				LOCALTIMESTAMP (0),
				_calling_login
			;
			
			_message := (SELECT 'The program ' || _program || ' is now accessible to ' ||  _firstname || ' ' || _lastname );
			
			_out_json :=  (SELECT json_build_object(
								'result_indicator', 'Success',
								'message', _message,
								'login', _submited_login,
								'service', _service,
								'program_id', _program_id,
								'program_name', _program,
								'visible', TRUE,
								'changing_user_login', _calling_login
								));

		END IF;
		
	ELSE	--	the calling user is not authorized to change program accesiblilty
		_message := 'The user ' || _calling_login || ' IS NOT Authorized to change users'' program accesiblilty. Nothng was changed.';
		
		_out_json :=  (SELECT json_build_object(
							'result_indicator', 'Failure',
							'message', _message,
							'login', (SELECT _in_data ->> 'login')::text,
							'service', (SELECT _in_data ->> 'service')::text,
							'program_name',  (SELECT _in_data ->> 'program')::text,
							'changing_user_login', _calling_login
							));	
	END IF;
	RETURN _out_json;
	
	
END;
$$ LANGUAGE plpgsql;		