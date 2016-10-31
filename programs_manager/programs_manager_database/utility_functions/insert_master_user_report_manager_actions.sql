-- The function report_manager_schema.insert_master_user_report_manager_actions
-- allows the master user to run all programs_manager actions. It is run as
-- the last step in the programs_manager installation

CREATE OR REPLACE FUNCTION programs_manager_schema.insert_master_user_prgrm_mngr_actions () RETURNS integer 
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
		
	--set up all programs_manager acttions as allowed for this user
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
	WHERE	service = 'programs_manager'
	;
		
	_integer_var := 1;
	RETURN _integer_var;
	
	
END;
$$ LANGUAGE plpgsql;		
