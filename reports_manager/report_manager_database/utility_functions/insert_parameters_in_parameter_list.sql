
-- The function report_manager_schema.insert_parameters_in_parameter_list
-- allows the master user to run all programs_manager actions. It is run as
-- the last step in the programs_manager installation

CREATE OR REPLACE FUNCTION report_manager_schema.insert_parameters_in_parameter_list (_parameter_name	text, _parameter_type	text, _parameter_load_method	text, _parameter_description	text) RETURNS integer 
AS $$

DECLARE
		
	_integer_var	integer;
	_sysuser_id	uuid;
	
BEGIN
		
	--set up all report parameters in the system 
	INSERT INTO report_manager_schema.parameter_list (
		parameter_name,
		parameter_type,
		parameter_load_method,
		parameter_description,
		datetime_parameter_changed,
		changing_user_login	
		)
	SELECT
		_parameter_name,
		_parameter_type,
		_parameter_load_method,
		_parameter_description,
		LOCALTIMESTAMP (0),
		'muser'
	;
		
	_integer_var := 1;
	RETURN _integer_var;
	
	
END;
$$ LANGUAGE plpgsql;		
