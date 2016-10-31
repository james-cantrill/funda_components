/* The function system_user_schema.trig_log_allowed_actions_history stores the audit records for the
* system_user_schema.system_user_state table
*/

CREATE OR REPLACE FUNCTION system_user_schema.trig_log_allowed_actions_history()
  RETURNS trigger
AS $$

DECLARE
		
	_integer_var integer;
	
BEGIN

	INSERT INTO system_user_schema.system_user_allowed_actions_history (
		sysuser_id,
		login,
		service,
		action,
		action_display_name,
		action_allowed,
		changing_user_login,
		datetime_action_changed_to,
		datetime_action_changed_from
		)
	SELECT
		OLD.sysuser_id,
		OLD.login,
		OLD.service,
		OLD.action,
		OLD.action_display_name,
		OLD.action_allowed,
		OLD.changing_user_login,
		OLD.datetime_action_allowed_changed,
		LOCALTIMESTAMP (0)
	;
	
	RETURN null;
	
	
END;
$$ LANGUAGE plpgsql;		

    CREATE TRIGGER trig_log_allowed_actions_history_after_update  
      AFTER UPDATE  
      ON system_user_schema.system_user_allowed_actions  
      FOR EACH ROW  
      EXECUTE PROCEDURE system_user_schema.trig_log_allowed_actions_history();  