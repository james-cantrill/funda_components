/* The function system_user_schema.util_inaction_logout looks at all logged in
* users and logs them out if there has been no action in a defined time interval.
*
* Its _inaction_interval parametrer specifies the inaction perod, in minutes
* after which the user is logged out
*/

CREATE OR REPLACE FUNCTION system_user_schema.util_inaction_logout (_inaction_interval integer) RETURNS integer
AS $$

DECLARE
		
	_integer_var integer;
	
	_timestamp_now	timestamp;
	
	_sysuser_id	uuid;
	_login	text;
	_datetime_last_active	timestamp;
	
	_users_cur CURSOR FOR SELECT sysuser_id, login, datetime_last_active 
						FROM	system_user_schema.system_user_last_active
						ORDER BY datetime_last_active;
						
	_minutes_inactive	integer;

BEGIN

--	WHILE 1 < 2 LOOP
	
		_timestamp_now := (SELECT clock_timestamp());
		RAISE NOTICE 'current timestamp at loop start is %', _timestamp_now;
		_integer_var := (SELECT COUNT (*) FROM system_user_schema.system_user_last_active);
		RAISE NOTICE 'rows in system_user_last_active at loop start = %', _integer_var;
		
		OPEN _users_cur;
		LOOP
			FETCH _users_cur INTO _sysuser_id, _login, _datetime_last_active;
			if not found then
				exit;
			end if;
			
			_timestamp_now := (SELECT clock_timestamp());
			
			_minutes_inactive := (SELECT extract (minutes from (_timestamp_now - _datetime_last_active))::integer);
			RAISE NOTICE 'for login, %, current timestamp is %, _datetime_last_active = %, _minutes_inactive = % ', _login, _timestamp_now, _datetime_last_active, _minutes_inactive;
			RAISE NOTICE 'For _inaction_interval = %, test _minutes_inactive > _inaction_interval = %', _inaction_interval, (_minutes_inactive > _inaction_interval);
			IF _minutes_inactive > _inaction_interval THEN

				RAISE NOTICE 'In IF _minutes_inactive > _inaction_interval for % --- %', _login, _sysuser_id;
				
				UPDATE	system_user_schema.system_user_state
				   SET	
						user_state = 'Timed Out',
						datetime_state_started = LOCALTIMESTAMP (0)
				WHERE	sysuser_id = _sysuser_id
				;
				GET DIAGNOSTICS _integer_var = ROW_COUNT;
				RAISE NOTICE 'rows updated = %', _integer_var;
				
				DELETE FROM system_user_schema.system_user_last_active
				WHERE sysuser_id = _sysuser_id
				;
				GET DIAGNOSTICS _integer_var = ROW_COUNT;
				RAISE NOTICE 'rows deleted = %', _integer_var;
				
				_integer_var := (SELECT COUNT (*) FROM system_user_schema.system_user_last_active);
				RAISE NOTICE 'rows in system_user_last_active at END IF = %', _integer_var;
				
			
			END IF;
			
		END LOOP;
		CLOSE _users_cur;

	--	PERFORM pg_sleep (60);
		
	--END LOOP;
					
	RETURN 0;
	
	
END;
$$ LANGUAGE plpgsql;		
