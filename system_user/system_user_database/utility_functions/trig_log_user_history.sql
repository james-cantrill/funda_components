/* The function system_user_schema.trig_log_user_history stores the audit records for the
* system_user_schema.system_user table
*/

CREATE OR REPLACE FUNCTION system_user_schema.trig_log_user_history()
  RETURNS trigger
AS $$

DECLARE
		
	_integer_var integer;
	
	_password_changed text;
	_change_type	text;
	
BEGIN

	IF (TG_OP = 'UPDATE' AND TG_LEVEL = 'ROW') THEN
		IF OLD.password != NEW.password THEN
			_password_changed := 'Yes';
		ELSE
			_password_changed := 'No';
		END IF;
		_change_type := 'Update';
		
	ELSE
		IF (TG_OP = 'DELETE' AND TG_LEVEL = 'ROW') THEN
			_password_changed := 'No';
			_change_type := 'Delete';
		ELSE
		END IF;
		
	END IF;
	
	INSERT INTO system_user_schema.system_users_history (
		sysuser_id,
		login,
		password_changed,
		firstname,
		lastname, 
		datetime_user_change_started,
		datetime_user_change_ended,
		changing_user_login,
		change_type
		)
	SELECT
		OLD.sysuser_id,
		OLD.login,
		_password_changed,
		OLD.firstname,
		OLD.lastname, 
		OLD.datetime_user_changed,
		LOCALTIMESTAMP (0),
		OLD.changing_user_login,
		_change_type
	;
	
	RETURN null;
	
	
END;
$$ LANGUAGE plpgsql;		

	
    CREATE TRIGGER trig_log_user_history_up_or_del 
      AFTER UPDATE OR DELETE 
      ON system_user_schema.system_users  
      FOR EACH ROW  
      EXECUTE PROCEDURE system_user_schema.trig_log_user_history();  
	  
	

	  