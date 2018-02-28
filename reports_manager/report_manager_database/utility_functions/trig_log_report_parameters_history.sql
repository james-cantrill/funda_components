/* The function system_user_schema.trig_log_report_parameters_history stores the audit records for the
* system_user_schema.system_user table
*/

CREATE OR REPLACE FUNCTION report_manager_schema.trig_log_report_parameters_history()
  RETURNS trigger
AS $$

DECLARE
		
	_integer_var integer;
	
	_password_changed text;
	_change_type	text;
	
BEGIN

	IF (TG_OP = 'UPDATE' AND TG_LEVEL = 'ROW') THEN
		_change_type := 'Update';
	ELSIF (TG_OP = 'DELETE' AND TG_LEVEL = 'ROW') THEN
		_change_type := 'Delete';
	END IF;
	
	INSERT INTO report_manager_schema.report_parameters_history (
		report_id,
		report_name,
		parameter_id,
		parameter_name,
		datetime_parameter_change_started,
		datetime_parameter_change_ended,
		changing_user_login,
		change_type
		)
	SELECT
		OLD.report_id,
		(SELECT report_name FROM report_manager_schema.reports WHERE report_id = OLD.report_id),
		OLD.parameter_id,
		(SELECT parameter_name FROM report_manager_schema.parameter_list WHERE parameter_id = OLD.parameter_id), 
		OLD.datetime_parameter_added,
		LOCALTIMESTAMP (0),
		OLD.changing_user_login,
		_change_type
	;
	
	RETURN null;
	
	
END;
$$ LANGUAGE plpgsql;		

	
    CREATE TRIGGER trig_log_report_parameters_history_up_or_del 
      AFTER UPDATE OR DELETE 
      ON report_manager_schema.report_parameters  
      FOR EACH ROW  
      EXECUTE PROCEDURE report_manager_schema.trig_log_report_parameters_history();  
	  
	

	  