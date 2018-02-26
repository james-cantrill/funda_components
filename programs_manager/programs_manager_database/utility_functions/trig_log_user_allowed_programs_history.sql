/* The function programs_manager_schema.trig_log_user_allowed_programs_history stores the audit records for the
* programs_manager_schema.system_user_allowed_programs_history table
*/

CREATE OR REPLACE FUNCTION programs_manager_schema.trig_log_user_allowed_programs_history()
  RETURNS trigger
AS $$

DECLARE
		
	_integer_var integer;
	
	_change_type	text;
	
BEGIN

	IF (TG_OP = 'UPDATE' AND TG_LEVEL = 'ROW') THEN
		_change_type := 'Update';
		
	ELSE
		IF (TG_OP = 'DELETE' AND TG_LEVEL = 'ROW') THEN
			_change_type := 'Delete';
		ELSE
		END IF;
		
	END IF;
	
	INSERT INTO programs_manager_schema.system_user_allowed_programs_history (
		sysuser_id,
		login,
		program_id,
		program_name,
		program_accessible,
		datetime_program_accessible_started,
		datetime_program_accessible_ended,
		changed_by_user_login,
		change_type
		)
	SELECT
		OLD.sysuser_id,
		OLD.login,
		OLD.program_id,
		OLD.program_name, 
		OLD.program_accessible,
		OLD.datetime_program_accessible_changed,
		LOCALTIMESTAMP (0),
		OLD.changed_by_user_login,
		_change_type
	;
	
	RETURN null;
	
	
END;
$$ LANGUAGE plpgsql;		

	DROP TRIGGER IF EXISTS trig_log_user_allowed_programs_history_up_or_del ON programs_manager_schema.system_user_allowed_programs;
	
    CREATE TRIGGER trig_log_user_allowed_programs_history_up_or_del 
      AFTER UPDATE OR DELETE 
      ON programs_manager_schema.system_user_allowed_programs 
      FOR EACH ROW  
      EXECUTE PROCEDURE programs_manager_schema.trig_log_user_allowed_programs_history();  
	  
	

	  