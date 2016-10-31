/* The function


	_in_data:	{
					login:
					password:
				}
			
* The json object returned by the function, _out_json, is defined  below.

	_out_json:	{
					result_indicator:
					message:
					sysuser_id:
					firstname:
					lastname:
				}
				

*/

CREATE OR REPLACE FUNCTION action_{name} (_in_data json) RETURNS json
AS $$

DECLARE
		
	_out_json json;
	
BEGIN


	RETURN _out_json;
	
	
END;
$$ LANGUAGE plpgsql;		