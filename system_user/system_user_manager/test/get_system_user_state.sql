-- get_system_user_schema.system_user_state.sql

SELECT * 
FROM system_user_schema.system_user_state
ORDER BY 
	sysuser_id,
	datetime_state_started
;