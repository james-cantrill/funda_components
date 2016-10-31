/* The function system_user_schema.trig_log_state_history stores the audit records for the
* system_user_schema.system_user_state table
*/

CREATE OR REPLACE FUNCTION system_user_schema.trig_log_state_history()
  RETURNS trigger
AS $$

DECLARE
		
	_integer_var integer;
	
BEGIN

	INSERT INTO system_user_schema.system_user_state_history (
		sysuser_id,
		user_state,
		datetime_state_started,
		datetime_state_ended
		)
	SELECT
		OLD.sysuser_id,
		OLD.user_state,
		OLD.datetime_state_started,
		LOCALTIMESTAMP (0)
	;
	
	RETURN null;
	
	
END;
$$ LANGUAGE plpgsql;		

    CREATE TRIGGER trig_log_state_history_after_update  
      AFTER UPDATE  
      ON system_user_schema.system_user_state  
      FOR EACH ROW  
      EXECUTE PROCEDURE system_user_schema.trig_log_state_history();  
	  
    CREATE TRIGGER trig_log_state_history_after_delete  
      AFTER DELete  
      ON system_user_schema.system_user_state  
      FOR EACH ROW  
      EXECUTE PROCEDURE system_user_schema.trig_log_state_history();  

	  