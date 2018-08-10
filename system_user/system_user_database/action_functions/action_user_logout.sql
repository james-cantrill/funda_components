/* The function system_user_schema.action_user_logout changes the state of the user indicated by
* the login in the json object _in_data (defined below) to Logged Out
* If the submitted login doesn't correspond to a system user it returns a
* failure message in tbe object _out_json (below)

	_in_data:	{
					login:
				}
			
* The json object returned by the function, _out_json, is defined  below.

	_out_json:	{
					result_indicator:
					message:
					login:
				}
				
	*/

CREATE OR REPLACE FUNCTION system_user_schema.action_user_logout (_in_data json) RETURNS json
AS $$

DECLARE
		
	_integer_var integer;
	_out_json	json;
	
	_sysuser_id	uuid;	
	_message	text;	
	_firstname	text;
	_lastname	text;
	
	_submited_login	text;	
	_submited_password	text;
	
	_user_state	text;
	
BEGIN

	--RAISE NOTICE 'Input json = %', _in_data;
	
	_submited_login := (SELECT _in_data ->> 'login')::text;
	
	_sysuser_id := (	SELECT 
							sysuser_id
						FROM system_user_schema.system_users 
						WHERE	login = lower(_submited_login) 
					);  
	 
	 
	IF _sysuser_id IS NOT NULL THEN	-- the user is in the system
	
		_user_state := (SELECT * FROM system_user_schema.util_get_user_state (_submited_login));
		
		IF _user_state = 'Logged In' THEN
		
			_firstname := (SELECT firstname FROM system_user_schema.system_users WHERE sysuser_id = _sysuser_id);
			_lastname := (SELECT lastname FROM system_user_schema.system_users WHERE sysuser_id = _sysuser_id);
			
			UPDATE	system_user_schema.system_user_state
			   SET	
					user_state = 'Logged Out',
					datetime_state_started = LOCALTIMESTAMP (0)
			WHERE	sysuser_id = _sysuser_id
			;
			
			DELETE FROM system_user_schema.system_user_last_active
			WHERE sysuser_id = _sysuser_id
			;
			
			_message := (SELECT  _firstname || ' ' || _lastname || ', is logged out.');
			
			 _out_json :=  (SELECT json_build_object(
								'result_indicator', 'Success',
								'message', _message,
								'sysuser_id', _sysuser_id,
								'firstname', _firstname,
								'lastname', _lastname
								));
							
		ELSE
			_message := (SELECT 'User is already logged out.') ;
			
			_out_json :=  (SELECT json_build_object
								(
								'result_indicator', 'Failure',
								'message', _message,
								'login', (SELECT _in_data ->> 'login')::text
								)
							);		
		END IF;

	ELSE	-- the entered login doesn't exist in the system and an error message will be returned
	
		_message := (SELECT 'Invalid username submitted. Please try again.') ;
		
		_out_json :=  (SELECT json_build_object
							(
							'result_indicator', 'Failure',
							'message', _message,
							'login', (SELECT _in_data ->> 'login')::text
							)
						);

	END IF;
	
		
	RETURN _out_json;
	
	
END;
$$ LANGUAGE plpgsql;		