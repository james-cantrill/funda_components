/* The function system_user_schema.action_user_login tests the login and password submitted in
* the json object _in_data (defined below) and if the combinaton is valid logs
* the user onto the system. If the combination isn't valid it returns a
* failuire message in tbe object _out_json (below)

	_in_data:	{
					login:
					password:
				}
			
* The json object returned by the function, _out_json, is defined  below.

	_out_json:	{
					result_indicator:
					message:
					sysuser_id:
					firstname:
					lastname:
				}
				
	*/

CREATE OR REPLACE FUNCTION system_user_schema.action_user_login (_in_data json) RETURNS json
AS $$

DECLARE
		
	_integer_var integer;
	_out_json	json;
	
	_sysuser_id	uuid;	
	_message	text;	
	_firstname	text;
	_lastname	text;
	
	_user_state	text;
	
	_submited_login	text;	
	_submited_password	text;
	
	--	for calling the system_user_schema.util_is_user_authorized function to determine if tnhe calling user is authorized to login (access the system)
	_calling_login	text;
	_input_authorized_json	json;	-- input json
	_output_authorized_json	json;	-- output json  
	_authorized_result	boolean;
	
BEGIN

	-- Determine if tnhe calling user is authorized
	_submited_login := (SELECT _in_data ->> 'login')::text;
	
-- Is the login in  the system
	_sysuser_id := (	SELECT 
						sysuser_id
					FROM system_user_schema.system_users 
					WHERE	login = lower(_submited_login)); 

-- What is the user's state
	IF _sysuser_id IS NOT NULL THEN
		_user_state := (SELECT user_state 
						FROM system_user_schema.system_user_state
						WHERE sysuser_id = _sysuser_id);
	END IF;
	
	-- Determine if the calling user is authorized	
	_input_authorized_json :=	(SELECT json_build_object(
							'login', _submited_login,
							'service', 'system_user',
							'action', 'user_login'
							));	
	_output_authorized_json := (SELECT * FROM system_user_schema.util_is_user_authorized (_input_authorized_json));	
	_authorized_result := (SELECT _output_authorized_json ->> 'authorized')::boolean;
	
	
	IF (SELECT _in_data ->> 'login')::text IS NULL THEN 
			_message := (SELECT 'The login is missing, please resubmit with complete data.') ;
		_out_json :=  (SELECT json_build_object(
							'result_indicator', 'Failure',
							'message', _message,
							'login', (SELECT _in_data ->> 'login')::text
							));
	ELSIF _sysuser_id IS NULL OR NOT _authorized_result THEN	-- calling user is not authorized

		_message := 'The user ' || _submited_login || ' IS NOT Authorized to access the system.';
		_out_json :=  (SELECT json_build_object(
							'result_indicator', 'Failure',
							'message', _message,
							'login', lower ((SELECT _in_data ->> 'login'))::text)
							);
	ELSIF _user_state = 'Logged In' THEN 
		_message := 'The user ' || _submited_login || ' IS ALREADY logged in.';
		_out_json :=  (SELECT json_build_object(
							'result_indicator', 'Failure',
							'message', _message,
							'login', lower ((SELECT _in_data ->> 'login'))::text)
							);
	ELSE
	
		_sysuser_id := NULL;
		_submited_password := (SELECT _in_data ->> 'password')::text;
		
		_sysuser_id := (	SELECT 
								sysuser_id
							FROM system_user_schema.system_users 
							WHERE	login = lower(_submited_login) 
							  AND	password = crypt(_submited_password, password)
						);  
		 
		IF _sysuser_id IS NOT NULL THEN	-- the login/password combination is valid the user can be logged in 
		
			_firstname := (SELECT firstname FROM system_user_schema.system_users WHERE sysuser_id = _sysuser_id);
			_lastname := (SELECT lastname FROM system_user_schema.system_users WHERE sysuser_id = _sysuser_id);
			
			-- log user in
			UPDATE	system_user_schema.system_user_state
			   SET	
					user_state = 'Logged In',
					datetime_state_started = LOCALTIMESTAMP (0)
			WHERE	sysuser_id = _sysuser_id
			;
			INSERT INTO system_user_schema.system_user_last_active (
				sysuser_id,
				login,
				datetime_last_active
				)
			SELECT
				_sysuser_id,
				_submited_login,
				clock_timestamp()
			;
			
			_message := (SELECT  _firstname || ' ' || _lastname || ', is logged in.');
			
			
			 _out_json :=  (SELECT json_build_object(
								'result_indicator', 'Success',
								'message', _message,
								'sysuser_id', _sysuser_id,
								'firstname', _firstname,
								'lastname', _lastname
								));

		ELSE	-- the entered login exists in the system and an error message will be returned
		
			_message := (SELECT 'Invalid username/password combination. Please try again.') ;
			
			_out_json :=  (SELECT json_build_object(
								'result_indicator', 'Failure',
								'message', _message,
								'firstname', (SELECT _in_data ->> 'firstname')::text,
								'lastname', (SELECT _in_data ->> 'lastname')::text
								));

		END IF;

	END IF;		

	
	RETURN _out_json;
	
	
END;
$$ LANGUAGE plpgsql;		