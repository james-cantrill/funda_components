-- get_system_user_schema.system_user_allowed_actions.sql

SELECT * 
FROM system_user_schema.system_user_allowed_actions
ORDER BY 
	sysuser_id,
	datetime_action_allowed_changed
;

