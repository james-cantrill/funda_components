/* The function programs_manager_schema.trig_log_organization_level_history stores the audit records for the
* programs_manager_schema.organization_level_history table
*/

CREATE OR REPLACE FUNCTION programs_manager_schema.trig_log_organization_level_history()
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
    
	INSERT INTO programs_manager_schema.organization_level_history (
		organization_level_id,
		organization_level_name,
		organization_level_display_name,
		organization_level_description,
		parent_level_id,
		is_root_level,
		organization_id,
		datetime_level_changed ,
		changing_user_login,
		datetime_user_change_started,
		datetime_user_change_ended,
		change_type
		)
	SELECT
		OLD.organization_level_id,
		OLD.organization_level_name,
		OLD.organization_level_display_name,
		OLD.organization_level_description,
		OLD.parent_level_id,
		OLD.is_root_level,
		OLD.organization_id,
		OLD.datetime_level_changed ,
		OLD.changing_user_login,
		old.datetime_level_changed,
		LOCALTIMESTAMP (0),
		_change_type
	;
	
	RETURN null;
	
	
END;
$$ LANGUAGE plpgsql;		

	DROP TRIGGER IF EXISTS trig_log_organization_level_history_up_or_del ON programs_manager_schema.organization_level;
	
    CREATE TRIGGER trig_log_organization_level_history_up_or_del 
      AFTER UPDATE OR DELETE 
      ON programs_manager_schema.organization_level 
      FOR EACH ROW  
      EXECUTE PROCEDURE programs_manager_schema.trig_log_organization_level_history();  
	  
	

	  