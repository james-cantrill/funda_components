/* The function system_user_schema.trig_log_reports_history stores the audit records for the
* system_user_schema.system_user table
*/

CREATE OR REPLACE FUNCTION report_manager_schema.trig_log_reports_history()
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
	
	INSERT INTO report_manager_schema.reports_history (
		report_id,
		report_name,
		description,
		url, 
		containing_folder_name,
		datetime_report_change_started,
		datetime_report_change_ended,
		changing_user_login,
		change_type
		)
	SELECT
		OLD.report_id,
		OLD.report_name,
		OLD.description,
		OLD.url, 
		OLD.containing_folder_name,
		OLD.datetime_report_added,
		LOCALTIMESTAMP (0),
		OLD.changing_user_login,
		_change_type
	;
	
	RETURN null;
	
	
END;
$$ LANGUAGE plpgsql;		

	
    CREATE TRIGGER trig_log_reports_history_up_or_del 
      AFTER UPDATE OR DELETE 
      ON report_manager_schema.reports  
      FOR EACH ROW  
      EXECUTE PROCEDURE report_manager_schema.trig_log_reports_history();  
	  
	

	  