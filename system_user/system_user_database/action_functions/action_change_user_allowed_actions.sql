/* The function system_user_schema.action_change_user_allowed_actions changes the allowed/disallowed status for the action and user defined in  the input data, in_json, defined below

	_in_data:	{
					login:
					service:
					action:
					task:
					changing_user_login:
				}
			
* The json object returned by the function, _out_json, is defined  below.

	_out_json:	{
					result_indicator:
					message:
					login:
					service:
					action:
					action_display_name:
					allowed:
					changing_user_login:
				}
*/

CREATE OR REPLACE FUNCTION system_user_schema.action_change_user_allowed_actions (_in_data json) RETURNS json
AS $$

DECLARE
		
	_out_json json;
	_sysuser_id	uuid;	
	_message	text;
	_action_allowed	boolean;
	
	_service	text;
	_action	text;
	_submited_login	text;
	_firstname	text;
	_lastname	text;
	
	--	for calling the system_user_schema.util_is_user_authorized function to determine if the calling user is authorized to add new users
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
							'action', 'enter_edit_allowed_actions'
							));
	
	_output_authorized_json := (SELECT * FROM system_user_schema.util_is_user_authorized (_input_authorized_json));
	
	_authorized_result := (SELECT _output_authorized_json ->> 'authorized')::boolean;
	
	IF _authorized_result  THEN
	
		_service := (SELECT _in_data ->> 'service')::text;
		_action := (SELECT _in_data ->> 'action')::text;
		_submited_login := (SELECT lower ((SELECT _in_data ->> 'login')));
		
		_sysuser_id := (	SELECT 
								sysuser_id 
							FROM system_user_schema.system_users 
							WHERE login = lower ((SELECT _in_data ->> 'login'))
							);
							
		IF _sysuser_id IS NOT NULL THEN	-- the user is in  the system and we can proced to change the service/action 
		
			_firstname := (SELECT firstname FROM system_user_schema.system_users WHERE sysuser_id = _sysuser_id);
			_lastname := (SELECT lastname FROM system_user_schema.system_users WHERE sysuser_id = _sysuser_id);
			
			_action_allowed := (	SELECT
									action_allowed
									FROM	system_user_schema.system_user_allowed_actions
									WHERE	 login = lower ((SELECT _in_data ->> 'login'))::text
									  AND	service = (SELECT _in_data ->> 'service')::text
									  AND	action = (SELECT _in_data ->> 'action')::text
								);
								
			IF (SELECT _in_data ->> 'task')::text = 'allow'  AND _action_allowed = FALSE THEN
			
				UPDATE	system_user_schema.system_user_allowed_actions
				   SET	action_allowed = TRUE,
						datetime_action_allowed_changed = LOCALTIMESTAMP (0)
				WHERE	 login = lower ((SELECT _in_data ->> 'login'))::text
				  AND	service = (SELECT _in_data ->> 'service')::text
				  AND	action = (SELECT _in_data ->> 'action')::text
				;
			
				_message := (SELECT 'The action ' || _service || '/' || _action || ' for ' ||  _firstname || ' ' || _lastname || ' is now allowed.');
			
			
				 _out_json :=  (SELECT json_build_object(
									'result_indicator', 'Successs',
									'message', _message,
									'firstname', _firstname,
									'lastname', _lastname,
									'login', _submited_login
									));
								
			ELSIF (SELECT _in_data ->> 'task')::text = 'allow'  AND _action_allowed = TRUE THEN
			
				_message := (SELECT 'The action ' || _service || '/' || _action || ' for ' ||  _firstname || ' ' || _lastname || ' is already allowed. Nothing will be done');
			
			
				 _out_json :=  (SELECT json_build_object(
									'result_indicator', 'Failure',
									'message', _message,
									'firstname', _firstname,
									'lastname', _lastname,
									'login', _submited_login
									));
										
			ELSIF (SELECT _in_data ->> 'task')::text = 'disallow'  AND _action_allowed = TRUE THEN
			
				UPDATE	system_user_schema.system_user_allowed_actions
				   SET	action_allowed = FALSE,
						datetime_action_allowed_changed = LOCALTIMESTAMP (0)
				WHERE	 login = lower ((SELECT _in_data ->> 'login'))::text
				  AND	service = (SELECT _in_data ->> 'service')::text
				  AND	action = (SELECT _in_data ->> 'action')::text
				;
			
				_message := (SELECT 'The action ' || _service || '/' || _action || ' for ' ||  _firstname || ' ' || _lastname || ' is now disallowed.');
			
			
				 _out_json :=  (SELECT json_build_object(
									'result_indicator', 'Successs',
									'message', _message,
									'firstname', _firstname,
									'lastname', _lastname,
									'login', _submited_login
									));
								
			
			
			
			ELSE
			
				_message := (SELECT 'The action ' || _service || '/' || _action || ' for ' ||  _firstname || ' ' || _lastname || ' is already disallowed. Nothing will be done');
			
				 _out_json :=  (SELECT json_build_object(
									'result_indicator', 'Failure',
									'message', _message,
									'firstname', _firstname,
									'lastname', _lastname,
									'login', _submited_login
									));
			
			END IF;

		ELSE	-- the username is not valid and an failure message will be returned
		
			_message := (SELECT 'Invalid username submitted; nothing was changed. Please try again.') ;
			
			_out_json :=  (SELECT json_build_object(
								'result_indicator', 'Failure',
								'message', _message,
								'login', (SELECT _in_data ->> 'login')::text,
								'service', (SELECT _in_data ->> 'service')::text,
								'action', (SELECT _in_data ->> 'action')::text,
								'action_display_name', (SELECT _in_data ->> 'action_display_name')::text,
								'allowed', (SELECT _in_data ->> 'allowed')::text
								));

		END IF;
		
	ELSE	--	the calling user is not authorized to chnge allowed actions
		_message := 'The user ' || _calling_login || ' IS NOT Authorized to change allowed actions. No actions were changed.';
		
		_out_json :=  (SELECT json_build_object(
							'result_indicator', 'Failure',
							'message', _message,
							'login', (SELECT _in_data ->> 'login')::text,
							'service', (SELECT _in_data ->> 'service')::text,
							'action', (SELECT _in_data ->> 'action')::text,
							'action_display_name', (SELECT _in_data ->> 'action_display_name')::text,
							'allowed', (SELECT _in_data ->> 'allowed')::text,
							'changing_user_login', _calling_login
							));	
	END IF;

	RETURN _out_json;
	
	
END;
$$ LANGUAGE plpgsql;		