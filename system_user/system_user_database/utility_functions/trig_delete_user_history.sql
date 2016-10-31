/* The function system_user_schema.trig_delete_user_history stores the  records from the system_user_schema.system_user table when they are deleted
*/

CREATE OR REPLACE FUNCTION system_user_schema.trig_delete_user_history()
  RETURNS trigger
AS $$

DECLARE
		
	_integer_var integer;
	
	_password_changed text;
	
BEGIN

	_password_changed := 'No';
	
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
		OLD.changing_user_login
		'Delete'
	;
	
	RETURN null;
	
	
END;
$$ LANGUAGE plpgsql;		

	
   CREATE TRIGGER trig_delete_user_history_after_delete  
      AFTER DELete  
      ON system_user_schema.system_users  
      FOR EACH ROW  
      EXECUTE PROCEDURE system_user_schema.trig_delete_user_history();  

	  