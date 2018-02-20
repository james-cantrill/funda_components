/* The function programs_manager_schema.trig_log_organizations_history stores the audit records for the
* programs_manager_schema.organizations_history table
*/

CREATE OR REPLACE FUNCTION programs_manager_schema.trig_log_organizations_history()
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
	RAISE NOTICE '_change_type = %', _change_type;
    
	INSERT INTO programs_manager_schema.organizations_history (
		organization_id,
		organization_name,
		organization_description,
		datetime_organization_changed, 
		changing_user_login,
		datetime_organization_change_started,
		datetime_organization_change_ended,
		change_type
		)
	SELECT
		OLD.organization_id,
		OLD.organization_name,
		OLD.organization_description,
		OLD.datetime_organization_changed,
		OLD.changing_user_login, 
		OLD.datetime_organization_changed,
		LOCALTIMESTAMP (0),
		_change_type
	;
	
	RETURN null;
	
	
END;
$$ LANGUAGE plpgsql;		

	
    CREATE TRIGGER trig_log_organizations_history_up_or_del 
      AFTER UPDATE OR DELETE 
      ON programs_manager_schema.organizations 
      FOR EACH ROW  
      EXECUTE PROCEDURE programs_manager_schema.trig_log_organizations_history();  
	  
	

	  