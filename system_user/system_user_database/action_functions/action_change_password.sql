/* The function system_user_schema.action_change_password changes a user's password using the
* data submitted in the json object _in_data (defined below). If the
* login/old password combination isn't valid it returns a failure message in
* the object _out_json (below)

	_in_data:	{
					login:
					new_password:
					changing_user_login:
				}
			
* The json object returned by the function, _out_json, is defined  below.

	_out_json:	{
					result_indicator:
					message:
					firstname:
					lastname:
					login:
					changing_user_login:
				}
				
*/

--DROP FUNCTION system_user_schema.action_change_password (in_data json);
CREATE OR REPLACE FUNCTION system_user_schema.action_change_password (_in_data json) RETURNS json
AS $$

DECLARE
		
	_integer_var integer;
	_out_json	json;
	
	_sysuser_id	uuid;
	
	_message	text;
	
	_firstname	text;
	_lastname	text;
	_submited_login	text;	
	_submited_new_password	text;
	
	--for calling the system_user_schema.util_is_user_authorized function to determine if tnhe calling user is authorized to add new users
	_calling_user_state	text;
	_calling_login	text;
	_input_authorized_json	json;	-- input json
	_output_authorized_json	json;	-- output json  
	_authorized_result	boolean;
	
BEGIN

	_submited_login := (SELECT _in_data ->> 'login')::text;
	
	_sysuser_id := (	SELECT 
							sysuser_id
						FROM system_user_schema.system_users 
						WHERE	login = lower(_submited_login) 
					);   
					
	_calling_login := (SELECT _in_data ->> 'changing_user_login')::text;
	_calling_user_state := (SELECT * FROM system_user_schema.util_get_user_state (_calling_login));
	
	IF _calling_user_state  = 'Logged In' THEN
		IF _submited_login = _calling_login THEN --the user is changing their own password, which is always authorized
			_authorized_result := TRUE;
		ELSE	-- the calling user must be authorized
			
			_input_authorized_json :=	(SELECT json_build_object(
									'login', _calling_login,
									'service', 'system_user',
									'action', 'change_password'
									));
			
			_output_authorized_json := (SELECT * FROM system_user_schema.util_is_user_authorized (_input_authorized_json));
			
			_authorized_result := (SELECT _output_authorized_json ->> 'authorized')::boolean;	
		END IF;
	
	ELSE
		_authorized_result := FALSE;
	END IF;
	
	IF _authorized_result  THEN
	
		IF _sysuser_id IS NOT NULL THEN	-- the user is in  the system and we can proced to change the password
		
			_firstname := (SELECT firstname FROM system_user_schema.system_users WHERE sysuser_id = _sysuser_id);
			_lastname := (SELECT lastname FROM system_user_schema.system_users WHERE sysuser_id = _sysuser_id);
			
			UPDATE	system_user_schema.system_users
			   SET	password = (SELECT crypt((SELECT _in_data ->> 'new_password')::text, gen_salt('bf', 8)))
			WHERE	sysuser_id = _sysuser_id
			;
			
			_message := (SELECT 'The password for ' ||  _firstname || ' ' || _lastname || ' has been changed.');
			
			 _out_json :=  (SELECT json_build_object(
								'result_indicator', 'Success',
								'message', _message,
								'firstname', _firstname,
								'lastname', _lastname,
								'login', _submited_login,
								'changing_user_login', _calling_login
								));

		ELSE	-- the username/password combination is not valid and an failure message will be returned
		
			_message := (SELECT 'Invalid username submitted. Please try again.') ;
			
			_out_json :=  (SELECT json_build_object(
								'result_indicator', 'Failure',
								'message', _message,
								'firstname', (SELECT _in_data ->> 'firstname')::text,
								'lastname', (SELECT _in_data ->> 'lastname')::text
								));

		END IF;
		
	ELSE
		IF _calling_user_state  = 'Logged In' THEN
			_message := 'The user ' || _calling_login || ' IS NOT Authorized to change other users passwords. The password was not changed.';
			_out_json :=  (SELECT json_build_object(
								'result_indicator', 'Failure',
								'message', _message,
								'firstname', (SELECT _in_data ->> 'firstname')::text,
								'lastname', (SELECT _in_data ->> 'lastname')::text,
								'login', _submited_login,
								'changing_user_login', _calling_login
								));
		ELSE
			_message := 'The user ' || _calling_login || ' IS NOT logged in. The password was not changed.';
			_out_json :=  (SELECT json_build_object(
								'result_indicator', 'Failure',
								'message', _message,
								'firstname', (SELECT _in_data ->> 'firstname')::text,
								'lastname', (SELECT _in_data ->> 'lastname')::text,
								'login', _submited_login,
								'changing_user_login', _calling_login
								));		
		END IF;
	END IF;	
					
	RETURN _out_json;
	
	
END;
$$ LANGUAGE plpgsql;	

	