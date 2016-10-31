/* The function system_user_schema.util_get_user_state retuns the current state of the user
* indicated by the _login parameter. If the submitted login doesn't correspond
* to a system user it returns "Unknown"


*/

CREATE OR REPLACE FUNCTION system_user_schema.util_get_user_state (_login text) RETURNS text
AS $$

DECLARE
		
	_integer_var integer;
	
	_sysuser_id	uuid;
	_is_logged_in	boolean;
	_user_state	text;
	
BEGIN

	_sysuser_id := (	SELECT 
						sysuser_id
					FROM system_user_schema.system_users 
					WHERE	login = lower(_login) 
				); 

	IF _sysuser_id IS NOT NULL THEN
		
		_user_state :=	(SELECT
							user_state
						FROM	system_user_schema.system_user_state
						WHERE	sysuser_id = _sysuser_id
						);
						
	ELSE
	
		_user_state := 'Unknown';
		
	END IF;
					
	RETURN _user_state;
	
	
END;
$$ LANGUAGE plpgsql;		
