/* The function system_user_schema.action_add_new_user adds a new user to the system
* the json object containng the inmput data, _in_data, is defined below.

	_in_data:	{
					firstname:
					lastname:
					login:
					password:
					changing_user_login:
				}
			
* The json object returned by the function, _out_json, is defined  below.

	_out_json:	{
					result_indicator:
					message:
					sysuser_id:
					firstname:
					lastname:
					login:
				}
				
	*/

CREATE OR REPLACE FUNCTION system_user_schema.action_add_new_user (_in_data json) RETURNS json
AS $$

DECLARE
		
	_integer_var integer;
	_out_json	json;
	
	_sysuser_id	uuid;
	
	_message	text;
	
	_submited_firstname	text;	
	_submited_lastname	text;
	
	_login	text;
	
	--	for calling the system_user_schema.util_is_user_authorized function to determine if tnhe calling user is authorized to add new users
	_calling_login	text;
	_input_authorized_json	json;	-- input json
	_output_authorized_json	json;	-- output json  
	_authorized_result	boolean;
	
BEGIN

	-- Determine if tnhe calling user is authorized
	_calling_login := (SELECT _in_data ->> 'changing_user_login')::text;
	
	_input_authorized_json :=	(SELECT json_build_object(
							'login', _calling_login,
							'service', 'system_user',
							'action', 'add_new_user'
							));
	
	_output_authorized_json := (SELECT * FROM system_user_schema.util_is_user_authorized (_input_authorized_json));
	
	_authorized_result := (SELECT _output_authorized_json ->> 'authorized')::boolean;
	
	IF _authorized_result  THEN
		
		_submited_firstname := (SELECT _in_data ->> 'firstname')::text;
		_submited_lastname := (SELECT _in_data ->> 'lastname')::text;
		
		IF (SELECT _in_data ->> 'firstname')::text IS NULL OR (SELECT _in_data ->> 'lastname')::text IS NULL OR (SELECT _in_data ->> 'login')::text IS NULL OR (SELECT _in_data ->> 'password')::text IS NULL THEN -- data is incomplete		
			_message := (SELECT 'The data is incomplete as submitted so the USER CAN NOT be entered, please resubmit with complete data.') ;
			_out_json :=  (SELECT json_build_object(
					'result_indicator', 'Failure',
					'message', _message,
					'firstname', (SELECT _in_data ->> 'firstname')::text,
					'lastname', (SELECT _in_data ->> 'lastname')::text, 
					'login', lower ((SELECT _in_data ->> 'login'))::text)
					);
		ELSE
			_sysuser_id := (	SELECT 
									sysuser_id 
								FROM system_user_schema.system_users 
								WHERE login = lower ((SELECT _in_data ->> 'login'))
								);
			
			IF _sysuser_id IS NULL THEN	-- the entered login doesn't exist in the system
			
				INSERT INTO system_user_schema.system_users (
					login,
					password,
					firstname,
					lastname,
					datetime_user_changed,
					changing_user_login
					)
				SELECT
					lower ((SELECT _in_data ->> 'login')::text),
					(SELECT crypt((SELECT _in_data ->> 'password')::text, gen_salt('bf', 8))),
					(SELECT _in_data ->> 'firstname')::text,
					(SELECT _in_data ->> 'lastname')::text,
					LOCALTIMESTAMP (0),
					(SELECT _in_data ->> 'changing_user_login')::text
				;
				
				_sysuser_id := (SELECT sysuser_id FROM system_user_schema.system_users WHERE login = lower((SELECT _in_data ->> 'login')));
				
				INSERT INTO system_user_schema.system_user_state (
					sysuser_id,
					user_state,
					datetime_state_started
					)
				SELECT
					_sysuser_id,
					'Logged Out',
					LOCALTIMESTAMP (0)
				;
				
				--set up all system acttions as not allowed for this user; they will edikted, allowed later in  an otnher function
				INSERT INTO system_user_schema.system_user_allowed_actions (
					sysuser_id,
					login,
					service,
					action,
					action_display_name,
					action_allowed,
					changing_user_login,
					datetime_action_allowed_changed
					)
				SELECT
					_sysuser_id,
					lower ((SELECT _in_data ->> 'login')::text),
					service,
					action,
					action_display_name,
					false,
					_calling_login,
					LOCALTIMESTAMP (0)
				FROM	system_user_schema.system_actions
				;
					


				_message := (SELECT 'The user, ' || _submited_firstname || ' ' || _submited_lastname || ', has been added to the system.');
				
				 _out_json :=  (SELECT json_build_object(
									'result_indicator', 'Successs',
									'message', _message,
									'sysuser_id', _sysuser_id,
									'firstname', (SELECT _in_data ->> 'firstname')::text,
									'lastname', (SELECT _in_data ->> 'lastname')::text, 
									'login', lower ((SELECT _in_data ->> 'login')::text))
									);

			ELSE	-- the entered login exists in the system and an error message will be returned
				_message := (SELECT 'The submitted login, ' || (SELECT _in_data ->> 'login')::text || ', already exists, please choose another.') ;

				_out_json :=  (SELECT json_build_object(
									'result_indicator', 'Failure',
									'message', _message,
									'firstname', (SELECT _in_data ->> 'firstname')::text,
									'lastname', (SELECT _in_data ->> 'lastname')::text, 
									'login', lower ((SELECT _in_data ->> 'login'))::text)
									);

			END IF;
			
		END IF;
		
	ELSE	-- calling user is not authorized

		_message := 'The user ' || _calling_login || ' IS NOT Authorized to Add New Users. No user was added.';

		_out_json :=  (SELECT json_build_object(
							'result_indicator', 'Failure',
							'message', _message,
							'firstname', (SELECT _in_data ->> 'firstname')::text,
							'lastname', (SELECT _in_data ->> 'lastname')::text, 
							'login', lower ((SELECT _in_data ->> 'login'))::text)
							);
	END IF;
	
	RETURN _out_json;
	
	
END;
$$ LANGUAGE plpgsql;		
