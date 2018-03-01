/* The function


	_in_data:	{
					login:
					changing_user_login:
				}
			
* The json object returned by the function, _out_json, is defined  below.

	_out_json:	{
				result_indicator:
				message:
				login:
				changing_user_login:
				programs: [
						{
							program_id:
							other_program_id:    -- unique program identifier from outside this system.
							program_name:
						}
					]
				}	
				

*/

CREATE OR REPLACE FUNCTION programs_manager_schema.action_list_user_visible_programs (_in_data json) RETURNS json
AS $$

DECLARE
		
	_out_json json;
	_programs	json[];
	_login	text;
	_integer_var	integer;
	_message	text;
	
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
							'action', 'list_user_visible_programs'
							));	
	
	_output_authorized_json := (SELECT * FROM system_user_schema.util_is_user_authorized (_input_authorized_json));	
	
	_authorized_result := (SELECT _output_authorized_json ->> 'authorized')::boolean;

	IF  NOT _authorized_result  THEN
		_message := 'The user ' || _calling_login || ' IS NOT Authorized to VIEW users program accesiblilty.';
		
					_out_json :=  (SELECT json_build_object(
										'result_indicator', 'Failure',
										'message', _message,
										'login', (SELECT _in_data ->> 'login')::text,
										'changing_user_login', (SELECT _in_data ->> 'changing_user_login')::text,
										'programs', _programs
										));
							
	ELSE
	
		_output_authorized_json := (SELECT * FROM system_user_schema.util_is_user_authorized (_input_authorized_json));	
		
		_authorized_result := (SELECT _output_authorized_json ->> 'authorized')::boolean;

		_login := ((SELECT _in_data ->> 'login')::text);
		
		DROP TABLE IF EXISTS programs_list;

		CREATE TEMPORARY TABLE programs_list (	
			program	json
		);
		
		INSERT INTO programs_list (
			program
			)
		SELECT
			row_to_json(report_row) 
		FROM (	SELECT
					ap.program_id,
					p.other_program_id,
					ap.program_name
				FROM	programs_manager_schema.system_user_allowed_programs ap,
						programs_manager_schema.programs p
				WHERE	ap.login = (SELECT _in_data ->> 'login')::text
				  AND	ap.program_accessible = TRUE 
				  AND	ap.program_id = p.program_id
		  ) report_row
		;

		
		_programs := (SELECT ARRAY_AGG(program) FROM programs_list);

		IF _programs IS NOT NULL THEN
			_message := 'Here is the list of programs visible to ' || _login || '.';
			
			_out_json :=  (SELECT json_build_object(
										'result_indicator', 'Success',
										'message', _message,
										'login', _login,
										'changing_user_login', (SELECT _in_data ->> 'changing_user_login')::text,
										'programs', _programs
										));
									
		ELSE
			_message := 'There are no programs visible to ' || _login || '.';
			
			_out_json :=  (SELECT json_build_object(
										'result_indicator', 'Failure',
										'message', _message,
										'login', _login,
										'changing_user_login', (SELECT _in_data ->> 'changing_user_login')::text,
										'programs', _programs
										));
		
		END IF;
	
	END IF;
	
	RETURN _out_json;
	
	
END;
$$ LANGUAGE plpgsql;		