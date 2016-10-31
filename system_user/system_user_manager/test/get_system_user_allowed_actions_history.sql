-- get_system_user_schema.system_user_allowed_actions_history.sql

SELECT * 
FROM system_user_schema.system_user_allowed_actions_history
ORDER BY 
	sysuser_id,
	datetime_action_changed_to
;

