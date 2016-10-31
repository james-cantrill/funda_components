/* The function


	_in_data:	{
					login:
				}
			
* The json object returned by the function, _out_json, is defined  below.

	_out_json:	{
				result_indicator:
				message:
				login:
				programs: [
						{
							program_id:
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
	
BEGIN

	_login := ((SELECT _in_data ->> 'login')::text);
	
	DROP TABLE IF EXISTS programs;

	CREATE TEMPORARY TABLE programs (	
		program	json
	);
	
	INSERT INTO programs (
		program
		)
	SELECT
		row_to_json(report_row) 
	FROM (	SELECT
				program_id,
				program
			FROM	programs_manager_schema.system_user_allowed_programs
			WHERE	login = (SELECT _in_data ->> 'login')::text
			  AND	program_accessible = TRUE 
	  ) report_row
	;

	
	_programs := (SELECT ARRAY_AGG(program) FROM programs);

	IF _programs IS NOT NULL THEN
		_message := 'Here is the list of programs visible to ' || _login || '.';
		
		_out_json :=  (SELECT json_build_object(
									'result_indicator', 'Success',
									'message', _message,
									'login', _login,
									'programs', _programs
									));
								
	ELSE
		_message := 'There are no programs visible to ' || _login || '.';
		
		_out_json :=  (SELECT json_build_object(
									'result_indicator', 'Failure',
									'message', _message,
									'login', _login,
									'programs', _programs
									));
	
	END IF;
	
	RETURN _out_json;
	
	
END;
$$ LANGUAGE plpgsql;		