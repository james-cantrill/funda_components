-- The function util_is_report_viewable_to_user determines if a user,
-- identified by the input login, is allowed to view the report, identified
-- by the input report_id.

-- 	_in_data:	{
-- 					login:
-- 					report_id:
-- 				}
-- 				
-- 	_out_json:	{
-- 					result_indicator:
-- 					message:
-- 					login:
-- 					report_id:
--					report_name:
-- 					authorized:
-- 				}				

CREATE OR REPLACE FUNCTION report_manager_schema.util_is_report_viewable_to_user (_in_data json) RETURNS json
AS $$

DECLARE
		
	_out_json json;
	_message	text;
	
	_requesting_login	text;
	_report_id	uuid;
	_report_name	text;
	_is_authorized	boolean;

BEGIN

	_requesting_login := (SELECT _in_data ->> 'login')::text;
	_report_id := (SELECT _in_data ->> 'report_id')::uuid;
	_report_name := (SELECT report_name FROM report_manager_schema.reports WHERE report_id = (SELECT _in_data ->> 'report_id')::uuid);
	
	_is_authorized :=	(SELECT
							report_viewable
						FROM	 report_manager_schema.system_user_allowed_reports
						WHERE	login = _requesting_login
						  AND	report_id = _report_id
						);

	IF _is_authorized THEN
	
	_message := ('This user, ' || _requesting_login || ' is allowed to view the ' || _report_name || 'report.');
		
	_out_json := 	(SELECT json_build_object(
						'result_indicator', 'Success',
						'message', _message,
						'login', _requesting_login,
						'report_id', _report_id,
						'report_name', _report_name,
						'authorized', _is_authorized
						)
					);	
									
	ELSIF _is_authorized IS NULL AND _report_name IS NULL THEN
	
	_message := ('This report DOES NOT EXIST.');
		
	_out_json := 	(SELECT json_build_object(
						'result_indicator', 'Non-existent',
						'message', _message,
						'login', _requesting_login,
						'report_id', _report_id,
						'report_name', _report_name,
						'authorized', _is_authorized
						)
					);	
	
	ELSE
	
	_message := ('This user, ' || _requesting_login || ' is NOT ALLOWED to view the ' || _report_name || ' report.');
		
	_out_json := 	(SELECT json_build_object(
						'result_indicator', 'Failure',
						'message', _message,
						'login', _requesting_login,
						'report_id', _report_id,
						'report_name', _report_name,
						'authorized', FALSE
						)
					);	
	END IF;
	
	RETURN _out_json;
	
	
END;
$$ LANGUAGE plpgsql;		
