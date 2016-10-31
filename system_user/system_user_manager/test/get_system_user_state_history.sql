-- get_system_user_schema.system_user_state_history.sql

SELECT * 
FROM system_user_schema.system_user_state_history
ORDER BY 
	sysuser_id,
	datetime_state_started
;

