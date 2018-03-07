/* The function system_user_schema.trig_log_system_user_allowed_reports_history stores the audit records for the
*  report_manager_schema.system_user_allowed_reports_history table
*/

CREATE OR REPLACE FUNCTION report_manager_schema.trig_log_system_user_allowed_reports_history()
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
	
	INSERT INTO report_manager_schema.system_user_allowed_reports_history (
		sysuser_id,
		login,
		report_id,
		report_name,
		report_viewable, 
		datetime_report_viewable_change_started,
		datetime_report_viewable_change_ended,
		changing_user_login,
		change_type
		)
	SELECT
		OLD.sysuser_id,
		OLD.login,
		OLD.report_id,
		OLD.report_name, 
		OLD.report_viewable,
		OLD.datetime_report_viewable_changed,
		LOCALTIMESTAMP (0),
		OLD.changing_user_login,
		_change_type
	;
	
	RETURN null;
	
	
END;
$$ LANGUAGE plpgsql;		

	
 	DROP TRIGGER IF EXISTS trig_log_system_user_allowed_reports_history_up_or_del ON report_manager_schema.system_user_allowed_reports;
	
   CREATE TRIGGER trig_log_system_user_allowed_reports_history_up_or_del 
      AFTER UPDATE OR DELETE 
      ON report_manager_schema.system_user_allowed_reports  
      FOR EACH ROW  
      EXECUTE PROCEDURE report_manager_schema.trig_log_system_user_allowed_reports_history();  
	  
	

	  