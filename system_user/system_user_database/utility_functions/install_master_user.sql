-- The function system_user_schema.install_master_user adds a master user to
-- the application during database installation

CREATE OR REPLACE FUNCTION system_user_schema.install_master_user () RETURNS integer 
AS $$

DECLARE
		
	_integer_var	integer;
	_sysuser_id	uuid;
	
BEGIN

	INSERT INTO system_user_schema.system_users (
		login,
		password,
		firstname,
		lastname,
		datetime_user_changed,
		changing_user_login
		)
	SELECT
		'muser',
		(SELECT crypt('ha_melech!16', gen_salt('bf', 8))),
		'Master',
		'User',
		LOCALTIMESTAMP (0),
		'Install'
	;
	
	
	_sysuser_id := (	SELECT 
							sysuser_id 
						FROM system_user_schema.system_users 
						WHERE login = 'muser')
						;
		
			
	INSERT INTO system_user_schema.system_user_state (
		sysuser_id,
		user_state,
		datetime_state_started
		)
	SELECT
		_sysuser_id,
		'Logged Out',
		LOCALTIMESTAMP (0)
	;
	
	--set up all system acttions as allowed for this user
	INSERT INTO system_user_schema.system_user_allowed_actions (
		sysuser_id,
		login,
		service,
		action,
		action_display_name,
		action_allowed,
		changing_user_login,
		datetime_action_allowed_changed
		)
	SELECT
		_sysuser_id,
		'muser',
		service,
		action,
		action_display_name,
		true,
		'Install',
		LOCALTIMESTAMP (0)
	FROM	system_user_schema.system_actions
	;
		
	_integer_var := 1;
	RETURN _integer_var;
	
	
END;
$$ LANGUAGE plpgsql;		