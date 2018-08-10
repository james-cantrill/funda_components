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
	
BEGIN

	WHILE 1 < 2 LOOP
	
		_timestamp_now := (SELECT clock_timestamp());
		RAISE NOTICE 'Current timestamp is %', _timestamp_now;
		PERFORM pg_sleep (300);

	END LOOP;
					
	RETURN 0;
	
	
END;
$$ LANGUAGE plpgsql;		
