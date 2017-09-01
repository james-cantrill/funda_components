/* The function lists the system actions for a user and if the user is allowed
* to invoke each action


	_in_data:	{
					user_login:
					requesting_user_login:
				}
			
* The json object returned by the function, _out_json, is defined  below.

	_out_json:	{
					result_indicator:
					message:
					user_login:
					requesting_user_login:
					user_actions_list:
						[
							{
								service:
								action:
								action_display_name:
								action_allowed:
							}
						]
				}
				

*/

CREATE OR REPLACE FUNCTION system_user_schema.action_list_actions_for_a_user (_in_data json) RETURNS json
AS $$

DECLARE
		
	_out_json json;
	
	
	_user_actions	json[];	
	_message	text;
	_user_login	text;
	
--	for calling the system_user_schema.util_is_user_authorized function to determine if the calling user is authorized to change a user's allowed actions
	_calling_login	text;
	_input_authorized_json	json;	-- input json
	_output_authorized_json	json;	-- output json  
	_authorized_result	boolean;

BEGIN

	_user_login  := (SELECT _in_data ->> 'user_login')::text;
	
	-- Determine if the calling user is authorized
	_calling_login := (SELECT _in_data ->> 'requesting_user_login')::text;
	
	_input_authorized_json :=	(SELECT json_build_object(
							'login', _calling_login,
							'service', 'system_user',
							'action', 'list_user_actions'
							));
	
	_output_authorized_json := (SELECT * FROM system_user_schema.util_is_user_authorized (_input_authorized_json));
	
	_authorized_result := (SELECT _output_authorized_json ->> 'authorized')::boolean;
	
	IF _authorized_result  THEN
	
		DROP TABLE IF EXISTS users_actions_list;

		CREATE TEMPORARY TABLE users_actions_list (	
			user_actions_json	json
		);
		
		INSERT INTO users_actions_list (
			user_actions_json
			)
		SELECT
			row_to_json(report_row) 
		FROM (	SELECT
					service,
					action,
					action_display_name,
					action_allowed
				FROM	system_user_schema.system_user_allowed_actions
				WHERE	login = _user_login
				ORDER BY 
					service,
					action_display_name
		  ) report_row
		;

		
		_user_actions := (SELECT ARRAY_AGG(user_actions_json) FROM users_actions_list);
		
		IF _user_actions IS NOT NULL THEN
			_message := 'Here is the list of actions for ' || _user_login;
			
			_out_json :=  (SELECT json_build_object(
										'result_indicator', 'Success',
										'message', _message,
										'user_login', _user_login,
										'requesting_user_login', _calling_login,
										'user_actions_list', _user_actions
										));
									
		ELSE
			_message := 'There are no actions for ' || _user_login;
			
			_out_json :=  (SELECT json_build_object(
										'result_indicator', 'Failure',
										'message', _message,
										'user_login', _user_login,
										'requesting_user_login', _calling_login,
										'user_actions_list', _user_actions
										));
		
		END IF;		
	ELSE	-- calling user is not authorized

		_message := 'The user ' || _calling_login || ' IS NOT Authorized to list the users actions.';

		_out_json :=  (SELECT json_build_object(
							'result_indicator', 'Failure',
							'message', _message,
							'user_login', _user_login,
							'requesting_user_login', _calling_login
							));
	
	END IF;
	
	RETURN _out_json;
	
	
END;
$$ LANGUAGE plpgsql;		