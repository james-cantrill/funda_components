-- The function action_load_selected_report

--	_in_data:	{
--					login:
--					report_id:
--				}
			
--	_out_json:	{
--					result_indicator:
--					message:
--					report_name:
--					url:
--					parameters: [{
--								parameter_name:
--								parameter_type:
--								parameter_load_method:
--								parameter_description:
--					}]
--				};


CREATE OR REPLACE FUNCTION report_manager_schema.action_load_selected_report (_in_data json) RETURNS json
AS $$

DECLARE
		
	_out_json json;
	_message	text;
	
	_requesting_login	text;
	_input_authorized_json	json;
	_output_authorized_json	json;
	_authorized_result	boolean;
	
	_viewable_input_json	json;
	_viewable_output_json	json;
	_viewable_result	boolean;
	
	_report_id	uuid;
	_report_name	text;
	_url	text;
	
	_param_data	json[];
	
BEGIN

	DROP TABLE IF EXISTS json_param_data;

	CREATE TEMPORARY TABLE json_param_data (
		json_entry	text
	);
	
	-- Determine if the requesting user is authorized
	_requesting_login := (SELECT _in_data ->> 'login')::text;
	
	_input_authorized_json :=	(SELECT json_build_object(
							'login', _requesting_login,
							'service', 'report_manager',
							'action', 'load_run_selected_report'
							));
	
	_output_authorized_json := (SELECT * FROM system_user_schema.util_is_user_authorized (_input_authorized_json));
	
	_authorized_result := (SELECT _output_authorized_json ->> 'authorized')::boolean;
	
	IF _authorized_result  THEN

		_report_name := (SELECT report_name FROM report_manager_schema.reports WHERE report_id = (SELECT _in_data ->> 'report_id')::uuid);

		_url := (SELECT url FROM report_manager_schema.reports WHERE report_id = (SELECT _in_data ->> 'report_id')::uuid);

		_viewable_output_json  :=	(SELECT * FROM report_manager_schema.util_is_report_viewable_to_user (_in_data));

		_viewable_result := (SELECT _viewable_output_json ->> 'authorized')::boolean;
		
		IF _viewable_result THEN 
		
			INSERT INTO json_param_data (
				json_entry
				)
			SELECT
				row_to_json (parameters_row)
			FROM (	SELECT DISTINCT
						pl.parameter_name,
						pl.parameter_type,
						pl.parameter_load_method,
						pl.parameter_description
					FROM	report_manager_schema.parameter_list pl,
							report_manager_schema.report_parameters rp
					WHERE	pl.parameter_id = rp.parameter_id
					  AND	rp.report_id = (SELECT _in_data ->> 'report_id')::uuid
			  ) parameters_row
			;
			
			_param_data := (SELECT ARRAY (SELECT json_entry FROM json_param_data ));
			
			_message := 'Here are the reports properties.';
			
			_out_json :=  (SELECT json_build_object(
								'result_indicator', 'Success',
								'message', _message,
								'report_name', _report_name,
								'url', _url,
								'parameters', _param_data
								));			
								
		ELSIF NOT _viewable_result THEN
		
			_message := 'This user, ' || _requesting_login || ' is NOT ALLOWED to view this ' || _report_name || ' report.';
					
			_out_json :=  (SELECT json_build_object(
								'result_indicator', 'Failure',
								'message', _message,
								'report_name', _report_name,
								'url',  _url,
								'parameters', _param_data
								));			
								
		ELSIF (SELECT _viewable_output_json ->> 'result_indicator') = 'Non-existent' THEN
			_message := 'The report with this Report ID, ' ||  (SELECT _in_data ->> 'report_id')::text || ' DOES NOT EXIST.';
			
			_out_json :=  (SELECT json_build_object(
								'result_indicator', 'Failure',
								'message', _message,
								'report_name', _report_name,
								'url', _url,
								'parameters', _param_data
								));			
			
		END IF;
		
	ELSE	-- user isn't authorized to enter or edit reports
	
		_message := 'The user ' || _requesting_login || ' IS NOT Authorized to load or view reports.';
		
		_out_json :=  (SELECT json_build_object(
							'result_indicator', 'Failure',
							'message', _message,
								'report_name', _report_name,
								'url', _url,
								'parameters', _param_data
							));	

	END IF;
	
	RETURN _out_json;
	
	
END;
$$ LANGUAGE plpgsql;		