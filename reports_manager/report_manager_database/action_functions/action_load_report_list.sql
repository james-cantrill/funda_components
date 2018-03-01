/* The function


	_in_data:	{
					login:
				}
			
* The json object returned by the function, _out_json, is defined  below.

	_out_json:	{
					result_indicator:
					message:
					reports: [{
								report_name:
								description:
					}]
				};
				

*/

CREATE OR REPLACE FUNCTION report_manager_schema.action_load_report_list (_in_data json) RETURNS json
AS $$

DECLARE
		
	_out_json json;
	_message	text;
	
	_requesting_login	text;
	
	_report_id	uuid;
	_report_name	text;
	_url	text;
	
	_param_name	text;
	_param_name2	text;
	_parameter_id	uuid;
	_param_json	json;
	_param_name_json	json;
	_param_array	text[];
	
BEGIN

	-- Determine if the requesting user is authorized
	_requesting_login := (SELECT _in_data ->> 'login')::text;
	
	_input_authorized_json :=	(SELECT json_build_object(
							'login', _requesting_login,
							'service', 'report_manager',
							'action', 'load_report_list'
							));
	
	_output_authorized_json := (SELECT * FROM system_user_schema.util_is_user_authorized (_input_authorized_json));
	
	_authorized_result := (SELECT _output_authorized_json ->> 'authorized')::boolean;
	

	
	
	RETURN _out_json;
	
	
END;
$$ LANGUAGE plpgsql;		