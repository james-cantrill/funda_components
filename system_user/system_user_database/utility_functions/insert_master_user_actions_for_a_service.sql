-- The function system_user_schema.insert_master_user_actions_for_a_service
-- allows the master user to run all system actions for a selected service. It is run as
-- It is run as the last step in the srvice's installation

CREATE OR REPLACE FUNCTION system_user_schema.insert_master_user_actions_for_a_service (_service_name text) RETURNS integer 
AS $$

DECLARE
		
	_integer_var	integer;
	_sysuser_id	uuid;
	
BEGIN

	_sysuser_id := (	SELECT 
							sysuser_id 
						FROM system_user_schema.system_users 
						WHERE login = 'muser')
						;
		
	--set up all report_manager actions as allowed for this user
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
	WHERE	service = _service_name
	;
		
	_integer_var := 1;
	RETURN _integer_var;
	
	
END;
$$ LANGUAGE plpgsql;		