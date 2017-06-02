/* The function system_user_schema.util_is_user_authorized determines if a user
* (identified by their _in_data.login ) is logged in and is authnorized to run the
* action (identified by the _in_data.action parameter) for a given microservice
* (identified by the _in_data.service parameter). The function returns TRUE in
* the _out_json.authorized field if they are authorized or FALSE if they're not.
* It returns a failuire message if the user isn 't in  the system  or isn't logged in .


	_in_data:	{
					login:
					service:
					action:
				}
			
* The json object returned by the function, _out_json, is defined  below.

	_out_json:	{
					result_indicator:
					message:
					login:
					service:
					action:
					authorized:
				}
				
*/

CREATE OR REPLACE FUNCTION system_user_schema.util_is_user_authorized  (_in_data json) RETURNS json
AS $$

DECLARE
		
	_integer_var integer;
	
	_out_json json;
	
	_sysuser_id	uuid;
	_is_authorized	boolean;
	_user_state	text;
	
	_message	text;
	_service	text;
	_action	text;
	_login	text;
	
BEGIN

	_service := (SELECT _in_data ->> 'service')::text;
	_action := (SELECT _in_data ->> 'action')::text;
	_login := (SELECT lower ((SELECT _in_data ->> 'login')));
	

	_user_state := (SELECT * FROM system_user_schema.util_get_user_state (_login));
	
	IF _user_state = 'Unknown' THEN
		_message  := 'No user with the login ' || _login || ' is in the system';
		_is_authorized := FALSE;
		_out_json :=  (SELECT json_build_object(
								'result_indicator', 'Failure',
								'message', _message,
								'login', _login,
								'service', _service,
								'action', _action,
								'authorized', _is_authorized
								));
									
	ELSIF _user_state = 'Logged Out' AND _action != 'user_login' THEN
		_message  := 'The user with the login ' || _login || ' is not logged into the system';
		_is_authorized := FALSE;
		_out_json :=  (SELECT json_build_object(
								'result_indicator', 'Failure',
								'message', _message,
								'login', _login,
								'service', _service,
								'action', _action,
								'authorized', _is_authorized
								));	
	ELSIF _user_state = 'Logged In' OR _action = 'user_login' THEN
	
		_is_authorized := (SELECT	action_allowed
							FROM	system_user_schema.system_user_allowed_actions
							WHERE	login = _login
							  AND	service = _service
							  AND	action = _action
							);
		
		IF _is_authorized THEN
		
			_message  := 'The user with the login ' || _login || ' is authorized for the service ' || _service || ' and action ' || _action || '.' ;
			
			_out_json :=  (SELECT json_build_object(
									'result_indicator', 'Success',
									'message', _message,
									'login', _login,
									'service', _service,
									'action', _action,
									'authorized', _is_authorized
									));	
								
		ELSE
		
			_message  := 'The user with the login ' || _login || ' is not authorized for the service ' || _service || ' and action ' || _action || '.' ;
			
			_out_json :=  (SELECT json_build_object(
									'result_indicator', 'Success',
									'message', _message,
									'login', _login,
									'service', _service,
									'action', _action,
									'authorized', _is_authorized
									));			
		END IF;

	ELSE
	
	END IF;


								
	RETURN _out_json;
	
	
END;
$$ LANGUAGE plpgsql;		