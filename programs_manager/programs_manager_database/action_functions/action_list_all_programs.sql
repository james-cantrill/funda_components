/* The function action_list_all_programs


	_in_data:	
	{
		changing_user_login:
	}
			
* The json object returned by the function, _out_json, is defined  below.

	_out_json:	
	{
		result_indicator:
		message:
		changing_user_login:
		programs: 
		[
			{
				program_id:
				program_name:
			}
		]
	}	
				

*/

CREATE OR REPLACE FUNCTION programs_manager_schema.action_list_all_programs (_in_data json) RETURNS json
AS $$

DECLARE
		
	_out_json json;
	_programs	json[];
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
							'action', 'enter_edit_programs'
							));	
	
	_output_authorized_json := (SELECT * FROM system_user_schema.util_is_user_authorized (_input_authorized_json));	
	
	_authorized_result := (SELECT _output_authorized_json ->> 'authorized')::boolean;

	IF  NOT _authorized_result  THEN
		_message := 'The user ' || _calling_login || ' IS NOT Authorized to VIEW all programs.';
		
					_out_json :=  (SELECT json_build_object(
										'result_indicator', 'Failure',
										'message', _message,
										'login', (SELECT _in_data ->> 'login')::text,
										'changing_user_login', (SELECT _in_data ->> 'changing_user_login')::text,
										'programs', _programs
										));
							
	ELSE
	
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
					program_id,
					program_name
				FROM	programs_manager_schema.programs 
		  ) report_row
		;
		
		_programs := (SELECT ARRAY_AGG(program) FROM programs_list);

		IF _programs IS NOT NULL THEN
			_message := 'Here is the list of all programs.';
			
			_out_json :=  (SELECT json_build_object(
										'result_indicator', 'Success',
										'message', _message,
										'changing_user_login', (SELECT _in_data ->> 'changing_user_login')::text,
										'programs', _programs
										));
									
		ELSE
			_message := 'There are no programs to list.';
			
			_out_json :=  (SELECT json_build_object(
								'result_indicator', 'Failure',
								'message', _message,
								'changing_user_login', (SELECT _in_data ->> 'changing_user_login')::text,
								'programs', _programs
										));
		
		END IF;
	
	END IF;
	
	RETURN _out_json;
	
	
END;
$$ LANGUAGE plpgsql;		