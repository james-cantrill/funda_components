/* The function action_list_users lists all the users currently on the system


	_in_data:	{
					requesting_user_login:
				}
			
* The json object returned by the function, _out_json, is defined  below.

	_out_json:	{
					result_indicator:
					message:
					requesting_user_login:
					users_list:
						[
							{
								sysuser_id:
								login:
								name_last_first:
							}
						]
				}
				

*/

CREATE OR REPLACE FUNCTION system_user_schema.action_list_users (_in_data json) RETURNS json
AS $$

DECLARE
		
	_out_json json;
	
	_users	json[];	
	_message	text;
	
--	for calling the system_user_schema.util_is_user_authorized function to determine if the calling user is authorized to add new users
	_calling_login	text;
	_input_authorized_json	json;	-- input json
	_output_authorized_json	json;	-- output json  
	_authorized_result	boolean;
	
	
BEGIN

	-- Determine if tnhe calling user is authorized
	_calling_login := (SELECT _in_data ->> 'requesting_user_login')::text;
	
	_input_authorized_json :=	(SELECT json_build_object(
							'login', _calling_login,
							'service', 'system_user',
							'action', 'list_users'
							));
	
	_output_authorized_json := (SELECT * FROM system_user_schema.util_is_user_authorized (_input_authorized_json));
	
	_authorized_result := (SELECT _output_authorized_json ->> 'authorized')::boolean;
	
	IF _authorized_result  THEN

		DROP TABLE IF EXISTS users_list;

		CREATE TEMPORARY TABLE users_list (	
			user_json	json
		);
		
		INSERT INTO users_list (
			user_json
			)
		SELECT
			row_to_json(report_row) 
		FROM (	SELECT
					sysuser_id,
					login,
					lastname || ', ' || firstname AS name_last_first
				FROM	system_user_schema.system_users
		  ) report_row
		;

		
		_users := (SELECT ARRAY_AGG(user_json) FROM users_list);
		
		IF _users IS NOT NULL THEN
			_message := 'Here is the users list.';
			
			_out_json :=  (SELECT json_build_object(
										'result_indicator', 'Success',
										'message', _message,
										'requesting_user_login', _calling_login,
										'users_list', _users
										));
									
		ELSE
			_message := 'There are no users.';
			
			_out_json :=  (SELECT json_build_object(
										'result_indicator', 'Failure',
										'message', _message,
										'requesting_user_login', _calling_login,
										'users_list', _users
										));
		
		END IF;		
	
	ELSE	-- calling user is not authorized

		_message := 'The user ' || _calling_login || ' IS NOT Authorized to see the list of users.';

		_out_json :=  (SELECT json_build_object(
							'result_indicator', 'Failure',
							'message', _message,
							'requesting_user_login', _calling_login
							));
	
	END IF;
	
	
	RETURN _out_json;
	
	
END;
$$ LANGUAGE plpgsql;		