/* The function programs_manager_schema.trig_log_programs_history stores the audit records for the
* programs_manager_schema.programs_history table
*/

CREATE OR REPLACE FUNCTION programs_manager_schema.trig_log_programs_history()
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
    
	INSERT INTO programs_manager_schema.programs_history (
		program_id,
		program_name,
		program_description,
		other_program_id,
		organization_id,
		containing_organization_level_id,
		datetime_program_changed,
		changing_user_login,
		datetime_user_change_started,
		datetime_user_change_ended,
		change_type
		)
	SELECT
		OLD.program_id,
		OLD.program_name,
		OLD.program_description,
		OLD.other_program_id,
		OLD.organization_id,
		OLD.containing_organization_level_id,
		OLD.datetime_program_changed,
		OLD.changing_user_login,
		OLD.datetime_program_changed,
		LOCALTIMESTAMP (0),
		_change_type
	;
	
	RETURN null;
	
	
END;
$$ LANGUAGE plpgsql;		

	DROP TRIGGER IF EXISTS trig_log_programs_history_up_or_del ON programs_manager_schema.programs;
	
    CREATE TRIGGER trig_log_programs_history_up_or_del 
      AFTER UPDATE OR DELETE 
      ON programs_manager_schema.programs 
      FOR EACH ROW  
      EXECUTE PROCEDURE programs_manager_schema.trig_log_programs_history();  
	  
	

	  